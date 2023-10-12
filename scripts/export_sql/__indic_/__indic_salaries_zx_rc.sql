SET client_encoding = 'UTF8';

CREATE OR REPLACE FUNCTION public.__indic_salaries_zx_rc(nom_ter text, typ_alea text, code_occ text, an_bdtopo text)
 RETURNS void
 LANGUAGE plpgsql
AS $function$

-- Fonction SQL de représentation cartographique de l'indicateur salaries_zx "Salariés en zone inondable"
-- © Cerema / GT AgiRisk (auteur du script : Sébastien)
-- Dernière mise à jour du script le 17/09/2023 par Sébastien (test avec succès sur Longuyon le 24/08/2023)

-- Paramètres d'entrée :
-- nom_ter = nom du territoire d'étude tel que renseigné dans le champ `territoire` de la table c_general.territoires
-- typ_alea : type d'aléa considéré (ex : débordement de cours d'eau, submersion marine)
-- code_occ : période de retour considérée pour le type d'aléa choisi (ex : QRef, Q100, Q10)
-- an_bdtopo = millésime (année au format AAAA) de la BD TOPO®

-- Exemple d'appel à cette fonction :
-- SELECT public.__indic_salaries_zx_rc('Jura', 'débordement de cours d''eau', 'QRef', '2022');

DECLARE
	c_hexag integer; -- un compteur des lignes modifiées pour logging
	c_entite integer; -- un compteur des lignes modifiées pour logging
	c_iris integer; -- un compteur des lignes modifiées pour logging
	c_com integer; -- un compteur des lignes modifiées pour logging
	c_epci integer; -- un compteur des lignes modifiées pour logging
	heure1 varchar; -- heure de début du traitement
	heure2 varchar; -- heure de fin du traitement
	valzoom integer; -- variable qui prend la valeur du niveau de zoom issue de la table r_ressources.niv_zoom
	valresult varchar; -- variable qui prend la valeur du code indicateur issu de la table r_ressources.niv_zoom
	typ_res varchar; -- variable qui prend la valeur du type_result à insérer dans salaries_zx_rc

