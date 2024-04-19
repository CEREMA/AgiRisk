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

CREATE OR REPLACE FUNCTION public.__var_oc1_geom(nom_ter text, an_bdtopo text)
 RETURNS void
 LANGUAGE plpgsql
AS $function$

-- Modalité de calcul d'Oc1 basée sur une intersection des polygones des bâtiments (champ geom de la table batiment de la BD TOPO®) avec le périmètre du territoire d'étude

-- Fonction SQL d'incrémentation de la table oc1 (bâtiments) dans le schéma c_occupation_sol
-- © Cerema / GT AgiRisk
-- Dernière mise à jour du script le 25/08/2023 par Sébastien (test avec succès sur Longuyon le 24/08/2023)

-- Paramètres d'entrée :
-- nom_ter = nom du territoire d'étude tel que renseigné dans le champ `territoire` de la table c_general.territoires
-- an_bdtopo = millésime (année au format AAAA) de la BD TOPO®

-- Exemple d'appel à cette fonction :
-- SELECT public.__var_oc1_geom('Jura', '2022');

DECLARE
	c integer; -- un compteur des lignes modifiées pour logging
	heure1 varchar; -- heure de début du traitement
	heure2 varchar; -- heure intermédiaire
	heure3 varchar; -- heure intermédiaire
	heure4 varchar; -- heure intermédiaire
	heure5 varchar; -- heure intermédiaire
	heure6 varchar; -- heure de fin du traitement

