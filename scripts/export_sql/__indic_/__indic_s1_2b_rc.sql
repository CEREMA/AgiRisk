SET client_encoding = 'UTF8';

CREATE OR REPLACE FUNCTION public.__indic_s1_2b_rc(nom_ter text, typ_alea text, code_occ text, an_bdtopo text)
 RETURNS void
 LANGUAGE plpgsql
AS $function$

-- Fonction SQL de représentation cartographique de l'indicateur S1/2b "Personnes occupant des locaux fortement inondables"
-- © Cerema / GT AgiRisk (auteurs principaux du script, inspiré de celui retravaillé par Lucie sur S3/1a : Anaïs, Sébastien)
-- Dernières mises à jour du script le 20/04/2023 par Lucie et le 25/08/2023 par Sébastien (test avec succès sur Longuyon le 24/08/2023)

-- Paramètres d'entrée :
-- nom_ter = nom du territoire d'étude tel que renseigné dans le champ `territoire` de la table c_general.territoires
-- typ_alea : type d'aléa considéré (ex : débordement de cours d'eau, submersion marine)
-- code_occ : période de retour considérée pour le type d'aléa choisi (ex : QRef, Q100, Q10)
-- an_bdtopo = millésime (année au format AAAA) de la BD TOPO®

-- Exemple d'appel à cette fonction :
-- SELECT public.__indic_s1_2b_rc('Jura', 'débordement de cours d''eau', 'QRef', '2022');

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
	typ_res varchar; -- variable qui prend la valeur du type_result à insérer dans s1_2b_rc

