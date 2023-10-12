CREATE OR REPLACE FUNCTION public.__var_oc1(nom_ter text, an_bdtopo text)
 RETURNS void
 LANGUAGE plpgsql
AS $function$

-- Fonction SQL d'incrémentation de la table oc1 (bâtiments) dans le schéma c_occupation_sol
-- Copyright Cerema / GT AgiRisk

-- Paramètres d'entrée :
-- nom_ter = nom du territoire d'étude tel que renseigné dans le champ `territoire` de la table c_general.territoires
-- an_bdtopo = millésime (année au format AAAA) de la BD TOPO®

-- Exemple d'appel à cette fonction : SELECT public.__var_oc1('Jura', '2022');

DECLARE
	c integer; -- un compteur des lignes modifiées pour logging
	heure1 varchar; -- heure de début du traitement
	heure2 varchar; -- heure de fin du traitement

BEGIN
	heure1 = clock_timestamp();
	
	--************************************************************************
	-- Définition des schémas de travail
	--************************************************************************
	SET SEARCH_PATH TO c_general, c_phenomenes, c_occupation_sol, r_ign_bdtopo, public;
	
	RAISE NOTICE '';
    RAISE NOTICE '====== RAPPORT ======';
    RAISE NOTICE 'Calcul de la variable Oc1 (bâtiments) sur le territoire ''%''', nom_ter;
    RAISE NOTICE 'Début du traitement : %', heure1;
	
    --************************************************************************
    -- Vérification de l'existence du territoire renseigné dans la table c_phenomenes.zt
    --************************************************************************
	IF NOT EXISTS (
		SELECT *
		FROM zt
		WHERE territoire = nom_ter
	)
	THEN
		RAISE EXCEPTION 'Il n''y a pas de territoire "%" dans la table c_phenomenes.zt. Fin de l''exécution.', nom_ter;
	END IF;
		
    --************************************************************************
    -- Vérification de l'existence du territoire renseigné dans la table c_occupation_sol.oc1
    --************************************************************************
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
		
	--************************************************************************
	-- Calcul d'Oc1
	--************************************************************************
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
			hauteur,
			nb_logts,
			nb_etages,
			sce_donnee,
			url,
			date_calcul,
			modalite_calcul,
			geom,
			geomloc)
		SELECT DISTINCT
			''' || nom_ter || ''' AS territoire,
                zt.id_iris AS id_iris,
                zt.libelle AS nom_iris,
				bati.id,
				bati.nature,
				bati.usage1,
				bati.usage2,
				bati.leger,
				bati.etat,
				bati.hauteur,
				bati.nb_logts,
				bati.nb_etages,
				''BDTOPO'' AS sce_donnee,
				''https://geoservices.ign.fr/telechargement'' as url,
				current_date AS date_calcul,
				''__var_oc1''::varchar(50) AS modalite_calcul,
				bati.geom,
				bati.geomloc
				FROM batiment_'||an_bdtopo||' as bati
				JOIN zt
				ON zt.territoire = ''' || nom_ter || '''
				AND ST_Intersects(bati.geom, zt.geom)
				';
		
    --************************************************************************
    -- Récupère le nombre d'entités ajoutées
    --************************************************************************
		GET DIAGNOSTICS c = row_count;

    --************************************************************************
    -- Création de la vue matérialisée sur le territoire
    --************************************************************************
		EXECUTE '
			DROP MATERIALIZED VIEW IF EXISTS c_occupation_sol.oc1_' || __util_to_snake_case(nom_ter) || ';
			CREATE MATERIALIZED VIEW c_occupation_sol.oc1_' || __util_to_snake_case(nom_ter) || ' as
			SELECT *
			FROM c_occupation_sol.oc1
			WHERE territoire = ''' || nom_ter || '''
			ORDER BY nom_iris
		';
		
		EXECUTE 'CREATE UNIQUE INDEX
		ON oc1_' || __util_to_snake_case(nom_ter) || ' (id)';

    --************************************************************************
    -- Création des index sur la vue
    --************************************************************************
		EXECUTE 'CREATE INDEX ON c_occupation_sol.oc1_' || __util_to_snake_case(nom_ter) || ' USING gist(geom)';
		EXECUTE 'CREATE INDEX ON c_occupation_sol.oc1_' || __util_to_snake_case(nom_ter) || ' USING btree(id)';
		EXECUTE 'CREATE INDEX ON c_occupation_sol.oc1_' || __util_to_snake_case(nom_ter) || ' USING btree(id_bdt)';
		EXECUTE 'CREATE INDEX ON c_occupation_sol.oc1_' || __util_to_snake_case(nom_ter) || ' USING btree(territoire)';
		EXECUTE 'CREATE INDEX ON c_occupation_sol.oc1_' || __util_to_snake_case(nom_ter) || ' USING btree(id_iris)';
		EXECUTE 'CREATE INDEX ON c_occupation_sol.oc1_' || __util_to_snake_case(nom_ter) || ' USING btree(nom_iris)';

	--************************************************************************
    -- Conclusion
    --************************************************************************
		RAISE NOTICE '';
		RAISE NOTICE '====== FIN TRAITEMENT ======';
		RAISE NOTICE '[INFO] La table oc1 (bâtiments) a été mise à jour dans le schéma c_occupation_sol pour le territoire de ''%''', nom_ter;
		RAISE NOTICE '';
		RAISE NOTICE '====== RESULTATS ======';
		RAISE NOTICE '% entités ajoutées pour le territoire ''%'' dans la table c_occupation_sol.oc1', c, nom_ter;
		RAISE NOTICE 'Création de la vue "%"', 'c_occupation_sol.oc1_' || __util_to_snake_case(nom_ter);
		heure2 = clock_timestamp();
		RAISE NOTICE 'Fin du traitement : %', heure2;
		RAISE NOTICE 'Durée du traitement : %', CAST(heure2 as time)-CAST(heure1 as time);
		RAISE NOTICE '';
		
	END IF;

END;
$function$
