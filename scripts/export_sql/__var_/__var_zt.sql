--***************************************************************************
--        Fonction de la base de données du projet AgiRisk
--        begin                : 2022-04-06
--        copyright            : (C) 2023 by Cerema
--        email                : agirisk@cerema.fr
--***************************************************************************/

--/***************************************************************************
--*                                                                         *
--*   Ce programme est un logiciel libre, distribué selon les termes de la  *
--*   licence CeCILL v2.1 disponible à l'adresse suivante :                 *
--*   http://www.cecill.info/licences/Licence_CeCILL_V2.1-fr.html           *
--*   ou toute autre version ultérieure.                                    *
--*                                                                         *
--/***************************************************************************/

SET client_encoding = 'UTF8';

CREATE OR REPLACE FUNCTION public.__var_zt(nom_ter text, an_bdtopo text, an_iris text, an_topage text)
 RETURNS void
 LANGUAGE plpgsql
AS $function$

-- Fonction SQL d'incrémentation de la table zt (périmètres de calcul élémentaires : contours IRIS GE intersectant le périmètre d'étude) dans le schéma c_phenomenes
-- © Cerema / GT AgiRisk
-- Dernières mises à jour du script le 19/06/2023 par Christophe (placement des conditions les plus discriminantes et les plus rapides en premier, lignes 93 à 96) et le 25/08/2023 par Sébastien (suppression de la partie regénération des index en juillet 2023 et test du script avec succès sur Longuyon le 24/08/2023)

-- Paramètres d'entrée :
-- nom_ter = nom du territoire d'étude tel que renseigné dans le champ `territoire` de la table c_general.territoires
-- an_bdtopo = millésime (année au format AAAA) de la BD TOPO®
-- an_iris = millésime (année au format AAAA) de la table des IRIS Grande Échelle
-- an_bdtopage = millésime (année au format AAAA) de la BD TOPAGE® (qui remplace la BD CARTHAGE® depuis 2020)

-- Exemple d'appel à cette fonction :
-- SELECT public.__var_zt('TRI Verdun', '2022', '2022', '2019');

DECLARE
	c integer; -- un compteur des lignes modifiées pour logging
	heure1 varchar; -- heure de début du traitement
	heure2 varchar; -- heure de fin du traitement

