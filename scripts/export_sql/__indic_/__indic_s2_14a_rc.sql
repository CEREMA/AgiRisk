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

CREATE OR REPLACE FUNCTION public.__indic_s2_14a_rc(nom_ter text, typ_alea text, code_occ text, an_bdtopo text)
 RETURNS void
 LANGUAGE plpgsql
AS $function$

-- Fonction SQL de représentation cartographique de l'indicateur S2/14a "Zones AU en zone inondable"
-- © Cerema / GT AgiRisk (auteurs du script : Anaïs (idée originale pour le croisement avec les hexagones), Lucie (optimisation du croisement avec les hexagones et avec les entités administratives), Sébastien (trame de départ))
-- Dernières mises à jour du script le 18/04/2023 par Lucie et le 25/08/2023 par Sébastien

-- Paramètres d'entrée :
-- nom_ter = nom du territoire d'étude tel que renseigné dans le champ `territoire` de la table c_general.territoires
-- typ_alea : type d'aléa considéré (ex : débordement de cours d'eau, submersion marine)
-- code_occ : période de retour considérée pour le type d'aléa choisi (ex : QRef, Q100, Q10)
-- an_bdtopo = millésime (année au format AAAA) de la BD TOPO®

-- Exemple d'appel à cette fonction :
-- SELECT public.__indic_s2_14a_rc('Jura', 'débordement de cours d''eau', 'QRef', '2022');

DECLARE
	c_parcelle integer; -- un compteur des lignes modifiées pour logging
	c_iris integer; -- un compteur des lignes modifiées pour logging
	c_com integer; -- un compteur des lignes modifiées pour logging
	c_epci integer; -- un compteur des lignes modifiées pour logging
	heure1 varchar; -- heure de début du traitement
	heure2 varchar; -- heure de fin du traitement
	typ_res varchar; -- variable qui prend la valeur du type_result à insérer dans s2_14a_rc

