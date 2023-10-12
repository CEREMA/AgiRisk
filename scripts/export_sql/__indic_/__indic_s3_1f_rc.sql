SET client_encoding = 'UTF8';

CREATE OR REPLACE FUNCTION public.__indic_s3_1f_rc(nom_ter text, typ_alea text, code_occ text, an_bdtopo text)
 RETURNS void
 LANGUAGE plpgsql
AS $function$

-- Fonction SQL de représentation cartographique de l'indicateur s3_1f "Surface agricole en zone inondable"
-- © Cerema / GT AgiRisk (auteurs du script : Tiffany, Sébastien, Lucie)
-- Dernières mises à jour du script le 06/04/2023 par Lucie et le 25/08/2023 par Sébastien (test avec succès sur Longuyon le 24/08/2023)

-- Paramètres d'entrée :
-- nom_ter = nom du territoire d'étude tel que renseigné dans le champ `territoire` de la table c_general.territoires
-- typ_alea : type d'aléa considéré (ex : débordement de cours d'eau, submersion marine)
-- code_occ : période de retour considérée pour le type d'aléa choisi (ex : QRef, Q100, Q10)
-- an_bdtopo = millésime (année au format AAAA) de la BD TOPO®

-- Exemple d'appel à cette fonction :
-- SELECT public.__indic_s3_1f_rc('Jura', 'débordement de cours d''''eau', 'QRef', '2022');

DECLARE
	c_parcelle integer; -- un compteur des lignes modifiées pour logging
	c_iris integer; -- un compteur des lignes modifiées pour logging
	c_com integer; -- un compteur des lignes modifiées pour logging
	c_epci integer; -- un compteur des lignes modifiées pour logging
	heure1 varchar; -- heure de début du traitement
	heure2 varchar; -- heure de fin du traitement
	typ_res varchar; -- variable qui prend la valeur du type_result à insérer dans s3_1f_rc

BEGIN
	heure1 = clock_timestamp();
	
	--************************************************************************
	-- Définition des schémas de travail
	--************************************************************************
	SET search_path TO p_rep_carto, p_indicateurs, c_phenomenes, r_ign_bdtopo, r_rep_carto, r_ressources, c_general, public;

	RAISE NOTICE '';
	RAISE NOTICE '====== RAPPORT ======';
	RAISE NOTICE 'Génération des représentations cartographiques pour l''indicateur s3_1f (surfaces agricoles en zone inondable)';
	RAISE NOTICE 'Début du traitement : %', heure1;
	RAISE NOTICE '';

	--************************************************************************
	-- Vérification de l'existence d'une table s3_1f dans le schéma p_indicateurs
	--************************************************************************
	IF NOT EXISTS(
		SELECT *
		FROM s3_1f
		WHERE territoire = ''||nom_ter||''
	   		AND type_alea = ''||typ_alea||''
	   		AND code_occurrence = ''||code_occ||''
	)
	THEN
		RAISE EXCEPTION 'L''indicateur s3_1f n''a pas encore été calculé sur le territoire "%" avec l''aléa "% - %". Fin de l''exécution', nom_ter, typ_alea, code_occ;
	END IF;
	
	--************************************************************************
	-- Vérification de l'absence de données pour le territoire, le type d'aléa et l'occurrence de crue renseignés dans la table s3_1f_rc
	--************************************************************************
	IF EXISTS(
		SELECT *
		FROM s3_1f_rc
		WHERE territoire = ''||nom_ter||''
	   	AND type_alea = ''||typ_alea||''
	   	AND code_occurrence = ''||code_occ||''
	)
	THEN
		RAISE EXCEPTION 'Il existe déjà des enregistrements pour le territoire "%" avec l''aléa "% - %" dans la table p_rep_carto.s3_1f_rc. 
		Pour les supprimer, lancer la requête suivante : 
		DELETE FROM p_rep_carto.s3_1f_rc WHERE territoire = ''%'' AND type_alea = ''%'' AND code_occurrence = ''%'';', nom_ter, typ_alea, code_occ, REPLACE(nom_ter,'''',''''''), REPLACE(typ_alea,'''',''''''), REPLACE(code_occ,'''','''''');
	END IF;
	
	--************************************************************************
	-- Insertion des parcelles et des hexagones (hexagones = parcelles pour cet indicateur)
	--************************************************************************
   
   	-- Possibilité de faire tourner l'ensemble de ces "type_result" dans une boucle car les requêtes sont exactement les mêmes

	RAISE NOTICE 'Insertion des parcelles';

	--FOR i IN 0..5
	
	--LOOP
	
		EXECUTE 'INSERT INTO s3_1f_rc(
					code_rpg,
					territoire, 
					type_alea, 
					code_occurrence, 
					type_result,
					id_geom,
					nom_id_geom, 
					loc_zx, 
					surf_in, 
					surf_out, 
					valid_result,
					date_calc, 
					geom)
				SELECT
					S3_1f.code_rpg,
					s3_1f.territoire,
					s3_1f.type_alea,
					s3_1f.code_occurrence,
					niv_zoom.type_result,
					zt.id_iris AS id_geom,
					s3_1f.nom_iris,
					s3_1f.loc_zx,
					COALESCE(SUM(s3_1f.surf_parc) FILTER (WHERE s3_1f.loc_zx = ''In''),0),
					COALESCE(SUM(s3_1f.surf_parc) FILTER (WHERE s3_1f.loc_zx = ''Out''),0),
					1 AS valid_result,
					s3_1f.date_calc AS date_calc,
					ST_Multi(ST_CollectionExtract(ST_ForceCollection(ST_MakeValid(ST_Union(s3_1f.geom))),3))
				FROM s3_1f
				JOIN niv_zoom
				ON right(s3_1f.moda_calc,5) = niv_zoom.code_indic
				RIGHT JOIN zt
				ON s3_1f.id_iris = zt.id_iris
				WHERE __util_to_snake_case(s3_1f.territoire) = ''' ||__util_to_snake_case(nom_ter) || '''
					AND __util_to_snake_case(s3_1f.type_alea) = ''' ||__util_to_snake_case(typ_alea) || '''
	 				AND __util_to_snake_case(s3_1f.code_occurrence) = ''' ||__util_to_snake_case(code_occ) || '''
					AND niv_zoom.niv_zoom = 0
				GROUP BY s3_1f.code_rpg, s3_1f.territoire, s3_1f.type_alea, s3_1f.code_occurrence, niv_zoom.type_result, id_geom, s3_1f.nom_iris, s3_1f.loc_zx, s3_1f.date_calc';
			
	--END LOOP;

	-- Récupération du nombre d'entités ajoutées
	EXECUTE '
		SELECT count(*)
		FROM s3_1f_rc
		WHERE __util_to_snake_case(territoire) = '''||__util_to_snake_case(nom_ter)||'''
			AND __util_to_snake_case(type_alea) = '''||__util_to_snake_case(typ_alea)||'''
			AND __util_to_snake_case(code_occurrence) = '''||__util_to_snake_case(code_occ)||'''
			AND type_result = ''Entite'' OR type_result LIKE ''Hexag_%'''
	INTO c_parcelle; -- nombre total de parcelles insérées dans la table

	--************************************************************************
	-- Insertion des IRIS
	--************************************************************************
	RAISE NOTICE 'Insertion des IRIS';

	EXECUTE 'DROP TABLE IF EXISTS zt_temp CASCADE;
	CREATE TEMP TABLE zt_temp AS
	SELECT *
	FROM zt
	WHERE __util_to_snake_case(territoire) = ''' ||__util_to_snake_case(nom_ter) || '''
	';

	EXECUTE 'CREATE INDEX ON zt_temp USING btree(id_iris)';

	EXECUTE 'DROP TABLE IF EXISTS s3_1f_iris CASCADE;
	CREATE TEMP TABLE s3_1f_iris AS
	SELECT
		niv_zoom.type_result,
		s3_1f.id_iris,
		s3_1f.nom_iris,
		s3_1f.date_calc,
		s3_1f.moda_calc,
		ROUND(COALESCE(SUM(s3_1f.surf_parc) FILTER (WHERE s3_1f.loc_zx = ''In''),0)::numeric,2) as surf_in,
		ROUND(COALESCE(SUM(s3_1f.surf_parc) FILTER (WHERE s3_1f.loc_zx = ''Out''),0)::numeric,2) as surf_out
	FROM s3_1f
	JOIN niv_zoom
	ON right(s3_1f.moda_calc,5) = niv_zoom.code_indic
	WHERE __util_to_snake_case(s3_1f.territoire) = ''' ||__util_to_snake_case(nom_ter) || '''
		AND __util_to_snake_case(s3_1f.type_alea) = '''||__util_to_snake_case(typ_alea) ||'''
		AND __util_to_snake_case(s3_1f.code_occurrence) = '''||__util_to_snake_case(code_occ) ||'''
		AND niv_zoom.niv_zoom = 6
	GROUP BY s3_1f.territoire, s3_1f.type_alea, s3_1f.code_occurrence, niv_zoom.type_result, s3_1f.id_iris, s3_1f.nom_iris, s3_1f.date_calc, s3_1f.moda_calc
	';
	
	EXECUTE 'CREATE INDEX ON s3_1f_iris USING btree(id_iris)';

	-- Il est IMPÉRATIF d'enregistrer la valeur du champ type_result dans une variable déclarée "typ_res" car l'appel au champ s3_1f_iris.type_result dans l'INSERT INTO ci-dessous fait sauter les IRIS non concernés par des parcelles s3_1f. Ce dysfonctionnement ressemble fortement à un bug PostgreSQL.
	-- Lucie a absolument TOUT tenté pour éviter de passer par cette variable déclarée sans succès. Cette méthode ajoute simplement deux lignes à l'ensemble du code, mais à creuser plus tard éventuellement.
	typ_res := (SELECT DISTINCT type_result FROM s3_1f_iris);

	EXECUTE 'INSERT INTO s3_1f_rc(
				territoire,
				type_alea,
				code_occurrence,
			  	type_result, 
				id_geom, 
				nom_id_geom, 
				loc_zx, 
				surf_in, 
				surf_out,
				valid_result,
				date_calc, 
				geom)
			SELECT
				'''||REPLACE(nom_ter,'''','''''')||''' as ter,
				'''||REPLACE(typ_alea,'''','''''')||''' as alea,
				'''||REPLACE(code_occ,'''','''''')||''' as occ,
				'''||typ_res||''',
				zt.id_iris AS id_geom,
				s3_1f.nom_iris,
				''indéterminé''::varchar(30) as loc_zx,
				s3_1f.surf_in,
				s3_1f.surf_out,
				1 AS valid_result,
				s3_1f.date_calc,
				zt.geom
			FROM s3_1f_iris as s3_1f
			RIGHT JOIN zt_temp as zt
			ON s3_1f.id_iris = zt.id_iris
			WHERE __util_to_snake_case(zt.territoire) = '''||__util_to_snake_case(nom_ter)||'''
			';

	-- Récupération du nombre d'entités ajoutées
	GET DIAGNOSTICS c_iris = row_count; -- nombre d'IRIS insérés dans la table

	--************************************************************************
	-- Insertion des communes
	--************************************************************************
	RAISE NOTICE 'Insertion des communes';
	
	EXECUTE 'DROP TABLE IF EXISTS com_temp CASCADE;
	CREATE TEMP TABLE com_temp AS
	SELECT com.*, zt.territoire
	FROM commune_' || an_bdtopo || ' AS com
	JOIN zt
	ON zt.id_commune = com.insee_com
	WHERE __util_to_snake_case(zt.territoire) = ''' ||__util_to_snake_case(nom_ter) || '''
	';
	
	EXECUTE 'CREATE INDEX ON com_temp USING btree(insee_com)';
	
	EXECUTE 'DROP TABLE IF EXISTS s3_1f_com CASCADE;
	CREATE TEMP TABLE s3_1f_com AS
	SELECT
		niv_zoom.type_result,
		s3_1f.id_commune,
		s3_1f.nom_commune,
		s3_1f.date_calc,
		s3_1f.moda_calc,
		ROUND(COALESCE(SUM(s3_1f.surf_parc) FILTER (WHERE s3_1f.loc_zx = ''In''),0)::numeric,2) as surf_in,
		ROUND(COALESCE(SUM(s3_1f.surf_parc) FILTER (WHERE s3_1f.loc_zx = ''Out''),0)::numeric,2) as surf_out
	FROM s3_1f
	JOIN niv_zoom
	ON right(s3_1f.moda_calc,5) = niv_zoom.code_indic
	WHERE __util_to_snake_case(s3_1f.territoire) = '''||__util_to_snake_case(nom_ter) || '''
		AND __util_to_snake_case(s3_1f.type_alea) = '''||__util_to_snake_case(typ_alea) ||'''
		AND __util_to_snake_case(s3_1f.code_occurrence) = '''||__util_to_snake_case(code_occ) ||'''
		AND niv_zoom.niv_zoom = 7
	GROUP BY s3_1f.territoire, s3_1f.type_alea, s3_1f.code_occurrence, niv_zoom.type_result, s3_1f.id_commune, s3_1f.nom_commune, s3_1f.date_calc, s3_1f.moda_calc
	';
	
	EXECUTE 'CREATE INDEX ON s3_1f_com USING btree(id_commune)';

	-- Il est IMPÉRATIF d'enregistrer la valeur du champ type_result dans une variable déclarée "typ_res" car l'appel au champ s3_1f_com.type_result dans l'INSERT INTO ci-dessous fait sauter les communes non concernées par des parcelles s3_1f. Ce dysfonctionnement ressemble fortement à un bug PostgreSQL.
	-- Lucie a absolument TOUT tenté pour éviter de passer par cette variable déclarée sans succès. Cette méthode ajoute simplement deux lignes à l'ensemble du code, mais à creuser plus tard éventuellement.
	typ_res := (SELECT DISTINCT type_result FROM s3_1f_com);

	EXECUTE 'INSERT INTO s3_1f_rc(
				territoire, 
				type_alea, 
				code_occurrence, 
				type_result, 
				id_geom, 
				nom_id_geom, 
				loc_zx, 
				surf_in, 
				surf_out, 
				valid_result,
				date_calc, 
				geom)
			SELECT DISTINCT
				'''||REPLACE(nom_ter,'''','''''')||''' as ter,
				'''||REPLACE(typ_alea,'''','''''')||''' as alea,
				'''||REPLACE(code_occ,'''','''''')||''' as occ,
				'''||typ_res||''',
				com.insee_com AS id_geom,
				s3_1f.nom_commune,
				''indéterminé''::varchar(30) as loc_zx,
				s3_1f.surf_in,
				s3_1f.surf_out,
				1 AS valid_result,
				s3_1f.date_calc,
				com.geom
			FROM s3_1f_com as s3_1f
			RIGHT JOIN com_temp AS com
			ON s3_1f.id_commune = com.insee_com
			WHERE __util_to_snake_case(com.territoire) = '''||__util_to_snake_case(nom_ter)||'''
			';

	-- Récupération du nombre d'entités ajoutées
	GET DIAGNOSTICS c_com = row_count; -- nombre de communes insérées dans la table

	--************************************************************************
	-- Insertion des EPCI
	--************************************************************************
	RAISE NOTICE 'Insertion des EPCI';
	
	EXECUTE 'DROP TABLE IF EXISTS epci_temp CASCADE;
	CREATE TEMP TABLE epci_temp AS
	SELECT DISTINCT epci.*, zt.territoire
	FROM epci_' || an_bdtopo || ' AS epci
	JOIN zt
	ON zt.id_epci = epci.code_siren
	WHERE __util_to_snake_case(zt.territoire) = ''' ||__util_to_snake_case(nom_ter) || '''
	';

	EXECUTE 'CREATE INDEX ON epci_temp USING btree(code_siren)';
	EXECUTE 'CREATE INDEX ON epci_temp USING gist(geom)';

	EXECUTE 'DROP TABLE IF EXISTS epci_too_large CASCADE';
	EXECUTE 'CREATE TEMP TABLE epci_too_large AS
	WITH tempa AS (
		SELECT
			territoire,
			SUM(ST_Area(geom))::double precision as s_epci
		FROM epci_temp
		GROUP BY territoire
	)
	SELECT DISTINCT
		ST_Area(territoires.geom)::double precision as s_ter,
		tempa.s_epci,
		(ST_Area(territoires.geom) / tempa.s_epci)::double precision as r_ter_epci
	FROM territoires
	JOIN tempa
	ON territoires.territoire = tempa.territoire
	';	
	
	IF EXISTS
	(
		SELECT *
		FROM epci_too_large
		WHERE r_ter_epci >= 0.95
	)
	THEN
	
		EXECUTE 'DROP TABLE IF EXISTS s3_1f_epci CASCADE;
		CREATE TEMP TABLE s3_1f_epci AS
		SELECT
			niv_zoom.type_result,
			s3_1f.id_epci,
			s3_1f.nom_epci,
			s3_1f.date_calc,
			s3_1f.moda_calc,
			ROUND(COALESCE(SUM(s3_1f.surf_parc) FILTER (WHERE s3_1f.loc_zx = ''In''),0)::numeric,2) as surf_in,
			ROUND(COALESCE(SUM(s3_1f.surf_parc) FILTER (WHERE s3_1f.loc_zx = ''Out''),0)::numeric,2) as surf_out
		FROM s3_1f
		JOIN niv_zoom
		ON right(s3_1f.moda_calc,5) = niv_zoom.code_indic
		WHERE __util_to_snake_case(s3_1f.territoire) = ''' ||__util_to_snake_case(nom_ter) || '''
			AND __util_to_snake_case(s3_1f.type_alea) = '''||__util_to_snake_case(typ_alea) ||'''
			AND __util_to_snake_case(s3_1f.code_occurrence) = '''||__util_to_snake_case(code_occ) ||'''
			AND niv_zoom.niv_zoom = 8
		GROUP BY s3_1f.territoire, s3_1f.type_alea, s3_1f.code_occurrence, niv_zoom.type_result, s3_1f.id_epci, s3_1f.nom_epci, s3_1f.date_calc, s3_1f.moda_calc
		';
			
		EXECUTE 'CREATE INDEX ON s3_1f_epci USING btree(id_epci)';
	
		-- Il est IMPÉRATIF d'enregistrer la valeur du champ type_result dans une variable déclarée "typ_res" car l'appel au champ s3_1f_epci.type_result dans l'INSERT INTO ci-dessous fait sauter les EPCI non concernés par des parcelles s3_1f. Ce dysfonctionnement ressemble fortement à un bug PostgreSQL.
		-- Lucie a absolument TOUT tenté pour éviter de passer par cette variable déclarée sans succès. Cette méthode ajoute simplement deux lignes à l'ensemble du code, mais à creuser plus tard éventuellement.
		typ_res := (SELECT DISTINCT type_result FROM s3_1f_epci);
	
		EXECUTE 'INSERT INTO s3_1f_rc(territoire, type_alea, code_occurrence, type_result, id_geom, nom_id_geom, loc_zx, surf_in, surf_out, valid_result, date_calc, geom)
				SELECT
					'''||REPLACE(nom_ter,'''','''''')||''' as ter,
					'''||REPLACE(typ_alea,'''','''''')||''' as alea,
					'''||REPLACE(code_occ,'''','''''')||''' as occ,
					'''||typ_res||''',
					epci.code_siren AS id_geom,
					s3_1f.nom_epci,
					''indéterminé''::varchar(30) as loc_zx,
					s3_1f.surf_in,
					s3_1f.surf_out,
					1 AS valid_result,
					s3_1f.date_calc AS date_calc,
					epci.geom
				FROM s3_1f_epci as s3_1f
				RIGHT JOIN epci_temp AS epci
				ON s3_1f.id_epci = epci.code_siren
				WHERE __util_to_snake_case(epci.territoire) = '''||__util_to_snake_case(nom_ter) ||'''
				';
	ELSE
	
		EXECUTE 'DROP TABLE IF EXISTS ter_temp CASCADE;
		CREATE TEMP TABLE ter_temp AS
		SELECT DISTINCT *
		FROM territoires
		WHERE __util_to_snake_case(territoire) = ''' ||__util_to_snake_case(nom_ter) || '''
		';
	
		EXECUTE 'CREATE INDEX ON ter_temp USING btree(id)';
		EXECUTE 'CREATE INDEX ON ter_temp USING gist(geom)';
	
		EXECUTE 'DROP TABLE IF EXISTS s3_1f_ter CASCADE;
		CREATE TEMP TABLE s3_1f_ter AS
		SELECT
			s3_1f.territoire,
			niv_zoom.type_result,
			s3_1f.date_calc,
			s3_1f.moda_calc,
			ROUND(COALESCE(SUM(s3_1f.surf_parc) FILTER (WHERE s3_1f.loc_zx = ''In''),0)::numeric,2) as surf_in,
			ROUND(COALESCE(SUM(s3_1f.surf_parc) FILTER (WHERE s3_1f.loc_zx = ''Out''),0)::numeric,2) as surf_out
		FROM s3_1f
		JOIN niv_zoom
		ON right(s3_1f.moda_calc,5) = niv_zoom.code_indic
		WHERE __util_to_snake_case(s3_1f.territoire) = ''' ||__util_to_snake_case(nom_ter) || '''
			AND __util_to_snake_case(s3_1f.type_alea) = '''||__util_to_snake_case(typ_alea) ||'''
			AND __util_to_snake_case(s3_1f.code_occurrence) = '''||__util_to_snake_case(code_occ) ||'''
			AND niv_zoom.niv_zoom = 8
		GROUP BY s3_1f.territoire, s3_1f.type_alea, s3_1f.code_occurrence, niv_zoom.type_result, s3_1f.date_calc, s3_1f.moda_calc
		';
			
		EXECUTE 'CREATE INDEX ON s3_1f_ter USING btree(territoire)';
	
		-- Il est IMPÉRATIF d'enregistrer la valeur du champ type_result dans une variable déclarée "typ_res" car l'appel au champ s3_1f_ter.type_result dans l'INSERT INTO ci-dessous fait sauter les EPCI non concernés par des parcelles s3_1f. Ce dysfonctionnement ressemble fortement à un bug PostgreSQL.
		-- Lucie a absolument TOUT tenté pour éviter de passer par cette variable déclarée sans succès. Cette méthode ajoute simplement deux lignes à l'ensemble du code, mais à creuser plus tard éventuellement.
		typ_res := (SELECT DISTINCT type_result FROM s3_1f_ter);
	
		EXECUTE 'INSERT INTO s3_1f_rc(territoire, type_alea, code_occurrence, type_result, id_geom, nom_id_geom, loc_zx, surf_in, surf_out, valid_result, date_calc, geom)
				SELECT DISTINCT
					'''||REPLACE(nom_ter,'''','''''')||''' as ter,
					'''||REPLACE(typ_alea,'''','''''')||''' as alea,
					'''||REPLACE(code_occ,'''','''''')||''' as occ,
					'''||typ_res||''',
					ter.id AS id_geom,
					'''||REPLACE(nom_ter,'''','''''')||''',
					''indéterminé''::varchar(200) as loc_zx,
					s3_1f.surf_in,
					s3_1f.surf_out,
					0 AS valid_result,
					s3_1f.date_calc AS date_calc,
					ter.geom
				FROM s3_1f_ter as s3_1f
				RIGHT JOIN ter_temp AS ter
				ON __util_to_snake_case(s3_1f.territoire) = __util_to_snake_case(ter.territoire)
				WHERE __util_to_snake_case(ter.territoire) = ''' ||__util_to_snake_case(nom_ter) || '''
				';
			
	END IF;

	-- Récupération du nombre d'entités ajoutées
	GET DIAGNOSTICS c_epci = row_count; -- nombre d'EPCI insérés dans la table

	--************************************************************************
	-- Création d'une vue matérialisée sur le territoire
	--************************************************************************
	RAISE NOTICE '';
	RAISE NOTICE 'Création de la vue matérialisée %', 'p_rep_carto.s3_1f_rc_'||__util_to_snake_case(nom_ter);
	EXECUTE '
		DROP MATERIALIZED VIEW IF EXISTS s3_1f_rc_' || __util_to_snake_case(nom_ter) || ' CASCADE;
		CREATE MATERIALIZED VIEW s3_1f_rc_' || __util_to_snake_case(nom_ter) || ' AS
		SELECT *
		FROM s3_1f_rc
		WHERE __util_to_snake_case(territoire) = ''' ||__util_to_snake_case(nom_ter) || '''
		';

	-- Création des index sur la vue matérialisée
	RAISE NOTICE 'Création des index sur la vue matérialisée';

	EXECUTE 'CREATE UNIQUE INDEX ON s3_1f_rc_' || __util_to_snake_case(nom_ter) || ' (id)';

	EXECUTE 'CREATE INDEX ON s3_1f_rc_' || __util_to_snake_case(nom_ter) || ' USING gist(geom)';
	EXECUTE 'CREATE INDEX ON s3_1f_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(id)';
	EXECUTE 'CREATE INDEX ON s3_1f_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(territoire)';
	EXECUTE 'CREATE INDEX ON s3_1f_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(type_alea)';
	EXECUTE 'CREATE INDEX ON s3_1f_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(code_occurrence)';
	EXECUTE 'CREATE INDEX ON s3_1f_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(type_result)';
	EXECUTE 'CREATE INDEX ON s3_1f_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(id_geom)';
	EXECUTE 'CREATE INDEX ON s3_1f_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(nom_id_geom)';
	EXECUTE 'CREATE INDEX ON s3_1f_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(code_rpg)';
	EXECUTE 'CREATE INDEX ON s3_1f_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(loc_zx)';
	EXECUTE 'CREATE INDEX ON s3_1f_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(surf_in)';
	EXECUTE 'CREATE INDEX ON s3_1f_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(surf_out)';
	EXECUTE 'CREATE INDEX ON s3_1f_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(pct_surf_in)';
	EXECUTE 'CREATE INDEX ON s3_1f_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(pct_surf_out)';
	EXECUTE 'CREATE INDEX ON s3_1f_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(total_surf)';
	EXECUTE 'CREATE INDEX ON s3_1f_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(valid_result)';
	EXECUTE 'CREATE INDEX ON s3_1f_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(date_calc)';
	RAISE NOTICE 'Index créés sur la vue matérialisée';

	--************************************************************************
	-- Conclusion
	--************************************************************************
	RAISE NOTICE '';
	RAISE NOTICE '====== FIN TRAITEMENT ======';
	RAISE NOTICE '[INFO] La table s3_1f_rc (représentation carto de l''indicateur surfaces agricoles inondables aux géométries administratives) a été mise à jour dans le schéma p_rep_carto pour le territoire "%" et l''aléa "% - %"', nom_ter, typ_alea, code_occ;
	RAISE NOTICE '';
	RAISE NOTICE '====== RÉSULTATS ======';

	IF c_parcelle+c_iris+c_com+c_epci > 1
		THEN RAISE NOTICE '% enregistrements insérés au total dans la table p_rep_carto.s3_1f_rc pour le territoire "%" et l''aléa "% - %"', c_parcelle+c_iris+c_com+c_epci, nom_ter, typ_alea, code_occ;
		ELSE RAISE NOTICE '% enregistrement inséré dans la table p_rep_carto.s3_1f_rc pour le territoire "%" et l''aléa "% - %"', c_parcelle+c_iris+c_com+c_epci, nom_ter, typ_alea, code_occ;
	END IF;

	RAISE NOTICE 'dont :';
	
		IF c_parcelle > 1
			THEN RAISE NOTICE '- % parcelles', c_parcelle;
			ELSE RAISE NOTICE '- % parcelle', c_parcelle;
		END IF;
	
		IF c_iris > 1
			THEN RAISE NOTICE '- % IRIS', c_iris;
			ELSE RAISE NOTICE '- % IRIS', c_iris;
		END IF;
	
		IF c_com > 1
			THEN RAISE NOTICE '- % communes', c_com;
			ELSE RAISE NOTICE '- % commune', c_com;
		END IF;
	
		IF c_epci > 1
			THEN RAISE NOTICE '- % EPCI', c_epci;
			ELSE
				IF EXISTS (
					SELECT *
					FROM p_rep_carto.logt_zx_rc
					WHERE territoire = ''||nom_ter||''
						AND type_alea = ''||typ_alea||''
						AND code_occurrence = ''||code_occ||''
						AND type_result = 'EPCI'
						AND nom_id_geom = ''||nom_ter||''
				)
				THEN RAISE NOTICE '- périmètre du territoire (les périmètres des EPCI dépassant ce dernier à l''échelle supracommunale)';
				ELSE RAISE NOTICE '- % EPCI', c_epci;
				END IF;
		END IF;

	RAISE NOTICE '';
	heure2 = clock_timestamp();
	RAISE NOTICE 'Fin du traitement : %', heure2;
	RAISE NOTICE 'Durée du traitement : %', CAST(heure2 as time)-CAST(heure1 as time);
	RAISE NOTICE '';

END;
$function$