BEGIN
	heure1 = clock_timestamp();

	--************************************************************************
	-- Définition des schémas de travail
	--************************************************************************
	SET SEARCH_PATH TO public, c_phenomenes, r_sandre_bdtopage, r_ign_irisge, r_ign_bdtopo;

	RAISE NOTICE '';
	RAISE NOTICE '====== RAPPORT ======';
	RAISE NOTICE 'Calcul de la variable Zt (périmètres de calcul élémentaires) sur le territoire "%"', nom_ter;
	RAISE NOTICE 'Début du traitement : %', heure1;

	--************************************************************************
	-- Vérification de l'existence du territoire dans la table c_general.territoires
	--************************************************************************
	IF NOT EXISTS (
		SELECT *
		FROM c_general.territoires
		WHERE territoire = ''||nom_ter||''
	)
	THEN
		RAISE EXCEPTION 'Il n''y a pas de territoire "%" dans la table c_general.territoires. Fin de l''exécution', nom_ter;
	END IF;

	--************************************************************************
	-- Vérification de l'absence du territoire renseigné dans la table c_phenomenes.zt
	--************************************************************************
	IF EXISTS (
		SELECT *
		FROM c_phenomenes.zt
		WHERE territoire = ''||nom_ter||''
	)
	THEN
		RAISE EXCEPTION 'Il existe déjà des enregistrements pour le territoire "%" dans la table c_phenomenes.zt. 
		Pour les supprimer, lancer la requête suivante : 
		DELETE FROM c_phenomenes.zt WHERE territoire = ''%'';', nom_ter, REPLACE(nom_ter,'''','''''');
	END IF;
/*
	--************************************************************************
	-- Correction des géométries dans la couche c_general.territoires pour éviter les erreurs bloquantes
	--************************************************************************
	-- TO-DO : déplacer cette partie de correction des geom de la table <territoires> lors de l'import de territoire depuis le plugin
	RAISE NOTICE 'Correction des géométries dans la couche c_general.territoires pour éviter les erreurs bloquantes';
	EXECUTE 'UPDATE c_general.territoires
	SET geom = ST_Multi(ST_Simplify(ST_CollectionExtract(ST_ForceCollection(ST_MakeValid(geom)),3),0))
	WHERE __util_to_snake_case(territoire) = '''||__util_to_snake_case(nom_ter)||'''';
*/
	--************************************************************************
	-- Calcul Zt pour le territoire renseigné
	--************************************************************************
	RAISE NOTICE '';
	RAISE NOTICE '[INFO] Les contours IRIS GE n''ont pas encore été importés pour le territoire "%" dans la table c_phenomenes.zt. 
			Import en cours...', nom_ter;
	EXECUTE '
		WITH administratif AS (
			SELECT
				'''||REPLACE(nom_ter,'''','''''')||''' AS territoire,
				iris.code_iris AS id_iris,
				CASE
					WHEN iris.nom_com = iris.nom_iris THEN iris.nom_com
					ELSE iris.nom_com || '' - '' || iris.nom_iris
				END AS libelle,
				iris.insee_com AS id_commune,
				commune.siren_epci AS id_epci,
				commune.insee_dep AS id_dpt,
				commune.insee_reg AS id_region,
				''IRIS GE IGN '||an_iris||', BD TOPO IGN '||an_bdtopo||''' AS sce_donnee,
				''__var_zt'' AS moda_calc,
				current_date AS date_calc,
				st_multi(iris.geom) AS geom
			FROM irisge_'||an_iris||' iris, commune_'||an_bdtopo||' commune, c_general.territoires ter
			WHERE iris.insee_com = commune.insee_com
				AND __util_to_snake_case(ter.territoire) = '''||__util_to_snake_case(nom_ter)||'''
				AND iris.geom && ter.geom
				AND ST_Intersects(ST_Buffer(iris.geom, -1), ter.geom)				
		)
		INSERT INTO zt(territoire, id_iris, libelle, id_commune, id_epci, id_dpt, id_region, sce_donnee, moda_calc, date_calc, geom)
		SELECT *
		FROM administratif';

	--************************************************************************
	-- Récupère le nombre d'entités ajoutées
	--************************************************************************
	GET DIAGNOSTICS c = row_count;

	--************************************************************************
	-- Création de la vue matérialisée zt sur le territoire
	--************************************************************************
	RAISE NOTICE '';
	RAISE NOTICE 'Création de la vue matérialisée %', 'c_phenomenes.zt_'||__util_to_snake_case(nom_ter);
	EXECUTE '
		DROP MATERIALIZED VIEW IF EXISTS c_phenomenes.zt_'||__util_to_snake_case(nom_ter)||' CASCADE;
		CREATE MATERIALIZED VIEW c_phenomenes.zt_'||__util_to_snake_case(nom_ter)||' AS
		SELECT *
		FROM c_phenomenes.zt
		WHERE __util_to_snake_case(zt.territoire) = '''||__util_to_snake_case(nom_ter)||'''';

	-- Création des index sur la vue matérialisée
	RAISE NOTICE 'Création des index sur la vue matérialisée';

	EXECUTE 'CREATE UNIQUE INDEX ON c_phenomenes.zt_'||__util_to_snake_case(nom_ter)||' (id)';

	EXECUTE 'CREATE INDEX ON c_phenomenes.zt_'||__util_to_snake_case(nom_ter)||' USING gist(geom)';
	EXECUTE 'CREATE INDEX ON c_phenomenes.zt_'||__util_to_snake_case(nom_ter)||' USING btree(id)';
	EXECUTE 'CREATE INDEX ON c_phenomenes.zt_'||__util_to_snake_case(nom_ter)||' USING btree(territoire)';
	EXECUTE 'CREATE INDEX ON c_phenomenes.zt_'||__util_to_snake_case(nom_ter)||' USING btree(id_iris)';
	EXECUTE 'CREATE INDEX ON c_phenomenes.zt_'||__util_to_snake_case(nom_ter)||' USING btree(libelle)';
	EXECUTE 'CREATE INDEX ON c_phenomenes.zt_'||__util_to_snake_case(nom_ter)||' USING btree(id_commune)';
	EXECUTE 'CREATE INDEX ON c_phenomenes.zt_'||__util_to_snake_case(nom_ter)||' USING btree(id_epci)';
	EXECUTE 'CREATE INDEX ON c_phenomenes.zt_'||__util_to_snake_case(nom_ter)||' USING btree(id_dpt)';
	EXECUTE 'CREATE INDEX ON c_phenomenes.zt_'||__util_to_snake_case(nom_ter)||' USING btree(id_region)';
	EXECUTE 'CREATE INDEX ON c_phenomenes.zt_'||__util_to_snake_case(nom_ter)||' USING btree(sce_donnee )';
	EXECUTE 'CREATE INDEX ON c_phenomenes.zt_'||__util_to_snake_case(nom_ter)||' USING btree(moda_calc)';
	EXECUTE 'CREATE INDEX ON c_phenomenes.zt_'||__util_to_snake_case(nom_ter)||' USING btree(date_calc)';
	RAISE NOTICE 'Index créés sur la vue matérialisée';

	--************************************************************************
	-- Conclusion
	--************************************************************************
	RAISE NOTICE '';
	RAISE NOTICE '====== FIN TRAITEMENT ======';
	RAISE NOTICE '[INFO] La table zt (périmètres de calcul élémentaires) a été mise à jour dans le schéma c_phenomenes pour le territoire de "%"', nom_ter;
	RAISE NOTICE '';
	RAISE NOTICE '====== RÉSULTATS ======';
	IF c > 1
		THEN RAISE NOTICE '% IRIS insérés au total dans la table c_occupation_sol.zt pour le territoire "%"', c, nom_ter;
		ELSE RAISE NOTICE '% IRIS inséré dans la table c_occupation_sol.zt pour le territoire "%"', c, nom_ter;
	END IF;
	RAISE NOTICE '';
   	heure2 = clock_timestamp();
	RAISE NOTICE 'Fin du traitement : %', heure2;
	RAISE NOTICE 'Durée du traitement : %', CAST(heure2 as time)-CAST(heure1 as time);
	RAISE NOTICE '';

END;
$function$
