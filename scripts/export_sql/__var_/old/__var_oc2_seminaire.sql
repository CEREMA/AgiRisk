CREATE OR REPLACE FUNCTION public.__var_oc2(nom_ter text, an_ff text, an_bdtopo text)
 RETURNS void
 LANGUAGE plpgsql
AS $function$

DECLARE 
	c integer;

BEGIN


-- nom_ter = nom du territoire test
-- an_ff = millésime des Fichiers Fonciers
-- an_bdtopo = millésime de la BDTOPO®

	SET SEARCH_PATH TO c_general, c_phenomenes, c_occupation_sol, r_ign_bdtopo, public;

	-- On considère que les logements sont constitués du bâti de la BDTOPO® auquel on soustrait les bâtiments en zone d'activité,
	-- les bâtiments qui intersectent des parcelles des fichiers fonciers dont nloclog = 0
	-- les bâtiments de plus de 100m de haut et ceux de moins de 20m² d'emprise au sol

	RAISE NOTICE '';
	RAISE NOTICE '======	RAPPORT		======';
	
	-- Test de l'existence du territoire dans la table des territoires
	IF NOT EXISTS (
		SELECT *
		FROM territoires t 
		WHERE territoire = nom_ter
	)
	THEN
		RAISE EXCEPTION 'Il n''y a pas de territoire "%" dans la table c_general.territoires. Fin de l''exécution.', nom_ter;
	END IF;

	EXECUTE 'DROP TABLE IF EXISTS tup_ff CASCADE';
	EXECUTE 'CREATE TEMP TABLE tup_ff AS
	SELECT tup.*
	FROM ff'||an_ff||'.ffta_'||an_ff||'_tup as tup
	JOIN territoires as ter
	ON ST_Intersects(tup.geomloc,ter.geom)
	WHERE ter.territoire = '''||nom_ter||'''';

	EXECUTE 'CREATE INDEX ON tup_ff USING gist(geomtup)';
	EXECUTE 'CREATE INDEX ON tup_ff USING gist(geomloc)';
	EXECUTE 'CREATE INDEX ON tup_ff USING btree(idtup)';
	EXECUTE 'CREATE INDEX ON tup_ff USING btree(nloclog)';
	
	RAISE NOTICE '';
	RAISE NOTICE '[INFO] La couche temporaire des parcelles TUP sur le territoire de "%" a bien été créée et indexée sur les champs geomtup, geomloc, idtup et nloclog.',nom_ter;

	EXECUTE 'DROP TABLE IF EXISTS zone_d_activite_ou_d_interet CASCADE';
	EXECUTE 'CREATE TEMP TABLE zone_d_activite_ou_d_interet AS
	SELECT act.*
	FROM r_ign_bdtopo.zone_d_activite_ou_d_interet_'||an_bdtopo||' act
	JOIN territoires as ter
	ON ST_Intersects(act.geomloc,ter.geom)
	WHERE ter.territoire = '''||nom_ter||'''';

	EXECUTE 'CREATE INDEX ON zone_d_activite_ou_d_interet USING gist(geom)';

	RAISE NOTICE '';
	RAISE NOTICE '[INFO] La couche temporaire des zones d''activité ou d''intérêt sur le territoire de "%" a bien été créée et indexée sur le champ geom.',nom_ter;

	EXECUTE 'WITH logmt AS
	(
		-- on ajoute les bâtiments bien appariés avec les logements FF
		SELECT *
		FROM oc1
		WHERE territoire = '''||nom_ter||'''
			AND nb_logts > 0
		
		UNION
		
		-- on ajoute les bâtiments à usage Résidentiel qui ne sont pas appariés dans les FF à un bâtiment de logement
		SELECT *
		FROM oc1
		WHERE territoire = '''||nom_ter||'''
			AND (usage1 = ''Résidentiel'' OR usage2 = ''Résidentiel'')
			AND nb_logts != 0
		
		UNION
		
		-- on ajoute les bâtiments non appariés avec les FF issus de la méthode "référentiel + Cerema Centre-Est"
		SELECT *
		FROM oc1
		WHERE territoire = '''||nom_ter||'''
			AND (ST_Area(geom) > 20 AND hauteur < 100)
			AND usage1 = ''Indifférencié''
			AND id NOT IN
				-- qui ne sont pas en ZAI (= plus de 20% du bâtiment en ZAI)
				(
					SELECT oc1.id
					FROM oc1
					JOIN zone_d_activite_ou_d_interet as act
					ON ST_Intersects(oc1.geom,act.geom)
					WHERE oc1.territoire = '''||nom_ter||'''
						AND ST_Area(ST_Multi(ST_CollectionExtract(ST_ForceCollection(ST_MakeValid(ST_Intersection(oc1.geom,act.geom))),3))) / ST_Area(oc1.geom) > 0.2
				)
			AND id NOT IN
				-- qui ne sont pas sur une parcelle TUP sans logement (= plus de 20% du bâtiment en parcelle sans logement)
				(
					SELECT oc1.id
					FROM oc1
					JOIN tup_ff as tup
					ON ST_Intersects(oc1.geom,tup.geomtup)
					WHERE oc1.territoire = '''||nom_ter||'''
						AND ST_Area(ST_Multi(ST_CollectionExtract(ST_ForceCollection(ST_MakeValid(ST_Intersection(oc1.geom,tup.geomtup))),3))) / ST_Area(oc1.geom) > 0.2
						AND tup.nloclog = 0
				)
			AND id NOT IN
				-- qui ne sont pas déjà repérés comme bâti sans logement
				(
					SELECT oc1.id
					FROM oc1
					WHERE territoire = '''||nom_ter||'''
						AND nb_logts = 0
				)
	)
	UPDATE oc1
	SET oc2 = ''true''
	FROM logmt
	WHERE logmt.id = oc1.id
		AND oc1.territoire = '''||nom_ter||'''
		';
	
	-- Récupère le nombre d'entités modifiées
		GET DIAGNOSTICS c = row_count;
	
	EXECUTE 'COMMENT ON COLUMN oc1.oc2 IS ''Indique si le bâtiment est considéré comme un bâtiment de logement.''';
	EXECUTE 'CREATE INDEX ON oc1 USING btree(oc2)';

	RAISE NOTICE '';
	RAISE NOTICE '[INFO] Le champ oc2 (logements) a été mis à jour et indexé dans la couche oc1 (bâtiments) sur le territoire de "%"', nom_ter;
	RAISE NOTICE '';
	RAISE NOTICE '-----	Résultats';
	RAISE NOTICE '	% entités modifiées pour "%" dans Oc2', c, nom_ter;
	RAISE NOTICE '';
	
END;
$function$
;

SELECT public.__var_oc2('Jura','2021','2022');