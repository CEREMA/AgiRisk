CREATE OR REPLACE FUNCTION public.__var_oc1bis(nom_ter text, an_bdtopo text)
 RETURNS void
 LANGUAGE plpgsql
AS $function$

DECLARE 
	c integer;

BEGIN

	SET SEARCH_PATH TO c_general, c_phenomenes, c_occupation_sol, r_ign_bdtopo, public;
	
	RAISE NOTICE '';
	RAISE NOTICE '======	RAPPORT		======';
	
	-- Test de l'existence du territoire dans la table des territoires
	IF NOT EXISTS (
		SELECT *
		FROM c_phenomenes.zt
		WHERE territoire = nom_ter
	)
	THEN
		RAISE EXCEPTION 'Il n''y a pas de territoire "%" dans la table c_phenomenes.zt. Fin de l''exécution.', nom_ter;
	END IF;
		
	-- Test de l'existence du territoire dans Oc1
	IF EXISTS (SELECT *
			FROM oc1
			WHERE territoire = nom_ter
			)
	THEN
		RAISE EXCEPTION 'Les lignes pour le territoire de "%" ont déjà été importées dans la table oc1.
		Pour les supprimer, lancer la requête suivante : DELETE FROM c_occupation_sol.oc1 WHERE territoire = ''%'';',nom_ter,nom_ter;

	ELSE

		RAISE NOTICE '[INFO] Les lignes pour le territoire de "%" n''ont pas encore été importées dans la table oc1.
			Import en cours...',nom_ter;
		
		-- Calcul Oc1 pour le territoire donné
		EXECUTE 'INSERT INTO c_occupation_sol.oc1 (
			id_bdt,
			nature,
			usage1,
			usage2,
			leger,
			etat,
			hauteur,
			nb_logts,
			nb_etages,
			territoire,
			date_donnee,
			date_calcul,
			sce_donnee,
			geom,
			geomloc)
		SELECT DISTINCT
			bati.id,
			bati.nature,
			bati.usage1,
			bati.usage2,
			bati.leger,
			bati.etat,
			bati.hauteur,
			bati.nb_logts,
			bati.nb_etages,
			zt.territoire,
			to_date('''||an_bdt||''',''YYYY''),
			current_date,
			''BDTOPO '||an_bdt||''',
			bati.geom,
			bati.geomloc
		FROM batiment_'||an_bdt||' as bati
		JOIN zt
		ON ST_Intersects(bati.geomloc, zt.geom)
		WHERE zt.territoire = '''||nom_ter||'''';
		
		-- Récupère le nombre d'entités ajoutées
		GET DIAGNOSTICS c = row_count;

		-- Création de la vue matérialisée sur le territoire
		EXECUTE '
			DROP MATERIALIZED VIEW IF EXISTS c_occupation_sol.oc1_' || an_bdt || '_' || __util_to_snake_case(nom_ter) || ';
			CREATE MATERIALIZED VIEW c_occupation_sol.oc1_' || an_bdt || '_' || __util_to_snake_case(nom_ter) || ' as
			SELECT *
			FROM c_occupation_sol.oc1
			WHERE territoire = ''' || nom_ter || '''
		';

		RAISE NOTICE '-----	Résultats';
		RAISE NOTICE '	% entités ajoutées pour "%" dans Oc1', c, nom_ter;
		RAISE NOTICE '	Création de la vue "%"', 'c_occupation_sol.oc1_' || an_bdt || '_' || __util_to_snake_case(nom_ter);
		RAISE NOTICE '';

	END IF;

END;
$function$
;