BEGIN
	heure1 = clock_timestamp();
	
	--************************************************************************
	-- Définition des schémas de travail
	--************************************************************************
	SET search_path TO p_rep_carto, p_indicateurs, c_phenomenes, r_ign_bdtopo, r_rep_carto, r_ressources, public;

	RAISE NOTICE '';
	RAISE NOTICE '====== RAPPORT ======';
	RAISE NOTICE 'Génération des représentations cartographiques pour l''indicateur S1/2b (occcupants de locaux fortement inondables)';
	RAISE NOTICE 'Début du traitement : %', heure1;
	RAISE NOTICE '';

	--************************************************************************
	-- Vérification de l'existence d'une table s1_2b dans le schéma p_indicateurs
	--************************************************************************
	IF NOT EXISTS (
		SELECT *
		FROM p_indicateurs.s1_2b
		WHERE territoire = ''||nom_ter||''
			AND type_alea = ''||typ_alea||''
			AND code_occurrence = ''||code_occ||''
	)
	THEN
		RAISE EXCEPTION 'L''indicateur S1/2b n''a pas encore été calculé sur le territoire "%" avec l''aléa "% - %". Fin de l''exécution', nom_ter, typ_alea, code_occ;
	END IF;

	--************************************************************************
	-- Vérification de l'absence de données pour le territoire, le type d'aléa et l'occurrence de crue renseignés dans la table p_rep_carto.s1_2b_rc
	--************************************************************************
	IF EXISTS (
		SELECT *
		FROM p_rep_carto.s1_2b_rc
		WHERE territoire = ''||nom_ter||''
			AND type_alea = ''||typ_alea||''
			AND code_occurrence = ''||code_occ||''
	)
	THEN
		RAISE EXCEPTION 'Il existe déjà des enregistrements pour le territoire "%" avec l''aléa "% - %" dans la table p_rep_carto.s1_2b_rc. 
		Pour les supprimer, lancer la requête suivante : 
		DELETE FROM p_rep_carto.s1_2b_rc WHERE territoire = ''%'' AND type_alea = ''%'' AND code_occurrence = ''%'';', nom_ter, typ_alea, code_occ, REPLACE(nom_ter,'''',''''''), REPLACE(typ_alea,'''',''''''), REPLACE(code_occ,'''','''''');
	END IF;

	--************************************************************************
	-- Insertion des données hexag_xxxha
	--************************************************************************
	RAISE NOTICE 'Insertion des données hexag_xxxha';
	FOR valzoom, valresult IN SELECT DISTINCT niv_zoom, lower(type_result) FROM niv_zoom WHERE type_result LIKE 'Hexag%'
	LOOP
		EXECUTE 'INSERT INTO s1_2b_rc(
			territoire,
			type_alea,
			code_occurrence,
			type_result,
			id_geom,
			nom_id_geom,
			loc_zq,
			pop6_rdc_in_fort_tresfort,
			pop6_rdc_in_fai_moyen,
			pop6_rdc_out_zq,
			valid_result,
			date_calc,
			geom
		)
		SELECT DISTINCT
			s1_2b.territoire,
			s1_2b.type_alea,
			s1_2b.code_occurrence,
			initcap('''||valresult||''')::varchar(200) AS type_result,
			hexag.grid_id::varchar(200) AS id_geom,
			''indéterminé''::varchar(200) AS nom_id_geom,
			''indéterminé''::varchar(30) AS loc_zq,
			CASE
				WHEN CEIL(COALESCE(SUM(s1_2b.pop6_rdc) FILTER (WHERE s1_2b.loc_zq = ''In fort'' or s1_2b.loc_zq = ''In très fort''),0)) > 0
				AND CEIL(COALESCE(SUM(s1_2b.pop6_rdc) FILTER (WHERE s1_2b.loc_zq = ''In fort'' or s1_2b.loc_zq = ''In très fort''),0)) < 10 THEN 10
				ELSE CEIL(COALESCE(SUM(s1_2b.pop6_rdc) FILTER (WHERE s1_2b.loc_zq = ''In fort'' or s1_2b.loc_zq = ''In très fort''),0))
			END,
			CASE
				WHEN CEIL(COALESCE(SUM(s1_2b.pop6_rdc) FILTER (WHERE s1_2b.loc_zq = ''In faible'' or s1_2b.loc_zq = ''In moyen''),0)) > 0
				AND CEIL(COALESCE(SUM(s1_2b.pop6_rdc) FILTER (WHERE s1_2b.loc_zq = ''In faible'' or s1_2b.loc_zq = ''In moyen''),0)) < 10 THEN 10
				ELSE CEIL(COALESCE(SUM(s1_2b.pop6_rdc) FILTER (WHERE s1_2b.loc_zq = ''In faible'' or s1_2b.loc_zq = ''In moyen''),0))
			END,
			CASE
				WHEN CEIL(COALESCE(SUM(s1_2b.pop6_rdc) FILTER (WHERE s1_2b.loc_zq = ''Out''),0)) > 0
				AND CEIL(COALESCE(SUM(s1_2b.pop6_rdc) FILTER (WHERE s1_2b.loc_zq = ''Out''),0)) < 10 THEN 10
				ELSE CEIL(COALESCE(SUM(s1_2b.pop6_rdc) FILTER (WHERE s1_2b.loc_zq = ''Out''),0))
			END,
			1 AS valid_result,
			s1_2b.date_calc AS date_calc,
			hexag.geom
		FROM s1_2b
		JOIN niv_zoom
		ON right(s1_2b.moda_calc,5) = niv_zoom.code_indic
		RIGHT JOIN '||valresult||' AS hexag
		ON ST_Intersects(s1_2b.geomloc, hexag.geom)
		WHERE __util_to_snake_case(s1_2b.territoire) = ''' ||__util_to_snake_case(nom_ter) || '''
			AND __util_to_snake_case(s1_2b.type_alea) = '''||__util_to_snake_case(typ_alea)||'''
			AND __util_to_snake_case(s1_2b.code_occurrence) = '''||__util_to_snake_case(code_occ)||'''
			AND niv_zoom.niv_zoom = '||valzoom||'
		GROUP BY s1_2b.territoire, s1_2b.type_alea, s1_2b.code_occurrence, type_result, id_geom, nom_id_geom, s1_2b.date_calc, hexag.geom
		';
	END LOOP;

	-- Récupération du nombre d'entités ajoutées
	EXECUTE '
		SELECT count(*)
		FROM s1_2b_rc
		WHERE __util_to_snake_case(territoire) = '''||__util_to_snake_case(nom_ter)||'''
			AND __util_to_snake_case(type_alea) = '''||__util_to_snake_case(typ_alea)||'''
			AND __util_to_snake_case(code_occurrence) = '''||__util_to_snake_case(code_occ)||'''
			AND type_result LIKE ''Hexag_%'''
	INTO c_hexag; -- nombre total d'hexagones insérés dans la table

	--************************************************************************
	-- Insertion des bâtiments "bruts" agglomérés à l'IRIS
	--************************************************************************
	RAISE NOTICE 'Insertion des bâtiments "bruts" agglomérés à l''IRIS';
	
	EXECUTE 'INSERT INTO s1_2b_rc(
			territoire,
			type_alea,
			code_occurrence,
			type_result,
			id_geom,
			nom_id_geom,
			loc_zq,
			pop6_rdc_in_fort_tresfort,
			pop6_rdc_in_fai_moyen,
			pop6_rdc_out_zq,
			valid_result,
			date_calc,
			geom
		)
		SELECT
			s1_2b.territoire,
			s1_2b.type_alea,
			s1_2b.code_occurrence,
			niv_zoom.type_result,
			zt.id_iris AS id_geom,
			s1_2b.nom_iris,
			s1_2b.loc_zq,
			CASE
				WHEN CEIL(COALESCE(SUM(s1_2b.pop6_rdc) FILTER (WHERE s1_2b.loc_zq = ''In fort'' or s1_2b.loc_zq = ''In très fort''),0)) > 0
				AND CEIL(COALESCE(SUM(s1_2b.pop6_rdc) FILTER (WHERE s1_2b.loc_zq = ''In fort'' or s1_2b.loc_zq = ''In très fort''),0)) < 10 THEN 10
				ELSE CEIL(COALESCE(SUM(s1_2b.pop6_rdc) FILTER (WHERE s1_2b.loc_zq = ''In fort'' or s1_2b.loc_zq = ''In très fort''),0))
			END,
			CASE
				WHEN CEIL(COALESCE(SUM(s1_2b.pop6_rdc) FILTER (WHERE s1_2b.loc_zq = ''In faible'' or s1_2b.loc_zq = ''In moyen''),0)) > 0
				AND CEIL(COALESCE(SUM(s1_2b.pop6_rdc) FILTER (WHERE s1_2b.loc_zq = ''In faible'' or s1_2b.loc_zq = ''In moyen''),0)) < 10 THEN 10
				ELSE CEIL(COALESCE(SUM(s1_2b.pop6_rdc) FILTER (WHERE s1_2b.loc_zq = ''In faible'' or s1_2b.loc_zq = ''In moyen''),0))
			END,
			CASE
				WHEN CEIL(COALESCE(SUM(s1_2b.pop6_rdc) FILTER (WHERE s1_2b.loc_zq = ''Out''),0)) > 0
				AND CEIL(COALESCE(SUM(s1_2b.pop6_rdc) FILTER (WHERE s1_2b.loc_zq = ''Out''),0)) < 10 THEN 10
				ELSE CEIL(COALESCE(SUM(s1_2b.pop6_rdc) FILTER (WHERE s1_2b.loc_zq = ''Out''),0))
			END,
			1,
			s1_2b.date_calc,
			ST_Multi(ST_Simplify(ST_CollectionExtract(ST_ForceCollection(ST_MakeValid(ST_Union(s1_2b.geom))),3),0))
		FROM s1_2b
		JOIN niv_zoom
		ON right(s1_2b.moda_calc,5) = niv_zoom.code_indic
		RIGHT JOIN zt
		ON s1_2b.id_iris = zt.id_iris
		WHERE __util_to_snake_case(zt.territoire) = '''||__util_to_snake_case(nom_ter)||'''
			AND __util_to_snake_case(s1_2b.territoire) = ''' ||__util_to_snake_case(nom_ter)|| '''
			AND __util_to_snake_case(s1_2b.type_alea) = '''||__util_to_snake_case(typ_alea)||'''
			AND __util_to_snake_case(s1_2b.code_occurrence) = '''||__util_to_snake_case(code_occ)||'''
			AND niv_zoom.niv_zoom = 0
		GROUP BY s1_2b.territoire, s1_2b.type_alea, s1_2b.code_occurrence, niv_zoom.type_result, id_geom, s1_2b.nom_iris, s1_2b.loc_zq, s1_2b.date_calc
		';

	-- Récupération du nombre d'entités ajoutées
	GET DIAGNOSTICS c_entite = row_count; -- nombre d'entités insérées dans la table

	--************************************************************************
	-- Insertion des IRIS
	--************************************************************************
	RAISE NOTICE 'Insertion des IRIS';

	EXECUTE 'DROP TABLE IF EXISTS zt_temp CASCADE;
		CREATE TEMP TABLE zt_temp AS
		SELECT DISTINCT *
		FROM zt
		WHERE __util_to_snake_case(territoire) = ''' ||__util_to_snake_case(nom_ter) || '''
		';

	EXECUTE 'CREATE INDEX ON zt_temp USING btree(id_iris)';

	EXECUTE 'DROP TABLE IF EXISTS s1_2b_iris CASCADE;
		CREATE TEMP TABLE s1_2b_iris AS
		SELECT DISTINCT
			niv_zoom.type_result,
			s1_2b.id_iris,
			s1_2b.nom_iris,
			s1_2b.date_calc,
			s1_2b.moda_calc,
			CASE
				WHEN CEIL(COALESCE(SUM(s1_2b.pop6_rdc) FILTER (WHERE s1_2b.loc_zq = ''In fort'' or s1_2b.loc_zq = ''In très fort''),0)) > 0
				AND CEIL(COALESCE(SUM(s1_2b.pop6_rdc) FILTER (WHERE s1_2b.loc_zq = ''In fort'' or s1_2b.loc_zq = ''In très fort''),0)) < 10 THEN 10
				ELSE CEIL(COALESCE(SUM(s1_2b.pop6_rdc) FILTER (WHERE s1_2b.loc_zq = ''In fort'' or s1_2b.loc_zq = ''In très fort''),0))
			END AS pop6_rdc_in_fort_tresfort,
			CASE
				WHEN CEIL(COALESCE(SUM(s1_2b.pop6_rdc) FILTER (WHERE s1_2b.loc_zq = ''In faible'' or s1_2b.loc_zq = ''In moyen''),0)) > 0
				AND CEIL(COALESCE(SUM(s1_2b.pop6_rdc) FILTER (WHERE s1_2b.loc_zq = ''In faible'' or s1_2b.loc_zq = ''In moyen''),0)) < 10 THEN 10
				ELSE CEIL(COALESCE(SUM(s1_2b.pop6_rdc) FILTER (WHERE s1_2b.loc_zq = ''In faible'' or s1_2b.loc_zq = ''In moyen''),0))
			END AS pop6_rdc_in_fai_moyen,
			CASE
				WHEN CEIL(COALESCE(SUM(s1_2b.pop6_rdc) FILTER (WHERE s1_2b.loc_zq = ''Out''),0)) > 0
				AND CEIL(COALESCE(SUM(s1_2b.pop6_rdc) FILTER (WHERE s1_2b.loc_zq = ''Out''),0)) < 10 THEN 10
				ELSE CEIL(COALESCE(SUM(s1_2b.pop6_rdc) FILTER (WHERE s1_2b.loc_zq = ''Out''),0))
			END AS pop6_rdc_out_zq
		FROM s1_2b
		JOIN niv_zoom
		ON right(s1_2b.moda_calc,5) = niv_zoom.code_indic
		WHERE __util_to_snake_case(s1_2b.territoire) = ''' ||__util_to_snake_case(nom_ter) || '''
			AND __util_to_snake_case(s1_2b.type_alea) = '''||__util_to_snake_case(typ_alea) ||'''
			AND __util_to_snake_case(s1_2b.code_occurrence) = '''||__util_to_snake_case(code_occ) ||'''
			AND niv_zoom.niv_zoom = 6
		GROUP BY s1_2b.territoire, s1_2b.type_alea, s1_2b.code_occurrence, niv_zoom.type_result, s1_2b.id_iris, s1_2b.nom_iris, s1_2b.date_calc, s1_2b.moda_calc
		';
	
	EXECUTE 'CREATE INDEX ON s1_2b_iris USING btree(id_iris)';

	-- Il est IMPÉRATIF d'enregistrer la valeur du champ type_result dans une variable déclarée "typ_res" car l'appel au champ s1_2b_iris.type_result dans l'INSERT INTO ci-dessous fait sauter les IRIS non concernés par des parcelles s1_2b. Ce dysfonctionnement ressemble fortement à un bug PostgreSQL.
	-- Lucie a absolument TOUT tenté pour éviter de passer par cette variable déclarée sans succès. Cette méthode ajoute simplement deux lignes à l'ensemble du code, mais à creuser plus tard éventuellement.
	typ_res := (SELECT DISTINCT type_result FROM s1_2b_iris);
	
	EXECUTE 'INSERT INTO s1_2b_rc(
			territoire,
			type_alea,
			code_occurrence,
			type_result,
			id_geom,
			nom_id_geom,
			loc_zq,
			pop6_rdc_in_fort_tresfort,
			pop6_rdc_in_fai_moyen,
			pop6_rdc_out_zq,
			valid_result,
			date_calc,
			geom
		)
		SELECT
			'''||REPLACE(nom_ter,'''','''''')||''' as ter,
			'''||REPLACE(typ_alea,'''','''''')||''' as alea,
			'''||REPLACE(code_occ,'''','''''')||''' as occ,
			'''||typ_res||''',
			zt.id_iris AS id_geom,
			s1_2b.nom_iris,
			''indéterminé''::varchar(200),
			s1_2b.pop6_rdc_in_fort_tresfort,
			s1_2b.pop6_rdc_in_fai_moyen,
			s1_2b.pop6_rdc_out_zq,
			1,
			s1_2b.date_calc,
			zt.geom
		FROM s1_2b_iris as s1_2b
		RIGHT JOIN zt_temp as zt
		ON s1_2b.id_iris = zt.id_iris
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
	
	EXECUTE 'DROP TABLE IF EXISTS s1_2b_com CASCADE;
		CREATE TEMP TABLE s1_2b_com AS
		SELECT
			niv_zoom.type_result,
			s1_2b.id_commune,
			s1_2b.nom_commune,
			s1_2b.date_calc,
			s1_2b.moda_calc,
			CASE
				WHEN CEIL(COALESCE(SUM(s1_2b.pop6_rdc) FILTER (WHERE s1_2b.loc_zq = ''In fort'' or s1_2b.loc_zq = ''In très fort''),0)) > 0
				AND CEIL(COALESCE(SUM(s1_2b.pop6_rdc) FILTER (WHERE s1_2b.loc_zq = ''In fort'' or s1_2b.loc_zq = ''In très fort''),0)) < 10 THEN 10
				ELSE CEIL(COALESCE(SUM(s1_2b.pop6_rdc) FILTER (WHERE s1_2b.loc_zq = ''In fort'' or s1_2b.loc_zq = ''In très fort''),0))
			END AS pop6_rdc_in_fort_tresfort,
			CASE
				WHEN CEIL(COALESCE(SUM(s1_2b.pop6_rdc) FILTER (WHERE s1_2b.loc_zq = ''In faible'' or s1_2b.loc_zq = ''In moyen''),0)) > 0
				AND CEIL(COALESCE(SUM(s1_2b.pop6_rdc) FILTER (WHERE s1_2b.loc_zq = ''In faible'' or s1_2b.loc_zq = ''In moyen''),0)) < 10 THEN 10
				ELSE CEIL(COALESCE(SUM(s1_2b.pop6_rdc) FILTER (WHERE s1_2b.loc_zq = ''In faible'' or s1_2b.loc_zq = ''In moyen''),0))
			END AS pop6_rdc_in_fai_moyen,
			CASE
				WHEN CEIL(COALESCE(SUM(s1_2b.pop6_rdc) FILTER (WHERE s1_2b.loc_zq = ''Out''),0)) > 0
				AND CEIL(COALESCE(SUM(s1_2b.pop6_rdc) FILTER (WHERE s1_2b.loc_zq = ''Out''),0)) < 10 THEN 10
				ELSE CEIL(COALESCE(SUM(s1_2b.pop6_rdc) FILTER (WHERE s1_2b.loc_zq = ''Out''),0))
			END AS pop6_rdc_out_zq
		FROM s1_2b
		JOIN niv_zoom
		ON right(s1_2b.moda_calc,5) = niv_zoom.code_indic
		WHERE __util_to_snake_case(s1_2b.territoire) = '''||__util_to_snake_case(nom_ter) || '''
			AND __util_to_snake_case(s1_2b.type_alea) = '''||__util_to_snake_case(typ_alea) ||'''
			AND __util_to_snake_case(s1_2b.code_occurrence) = '''||__util_to_snake_case(code_occ) ||'''
			AND niv_zoom.niv_zoom = 7
		GROUP BY s1_2b.territoire, s1_2b.type_alea, s1_2b.code_occurrence, niv_zoom.type_result, s1_2b.id_commune, s1_2b.nom_commune, s1_2b.date_calc, s1_2b.moda_calc
		';
	
	EXECUTE 'CREATE INDEX ON s1_2b_com USING btree(id_commune)';

	-- Il est IMPÉRATIF d'enregistrer la valeur du champ type_result dans une variable déclarée "typ_res" car l'appel au champ s1_2b_com.type_result dans l'INSERT INTO ci-dessous fait sauter les communes non concernées par des parcelles s1_2b. Ce dysfonctionnement ressemble fortement à un bug PostgreSQL.
	-- Lucie a absolument TOUT tenté pour éviter de passer par cette variable déclarée sans succès. Cette méthode ajoute simplement deux lignes à l'ensemble du code, mais à creuser plus tard éventuellement.
	typ_res := (SELECT DISTINCT type_result FROM s1_2b_com);

	EXECUTE 'INSERT INTO s1_2b_rc(
			territoire,
			type_alea,
			code_occurrence,
			type_result,
			id_geom,
			nom_id_geom,
			loc_zq,
			pop6_rdc_in_fort_tresfort,
			pop6_rdc_in_fai_moyen,
			pop6_rdc_out_zq,
			valid_result,
			date_calc,
			geom
		)
		SELECT
			'''||REPLACE(nom_ter,'''','''''')||''' as ter,
			'''||REPLACE(typ_alea,'''','''''')||''' as alea,
			'''||REPLACE(code_occ,'''','''''')||''' as occ,
			'''||typ_res||''',
			com.insee_com AS id_geom,
			s1_2b.nom_commune,
			''indéterminé''::varchar(200) AS loc_zq,
			s1_2b.pop6_rdc_in_fort_tresfort,
			s1_2b.pop6_rdc_in_fai_moyen,
			s1_2b.pop6_rdc_out_zq,
			1,
			s1_2b.date_calc,
			com.geom
		FROM s1_2b_com as s1_2b
		RIGHT JOIN com_temp as com
		ON s1_2b.id_commune = com.insee_com
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
	
		EXECUTE 'DROP TABLE IF EXISTS s1_2b_epci CASCADE;
			CREATE TEMP TABLE s1_2b_epci AS
			SELECT
				niv_zoom.type_result,
				s1_2b.id_epci,
				s1_2b.nom_epci,
				s1_2b.date_calc,
				s1_2b.moda_calc,
				CASE
					WHEN CEIL(COALESCE(SUM(s1_2b.pop6_rdc) FILTER (WHERE s1_2b.loc_zq = ''In fort'' or s1_2b.loc_zq = ''In très fort''),0)) > 0
					AND CEIL(COALESCE(SUM(s1_2b.pop6_rdc) FILTER (WHERE s1_2b.loc_zq = ''In fort'' or s1_2b.loc_zq = ''In très fort''),0)) < 10 THEN 10
					ELSE CEIL(COALESCE(SUM(s1_2b.pop6_rdc) FILTER (WHERE s1_2b.loc_zq = ''In fort'' or s1_2b.loc_zq = ''In très fort''),0))
				END AS pop6_rdc_in_fort_tresfort,
				CASE
					WHEN CEIL(COALESCE(SUM(s1_2b.pop6_rdc) FILTER (WHERE s1_2b.loc_zq = ''In faible'' or s1_2b.loc_zq = ''In moyen''),0)) > 0
					AND CEIL(COALESCE(SUM(s1_2b.pop6_rdc) FILTER (WHERE s1_2b.loc_zq = ''In faible'' or s1_2b.loc_zq = ''In moyen''),0)) < 10 THEN 10
					ELSE CEIL(COALESCE(SUM(s1_2b.pop6_rdc) FILTER (WHERE s1_2b.loc_zq = ''In faible'' or s1_2b.loc_zq = ''In moyen''),0))
				END AS pop6_rdc_in_fai_moyen,
				CASE
					WHEN CEIL(COALESCE(SUM(s1_2b.pop6_rdc) FILTER (WHERE s1_2b.loc_zq = ''Out''),0)) > 0
					AND CEIL(COALESCE(SUM(s1_2b.pop6_rdc) FILTER (WHERE s1_2b.loc_zq = ''Out''),0)) < 10 THEN 10
					ELSE CEIL(COALESCE(SUM(s1_2b.pop6_rdc) FILTER (WHERE s1_2b.loc_zq = ''Out''),0))
				END AS pop6_rdc_out_zq
			FROM s1_2b
			JOIN niv_zoom
			ON right(s1_2b.moda_calc,5) = niv_zoom.code_indic
			WHERE __util_to_snake_case(s1_2b.territoire) = ''' ||__util_to_snake_case(nom_ter)|| '''
				AND __util_to_snake_case(s1_2b.type_alea) = '''||__util_to_snake_case(typ_alea)||'''
				AND __util_to_snake_case(s1_2b.code_occurrence) = '''||__util_to_snake_case(code_occ)||'''
				AND niv_zoom.niv_zoom = 8
			GROUP BY s1_2b.territoire, s1_2b.type_alea, s1_2b.code_occurrence, niv_zoom.type_result, s1_2b.id_epci, s1_2b.nom_epci,  s1_2b.date_calc, s1_2b.moda_calc
			';
	
		EXECUTE 'CREATE INDEX ON s1_2b_epci USING btree(id_epci)';
	
		-- Il est IMPÉRATIF d'enregistrer la valeur du champ type_result dans une variable déclarée "typ_res" car l'appel au champ s1_2b_epci.type_result dans l'INSERT INTO ci-dessous fait sauter les EPCI non concernés par des parcelles s1_2b. Ce dysfonctionnement ressemble fortement à un bug PostgreSQL.
		-- Lucie a absolument TOUT tenté pour éviter de passer par cette variable déclarée sans succès. Cette méthode ajoute simplement deux lignes à l'ensemble du code, mais à creuser plus tard éventuellement.
		typ_res := (SELECT DISTINCT type_result FROM s1_2b_epci);

		EXECUTE 'INSERT INTO s1_2b_rc (
				territoire,
				type_alea,
				code_occurrence,
				type_result,
				id_geom,
				nom_id_geom,
				loc_zq,
				pop6_rdc_in_fort_tresfort,
				pop6_rdc_in_fai_moyen,
				pop6_rdc_out_zq,
				valid_result,
				date_calc,
				geom
			)
			SELECT DISTINCT
				'''||REPLACE(nom_ter,'''','''''')||''' AS ter,
				'''||REPLACE(typ_alea,'''','''''')||''' AS alea,
				'''||REPLACE(code_occ,'''','''''')||''' AS occ,
				'''||typ_res||''',
				epci.code_siren,
				s1_2b.nom_epci,
				''indéterminé''::varchar(200),
				s1_2b.pop6_rdc_in_fort_tresfort,
				s1_2b.pop6_rdc_in_fai_moyen,
				s1_2b.pop6_rdc_out_zq,
				1,
				s1_2b.date_calc,
				epci.geom
			FROM s1_2b_epci AS s1_2b
			RIGHT JOIN epci_temp AS epci
			ON s1_2b.id_epci = epci.code_siren
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

		EXECUTE 'DROP TABLE IF EXISTS s1_2b_ter CASCADE;
			CREATE TEMP TABLE s1_2b_ter AS
			SELECT
				s1_2b.territoire,
				niv_zoom.type_result,
				s1_2b.date_calc,
				s1_2b.moda_calc,
				CASE
					WHEN CEIL(COALESCE(SUM(s1_2b.pop6_rdc) FILTER (WHERE s1_2b.loc_zq = ''In fort'' or s1_2b.loc_zq = ''In très fort''),0)) > 0
					AND CEIL(COALESCE(SUM(s1_2b.pop6_rdc) FILTER (WHERE s1_2b.loc_zq = ''In fort'' or s1_2b.loc_zq = ''In très fort''),0)) < 10 THEN 10
					ELSE CEIL(COALESCE(SUM(s1_2b.pop6_rdc) FILTER (WHERE s1_2b.loc_zq = ''In fort'' or s1_2b.loc_zq = ''In très fort''),0))
				END AS pop6_rdc_in_fort_tresfort,
				CASE
					WHEN CEIL(COALESCE(SUM(s1_2b.pop6_rdc) FILTER (WHERE s1_2b.loc_zq = ''In faible'' or s1_2b.loc_zq = ''In moyen''),0)) > 0
					AND CEIL(COALESCE(SUM(s1_2b.pop6_rdc) FILTER (WHERE s1_2b.loc_zq = ''In faible'' or s1_2b.loc_zq = ''In moyen''),0)) < 10 THEN 10
					ELSE CEIL(COALESCE(SUM(s1_2b.pop6_rdc) FILTER (WHERE s1_2b.loc_zq = ''In faible'' or s1_2b.loc_zq = ''In moyen''),0))
				END AS pop6_rdc_in_fai_moyen,
				CASE
					WHEN CEIL(COALESCE(SUM(s1_2b.pop6_rdc) FILTER (WHERE s1_2b.loc_zq = ''Out''),0)) > 0
					AND CEIL(COALESCE(SUM(s1_2b.pop6_rdc) FILTER (WHERE s1_2b.loc_zq = ''Out''),0)) < 10 THEN 10
					ELSE CEIL(COALESCE(SUM(s1_2b.pop6_rdc) FILTER (WHERE s1_2b.loc_zq = ''Out''),0))
				END AS pop6_rdc_out_zq
			FROM s1_2b
			JOIN niv_zoom
			ON right(s1_2b.moda_calc,5) = niv_zoom.code_indic
			WHERE __util_to_snake_case(s1_2b.territoire) = ''' ||__util_to_snake_case(nom_ter)|| '''
				AND __util_to_snake_case(s1_2b.type_alea) = '''||__util_to_snake_case(typ_alea)||'''
				AND __util_to_snake_case(s1_2b.code_occurrence) = '''||__util_to_snake_case(code_occ)||'''
				AND niv_zoom.niv_zoom = 8
			GROUP BY s1_2b.territoire, s1_2b.type_alea, s1_2b.code_occurrence, niv_zoom.type_result, s1_2b.date_calc, s1_2b.moda_calc
			';

		EXECUTE 'CREATE INDEX ON s1_2b_ter USING btree(territoire)';
	
		-- Il est IMPÉRATIF d'enregistrer la valeur du champ type_result dans une variable déclarée "typ_res" car l'appel au champ s1_2b_ter.type_result dans l'INSERT INTO ci-dessous fait sauter les EPCI non concernés par des parcelles s1_2b. Ce dysfonctionnement ressemble fortement à un bug PostgreSQL.
		-- Lucie a absolument TOUT tenté pour éviter de passer par cette variable déclarée sans succès. Cette méthode ajoute simplement deux lignes à l'ensemble du code, mais à creuser plus tard éventuellement.
		typ_res := (SELECT DISTINCT type_result FROM s1_2b_ter);

		EXECUTE 'INSERT INTO s1_2b_rc (
				territoire,
				type_alea,
				code_occurrence,
				type_result,
				id_geom,
				nom_id_geom,
				loc_zq,
				pop6_rdc_in_fort_tresfort,
				pop6_rdc_in_fai_moyen,
				pop6_rdc_out_zq,
				valid_result,
				date_calc,
				geom
			)
			SELECT DISTINCT
				'''||REPLACE(nom_ter,'''','''''')||''' AS ter,
				'''||REPLACE(typ_alea,'''','''''')||''' AS alea,
				'''||REPLACE(code_occ,'''','''''')||''' AS occ,
				'''||typ_res||''',
				ter.id,
				'''||REPLACE(nom_ter,'''','''''')||''',
				''indéterminé''::varchar(200),
				s1_2b.pop6_rdc_in_fort_tresfort,
				s1_2b.pop6_rdc_in_fai_moyen,
				s1_2b.pop6_rdc_out_zq,
				0,
				s1_2b.date_calc,
				ter.geom
			FROM s1_2b_ter AS s1_2b
			RIGHT JOIN ter_temp AS ter
			ON __util_to_snake_case(s1_2b.territoire) = __util_to_snake_case(ter.territoire)
			WHERE __util_to_snake_case(ter.territoire) = ''' ||__util_to_snake_case(nom_ter)|| '''
			';

	END IF;

	-- Récupération du nombre d'entités ajoutées
	GET DIAGNOSTICS c_epci = row_count; -- nombre d'EPCI insérés dans la table

	--************************************************************************
	-- Création d'une vue matérialisée sur le territoire
	--************************************************************************
	RAISE NOTICE '';
	RAISE NOTICE 'Création de la vue matérialisée %', 'p_rep_carto.s1_2b_rc_'||__util_to_snake_case(nom_ter);
	EXECUTE '
		DROP MATERIALIZED VIEW IF EXISTS s1_2b_rc_' || __util_to_snake_case(nom_ter) || ' CASCADE;
		CREATE MATERIALIZED VIEW s1_2b_rc_' || __util_to_snake_case(nom_ter) || ' AS
		SELECT *
		FROM s1_2b_rc
		WHERE __util_to_snake_case(territoire) = '''||__util_to_snake_case(nom_ter)||'''';

	-- Création des index sur la vue matérialisée
	RAISE NOTICE 'Création des index sur la vue matérialisée';

	EXECUTE 'CREATE UNIQUE INDEX ON s1_2b_rc_' || __util_to_snake_case(nom_ter) || ' (id)';

	EXECUTE 'CREATE INDEX ON s1_2b_rc_' || __util_to_snake_case(nom_ter) || ' USING gist(geom)';
	EXECUTE 'CREATE INDEX ON s1_2b_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(id)';
	EXECUTE 'CREATE INDEX ON s1_2b_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(territoire)';
	EXECUTE 'CREATE INDEX ON s1_2b_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(type_alea)';
	EXECUTE 'CREATE INDEX ON s1_2b_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(code_occurrence)';
	EXECUTE 'CREATE INDEX ON s1_2b_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(type_result)';
	EXECUTE 'CREATE INDEX ON s1_2b_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(id_geom)';
	EXECUTE 'CREATE INDEX ON s1_2b_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(nom_id_geom)';
	EXECUTE 'CREATE INDEX ON s1_2b_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(loc_zq)';
	EXECUTE 'CREATE INDEX ON s1_2b_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(pop6_rdc_in_fort_tresfort)';
	EXECUTE 'CREATE INDEX ON s1_2b_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(pop6_rdc_in_fai_moyen)';
	EXECUTE 'CREATE INDEX ON s1_2b_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(pop6_rdc_out_zq)';
	EXECUTE 'CREATE INDEX ON s1_2b_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(pct_rdc_in_fort_tresfort)';
	EXECUTE 'CREATE INDEX ON s1_2b_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(pct_rdc_in_fai_moyen)';
	EXECUTE 'CREATE INDEX ON s1_2b_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(pct_rdc_out_zq)';
	EXECUTE 'CREATE INDEX ON s1_2b_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(total_rdc)';
	EXECUTE 'CREATE INDEX ON s1_2b_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(valid_result)';
	EXECUTE 'CREATE INDEX ON s1_2b_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(date_calc)';
	RAISE NOTICE 'Index créés sur la vue matérialisée';

	--************************************************************************
	-- Conclusion
	--************************************************************************
	RAISE NOTICE '';
	RAISE NOTICE '====== FIN TRAITEMENT ======';
	RAISE NOTICE '[INFO] La table s1_2b_rc (représentation carto de l''indicateur sous forme d''hexagones + autres géométries administratives) a été mise à jour dans le schéma p_rep_carto pour le territoire "%" et l''aléa "% - %"', nom_ter, typ_alea, code_occ;
	RAISE NOTICE '';
	RAISE NOTICE '====== RÉSULTATS ======';

	IF c_hexag+c_entite+c_iris+c_com+c_epci > 1
		THEN RAISE NOTICE '% enregistrements insérés au total dans la table p_rep_carto.s1_2b_rc pour le territoire "%" et l''aléa "% - %"', c_hexag+c_entite+c_iris+c_com+c_epci, nom_ter, typ_alea, code_occ;
		ELSE RAISE NOTICE '% enregistrement inséré dans la table p_rep_carto.s1_2b_rc pour le territoire "%" et l''aléa "% - %"', c_hexag+c_entite+c_iris+c_com+c_epci, nom_ter, typ_alea, code_occ;
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