BEGIN
	heure1 = clock_timestamp();

	--************************************************************************
	-- Définition des schémas de travail
	--************************************************************************
	SET SEARCH_PATH TO c_general, c_phenomenes, c_occupation_sol, r_ign_bdtopo, public;

	RAISE NOTICE '';
	RAISE NOTICE '====== RAPPORT ======';
	RAISE NOTICE 'Calcul de la variable Oc1 (bâtiments) sur le territoire "%"', nom_ter;
	RAISE NOTICE 'Début du traitement : %', heure1;

	--************************************************************************
	-- Vérification de l'existence du territoire renseigné dans la table c_general.territoires
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
	-- Vérification de l'existence du territoire renseigné dans la table c_phenomenes.zt
	--************************************************************************
	IF NOT EXISTS (
		SELECT *
		FROM c_phenomenes.zt
		WHERE territoire = ''||nom_ter||''
	)
	THEN
		RAISE EXCEPTION 'Il n''y a pas de territoire "%" dans la table c_phenomenes.zt. Fin de l''exécution', nom_ter;
	END IF;

	--************************************************************************
	-- Vérification de l'absence du territoire renseigné dans la table c_occupation_sol.oc1
	--************************************************************************
	IF EXISTS (
		SELECT *
		FROM c_occupation_sol.oc1
		WHERE territoire = ''||nom_ter||''
	)
	THEN
		RAISE EXCEPTION 'Il existe déjà des enregistrements pour le territoire "%" dans la table c_occupation_sol.oc1. 
		Pour les supprimer, lancer la requête suivante : 
		DELETE FROM c_occupation_sol.oc1 WHERE territoire = ''%'';', nom_ter, REPLACE(nom_ter,'''','''''');
	END IF;

	--************************************************************************
	-- Calcul Oc1 sur la base d'une insertion des polygones (geom) avec le périmètre du territoire donné
	--************************************************************************
	RAISE NOTICE '';
	RAISE NOTICE '[INFO] Les bâtiments n''ont pas encore été importés pour le territoire "%" dans la table c_occupation_sol.oc1. 
			Import en cours...', nom_ter;

	heure2 = clock_timestamp(); -- ajout pour contrôler les temps de calcul à chaque étape

	EXECUTE 'INSERT INTO c_occupation_sol.oc1 (
			territoire,
			id_iris,
			nom_iris,
			id_bdt,
			nature,
			usage1,
			usage2,
			leger,
			etat,
			hauteur_bdt,
			nb_etages_bdt,
			nb_logts_bdt,
			sce_donnee,
			moda_calc,
			date_calc,
			geom,
			geomloc
		)
		SELECT DISTINCT
			'''||REPLACE(nom_ter,'''','''''')||''',
			zt.id_iris,
			zt.libelle,
			bati.id,
			bati.nature,
			bati.usage1,
			bati.usage2,
			bati.leger,
			bati.etat,
			bati.hauteur,
			bati.nb_etages,
			bati.nb_logts,
			''BD TOPO IGN '||an_bdtopo||''',
			''__var_oc1_geom'',
			current_date,
			st_multi(st_buffer(bati.geom, 0)) geom,
			bati.geomloc
		FROM batiment_'||an_bdtopo||' AS bati
		JOIN zt
		ON __util_to_snake_case(zt.territoire) = '''||__util_to_snake_case(nom_ter)||'''
		AND ST_Intersects(bati.geom, zt.geom)';

	heure3 = clock_timestamp();
	RAISE NOTICE 'Durée de l''étape d''incrémentation de la table oc1 : %', CAST(heure3 as time)-CAST(heure2 as time);

	--************************************************************************
	-- Récupère le nombre d'entités ajoutées
	--************************************************************************
	GET DIAGNOSTICS c = row_count;

	--************************************************************************
	-- Création de la vue matérialisée oc1 sur le territoire
	--************************************************************************
	RAISE NOTICE '';
	RAISE NOTICE 'Création de la vue matérialisée %', 'c_occupation_sol.oc1_'||__util_to_snake_case(nom_ter);
	EXECUTE '
		DROP MATERIALIZED VIEW IF EXISTS c_occupation_sol.oc1_'||__util_to_snake_case(nom_ter)||' CASCADE;
		CREATE MATERIALIZED VIEW c_occupation_sol.oc1_'||__util_to_snake_case(nom_ter)||' AS
		SELECT *
		FROM c_occupation_sol.oc1
		WHERE __util_to_snake_case(territoire) = '''||__util_to_snake_case(nom_ter)||'''
		ORDER BY nom_iris';

	RAISE NOTICE 'Vue matérialisée créée';
	heure4 = clock_timestamp();
	RAISE NOTICE 'Durée de l''étape de création de la vue matérialisée : %', CAST(heure4 as time)-CAST(heure3 as time);

	-- Création des index sur la vue matérialisée
	RAISE NOTICE 'Création des index sur la vue matérialisée';

	EXECUTE 'CREATE UNIQUE INDEX ON c_occupation_sol.oc1_'||__util_to_snake_case(nom_ter)||' (id)';

	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc1_'||__util_to_snake_case(nom_ter)||' USING gist(geom)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc1_'||__util_to_snake_case(nom_ter)||' USING gist(geomloc)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc1_'||__util_to_snake_case(nom_ter)||' USING btree(id)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc1_'||__util_to_snake_case(nom_ter)||' USING btree(territoire)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc1_'||__util_to_snake_case(nom_ter)||' USING btree(id_iris)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc1_'||__util_to_snake_case(nom_ter)||' USING btree(nom_iris)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc1_'||__util_to_snake_case(nom_ter)||' USING btree(id_bdt)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc1_'||__util_to_snake_case(nom_ter)||' USING btree(nature)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc1_'||__util_to_snake_case(nom_ter)||' USING btree(usage1)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc1_'||__util_to_snake_case(nom_ter)||' USING btree(usage2)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc1_'||__util_to_snake_case(nom_ter)||' USING btree(leger)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc1_'||__util_to_snake_case(nom_ter)||' USING btree(etat)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc1_'||__util_to_snake_case(nom_ter)||' USING btree(hauteur_bdt)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc1_'||__util_to_snake_case(nom_ter)||' USING btree(hauteur_corr)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc1_'||__util_to_snake_case(nom_ter)||' USING btree(nb_logts_bdt)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc1_'||__util_to_snake_case(nom_ter)||' USING btree(nb_logts_corr)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc1_'||__util_to_snake_case(nom_ter)||' USING btree(nb_etages_bdt)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc1_'||__util_to_snake_case(nom_ter)||' USING btree(nb_etages_corr)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc1_'||__util_to_snake_case(nom_ter)||' USING btree(plainpied)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc1_'||__util_to_snake_case(nom_ter)||' USING btree(idtup)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc1_'||__util_to_snake_case(nom_ter)||' USING btree(tlocdomin_ff)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc1_'||__util_to_snake_case(nom_ter)||' USING btree(oc2)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc1_'||__util_to_snake_case(nom_ter)||' USING btree(oc3)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc1_'||__util_to_snake_case(nom_ter)||' USING btree(pop1)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc1_'||__util_to_snake_case(nom_ter)||' USING btree(pop1_agee)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc1_'||__util_to_snake_case(nom_ter)||' USING btree(pop2_bas)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc1_'||__util_to_snake_case(nom_ter)||' USING btree(pop2_haut)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc1_'||__util_to_snake_case(nom_ter)||' USING btree(pop3)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc1_'||__util_to_snake_case(nom_ter)||' USING btree(pop4)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc1_'||__util_to_snake_case(nom_ter)||' USING btree(pop5)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc1_'||__util_to_snake_case(nom_ter)||' USING btree(pop6_bas)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc1_'||__util_to_snake_case(nom_ter)||' USING btree(pop6_haut)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc1_'||__util_to_snake_case(nom_ter)||' USING btree(capacite_touristique)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc1_'||__util_to_snake_case(nom_ter)||' USING btree(sce_donnee)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc1_'||__util_to_snake_case(nom_ter)||' USING btree(moda_calc)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc1_'||__util_to_snake_case(nom_ter)||' USING btree(date_calc)';

	RAISE NOTICE 'Index créés sur la vue matérialisée';
	heure5 = clock_timestamp();
	RAISE NOTICE 'Durée de l''étape de création des index sur la vue matérialisée : %', CAST(heure5 as time)-CAST(heure4 as time);

	--************************************************************************
	-- Conclusion
	--************************************************************************
	RAISE NOTICE '';
	RAISE NOTICE '====== FIN TRAITEMENT ======';
	RAISE NOTICE '[INFO] La table oc1 (bâtiments) a été mise à jour dans le schéma c_occupation_sol pour le territoire "%"', nom_ter;
	RAISE NOTICE '';
	RAISE NOTICE '====== RÉSULTATS ======';
	IF c > 1
		THEN RAISE NOTICE '% enregistrements insérés au total dans la table c_occupation_sol.oc1 pour le territoire "%"', c, nom_ter;
		ELSE RAISE NOTICE '% enregistrement inséré dans la table c_occupation_sol.oc1 pour le territoire "%"', c, nom_ter;
	END IF;
	RAISE NOTICE '';
	heure6 = clock_timestamp();
	RAISE NOTICE 'Fin du traitement : %', heure6;
	RAISE NOTICE 'Durée du traitement : %', CAST(heure6 as time)-CAST(heure1 as time);
	RAISE NOTICE '';
	
END;
$function$
