SET client_encoding = 'UTF8';

CREATE OR REPLACE FUNCTION public.__var_oc2_ref(nom_ter text, an_ff text, an_bdtopo text)
 RETURNS void
 LANGUAGE plpgsql
AS $function$

-- Modalité de calcul d'Oc2 basée sur l'ancienne méthode issue du Référentiel national de vulnérabilité aux inondations + compléments avec méthode Cerema Centre-Est

-- Fonction SQL d'incrémentation du champ attributaire booléen oc2 (logements) dans la table c_occupation_sol.oc1
-- © Cerema / GT AgiRisk
-- Dernière mise à jour du script le 27/08/2023 par Sébastien

-- Paramètres d'entrée :
-- nom_ter = nom du territoire d'étude tel que renseigné dans le champ `territoire` de la table c_general.territoires
-- an_ff = millésime (année au format AAAA) des Fichiers Fonciers (FF)
-- an_bdtopo = millésime (année au format AAAA) de la BD TOPO®

-- Exemple d'appel à cette fonction :
-- SELECT public.__var_oc2_ref('Jura', '2021', '2022');

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
	RAISE NOTICE 'Calcul de la variable Oc2 (logements) selon la méthode "Référentiel + Cerema Centre-Est" sur le territoire "%"', nom_ter;
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
	-- Vérification de l'absence du territoire renseigné dans la table c_occupation_sol.oc2_ref
	--************************************************************************
	IF EXISTS (
		SELECT *
		FROM c_occupation_sol.oc2_ref
		WHERE territoire = ''||nom_ter||''
	)
	THEN
		RAISE EXCEPTION 'Il existe déjà des enregistrements pour le territoire "%" dans la table c_occupation_sol.oc2_ref. 
		Pour les supprimer, lancer la requête suivante : 
		DELETE FROM c_occupation_sol.oc2_ref WHERE territoire = ''%'';', nom_ter, REPLACE(nom_ter,'''','''''');
	END IF;

	--************************************************************************
	-- Méthode de calcul Oc2
	--************************************************************************
	-- On considère que les logements sont constitués du bâti de la BD TOPO® auquel on soustrait :
		-- les bâtiments en zone d'activité ;
		-- les bâtiments qui intersectent des parcelles des fichiers fonciers dont nloclog = 0 ;
		-- les bâtiments de plus de 100m de haut et ceux de moins de 20m² d'emprise au sol.

	--************************************************************************
	-- Création d'une table temporaire des parcelles TUP
	--************************************************************************
	EXECUTE 'DROP TABLE IF EXISTS tup_ff CASCADE';
	EXECUTE 'CREATE TEMP TABLE tup_ff AS
		SELECT tup.*
		FROM ff'||an_ff||'.ffta_'||an_ff||'_tup AS tup
		JOIN territoires AS ter
		ON ST_Intersects(tup.geomloc, ter.geom)
		WHERE __util_to_snake_case(ter.territoire) = '''||__util_to_snake_case(nom_ter)||'''';

	EXECUTE 'CREATE INDEX ON tup_ff USING gist(geomtup)';
	EXECUTE 'CREATE INDEX ON tup_ff USING gist(geomloc)';
	EXECUTE 'CREATE INDEX ON tup_ff USING btree(idtup)';
	EXECUTE 'CREATE INDEX ON tup_ff USING btree(nloclog)';

	RAISE NOTICE '[INFO] La couche temporaire des parcelles TUP sur le territoire "%" a bien été créée et indexée sur les champs geomtup, geomloc, idtup et nloclog', nom_ter;

	--************************************************************************
	-- Création d'une table temporaire des zones d'activité ou d'intérêt
	--************************************************************************
	EXECUTE 'DROP TABLE IF EXISTS zone_d_activite_ou_d_interet_temp CASCADE';
	EXECUTE 'CREATE TEMP TABLE zone_d_activite_ou_d_interet_temp AS
		SELECT act.*
		FROM r_ign_bdtopo.zone_d_activite_ou_d_interet_'||an_bdtopo||' AS act
		JOIN territoires AS ter
		ON ST_Intersects(act.geomloc, ter.geom)
		WHERE __util_to_snake_case(ter.territoire) = '''||__util_to_snake_case(nom_ter)||'''';

	EXECUTE 'CREATE INDEX ON zone_d_activite_ou_d_interet_temp USING gist(geom)';

	RAISE NOTICE '[INFO] La couche temporaire des zones d''activité ou d''intérêt sur le territoire "%" a bien été créée et indexée sur le champ geom', nom_ter;

	--************************************************************************
	-- Constitution d'une table temporaire logmt
	--************************************************************************
	RAISE NOTICE '[INFO] Création d''une table temporaire inter_oc1_zai des bâtiments qui intersectent les ZAI';

	PERFORM __util_subdivide(''||nom_ter||'','zone_d_activite_ou_d_interet_temp','zai','geom');

	RAISE NOTICE '[INFO] La couche l_subdivide_zai a été créée';

	EXECUTE 'DROP TABLE IF EXISTS inter_oc1_zai CASCADE';
	EXECUTE 'CREATE TEMP TABLE inter_oc1_zai AS
	SELECT oc1.id,
	ST_Area(oc1.geom)::double precision as area_tot,
	CASE
		WHEN ST_Within(oc1.geom,act.geom) THEN ST_Area(oc1.geom)
		ELSE ST_Area(ST_Multi(ST_CollectionExtract(ST_ForceCollection(ST_MakeValid(ST_Intersection(oc1.geom,act.geom))),3)))
	END::double precision as area_inter
	FROM oc1
	JOIN l_subdivide_zai AS act
	ON ST_Intersects(oc1.geom, act.geom)
	WHERE __util_to_snake_case(oc1.territoire) = '''||__util_to_snake_case(nom_ter)||'''
	';

	EXECUTE 'CREATE INDEX ON inter_oc1_zai USING btree(id)';
	EXECUTE 'CREATE INDEX ON inter_oc1_zai USING btree(area_tot)';
	EXECUTE 'CREATE INDEX ON inter_oc1_zai USING btree(area_inter)';

	RAISE NOTICE '[INFO] Création d''une table temporaire oc1_zai des bâtiments situés à plus de 20 pourcents en ZAI';

	EXECUTE 'DROP TABLE IF EXISTS oc1_zai CASCADE';
	EXECUTE 'CREATE TEMP TABLE oc1_zai AS
	SELECT id
	FROM inter_oc1_zai
	GROUP BY id
	HAVING SUM(area_inter) / SUM(area_tot) > 0.2
	';	

	RAISE NOTICE '[INFO] Création d''une table temporaire inter_oc1_tup des bâtiments qui intersectent les TUP sans logement';

	PERFORM __util_subdivide(''||nom_ter||'','tup_ff','tup','geomtup');

	RAISE NOTICE '[INFO] La couche l_subdivide_tup a été créée';

	EXECUTE 'DROP TABLE IF EXISTS inter_oc1_tup CASCADE';
	EXECUTE 'CREATE TEMP TABLE inter_oc1_tup AS
	SELECT oc1.id,
	ST_Area(oc1.geom)::double precision as area_tot,
	CASE
		WHEN ST_Within(oc1.geom,tup.geom) THEN ST_Area(oc1.geom)
		ELSE ST_Area(ST_Multi(ST_CollectionExtract(ST_ForceCollection(ST_MakeValid(ST_Intersection(oc1.geom,tup.geom))),3)))
	END::double precision as area_inter
	FROM oc1
	JOIN l_subdivide_tup AS tup
	ON ST_Intersects(oc1.geom, tup.geom)
	WHERE __util_to_snake_case(oc1.territoire) = '''||__util_to_snake_case(nom_ter)||'''
		AND tup.nloclog = 0
	';

	EXECUTE 'CREATE INDEX ON inter_oc1_tup USING btree(id)';
	EXECUTE 'CREATE INDEX ON inter_oc1_tup USING btree(area_tot)';
	EXECUTE 'CREATE INDEX ON inter_oc1_tup USING btree(area_inter)';

	RAISE NOTICE '[INFO] Création d''une table temporaire oc1_tup des bâtiments situés à plus de 20 pourcents sur une TUP sans logement';

	EXECUTE 'DROP TABLE IF EXISTS oc1_tup CASCADE';
	EXECUTE 'CREATE TEMP TABLE oc1_tup AS
	SELECT id
	FROM inter_oc1_tup
	GROUP BY id
	HAVING SUM(area_inter) / SUM(area_tot) > 0.2
	';

	EXECUTE 'CREATE INDEX ON oc1_tup USING btree(id)';

	EXECUTE 'DROP TABLE IF EXISTS logmt CASCADE';
	EXECUTE 'CREATE TEMP TABLE logmt AS
		-- on ajoute les bâtiments bien appariés avec les logements FF
		SELECT *
		FROM oc1
		WHERE __util_to_snake_case(territoire) = '''||__util_to_snake_case(nom_ter)||'''
			AND nb_logts_bdt > 0
		
		UNION
		
		-- on ajoute les bâtiments à usage Résidentiel qui ne sont pas appariés dans les FF à un bâtiment de logement
		SELECT *
		FROM oc1
		WHERE __util_to_snake_case(territoire) = '''||__util_to_snake_case(nom_ter)||'''
			AND (usage1 = ''Résidentiel'' OR usage2 = ''Résidentiel'')
			AND (nb_logts_bdt IS NULL OR nb_logts_bdt != 0)
		
		UNION
		
		-- on ajoute les bâtiments non appariés avec les FF issus de la méthode "Référentiel + Cerema Centre-Est"
		SELECT *
		FROM oc1
		WHERE __util_to_snake_case(territoire) = '''||__util_to_snake_case(nom_ter)||'''
			AND usage1 = ''Indifférencié''
			AND (ST_Area(geom) > 20 AND hauteur_bdt < 100)			
			AND id NOT IN
				-- qui ne sont pas en ZAI (= plus de 20% du bâtiment en ZAI)
				(
					SELECT id
					FROM oc1_zai
				)
			AND id NOT IN
				-- qui ne sont pas sur une parcelle TUP sans logement (= plus de 20% du bâtiment en parcelle sans logement)
				(
					SELECT id
					FROM oc1_tup
				)
			AND id NOT IN
				-- qui ne sont pas déjà repérés comme bâti sans logement
				(
					SELECT oc1.id
					FROM oc1
					WHERE __util_to_snake_case(territoire) = '''||__util_to_snake_case(nom_ter)||'''
						AND nb_logts_bdt = 0
				)
		';
	
	EXECUTE 'CREATE INDEX ON logmt USING btree(id)';
	
	RAISE NOTICE '[INFO] La couche temporaire des logements sur le territoire "%" a bien été créée et indexée sur le champ id', nom_ter;

	--************************************************************************
	-- Mise à jour de la table c_occupation_sol.oc2_ref correspondant au croisement entre les Fichiers Fonciers et la BD TOPO®
	--************************************************************************
	RAISE NOTICE 'Mise à jour de la table c_occupation_sol.oc2_ref';
	EXECUTE 'INSERT INTO c_occupation_sol.oc2_ref(
			territoire,
			id_bdt,
			nb_logts_ind,
			nb_appts,
			id_logt,
			type_logt,
			niv_logt,
			typo_acb,
			surf_polygon_tot,
			surf_rdc_rect_tot,
			sous_sol,
			surf_ssol_tot_bat,
			surf_ssol_rap_logt,
			sce_donnee,
			moda_calc,
			date_calc,
			geom,
			geomloc
		)
		SELECT DISTINCT
			logmt.territoire AS territoire,
			logmt.id_bdt AS id_bdt,
			0 AS nb_logts_ind,
			0 AS nb_appts,
			-9999 AS id_logt,
			NULL AS type_logt,
			''NON PRECISE'' AS niv_logt,
			NULL AS typo_acb,
			ROUND(CAST(ST_Area(logmt.geom) AS numeric),2) AS surf_polygon_tot,
			0 AS surf_rdc_rect_tot,
			false AS sous_sol,
			0 AS surf_ssol_tot_bat,
			0 AS surf_ssol_rap_logt,
			''Fichiers Fonciers '||an_ff||''' AS sce_donnee,
			''__var_oc2_ref'' AS moda_calc,
			current_date AS date_calc,
			logmt.geom AS geom,
			logmt.geomloc AS geomloc
		FROM logmt
		';
	
	 --************************************************************************
	-- Création de la vue matérialisée oc2_ref sur le territoire
	--************************************************************************
	RAISE NOTICE '';
	RAISE NOTICE 'Création de la vue matérialisée %', 'c_occupation_sol.oc2_ref_'||__util_to_snake_case(nom_ter);
	EXECUTE '
		DROP MATERIALIZED VIEW IF EXISTS c_occupation_sol.oc2_ref_'||__util_to_snake_case(nom_ter)||' CASCADE;
		CREATE MATERIALIZED VIEW c_occupation_sol.oc2_ref_'||__util_to_snake_case(nom_ter)||' AS
		SELECT *
		FROM c_occupation_sol.oc2_ref
		WHERE __util_to_snake_case(territoire) = '''||__util_to_snake_case(nom_ter)||'''';

	RAISE NOTICE 'Vue matérialisée créée';

	-- Création des index sur la vue matérialisée
	RAISE NOTICE 'Création des index sur la vue matérialisée';

	EXECUTE 'CREATE UNIQUE INDEX ON c_occupation_sol.oc2_ref_'||__util_to_snake_case(nom_ter)||' (id)';

	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc2_ref_'||__util_to_snake_case(nom_ter)||' USING gist(geom)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc2_ref_'||__util_to_snake_case(nom_ter)||' USING gist(geomloc)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc2_ref_'||__util_to_snake_case(nom_ter)||' USING btree(id)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc2_ref_'||__util_to_snake_case(nom_ter)||' USING btree(territoire)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc2_ref_'||__util_to_snake_case(nom_ter)||' USING btree(id_bdt)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc2_ref_'||__util_to_snake_case(nom_ter)||' USING btree(nb_logts_ind)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc2_ref_'||__util_to_snake_case(nom_ter)||' USING btree(nb_appts)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc2_ref_'||__util_to_snake_case(nom_ter)||' USING btree(id_logt)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc2_ref_'||__util_to_snake_case(nom_ter)||' USING btree(type_logt)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc2_ref_'||__util_to_snake_case(nom_ter)||' USING btree(niv_logt)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc2_ref_'||__util_to_snake_case(nom_ter)||' USING btree(typo_acb)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc2_ref_'||__util_to_snake_case(nom_ter)||' USING btree(surf_polygon_tot)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc2_ref_'||__util_to_snake_case(nom_ter)||' USING btree(surf_rdc_rect_tot)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc2_ref_'||__util_to_snake_case(nom_ter)||' USING btree(sous_sol)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc2_ref_'||__util_to_snake_case(nom_ter)||' USING btree(surf_ssol_tot_bat)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc2_ref_'||__util_to_snake_case(nom_ter)||' USING btree(surf_ssol_rap_logt)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc2_ref_'||__util_to_snake_case(nom_ter)||' USING btree(sce_donnee)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc2_ref_'||__util_to_snake_case(nom_ter)||' USING btree(moda_calc)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc2_ref_'||__util_to_snake_case(nom_ter)||' USING btree(date_calc)';
	RAISE NOTICE 'Index créés sur la vue matérialisée';

	--************************************************************************
	-- Requête mettant à jour le champ booléen oc2 de la table oc1
	--************************************************************************
	EXECUTE '
		UPDATE c_occupation_sol.oc1
		SET oc2 = ''true''
		FROM oc2_ref
		WHERE __util_to_snake_case(oc1.territoire) = '''||__util_to_snake_case(nom_ter)||'''
			AND oc2_ref.id_bdt = oc1.id_bdt';

	--************************************************************************
	-- Requête mettant à jour le champ nb_logts_corr de la table oc1
	--************************************************************************
	EXECUTE '
		UPDATE c_occupation_sol.oc1
		SET nb_logts_corr =
			CASE
				WHEN nb_logts_bdt IS NULL AND oc2 = ''false'' THEN 0
				WHEN nb_logts_bdt IS NULL AND oc2 = ''true'' THEN 1
				ELSE nb_logts_bdt
			END
		WHERE __util_to_snake_case(oc1.territoire) = '''||__util_to_snake_case(nom_ter)||'''';

	--************************************************************************
	-- Récupère le nombre d'entités modifiées
	--************************************************************************
	GET DIAGNOSTICS c = row_count;

	--************************************************************************
	-- Mise à jour de la vue matérialisée oc1 sur le territoire
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

	--************************************************************************
	-- Conclusion
	--************************************************************************
	RAISE NOTICE '';
	RAISE NOTICE '====== FIN TRAITEMENT ======';
	RAISE NOTICE '[INFO] Le champ oc2 (logements) a été mis à jour et indexé dans la couche oc1 (bâtiments) sur le territoire "%"', nom_ter;
	RAISE NOTICE '';
	RAISE NOTICE '====== RÉSULTATS ======';
	RAISE NOTICE '% entités modifiées pour "%" dans la table c_occupation_sol.oc1', c, nom_ter;
	heure2 = clock_timestamp();
	RAISE NOTICE 'Fin du traitement : %', heure2;
	RAISE NOTICE 'Durée du traitement : %', CAST(heure2 as time)-CAST(heure1 as time);
	RAISE NOTICE '';

END;
$function$