BEGIN
	heure1 = current_timestamp;
	
	--************************************************************************
	-- Définition des schémas de travail
	--************************************************************************
	SET search_path TO p_rep_carto, p_indicateurs, c_phenomenes, c_general, r_ign_bdtopo, r_rep_carto,  r_ressources, public;

	RAISE NOTICE '';
	RAISE NOTICE '====== RAPPORT ======';
	RAISE NOTICE 'Génération des représentations cartographiques pour l''indicateur salaries_zx (salariés en zone inondable)';
	RAISE NOTICE 'Début du traitement : %', heure1;
	RAISE NOTICE '';

	--************************************************************************
	-- Vérification de l'existence d'une table salaries_zx dans le schéma p_indicateurs
	--************************************************************************
	IF NOT EXISTS (
		SELECT *
		FROM p_indicateurs.salaries_zx
		WHERE territoire = ''||nom_ter||''
			AND type_alea = ''||typ_alea||''
			AND code_occurrence = ''||code_occ||''
	)
	THEN
		RAISE EXCEPTION 'L''indicateur salaries_zx n''a pas encore été calculé sur le territoire "%" avec l''aléa "% - %". Fin de l''exécution', nom_ter, typ_alea, code_occ;
	END IF;

	--************************************************************************
	-- Vérification de l'absence de données pour le territoire, le type d'aléa et l'occurrence de crue renseignés dans la table p_rep_carto.salaries_zx_rc
	--************************************************************************
	IF EXISTS (
		SELECT *
		FROM p_rep_carto.salaries_zx_rc
		WHERE territoire = ''||nom_ter||''
			AND type_alea = ''||typ_alea||''
			AND code_occurrence = ''||code_occ||''
	)
	THEN
		RAISE EXCEPTION 'Il existe déjà des enregistrements pour le territoire "%" avec l''aléa "% - %" dans la table p_rep_carto.salaries_zx_rc. 
		Pour les supprimer, lancer la requête suivante : 
		DELETE FROM p_rep_carto.salaries_zx_rc WHERE territoire = ''%'' AND type_alea = ''%'' AND code_occurrence = ''%'';', nom_ter, typ_alea, code_occ, REPLACE(nom_ter,'''',''''''), REPLACE(typ_alea,'''',''''''), REPLACE(code_occ,'''','''''');
	END IF;
   
	--************************************************************************
	-- Insertion des données hexag_xxxha
	--************************************************************************
	RAISE NOTICE 'Insertion des données hexag_xxxha';

	FOR valzoom, valresult IN SELECT DISTINCT niv_zoom, lower(type_result) FROM niv_zoom WHERE type_result LIKE 'Hexag%'
	LOOP
		EXECUTE 'INSERT INTO salaries_zx_rc (
				territoire,
				type_alea,
				code_occurrence,
				type_result,
				id_geom,
				nom_id_geom,
				loc_zx,
				pop2_bas_in,
				pop2_haut_in,
				pop2_bas_out,
				pop2_haut_out,
				valid_result,
				date_calc,
				geom
			)
			SELECT DISTINCT
				salaries_zx.territoire,
				salaries_zx.type_alea,
				salaries_zx.code_occurrence,
				initcap('''||valresult||''')::varchar(200) AS type_result,
				hexag.grid_id::varchar(200) AS id_geom,
				''indéterminé''::varchar(200) AS nom_id_geom,
				''indéterminé''::varchar(30) AS loc_zx,
				CASE
					WHEN CEIL(COALESCE(SUM(salaries_zx.pop2_bas) FILTER (WHERE salaries_zx.loc_zx = ''In''),0)) > 0
					AND CEIL(COALESCE(SUM(salaries_zx.pop2_bas) FILTER (WHERE salaries_zx.loc_zx = ''In''),0)) < 10 THEN 10
					ELSE CEIL(COALESCE(SUM(salaries_zx.pop2_bas) FILTER (WHERE salaries_zx.loc_zx = ''In''),0))
				END,
				CASE
					WHEN CEIL(COALESCE(SUM(salaries_zx.pop2_haut) FILTER (WHERE salaries_zx.loc_zx = ''In''),0)) > 0
					AND CEIL(COALESCE(SUM(salaries_zx.pop2_haut) FILTER (WHERE salaries_zx.loc_zx = ''In''),0)) < 10 THEN 10
					ELSE CEIL(COALESCE(SUM(salaries_zx.pop2_haut) FILTER (WHERE salaries_zx.loc_zx = ''In''),0))
				END,
				CASE
					WHEN CEIL(COALESCE(SUM(salaries_zx.pop2_bas) FILTER (WHERE salaries_zx.loc_zx = ''Out''),0)) > 0
					AND CEIL(COALESCE(SUM(salaries_zx.pop2_bas) FILTER (WHERE salaries_zx.loc_zx = ''Out''),0)) < 10 THEN 10
					ELSE CEIL(COALESCE(SUM(salaries_zx.pop2_bas) FILTER (WHERE salaries_zx.loc_zx = ''Out''),0))
				END,
				CASE
					WHEN CEIL(COALESCE(SUM(salaries_zx.pop2_haut) FILTER (WHERE salaries_zx.loc_zx = ''Out''),0)) > 0
					AND CEIL(COALESCE(SUM(salaries_zx.pop2_haut) FILTER (WHERE salaries_zx.loc_zx = ''Out''),0)) < 10 THEN 10
					ELSE CEIL(COALESCE(SUM(salaries_zx.pop2_haut) FILTER (WHERE salaries_zx.loc_zx = ''Out''),0))
				END,
				1,
				salaries_zx.date_calc,
				hexag.geom
			FROM salaries_zx
			JOIN niv_zoom
			ON right(salaries_zx.moda_calc,11) = niv_zoom.code_indic
			RIGHT JOIN '||valresult||' AS hexag
			ON ST_Intersects(salaries_zx.geomloc, hexag.geom)
			WHERE __util_to_snake_case(salaries_zx.territoire) = '''||__util_to_snake_case(nom_ter)||'''
				AND __util_to_snake_case(salaries_zx.type_alea) = '''||__util_to_snake_case(typ_alea)||'''
				AND __util_to_snake_case(salaries_zx.code_occurrence) = '''||__util_to_snake_case(code_occ)||'''
				AND niv_zoom.niv_zoom = '||valzoom||'
			GROUP BY salaries_zx.territoire, salaries_zx.type_alea, salaries_zx.code_occurrence, type_result, id_geom, salaries_zx.date_calc, hexag.geom
			';
	END LOOP;

	-- Récupération du nombre d'entités ajoutées
	EXECUTE '
		SELECT count(*)
		FROM salaries_zx_rc
		WHERE __util_to_snake_case(territoire) = '''||__util_to_snake_case(nom_ter)||'''
			AND __util_to_snake_case(type_alea) = '''||__util_to_snake_case(typ_alea)||'''
			AND __util_to_snake_case(code_occurrence) = '''||__util_to_snake_case(code_occ)||'''
			AND type_result LIKE ''Hexag_%'''
	INTO c_hexag; -- nombre total d'hexagones insérés dans la table

	--************************************************************************
	-- Insertion des entités "brutes" agglomérées à l'IRIS
	--************************************************************************
	RAISE NOTICE 'Insertion des bâtiments "bruts" agglomérés à l''IRIS';
	
	EXECUTE 'INSERT INTO salaries_zx_rc(
				territoire,
				type_alea,
				code_occurrence,
				type_result,
				id_geom,
				nom_id_geom,
				loc_zx,
				pop2_bas_in,
				pop2_haut_in,
				pop2_bas_out,
				pop2_haut_out,
				valid_result,
				date_calc,
				geom
			)
			SELECT
				salaries_zx.territoire,
				salaries_zx.type_alea,
				salaries_zx.code_occurrence,
				niv_zoom.type_result,
				zt.id_iris AS id_geom,
				salaries_zx.nom_iris,
				salaries_zx.loc_zx,
				CEIL(COALESCE(SUM(salaries_zx.pop2_bas) FILTER (WHERE salaries_zx.loc_zx = ''In''),0)),
				CEIL(COALESCE(SUM(salaries_zx.pop2_haut) FILTER (WHERE salaries_zx.loc_zx = ''In''),0)),
				CEIL(COALESCE(SUM(salaries_zx.pop2_bas) FILTER (WHERE salaries_zx.loc_zx = ''Out''),0)),
				CEIL(COALESCE(SUM(salaries_zx.pop2_haut) FILTER (WHERE salaries_zx.loc_zx = ''Out''),0)),
				1,
				salaries_zx.date_calc,
				ST_Multi(ST_Simplify(ST_CollectionExtract(ST_ForceCollection(ST_MakeValid(ST_Union(salaries_zx.geom))),3),0))
			FROM salaries_zx
			JOIN niv_zoom
			ON right(salaries_zx.moda_calc,11) = niv_zoom.code_indic
			RIGHT JOIN zt
			ON salaries_zx.id_iris = zt.id_iris
			WHERE __util_to_snake_case(zt.territoire) = '''||__util_to_snake_case(nom_ter)||'''
				AND __util_to_snake_case(salaries_zx.territoire) = '''||__util_to_snake_case(nom_ter)||'''
				AND __util_to_snake_case(salaries_zx.type_alea) = '''||__util_to_snake_case(typ_alea)||'''
				AND __util_to_snake_case(salaries_zx.code_occurrence) = '''||__util_to_snake_case(code_occ)||'''
				AND niv_zoom.niv_zoom = 0
			GROUP BY salaries_zx.territoire, salaries_zx.type_alea, salaries_zx.code_occurrence, niv_zoom.type_result, id_geom, salaries_zx.nom_iris, salaries_zx.loc_zx, salaries_zx.date_calc
			';

	-- Récupération du nombre d'entités ajoutées
	GET DIAGNOSTICS c_entite = row_count; -- nombre d'entités insérées dans la table

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

	EXECUTE 'DROP TABLE IF EXISTS salaries_zx_iris CASCADE;
	CREATE TEMP TABLE salaries_zx_iris AS
	SELECT
		niv_zoom.type_result,
		salaries_zx.id_iris,
		salaries_zx.nom_iris,
		salaries_zx.date_calc,
		salaries_zx.moda_calc,
		CEIL(COALESCE(SUM(salaries_zx.pop2_bas) FILTER (WHERE salaries_zx.loc_zx = ''In''),0)) as pop2_bas_in,
		CEIL(COALESCE(SUM(salaries_zx.pop2_haut) FILTER (WHERE salaries_zx.loc_zx = ''In''),0)) as pop2_haut_in,
		CEIL(COALESCE(SUM(salaries_zx.pop2_bas) FILTER (WHERE salaries_zx.loc_zx = ''Out''),0)) as pop2_bas_out,
		CEIL(COALESCE(SUM(salaries_zx.pop2_haut) FILTER (WHERE salaries_zx.loc_zx = ''Out''),0)) as pop2_haut_out
	FROM salaries_zx
	JOIN niv_zoom
	ON right(salaries_zx.moda_calc,11) = niv_zoom.code_indic
	WHERE __util_to_snake_case(salaries_zx.territoire) = ''' ||__util_to_snake_case(nom_ter) || '''
		AND __util_to_snake_case(salaries_zx.type_alea) = '''||__util_to_snake_case(typ_alea) ||'''
		AND __util_to_snake_case(salaries_zx.code_occurrence) = '''||__util_to_snake_case(code_occ) ||'''
		AND niv_zoom.niv_zoom = 6
	GROUP BY salaries_zx.territoire, salaries_zx.type_alea, salaries_zx.code_occurrence, niv_zoom.type_result, salaries_zx.id_iris, salaries_zx.nom_iris, salaries_zx.date_calc, salaries_zx.moda_calc
	';
	
	EXECUTE 'CREATE INDEX ON salaries_zx_iris USING btree(id_iris)';

	-- Il est IMPÉRATIF d'enregistrer la valeur du champ type_result dans une variable déclarée "typ_res" car l'appel au champ salaries_zx_iris.type_result dans l'INSERT INTO ci-dessous fait sauter les IRIS non concernés par des parcelles salaries_zx. Ce dysfonctionnement ressemble fortement à un bug PostgreSQL.
	-- Lucie a absolument TOUT tenté pour éviter de passer par cette variable déclarée sans succès. Cette méthode ajoute simplement deux lignes à l'ensemble du code, mais à creuser plus tard éventuellement.
	typ_res := (SELECT DISTINCT type_result FROM salaries_zx_iris);

	EXECUTE 'INSERT INTO salaries_zx_rc(
				territoire,
				type_alea,
				code_occurrence,
				type_result,
				id_geom,
				nom_id_geom,
				loc_zx,
				pop2_bas_in,
				pop2_haut_in,
				pop2_bas_out,
				pop2_haut_out,
				valid_result,
				date_calc,
				geom
			)
			SELECT DISTINCT
				'''||REPLACE(nom_ter,'''','''''')||''' as ter,
				'''||REPLACE(typ_alea,'''','''''')||''' as alea,
				'''||REPLACE(code_occ,'''','''''')||''' as occ,
				'''||typ_res||''',
				zt.id_iris AS id_geom,
				salaries_zx.nom_iris,
				''indéterminé''::varchar(30) as loc_zx,
				salaries_zx.pop2_bas_in,
				salaries_zx.pop2_haut_in,
				salaries_zx.pop2_bas_out,
				salaries_zx.pop2_haut_out,
				1,
				salaries_zx.date_calc,
				zt.geom
			FROM salaries_zx_iris as salaries_zx
			RIGHT JOIN zt_temp as zt
			ON salaries_zx.id_iris = zt.id_iris
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
	SELECT DISTINCT com.*, zt.territoire
	FROM commune_' || an_bdtopo || ' AS com
	JOIN zt
	ON zt.id_commune = com.insee_com
	WHERE __util_to_snake_case(zt.territoire) = ''' ||__util_to_snake_case(nom_ter) || '''
	';
	
	EXECUTE 'CREATE INDEX ON com_temp USING btree(insee_com)';
	
	EXECUTE 'DROP TABLE IF EXISTS salaries_zx_com CASCADE;
	CREATE TEMP TABLE salaries_zx_com AS
	SELECT
		niv_zoom.type_result,
		salaries_zx.id_commune,
		salaries_zx.nom_commune,
		salaries_zx.date_calc,
		salaries_zx.moda_calc,
		CEIL(COALESCE(SUM(salaries_zx.pop2_bas) FILTER (WHERE salaries_zx.loc_zx = ''In''),0)) as pop2_bas_in,
		CEIL(COALESCE(SUM(salaries_zx.pop2_haut) FILTER (WHERE salaries_zx.loc_zx = ''In''),0)) as pop2_haut_in,
		CEIL(COALESCE(SUM(salaries_zx.pop2_bas) FILTER (WHERE salaries_zx.loc_zx = ''Out''),0)) as pop2_bas_out,
		CEIL(COALESCE(SUM(salaries_zx.pop2_haut) FILTER (WHERE salaries_zx.loc_zx = ''Out''),0)) as pop2_haut_out
	FROM salaries_zx
	JOIN niv_zoom
	ON right(salaries_zx.moda_calc,11) = niv_zoom.code_indic
	WHERE __util_to_snake_case(salaries_zx.territoire) = '''||__util_to_snake_case(nom_ter) || '''
		AND __util_to_snake_case(salaries_zx.type_alea) = '''||__util_to_snake_case(typ_alea) ||'''
		AND __util_to_snake_case(salaries_zx.code_occurrence) = '''||__util_to_snake_case(code_occ) ||'''
		AND niv_zoom.niv_zoom = 7
	GROUP BY salaries_zx.territoire, salaries_zx.type_alea, salaries_zx.code_occurrence, niv_zoom.type_result, salaries_zx.id_commune, salaries_zx.nom_commune, salaries_zx.date_calc, salaries_zx.moda_calc
	';
	
	EXECUTE 'CREATE INDEX ON salaries_zx_com USING btree(id_commune)';

	-- Il est IMPÉRATIF d'enregistrer la valeur du champ type_result dans une variable déclarée "typ_res" car l'appel au champ salaries_zx_com.type_result dans l'INSERT INTO ci-dessous fait sauter les communes non concernées par des parcelles salaries_zx. Ce dysfonctionnement ressemble fortement à un bug PostgreSQL.
	-- Lucie a absolument TOUT tenté pour éviter de passer par cette variable déclarée sans succès. Cette méthode ajoute simplement deux lignes à l'ensemble du code, mais à creuser plus tard éventuellement.
	typ_res := (SELECT DISTINCT type_result FROM salaries_zx_com);

	EXECUTE 'INSERT INTO salaries_zx_rc(
				territoire,
				type_alea,
				code_occurrence,
				type_result,
				id_geom,
				nom_id_geom,
				loc_zx,
				pop2_bas_in,
				pop2_haut_in,
				pop2_bas_out,
				pop2_haut_out,
				valid_result,
				date_calc,
				geom
			)
			SELECT DISTINCT
				'''||REPLACE(nom_ter,'''','''''')||''' as ter,
				'''||REPLACE(typ_alea,'''','''''')||''' as alea,
				'''||REPLACE(code_occ,'''','''''')||''' as occ,
				'''||typ_res||''',
				com.insee_com AS id_geom,
				salaries_zx.nom_commune,
				''indéterminé''::varchar(30) as loc_zx,
				salaries_zx.pop2_bas_in,
				salaries_zx.pop2_haut_in,
				salaries_zx.pop2_bas_out,
				salaries_zx.pop2_haut_out,
				1,
				salaries_zx.date_calc,
				com.geom
			FROM salaries_zx_com as salaries_zx
			RIGHT JOIN com_temp AS com
			ON salaries_zx.id_commune = com.insee_com
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
		FROM epci_'||an_bdtopo||' AS epci
		JOIN zt
		ON zt.id_epci = epci.code_siren
		WHERE __util_to_snake_case(zt.territoire) = ''' ||__util_to_snake_case(nom_ter)|| '''';

	EXECUTE 'CREATE INDEX ON epci_temp USING btree(code_siren)';
	EXECUTE 'CREATE INDEX ON epci_temp USING gist(geom)';

	EXECUTE 'DROP TABLE IF EXISTS epci_too_large CASCADE';
	EXECUTE 'CREATE TEMP TABLE epci_too_large AS
		WITH tempa AS (
			SELECT
				territoire,
				SUM(ST_Area(geom))::double precision AS s_epci
			FROM epci_temp
			GROUP BY territoire
		)
		SELECT DISTINCT
			ST_Area(territoires.geom)::double precision AS s_ter,
			tempa.s_epci,
			(ST_Area(territoires.geom) / tempa.s_epci)::double precision AS r_ter_epci
		FROM c_general.territoires
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
	
		EXECUTE 'DROP TABLE IF EXISTS salaries_zx_epci CASCADE;
		CREATE TEMP TABLE salaries_zx_epci AS
		SELECT
			niv_zoom.type_result,
			salaries_zx.id_epci,
			salaries_zx.nom_epci,
			salaries_zx.date_calc,
			salaries_zx.moda_calc,
			CEIL(COALESCE(SUM(salaries_zx.pop2_bas) FILTER (WHERE salaries_zx.loc_zx = ''In''),0)) as pop2_bas_in,
			CEIL(COALESCE(SUM(salaries_zx.pop2_haut) FILTER (WHERE salaries_zx.loc_zx = ''In''),0)) as pop2_haut_in,
			CEIL(COALESCE(SUM(salaries_zx.pop2_bas) FILTER (WHERE salaries_zx.loc_zx = ''Out''),0)) as pop2_bas_out,
			CEIL(COALESCE(SUM(salaries_zx.pop2_haut) FILTER (WHERE salaries_zx.loc_zx = ''Out''),0)) as pop2_haut_out
		FROM salaries_zx
		JOIN niv_zoom
		ON right(salaries_zx.moda_calc,11) = niv_zoom.code_indic
		WHERE __util_to_snake_case(salaries_zx.territoire) = ''' ||__util_to_snake_case(nom_ter)|| '''
			AND __util_to_snake_case(salaries_zx.type_alea) = '''||__util_to_snake_case(typ_alea)||'''
			AND __util_to_snake_case(salaries_zx.code_occurrence) = '''||__util_to_snake_case(code_occ)||'''
			AND niv_zoom.niv_zoom = 8
		GROUP BY salaries_zx.territoire, salaries_zx.type_alea, salaries_zx.code_occurrence, niv_zoom.type_result, salaries_zx.id_epci, salaries_zx.nom_epci, salaries_zx.date_calc, salaries_zx.moda_calc
		';
			
		EXECUTE 'CREATE INDEX ON salaries_zx_epci USING btree(id_epci)';
	
		-- Il est IMPÉRATIF d'enregistrer la valeur du champ type_result dans une variable déclarée "typ_res" car l'appel au champ salaries_zx_epci.type_result dans l'INSERT INTO ci-dessous fait sauter les EPCI non concernés par des parcelles salaries_zx. Ce dysfonctionnement ressemble fortement à un bug PostgreSQL.
		-- Lucie a absolument TOUT tenté pour éviter de passer par cette variable déclarée sans succès. Cette méthode ajoute simplement deux lignes à l'ensemble du code, mais à creuser plus tard éventuellement.
		typ_res := (SELECT DISTINCT type_result FROM salaries_zx_epci);
	
		EXECUTE 'INSERT INTO salaries_zx_rc(
					territoire,
					type_alea,
					code_occurrence,
					type_result,
					id_geom,
					nom_id_geom,
					loc_zx,
					pop2_bas_in,
					pop2_haut_in,
					pop2_bas_out,
					pop2_haut_out,
					valid_result,
					date_calc,
					geom
				)
				SELECT DISTINCT
					'''||REPLACE(nom_ter,'''','''''')||''' AS ter,
					'''||REPLACE(typ_alea,'''','''''')||''' AS alea,
					'''||REPLACE(code_occ,'''','''''')||''' AS occ,
					'''||typ_res||''',
					epci.code_siren AS id_geom,
					salaries_zx.nom_epci,
					''indéterminé''::varchar(30) as loc_zx,
					salaries_zx.pop2_bas_in,
					salaries_zx.pop2_haut_in,
					salaries_zx.pop2_bas_out,
					salaries_zx.pop2_haut_out,
					1,
					salaries_zx.date_calc,
					epci.geom
				FROM salaries_zx_epci as salaries_zx
				RIGHT JOIN epci_temp AS epci
				ON salaries_zx.id_epci = epci.code_siren
				WHERE __util_to_snake_case(epci.territoire) = ''' ||__util_to_snake_case(nom_ter)|| '''
				';	
	ELSE
	
		EXECUTE 'DROP TABLE IF EXISTS ter_temp CASCADE;
			CREATE TEMP TABLE ter_temp AS
			SELECT DISTINCT *
			FROM c_general.territoires
			WHERE __util_to_snake_case(territoire) = ''' ||__util_to_snake_case(nom_ter)|| '''';
	
		EXECUTE 'CREATE INDEX ON ter_temp USING btree(id)';
		EXECUTE 'CREATE INDEX ON ter_temp USING gist(geom)';
	
		EXECUTE 'DROP TABLE IF EXISTS salaries_zx_ter CASCADE;
		CREATE TEMP TABLE salaries_zx_ter AS
		SELECT
			salaries_zx.territoire,
			niv_zoom.type_result,
			salaries_zx.date_calc,
			salaries_zx.moda_calc,
			CEIL(COALESCE(SUM(salaries_zx.pop2_bas) FILTER (WHERE salaries_zx.loc_zx = ''In''),0)) as pop2_bas_in,
			CEIL(COALESCE(SUM(salaries_zx.pop2_haut) FILTER (WHERE salaries_zx.loc_zx = ''In''),0)) as pop2_haut_in,
			CEIL(COALESCE(SUM(salaries_zx.pop2_bas) FILTER (WHERE salaries_zx.loc_zx = ''Out''),0)) as pop2_bas_out,
			CEIL(COALESCE(SUM(salaries_zx.pop2_haut) FILTER (WHERE salaries_zx.loc_zx = ''Out''),0)) as pop2_haut_out
		FROM salaries_zx
		JOIN niv_zoom
		ON right(salaries_zx.moda_calc,11) = niv_zoom.code_indic
		WHERE __util_to_snake_case(salaries_zx.territoire) = ''' ||__util_to_snake_case(nom_ter)|| '''
			AND __util_to_snake_case(salaries_zx.type_alea) = '''||__util_to_snake_case(typ_alea)||'''
			AND __util_to_snake_case(salaries_zx.code_occurrence) = '''||__util_to_snake_case(code_occ)||'''
			AND niv_zoom.niv_zoom = 8
		GROUP BY salaries_zx.territoire, salaries_zx.type_alea, salaries_zx.code_occurrence, niv_zoom.type_result, salaries_zx.date_calc, salaries_zx.moda_calc
		';
			
		EXECUTE 'CREATE INDEX ON salaries_zx_ter USING btree(territoire)';
	
		-- Il est IMPÉRATIF d'enregistrer la valeur du champ type_result dans une variable déclarée "typ_res" car l'appel au champ salaries_zx_ter.type_result dans l'INSERT INTO ci-dessous fait sauter les EPCI non concernés par des parcelles salaries_zx. Ce dysfonctionnement ressemble fortement à un bug PostgreSQL.
		-- Lucie a absolument TOUT tenté pour éviter de passer par cette variable déclarée sans succès. Cette méthode ajoute simplement deux lignes à l'ensemble du code, mais à creuser plus tard éventuellement.
		typ_res := (SELECT DISTINCT type_result FROM salaries_zx_ter);
	
		EXECUTE 'INSERT INTO salaries_zx_rc(
					territoire,
					type_alea,
					code_occurrence,
					type_result,
					id_geom,
					nom_id_geom,
					loc_zx,
					pop2_bas_in,
					pop2_haut_in,
					pop2_bas_out,
					pop2_haut_out,
					valid_result,
					date_calc,
					geom
				)
				SELECT DISTINCT
					'''||REPLACE(nom_ter,'''','''''')||''' AS ter,
					'''||REPLACE(typ_alea,'''','''''')||''' AS alea,
					'''||REPLACE(code_occ,'''','''''')||''' AS occ,
					'''||typ_res||''',
					ter.id AS id_geom,
					'''||REPLACE(nom_ter,'''','''''')||''',
					''indéterminé''::varchar(30) as loc_zx,
					salaries_zx.pop2_bas_in,
					salaries_zx.pop2_haut_in,
					salaries_zx.pop2_bas_out,
					salaries_zx.pop2_haut_out,
					0,
					salaries_zx.date_calc,
					ter.geom
				FROM salaries_zx_ter as salaries_zx
				RIGHT JOIN ter_temp AS ter
				ON __util_to_snake_case(salaries_zx.territoire) = __util_to_snake_case(ter.territoire)
				WHERE __util_to_snake_case(ter.territoire) = ''' ||__util_to_snake_case(nom_ter)|| '''
				';
			
	END IF;

	-- Récupération du nombre d'entités ajoutées
	GET DIAGNOSTICS c_epci = row_count; -- nombre d'EPCI insérés dans la table

	--************************************************************************
	-- Création d'une vue matérialisée sur le territoire
	--************************************************************************
	RAISE NOTICE '';
	RAISE NOTICE 'Création de la vue matérialisée %', 'p_rep_carto.salaries_zx_rc_'||__util_to_snake_case(nom_ter);
	EXECUTE '
		DROP MATERIALIZED VIEW IF EXISTS salaries_zx_rc_' || __util_to_snake_case(nom_ter) || ' CASCADE;
		CREATE MATERIALIZED VIEW salaries_zx_rc_' || __util_to_snake_case(nom_ter) || ' AS
		SELECT *
		FROM salaries_zx_rc
		WHERE __util_to_snake_case(territoire) = '''||__util_to_snake_case(nom_ter)||'''';

	-- Création des index sur la vue matérialisée
	RAISE NOTICE 'Création des index sur la vue matérialisée';

	EXECUTE 'CREATE UNIQUE INDEX ON salaries_zx_rc_' || __util_to_snake_case(nom_ter) || ' (id)';

	EXECUTE 'CREATE INDEX ON salaries_zx_rc_' || __util_to_snake_case(nom_ter) || ' USING gist(geom)';
	EXECUTE 'CREATE INDEX ON salaries_zx_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(id)';
	EXECUTE 'CREATE INDEX ON salaries_zx_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(territoire)';
	EXECUTE 'CREATE INDEX ON salaries_zx_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(type_alea)';
	EXECUTE 'CREATE INDEX ON salaries_zx_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(code_occurrence)';
	EXECUTE 'CREATE INDEX ON salaries_zx_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(type_result)';
	EXECUTE 'CREATE INDEX ON salaries_zx_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(id_geom)';
	EXECUTE 'CREATE INDEX ON salaries_zx_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(nom_id_geom)';
	EXECUTE 'CREATE INDEX ON salaries_zx_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(loc_zx)';
	EXECUTE 'CREATE INDEX ON salaries_zx_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(pop2_bas_in)';
	EXECUTE 'CREATE INDEX ON salaries_zx_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(pop2_haut_in)';
	EXECUTE 'CREATE INDEX ON salaries_zx_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(pop2_bas_out)';
	EXECUTE 'CREATE INDEX ON salaries_zx_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(pop2_haut_out)';
	EXECUTE 'CREATE INDEX ON salaries_zx_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(pct_pop2_bas_in)';
	EXECUTE 'CREATE INDEX ON salaries_zx_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(pct_pop2_haut_in)';
	EXECUTE 'CREATE INDEX ON salaries_zx_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(pct_pop2_bas_out)';
	EXECUTE 'CREATE INDEX ON salaries_zx_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(pct_pop2_haut_out)';
	EXECUTE 'CREATE INDEX ON salaries_zx_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(total_bas)';
	EXECUTE 'CREATE INDEX ON salaries_zx_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(total_haut)';
	EXECUTE 'CREATE INDEX ON salaries_zx_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(valid_result)';
	EXECUTE 'CREATE INDEX ON salaries_zx_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(date_calc)';
	RAISE NOTICE 'Index créés sur la vue matérialisée';

	--************************************************************************
	-- Conclusion
	--************************************************************************
	RAISE NOTICE '';
	RAISE NOTICE '====== FIN TRAITEMENT ======';
	RAISE NOTICE '[INFO] La table salaries_zx_rc (représentation cartographique de l''indicateur salaries_zx sous forme d''hexagones + autres géométries administratives) a été mise à jour dans le schéma p_rep_carto pour le territoire "%" et l''aléa "% - %"', nom_ter, typ_alea, code_occ;
	RAISE NOTICE '';
	RAISE NOTICE '====== RÉSULTATS ======';

	IF c_hexag+c_entite+c_iris+c_com+c_epci > 1
		THEN RAISE NOTICE '% enregistrements insérés au total dans la table p_rep_carto.salaries_zx_rc pour le territoire "%" et l''aléa "% - %"', c_hexag+c_entite+c_iris+c_com+c_epci, nom_ter, typ_alea, code_occ;
		ELSE RAISE NOTICE '% enregistrement inséré dans la table p_rep_carto.salaries_zx_rc pour le territoire "%" et l''aléa "% - %"', c_hexag+c_entite+c_iris+c_com+c_epci, nom_ter, typ_alea, code_occ;
	END IF;

	RAISE NOTICE 'dont :';
	
		IF c_hexag > 1
			THEN RAISE NOTICE '- % hexagones', c_hexag;
			ELSE RAISE NOTICE '- % hexagone', c_hexag;
		END IF;
	
		IF c_entite > 1
			THEN RAISE NOTICE '- % entités "bâtiments agglomérés à l''IRIS"', c_entite;
			ELSE RAISE NOTICE '- % entité "bâtiments agglomérés à l''IRIS"', c_entite;
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
