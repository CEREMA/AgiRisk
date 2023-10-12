CREATE OR REPLACE FUNCTION public.__var_pop5(nom_ter text, an_ff text)
 RETURNS void
 LANGUAGE plpgsql
AS $function$

BEGIN

-- nom_ter = nom du territoire test
-- an_ff = millésime des FF
-- an_pop = millésime de la couche population insee
-- chp_pop = nom du champ de temp_oc1 que l'on souhaite intégrer dans le champ pop1 d'Oc1 (pop1_nb ou pop1_s)

	-- 0. Préalables
	
	-- Définition des schémas de travail
	SET SEARCH_PATH TO c_occupation_sol, c_general, c_phenomenes, r_ign_bdtopo, r_insee_pop, public;
	
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

	-- 1. Calcul de la surface développée des résidences secondaires (RS) par TUP

	/* On calcule le pourcentage de locaux de type RS par TUP en nombre (pct_nb_rs) et en surface (pct_s_rs)
	On considère donc ici que la surface développée d'un local de type habitation = au champ stoth des FF

	Avant toute chose, il est nécessaire de vérifier les conditions suivantes pour s'assurer qu'il s'agit bien d'une RS, car le champ proba_rprs des FF pas toujours fiable :
	SI locprop = '1' (la commune du local = la commune du propriétaire)
	Ne considérer que c'est une RS que s'il y a plusieurs locaux rattachés au compte propriétaire (si le propriétaire ne possède qu'un local d'habitation sur la commune et qu'il habite sur cette même commune, c'est forcément sa résidence principale !) et si le local considéré n'est pas celui de plus grande surface habitable.
	*/
	
	EXECUTE 'DROP TABLE IF EXISTS local CASCADE;
	CREATE TEMP TABLE local AS
	SELECT loc.*
	FROM ff'||an_ff||'.fftp_'||an_ff||'_pb0010_local as loc
	JOIN territoires as ter
	ON ST_Intersects(loc.geomloc,ter.geom)
	WHERE ter.territoire = '''||nom_ter||'''
	';

	EXECUTE 'CREATE INDEX ON local USING btree(stoth)';
	EXECUTE 'CREATE INDEX ON local USING btree(idprocpte)';
	EXECUTE 'CREATE INDEX ON local USING btree(proba_rprs)';
	EXECUTE 'CREATE INDEX ON local USING btree(locprop)';

	EXECUTE 'DROP TABLE IF EXISTS tup CASCADE;
	CREATE TEMP TABLE tup AS
	SELECT tup.*
	FROM ff'||an_ff||'.ffta_'||an_ff||'_tup as tup
	JOIN territoires as ter
	ON ST_Intersects(tup.geomloc,ter.geom)
	WHERE ter.territoire = '''||nom_ter||'''
	';

	EXECUTE 'CREATE INDEX ON tup USING gist(geomtup)';
	EXECUTE 'CREATE INDEX ON tup USING gist(geomloc)';
	EXECUTE 'CREATE INDEX ON tup USING btree(idtup)';

	EXECUTE 'ALTER TABLE local
	DROP COLUMN IF EXISTS rs_corr,
	ADD COLUMN rs_corr varchar(20)';

	EXECUTE 'WITH loc AS
	(
		SELECT *,
		MAX(stoth) OVER (PARTITION BY idprocpte) as stothmax
		FROM local
	),
	rs_correct AS
	(
		SELECT *,
			CASE
				WHEN proba_rprs = ''RS'' AND (locprop <> ''1'' OR (locprop = ''1'' AND stoth < stothmax)) THEN ''RS''
				ELSE proba_rprs
			END AS typheb
		FROM loc
	)
	UPDATE local
	SET rs_corr = rs_correct.typheb
	FROM rs_correct
	WHERE local.idlocal = rs_correct.idlocal';

	EXECUTE 'CREATE INDEX ON local USING btree(rs_corr)';

	EXECUTE 'DROP TABLE IF EXISTS tup_local CASCADE;
	CREATE TEMP TABLE tup_local AS
	SELECT tup.idtup, tup.geomtup,
	
	-- liste des idlocal par parcelle TUP
	ARRAY_AGG(loc.idlocal)::varchar[] as idlocal_l,
	
	-- surface d''habitation totale par parcelle TUP
	COALESCE((SUM(loc.stoth) FILTER (WHERE loc.logh = ''t'')),0)::numeric as s_logh,
	
	-- surface totale des locaux de type RS ou vacants par parcelle TUP
	COALESCE((SUM(loc.stoth) FILTER (WHERE loc.rs_corr = ''RS'')),0)::numeric as s_rs
	
	FROM tup as tup
	JOIN local as loc
	ON loc.idtup = tup.idtup
	GROUP BY tup.idtup, tup.geomtup
	';

	EXECUTE 'CREATE INDEX ON tup_local USING btree(s_logh)';
	EXECUTE 'CREATE INDEX ON tup_local USING btree(s_rs)';

	EXECUTE 'ALTER TABLE tup_local
	DROP COLUMN IF EXISTS pct_s_rs,
	ADD COLUMN pct_s_rs double precision DEFAULT 0';
	
	EXECUTE 'UPDATE tup_local
	SET pct_s_rs = (s_rs::numeric / s_logh)
	WHERE s_logh > 0';

	EXECUTE 'CREATE INDEX ON tup_local USING btree(pct_s_rs)';

	-- 3. Ventilation nombre de RS et surfaces développées de RS entre les bâtiments de chaque TUP

	-- 3.3 On affecte à chaque bâtiment de logement le pourcentage en nombre et en surface développée de locaux inoccupés de sa parcelle TUP

	-- 3.3.1 Création d'une copie d'Oc1 pour ne pas avoir trop de champs inutiles (= champs utiles uniquement pour les calculs) dans la table d'origine Oc1

	EXECUTE 'DROP TABLE IF EXISTS temp_oc1 CASCADE;
	CREATE TEMP TABLE temp_oc1 (LIKE oc1 INCLUDING constraints INCLUDING indexes)';
	EXECUTE 'INSERT INTO temp_oc1
	SELECT *
	FROM oc1
	WHERE territoire = '''||nom_ter||'''';
	
	-- 3.3.1 Mise à jour des champs de pourcentage locaux 'RS' dans la table temporaire temp_oc1
		
	EXECUTE 'ALTER TABLE temp_oc1
	DROP COLUMN IF EXISTS pct_s_rs,
	ADD COLUMN pct_s_rs double precision DEFAULT 0';

	EXECUTE 'UPDATE temp_oc1
	SET pct_s_rs = tup.pct_s_rs
	FROM tup_local as tup
	WHERE territoire = '''||nom_ter||'''
		AND temp_oc1.oc2 IS TRUE
		AND temp_oc1.idtup = tup.idtup';

 	EXECUTE 'COMMENT ON COLUMN temp_oc1.pct_s_rs IS ''Pourcentage en surface développée de locaux de type "résidence secondaire" ou "vacants" dans la parcelle TUP du bâtiment.''';
	EXECUTE 'CREATE INDEX ON temp_oc1 USING btree(pct_s_rs)';
	
	-- 4. Calcul de la surface développée totale (sedvtot) des bâtiments

	EXECUTE 'ALTER TABLE temp_oc1
	DROP COLUMN IF EXISTS sdevtot,
	DROP COLUMN IF EXISTS sdevrs,
	ADD COLUMN sdevtot double precision DEFAULT 0,
	ADD COLUMN sdevrs double precision DEFAULT 0';

	EXECUTE 'UPDATE temp_oc1
	SET sdevtot = ST_Area(geom) * nombre_d_etages
	WHERE oc2 IS TRUE
	AND territoire = '''||nom_ter||'''';
	
	-- 5. Calcul de la surface développée des résidences secondaires (RS)

	EXECUTE 'UPDATE temp_oc1
	SET sdevrs = pct_s_rs * sdevtot
	WHERE oc2 IS TRUE
	AND territoire = '''||nom_ter||'''';

	EXECUTE 'COMMENT ON COLUMN temp_oc1.sdevtot IS ''Surface développée totale du bâtiment (emprise au sol * nombre de niveaux à l''''intérieur du bâtiment).''';
	EXECUTE 'COMMENT ON COLUMN temp_oc1.sdevrs IS ''Surface développée des locaux de type "résidence secondaire" à l''''intérieur du bâtiment.''';
	EXECUTE 'CREATE INDEX ON temp_oc1 USING btree(sdevtot)';
	EXECUTE 'CREATE INDEX ON temp_oc1 USING btree(sdevrs)';

	-- 6. Calcul de la population de résidents secondaires à l'intérieur des bâtiments

	-- 6.1 Ajout de champs dans la couche temporaire temp_oc1

	EXECUTE 'ALTER TABLE temp_oc1
	DROP COLUMN IF EXISTS pop_rs,
	ADD COLUMN pop_rs double precision DEFAULT 0';

	-- 6.4 Affectation du nombre d'habitants par bâtiment
	
	-- 6.4.2 Avec les clés de répartition calculées à partir de la surface des RS
	-- et en considérant un coefficient d'occupation du logement d'1 personne pour 20m²
	
	EXECUTE 'WITH tempb AS
	-- requête qui permet de calculer la population par bâtiment (calcul de proportionnalité en considérant 1 personne pour 20m²)
	(
		SELECT temp_oc1.id,
		round(temp_oc1.sdevrs::numeric / 20, 2)::double precision as pop_rs
		FROM temp_oc1
		WHERE temp_oc1.territoire = '''||nom_ter||'''
	)
	-- requête de mise à jour de la couche du bâti
	UPDATE temp_oc1
	SET pop_rs = tempb.pop_rs
	FROM tempb
	WHERE temp_oc1.id = tempb.id
		AND temp_oc1.territoire = '''||nom_ter||'''
		AND oc2 IS TRUE';

	EXECUTE 'COMMENT ON COLUMN temp_oc1.pop_rs IS ''Estimation du nombre de résidents secondaires à l''''intérieur du bâtiment (calculé en retirant de la surface développée totale du bâtiment le pourcentage en surface développée de locaux inoccupés sur la TUP).''';
	EXECUTE 'CREATE INDEX ON temp_oc1 USING btree(pop_rs)';


	-- 7. Calcul de la capacité touristique (donnée nationale Atout France 'hébergements classés' mais non exhaustive)
	-- On ne prend pas en compte les campings, villages vacances et aires de gens du voyage
		
	EXECUTE 'WITH tmp AS 
	(
		SELECT heb_tour.id_heb AS id_heb, heb_tour.capacite_da::double precision, t.oc1_id, t.dist
		FROM r_atoutfrance.heberg_touris_classes as heb_tour
		CROSS JOIN LATERAL
	-- requête qui permet de récupérer la distance la plus proche entre le ponctuel des hébergements classés et la table temporaire oc1 des bâtis
	(
		SELECT oc1.id AS oc1_id, st_distance(oc1.geom, heb_tour.geom) AS dist
		FROM c_occupation_sol.oc1
		--filtre sur un rayon de 50m
		WHERE ST_Dwithin(oc1.geom, heb_tour.geom,50)
		ORDER BY heb_tour.geom <-> oc1.geom
		LIMIT 1) AS t
		WHERE heb_tour.typologie_e like ''HÔTEL'' or heb_tour.typologie_e like ''RÉSIDENCE DE TOURISME''
	),
	
	-- requête qui permet de créer un identifiant partitionné par identifiant bâti de la distance la plus petite à la plus grande
		
		tmp1 AS 
	(
		SELECT t.*, ROW_NUMBER() OVER (PARTITION BY t.oc1_id ORDER BY t.dist ) AS rn
		FROM tmp AS t
	),
	
	-- requête qui permet d''aggréger les données de résidences de tourisme sous forme de listes
		
		tmp2 AS
	(
		SELECT oc1_id, capacite_da as heb_cap
		--array_agg(capacite_da) as heb_cap,
		--sum(capacite_da::numeric) as heb_cap_sum
		FROM tmp1
		GROUP BY tmp1.oc1_id, heb_cap
	)
	
	-- requête qui permet de mettre à jour la capacité touristique de la table oc1
		UPDATE c_occupation_sol.oc1 as bati
		SET capacite_touristique=tmp2.heb_cap
		FROM tmp2, tmp1
		WHERE tmp2.oc1_id = bati.id AND tmp1.oc1_id=bati.id AND tmp1.rn = 1';

	EXECUTE 'COMMENT ON COLUMN oc1.capacite_touristique IS ''Estimation de la capacité d''''accueil maximale des résidences de tourisme (dont hôtels)''';
	EXECUTE 'CREATE INDEX ON oc1 USING btree(capacite_touristique)';	


	-- 8. Prise en compte des campings / VVF et aires des gens du voyage
	--> TO-DO

	-- 8. Mise à jour de la couche d'origine Oc1 (en sommant les différentes capacités et populations décrivant Pop5)
	
	EXECUTE 'UPDATE oc1
	SET capacite_touristique =
	CASE
	WHEN capacite_touristique IS NULL THEN 0
	ELSE capacite_touristique
	END';
	
	EXECUTE 'UPDATE oc1
	SET pop5 = temp_oc1.pop1 + temp_oc1.pop_rs + oc1.capacite_touristique
	FROM temp_oc1
	WHERE oc1.id = temp_oc1.id';

END;
$function$
;

SELECT public.__var_pop5('Jura', '2021');