BEGIN
	heure1 = clock_timestamp();
	
	--************************************************************************
	-- Définition des schémas de travail
	--************************************************************************
	SET search_path TO p_rep_carto, p_indicateurs, c_phenomenes, r_ressources, c_general, r_ign_bdtopo, r_rep_carto, public;

	RAISE NOTICE '';
	RAISE NOTICE '====== RAPPORT ======';
	RAISE NOTICE 'Génération des représentations cartographiques pour l''indicateur S2/14a (Zones AU en zone inondable)';
	RAISE NOTICE 'Début du traitement : %', heure1;
	RAISE NOTICE '';

	--************************************************************************
	-- Vérification de l'existence d'une table s2_14a dans le schéma p_indicateurs
	--************************************************************************
	IF NOT EXISTS (
		SELECT *
		FROM s2_14a
		WHERE territoire = ''||nom_ter||''
	   		AND type_alea = ''||typ_alea||''
	   		AND code_occurrence = ''||code_occ||''
	)
	THEN
		RAISE EXCEPTION 'L''indicateur s2_14a n''a pas encore été calculé sur le territoire "%" avec l''aléa "% - %". Fin de l''exécution', nom_ter, typ_alea, code_occ;
	END IF;
	
	--************************************************************************
	-- Vérification de l'absence de données pour le territoire, le type d'aléa et l'occurrence de crue renseignés dans la table s2_14a_rc
	--************************************************************************
	IF EXISTS (
		SELECT *
		FROM s2_14a_rc
		WHERE territoire = ''||nom_ter||''
	   	AND type_alea = ''||typ_alea||''
	   	AND code_occurrence = ''||code_occ||''
	)
	THEN
		RAISE EXCEPTION 'Il existe déjà des enregistrements pour le territoire "%" avec l''aléa "% - %" dans la table p_rep_carto.s2_14a_rc. 
		Pour les supprimer, lancer la requête suivante : 
		DELETE FROM p_rep_carto.s2_14a_rc WHERE territoire = ''%'' AND type_alea = ''%'' AND code_occurrence = ''%'';', nom_ter, typ_alea, code_occ, REPLACE(nom_ter,'''',''''''), REPLACE(typ_alea,'''',''''''), REPLACE(code_occ,'''','''''');
	END IF;

   --************************************************************************
	-- Insertion des parcelles et des hexagones (hexagones = parcelles pour cet indicateur)
	--************************************************************************
   
   	-- Possibilité de faire tourner l'ensemble de ces "type_result" dans une boucle car les requêtes sont exactement les mêmes

	RAISE NOTICE 'Insertion des parcelles';

	--FOR i IN 0..5
	
	--LOOP
	
		EXECUTE 'INSERT INTO s2_14a_rc(
					territoire, 
					type_alea, 
					code_occurrence, 
					type_result,
					id_geom,
					nom_id_geom, 
					loc_zx, 
					surf_au_in, 
					surf_au_out, 
					valid_result,
					date_calc, 
					geom)
				SELECT
					s2_14a.territoire,
					s2_14a.type_alea,
					s2_14a.code_occurrence,
					niv_zoom.type_result,
					zt.id_iris AS id_geom,
					s2_14a.nom_iris,
					s2_14a.loc_zx,
					COALESCE(SUM(s2_14a.surf_au) FILTER (WHERE s2_14a.loc_zx = ''In''),0),
					COALESCE(SUM(s2_14a.surf_au) FILTER (WHERE s2_14a.loc_zx = ''Out''),0),
					1 AS valid_result,
					s2_14a.date_calc AS date_calc,
					ST_Multi(ST_CollectionExtract(ST_ForceCollection(ST_MakeValid(ST_Union(s2_14a.geom))),3))
				FROM s2_14a
				JOIN niv_zoom
				ON right(s2_14a.moda_calc,6) = niv_zoom.code_indic
				RIGHT JOIN zt
				ON s2_14a.id_iris = zt.id_iris
				WHERE __util_to_snake_case(zt.territoire) = ''' ||__util_to_snake_case(nom_ter) || '''
					AND __util_to_snake_case(s2_14a.territoire) = ''' ||__util_to_snake_case(nom_ter) || '''
					AND __util_to_snake_case(s2_14a.type_alea) = ''' ||__util_to_snake_case(typ_alea) || '''
	 				AND __util_to_snake_case(s2_14a.code_occurrence) = ''' ||__util_to_snake_case(code_occ) || '''
					AND niv_zoom.niv_zoom = 0
				GROUP BY s2_14a.territoire, s2_14a.type_alea, s2_14a.code_occurrence, niv_zoom.type_result, id_geom, s2_14a.nom_iris, s2_14a.loc_zx, s2_14a.date_calc';
			
	--END LOOP;

	-- Récupération du nombre d'entités ajoutées
	EXECUTE '
		SELECT count(*)
		FROM s2_14a_rc
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
		SELECT DISTINCT *
		FROM zt
		WHERE __util_to_snake_case(territoire) = ''' ||__util_to_snake_case(nom_ter) || '''
	';
	
	EXECUTE 'CREATE INDEX ON zt_temp USING btree(id_iris)';

	EXECUTE 'DROP TABLE IF EXISTS s2_14a_iris CASCADE;
		CREATE TEMP TABLE s2_14a_iris AS
		SELECT DISTINCT
			niv_zoom.type_result,
			s2_14a.id_iris,
			s2_14a.nom_iris,
			s2_14a.date_calc,
			s2_14a.moda_calc,
			ROUND(COALESCE(SUM(s2_14a.surf_au) FILTER (WHERE s2_14a.loc_zx = ''In''),0)::numeric,2) as surf_au_in,
			ROUND(COALESCE(SUM(s2_14a.surf_au) FILTER (WHERE s2_14a.loc_zx = ''Out''),0)::numeric,2) as surf_au_out
		FROM s2_14a
		JOIN niv_zoom
		ON right(s2_14a.moda_calc,6) = niv_zoom.code_indic
		WHERE __util_to_snake_case(s2_14a.territoire) = ''' ||__util_to_snake_case(nom_ter) || '''
			AND __util_to_snake_case(s2_14a.type_alea) = '''||__util_to_snake_case(typ_alea) ||'''
			AND __util_to_snake_case(s2_14a.code_occurrence) = '''||__util_to_snake_case(code_occ) ||'''
			AND niv_zoom.niv_zoom = 6
		GROUP BY s2_14a.territoire, s2_14a.type_alea, s2_14a.code_occurrence, niv_zoom.type_result, s2_14a.id_iris, s2_14a.nom_iris, s2_14a.date_calc, s2_14a.moda_calc
	';
	
	EXECUTE 'CREATE INDEX ON s2_14a_iris USING btree(id_iris)';

	-- Il est IMPÉRATIF d'enregistrer la valeur du champ type_result dans une variable déclarée "typ_res" car l'appel au champ s2_14a_iris.type_result dans l'INSERT INTO ci-dessous fait sauter les IRIS non concernés par des parcelles s2_14a. Ce dysfonctionnement ressemble fortement à un bug PostgreSQL.
	-- Lucie a absolument TOUT tenté pour éviter de passer par cette variable déclarée sans succès. Cette méthode ajoute simplement deux lignes à l'ensemble du code, mais à creuser plus tard éventuellement.
	typ_res := (SELECT DISTINCT type_result FROM s2_14a_iris);
	
	EXECUTE 'INSERT INTO s2_14a_rc(territoire, type_alea, code_occurrence, type_result, id_geom, nom_id_geom, loc_zx, surf_au_in, surf_au_out, valid_result, date_calc, geom)
		SELECT DISTINCT
			'''||REPLACE(nom_ter,'''','''''')||''' as ter,
			'''||REPLACE(typ_alea,'''','''''')||''' as alea,
			'''||REPLACE(code_occ,'''','''''')||''' as occ,
			'''||typ_res||''',
			zt.id_iris AS id_geom,
			s2_14a.nom_iris,
			''indéterminé''::varchar(30) as loc_zx,
			s2_14a.surf_au_in,
			s2_14a.surf_au_out,
			1 AS valid_result,
			s2_14a.date_calc AS date_calc,
			zt.geom
		FROM s2_14a_iris as s2_14a
		RIGHT JOIN zt_temp as zt
		ON s2_14a.id_iris = zt.id_iris
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
	
	EXECUTE 'DROP TABLE IF EXISTS s2_14a_com CASCADE;
		CREATE TEMP TABLE s2_14a_com AS
		SELECT DISTINCT
			niv_zoom.type_result,
			s2_14a.id_commune,
			s2_14a.nom_commune,
			s2_14a.date_calc,
			s2_14a.moda_calc,
			ROUND(COALESCE(SUM(s2_14a.surf_au) FILTER (WHERE s2_14a.loc_zx = ''In''),0)::numeric,2) as surf_au_in,
			ROUND(COALESCE(SUM(s2_14a.surf_au) FILTER (WHERE s2_14a.loc_zx = ''Out''),0)::numeric,2) as surf_au_out
		FROM s2_14a
		JOIN niv_zoom
		ON right(s2_14a.moda_calc,6) = niv_zoom.code_indic
		WHERE __util_to_snake_case(s2_14a.territoire) = '''||__util_to_snake_case(nom_ter) || '''
			AND __util_to_snake_case(s2_14a.type_alea) = '''||__util_to_snake_case(typ_alea) ||'''
			AND __util_to_snake_case(s2_14a.code_occurrence) = '''||__util_to_snake_case(code_occ) ||'''
			AND niv_zoom.niv_zoom = 7
		GROUP BY s2_14a.territoire, s2_14a.type_alea, s2_14a.code_occurrence, niv_zoom.type_result, s2_14a.id_commune, s2_14a.nom_commune, s2_14a.date_calc, s2_14a.moda_calc
	';
	
	EXECUTE 'CREATE INDEX ON s2_14a_com USING btree(id_commune)';

	-- Il est IMPÉRATIF d'enregistrer la valeur du champ type_result dans une variable déclarée "typ_res" car l'appel au champ s2_14a_com.type_result dans l'INSERT INTO ci-dessous fait sauter les communes non concernées par des parcelles s2_14a. Ce dysfonctionnement ressemble fortement à un bug PostgreSQL.
	-- Lucie a absolument TOUT tenté pour éviter de passer par cette variable déclarée sans succès. Cette méthode ajoute simplement deux lignes à l'ensemble du code, mais à creuser plus tard éventuellement.
	typ_res := (SELECT DISTINCT type_result FROM s2_14a_com);

	EXECUTE 'INSERT INTO s2_14a_rc(territoire, type_alea, code_occurrence, type_result, id_geom, nom_id_geom, loc_zx, surf_au_in, surf_au_out, valid_result, date_calc, geom)
		SELECT DISTINCT
			'''||REPLACE(nom_ter,'''','''''')||''' as ter,
			'''||REPLACE(typ_alea,'''','''''')||''' as alea,
			'''||REPLACE(code_occ,'''','''''')||''' as occ,
			'''||typ_res||''',
			com.insee_com AS id_geom,
			s2_14a.nom_commune,
			''indéterminé''::varchar(30) as loc_zx,
			s2_14a.surf_au_in,
			s2_14a.surf_au_out,
			1 AS valid_result,
			s2_14a.date_calc AS date_calc,
			com.geom
		FROM s2_14a_com as s2_14a
		RIGHT JOIN com_temp AS com
		ON s2_14a.id_commune = com.insee_com
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
	
		EXECUTE 'DROP TABLE IF EXISTS s2_14a_epci CASCADE;
		CREATE TEMP TABLE s2_14a_epci AS
		SELECT DISTINCT
			niv_zoom.type_result,
			s2_14a.id_epci,
			s2_14a.nom_epci,
			s2_14a.date_calc,
			s2_14a.moda_calc,
			ROUND(COALESCE(SUM(s2_14a.surf_au) FILTER (WHERE s2_14a.loc_zx = ''In''),0)::numeric,2) as surf_au_in,
			ROUND(COALESCE(SUM(s2_14a.surf_au) FILTER (WHERE s2_14a.loc_zx = ''Out''),0)::numeric,2) as surf_au_out
		FROM s2_14a
		JOIN niv_zoom
		ON right(s2_14a.moda_calc,6) = niv_zoom.code_indic
		WHERE __util_to_snake_case(s2_14a.territoire) = ''' ||__util_to_snake_case(nom_ter) || '''
			AND __util_to_snake_case(s2_14a.type_alea) = '''||__util_to_snake_case(typ_alea) ||'''
			AND __util_to_snake_case(s2_14a.code_occurrence) = '''||__util_to_snake_case(code_occ) ||'''
			AND niv_zoom.niv_zoom = 8
		GROUP BY s2_14a.territoire, s2_14a.type_alea, s2_14a.code_occurrence, niv_zoom.type_result, s2_14a.id_epci, s2_14a.nom_epci, s2_14a.date_calc, s2_14a.moda_calc
		';
			
		EXECUTE 'CREATE INDEX ON s2_14a_epci USING btree(id_epci)';
	
		-- Il est IMPÉRATIF d'enregistrer la valeur du champ type_result dans une variable déclarée "typ_res" car l'appel au champ s2_14a_epci.type_result dans l'INSERT INTO ci-dessous fait sauter les EPCI non concernés par des parcelles s2_14a. Ce dysfonctionnement ressemble fortement à un bug PostgreSQL.
		-- Lucie a absolument TOUT tenté pour éviter de passer par cette variable déclarée sans succès. Cette méthode ajoute simplement deux lignes à l'ensemble du code, mais à creuser plus tard éventuellement.
		typ_res := (SELECT DISTINCT type_result FROM s2_14a_epci);
	
		EXECUTE 'INSERT INTO s2_14a_rc(territoire, type_alea, code_occurrence, type_result, id_geom, nom_id_geom, loc_zx, surf_au_in, surf_au_out, valid_result, date_calc, geom)
				SELECT DISTINCT
					'''||REPLACE(nom_ter,'''','''''')||''' as ter,
					'''||REPLACE(typ_alea,'''','''''')||''' as alea,
					'''||REPLACE(code_occ,'''','''''')||''' as occ,
					'''||typ_res||''',
					epci.code_siren AS id_geom,
					s2_14a.nom_epci,
					''indéterminé''::varchar(30) as loc_zx,
					s2_14a.surf_au_in,
					s2_14a.surf_au_out,
					1 AS valid_result,
					s2_14a.date_calc AS date_calc,
					epci.geom
				FROM s2_14a_epci as s2_14a
				RIGHT JOIN epci_temp AS epci
				ON s2_14a.id_epci = epci.code_siren
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
	
		EXECUTE 'DROP TABLE IF EXISTS s2_14a_ter CASCADE;
		CREATE TEMP TABLE s2_14a_ter AS
		SELECT DISTINCT
			s2_14a.territoire,
			niv_zoom.type_result,
			s2_14a.date_calc,
			s2_14a.moda_calc,
			ROUND(COALESCE(SUM(s2_14a.surf_au) FILTER (WHERE s2_14a.loc_zx = ''In''),0)::numeric,2) as surf_au_in,
			ROUND(COALESCE(SUM(s2_14a.surf_au) FILTER (WHERE s2_14a.loc_zx = ''Out''),0)::numeric,2) as surf_au_out
		FROM s2_14a
		JOIN niv_zoom
		ON right(s2_14a.moda_calc,6) = niv_zoom.code_indic
		WHERE __util_to_snake_case(s2_14a.territoire) = ''' ||__util_to_snake_case(nom_ter) || '''
			AND __util_to_snake_case(s2_14a.type_alea) = '''||__util_to_snake_case(typ_alea) ||'''
			AND __util_to_snake_case(s2_14a.code_occurrence) = '''||__util_to_snake_case(code_occ) ||'''
			AND niv_zoom.niv_zoom = 8
		GROUP BY s2_14a.territoire, s2_14a.type_alea, s2_14a.code_occurrence, niv_zoom.type_result, s2_14a.date_calc, s2_14a.moda_calc
		';
			
		EXECUTE 'CREATE INDEX ON s2_14a_ter USING btree(territoire)';
	
		-- Il est IMPÉRATIF d'enregistrer la valeur du champ type_result dans une variable déclarée "typ_res" car l'appel au champ s2_14a_ter.type_result dans l'INSERT INTO ci-dessous fait sauter les EPCI non concernés par des parcelles s2_14a. Ce dysfonctionnement ressemble fortement à un bug PostgreSQL.
		-- Lucie a absolument TOUT tenté pour éviter de passer par cette variable déclarée sans succès. Cette méthode ajoute simplement deux lignes à l'ensemble du code, mais à creuser plus tard éventuellement.
		typ_res := (SELECT DISTINCT type_result FROM s2_14a_ter);
	
		EXECUTE 'INSERT INTO s2_14a_rc(territoire, type_alea, code_occurrence, type_result, id_geom, nom_id_geom, loc_zx, surf_au_in, surf_au_out, valid_result, date_calc, geom)
				SELECT DISTINCT
					'''||REPLACE(nom_ter,'''','''''')||''' as ter,
					'''||REPLACE(typ_alea,'''','''''')||''' as alea,
					'''||REPLACE(code_occ,'''','''''')||''' as occ,
					'''||typ_res||''',
					ter.id AS id_geom,
					'''||REPLACE(nom_ter,'''','''''')||''',
					''indéterminé''::varchar(30) as loc_zx,
					s2_14a.surf_au_in,
					s2_14a.surf_au_out,
					0 AS valid_result,
					s2_14a.date_calc AS date_calc,
					ter.geom
				FROM s2_14a_ter as s2_14a
				RIGHT JOIN ter_temp AS ter
				ON __util_to_snake_case(s2_14a.territoire) = __util_to_snake_case(ter.territoire)
				WHERE __util_to_snake_case(ter.territoire) = ''' ||__util_to_snake_case(nom_ter) || '''
				';
			
	END IF;

	-- Récupération du nombre d'entités ajoutées
	GET DIAGNOSTICS c_epci = row_count; -- nombre d'EPCI insérés dans la table

	--************************************************************************
	-- Création d'une vue matérialisée sur le territoire
	--************************************************************************
	EXECUTE '
		DROP MATERIALIZED VIEW IF EXISTS s2_14a_rc_' || __util_to_snake_case(nom_ter) || ' CASCADE;
		CREATE MATERIALIZED VIEW s2_14a_rc_' || __util_to_snake_case(nom_ter) || ' AS
		SELECT *
		FROM s2_14a_rc
		WHERE __util_to_snake_case(territoire) = ''' ||__util_to_snake_case(nom_ter) || '''
		';

	-- Création des index sur la vue matérialisée
	RAISE NOTICE 'Création des index sur la vue matérialisée';

	EXECUTE 'CREATE UNIQUE INDEX ON s2_14a_rc_' || __util_to_snake_case(nom_ter) || ' (id)';

	EXECUTE 'CREATE INDEX ON s2_14a_rc_' || __util_to_snake_case(nom_ter) || ' USING gist(geom)';
	EXECUTE 'CREATE INDEX ON s2_14a_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(id)';
	EXECUTE 'CREATE INDEX ON s2_14a_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(territoire)';
	EXECUTE 'CREATE INDEX ON s2_14a_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(type_alea)';
	EXECUTE 'CREATE INDEX ON s2_14a_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(code_occurrence)';
	EXECUTE 'CREATE INDEX ON s2_14a_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(type_result)';
	EXECUTE 'CREATE INDEX ON s2_14a_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(id_geom)';
	EXECUTE 'CREATE INDEX ON s2_14a_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(nom_id_geom)';
	EXECUTE 'CREATE INDEX ON s2_14a_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(loc_zx)';
	EXECUTE 'CREATE INDEX ON s2_14a_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(surf_au_in)';
	EXECUTE 'CREATE INDEX ON s2_14a_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(surf_au_out)';
	EXECUTE 'CREATE INDEX ON s2_14a_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(pct_surf_au_in)';
	EXECUTE 'CREATE INDEX ON s2_14a_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(pct_surf_au_out)';
	EXECUTE 'CREATE INDEX ON s2_14a_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(total_surf_au)';
	EXECUTE 'CREATE INDEX ON s2_14a_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(valid_result)';
	EXECUTE 'CREATE INDEX ON s2_14a_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(date_calc)';
	RAISE NOTICE 'Index créés sur la vue matérialisée';

	--************************************************************************
	-- Conclusion
	--************************************************************************
	RAISE NOTICE '';
	RAISE NOTICE '====== FIN TRAITEMENT ======';
	RAISE NOTICE '[INFO] La table s2_14a_rc (représentation carto de l''indicateur sous forme d''hexagones + autres géométries administratives) a été mise à jour dans le schéma p_rep_carto pour le territoire "%" et l''aléa "% - %"', nom_ter, typ_alea, code_occ;
	RAISE NOTICE '';
	RAISE NOTICE '====== RÉSULTATS ======';

	IF c_parcelle+c_iris+c_com+c_epci > 1
		THEN RAISE NOTICE '% enregistrements insérés au total dans la table p_rep_carto.s2_14a_rc pour le territoire "%" et l''aléa "% - %"', c_parcelle+c_iris+c_com+c_epci, nom_ter, typ_alea, code_occ;
		ELSE RAISE NOTICE '% enregistrement inséré dans la table p_rep_carto.s2_14a_rc pour le territoire "%" et l''aléa "% - %"', c_parcelle+c_iris+c_com+c_epci, nom_ter, typ_alea, code_occ;
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
	RAISE NOTICE 'Création de la vue "%"', 'p_rep_carto.s2_14a_rc_'||__util_to_snake_case(nom_ter);
	heure2 = clock_timestamp();
	RAISE NOTICE 'Fin du traitement : %', heure2;
	RAISE NOTICE 'Durée du traitement : %', CAST(heure2 as time)-CAST(heure1 as time);
	RAISE NOTICE '';

END;
$function$
