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

CREATE OR REPLACE FUNCTION public.__var_zq(nom_ter text, typ_alea text, code_occ text, desc_alea text)
 RETURNS void
 LANGUAGE plpgsql
AS $function$

-- Fonction SQL de correction éventuelle des géométries après import et de constitution d'une vue matérialisée zq sur le territoire spécifié. 
-- Attention contrairement à d'autres __var_*, cette fonction crée seulement la vue matérialisée car l'aléa du territoire est ajouté à la table zq par le plugin.
-- © Cerema / GT AgiRisk (auteurs du script : Thomas, Sébastien)
-- Dernière mise à jour du script le 5/10/2023 par Christophe

-- Paramètres d'entrée :
-- nom_ter : nom du territoire d'étude tel que renseigné dans le champ `territoire` de la table c_general.territoires (ex : Jura, Scot de Tours, TRI Noirmoutier SJDM, TRI Verdun, Vienne Clain, Zorn)
-- typ_alea : type d'aléa considéré (ex : débordement de cours d'eau, submersion marine)
-- code_occ : période de retour considérée pour le type d'aléa choisi (ex : QRef, Q100, Q10)
-- desc_alea : description de la source de l'aléa (ex : PPRi de ..., Etude de modélisation ...)

-- Exemple d'appel à cette fonction :
-- SELECT public.__var_zq('Longuyon', 'débordement de cours d''eau', 'Q100', 'Modélisation Chiers BCEOM 2007');

DECLARE
	heure1 varchar; -- heure de début du traitement
	heure2 varchar; -- heure de fin du traitement des géométries invalides
	heure3 varchar; -- heure de fin du traitement total
	nb_geom_invalides integer; -- nombre de géométries invalides corrigées

BEGIN
	heure1 = clock_timestamp();

	--************************************************************************
	-- Définition des schémas de travail
	--************************************************************************
	SET SEARCH_PATH TO public, c_phenomenes;

	RAISE NOTICE '';
	RAISE NOTICE '====== RAPPORT ======';

   --************************************************************************
	-- Correction des géométries importées, au besoin
	--************************************************************************

	RAISE NOTICE 'Correction des éventuelles géométries invalides après import depuis le plugin';
	RAISE NOTICE 'Début du traitement : %', heure1;



	EXECUTE '		
		UPDATE c_phenomenes.zq SET geom = ST_Multi(ST_Simplify(ST_CollectionExtract(ST_ForceCollection(ST_MakeValid(geom)),3),0))
		WHERE __util_to_snake_case(territoire) = '''||__util_to_snake_case(nom_ter)||''' 
			AND __util_to_snake_case(type_alea) = '''||__util_to_snake_case(typ_alea)||'''
			AND __util_to_snake_case(code_occurrence) = '''||__util_to_snake_case(code_occ)||'''
			AND NOT ST_ISVALID(geom)';

	GET DIAGNOSTICS nb_geom_invalides = row_count;

	RAISE NOTICE '% géométries invalides corrigées',nb_geom_invalides;    

	heure2 = clock_timestamp();
	RAISE NOTICE 'Durée du traitement : %', CAST(heure2 as time)-CAST(heure1 as time);
	
   --************************************************************************
	-- Création de la vue matérialisée zq sur le territoire
	--************************************************************************

	RAISE NOTICE 'Création de la vue matérialisée zq sur le territoire';
	RAISE NOTICE 'Début du traitement : %', heure2;

	EXECUTE '
		DROP MATERIALIZED VIEW IF EXISTS c_phenomenes.zq_'||__util_to_snake_case(nom_ter)||' CASCADE;
		CREATE MATERIALIZED VIEW c_phenomenes.zq_'||__util_to_snake_case(nom_ter)||' AS
		SELECT *
		FROM c_phenomenes.zq
		WHERE __util_to_snake_case(territoire) = '''||__util_to_snake_case(nom_ter)||'''';

	-- Création des index sur la vue matérialisée
	RAISE NOTICE 'Création des index sur la vue matérialisée';

	EXECUTE 'CREATE UNIQUE INDEX ON c_phenomenes.zq_'||__util_to_snake_case(nom_ter)||' (id)';

	EXECUTE 'CREATE INDEX ON c_phenomenes.zq_'||__util_to_snake_case(nom_ter)||' USING gist(geom)';
	EXECUTE 'CREATE INDEX ON c_phenomenes.zq_'||__util_to_snake_case(nom_ter)||' USING btree(id)';
	EXECUTE 'CREATE INDEX ON c_phenomenes.zq_'||__util_to_snake_case(nom_ter)||' USING btree(territoire)';
	EXECUTE 'CREATE INDEX ON c_phenomenes.zq_'||__util_to_snake_case(nom_ter)||' USING btree(type_alea)';
	EXECUTE 'CREATE INDEX ON c_phenomenes.zq_'||__util_to_snake_case(nom_ter)||' USING btree(occurrence)';
	EXECUTE 'CREATE INDEX ON c_phenomenes.zq_'||__util_to_snake_case(nom_ter)||' USING btree(code_occurrence)';
	EXECUTE 'CREATE INDEX ON c_phenomenes.zq_'||__util_to_snake_case(nom_ter)||' USING btree(description_alea)';
	EXECUTE 'CREATE INDEX ON c_phenomenes.zq_'||__util_to_snake_case(nom_ter)||' USING btree(intensite_alea)';
	RAISE NOTICE 'Index créés sur la vue matérialisée';

	--************************************************************************
	-- Conclusion
	--************************************************************************
	RAISE NOTICE '';
	RAISE NOTICE '====== FIN TRAITEMENT ======';
	RAISE NOTICE '';
	RAISE NOTICE '====== RÉSULTATS ======';
	RAISE NOTICE 'Création de la vue "%"', 'c_phenomenes.zq_'||__util_to_snake_case(nom_ter);
	heure3 = clock_timestamp();
	RAISE NOTICE 'Fin du traitement : %', heure2;
	RAISE NOTICE 'Durée du traitement : %', CAST(heure3 as time)-CAST(heure1 as time);
	RAISE NOTICE '';

END;
$function$
;
