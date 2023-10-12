CREATE OR REPLACE FUNCTION public.__indic_s2_2a_rc(nom_ter text, typ_alea text, code_occ text, an_bdtopo text, l_hexa character varying[])
 RETURNS void
 LANGUAGE plpgsql
AS $function$

-- Fonction SQL de représentation cartographique de l'indicateur S2/2a "Montant des dommages aux logements en fonction de la hauteur d'eau et de la durée de submersion"
-- Copyright Cerema / GT AgiRisk
-- Auteur principal du script, inspiré de celui retravaillé par Lucie sur S3/1a : Sébastien

-- Paramètres d'entrée :
-- nom_ter = nom du territoire d'étude tel que renseigné dans le champ `territoire` de la table c_general.territoires
-- typ_alea : type d'aléa considéré (ex : débordement de cours d'eau, submersion marine)
-- code_occ : période de retour considérée pour le type d'aléa choisi (ex : QRef, Q100, Q10)
-- an_bdtopo = millésime (année au format AAAA) de la BD TOPO®

-- Exemple d'appel à cette fonction : SELECT public.__indic_s2_2a_rc('TRI Verdun', 'débordement de cours d''''eau', 'QRef', '2022', ARRAY['1','5','10','50','100']);

DECLARE
    c integer; -- un compteur des lignes modifiées pour logging
	heure1 varchar; -- heure de début du traitement
	heure2 varchar; -- heure de fin du traitement
	valzoom integer; -- variable qui prend la valeur du niveau de zoom issue de la table r_ressources.niv_zoom
	valresult varchar; -- variable qui prend la valeur du code indicateur issu de la table r_ressources.niv_zoom
	nindexs2_2a_rc varchar; -- liste des index s2_2a_rc
	att varchar; -- liste des attributs de la couche s2_2a_rc	
	typ varchar; -- liste des TYPES d'attributs de la couche s2_2a_rc

BEGIN
	heure1 = clock_timestamp();
	
	--************************************************************************
	-- Définition des schémas de travail
	--************************************************************************
    SET search_path TO p_rep_carto, p_indicateurs, c_general, c_phenomenes, r_ign_bdtopo, r_rep_carto, public;

    RAISE NOTICE '';
    RAISE NOTICE '====== RAPPORT ======';
    RAISE NOTICE 'Génération des représentations cartographiques pour l''indicateur S2/2a (montant des dommages aux logements)';
    RAISE NOTICE 'Début du traitement : %', heure1;
/*
    --************************************************************************
    -- Vérification de l'existence d'une table s2_2a dans le schéma p_indicateurs
    --************************************************************************
    IF NOT EXISTS(
        SELECT *
        FROM s2_2a
        WHERE territoire = nom_ter
       	AND type_alea = typ_alea
       	AND code_occurrence = code_occ
    )
    THEN
        RAISE EXCEPTION 'L''indicateur S2/2a n''a pas encore été calculé. Fin de l''exécution';
    END IF;
*/
	--************************************************************************
    -- Vérification de l'existence des données dans la table s2_2a_rc
    --************************************************************************
    IF EXISTS(
        SELECT *
        FROM s2_2a_rc
		WHERE territoire = nom_ter
       	AND type_alea = typ_alea
       	AND code_occurrence = code_occ
    )
    THEN
        RAISE EXCEPTION 'Il existe déjà des enregistrements pour le territoire ''%'' et l''aléa renseigné dans la table p_rep_carto.s2_2a_rc. Pour les supprimer, lancer la requête suivante : DELETE FROM p_rep_carto.s2_2a_rc WHERE territoire = ''%'' AND type_alea = ''%'' AND code_occurrence = ''%'';', nom_ter, nom_ter, typ_alea, code_occ;
    END IF;

    --************************************************************************
    -- Insertion des données hexag_xxxha
    --************************************************************************
	RAISE NOTICE 'Insertion des données hexag_xxxha';
	
	FOR valzoom, valresult IN SELECT DISTINCT niv_zoom, lower(type_result) FROM niv_zoom WHERE type_result LIKE 'Hexag%'
	
	LOOP
	
		EXECUTE 'INSERT INTO s2_2a_rc(territoire, type_alea, code_occurrence, type_result, id_geom, nom_id_geom, loc_zq, pop6_pp_in_fort_tresfort, pop6_pp_in_fai_moyen, pop6_pp_out_zq, valid_result, date_calcul, geom)
		SELECT DISTINCT
			s2_2a.territoire,
			s2_2a.type_alea,
			s2_2a.code_occurrence,
			initcap('''||valresult||''')::varchar(200) AS type_result,
			hexag.grid_id::varchar(200) AS id_geom,
			''indéterminé''::varchar(200) AS nom_id_geom,
			''indéterminé''::varchar(200) AS loc_zq,
			ceil(COALESCE(SUM(s2_2a.pop6_pp) FILTER (WHERE s2_2a.loc_zq = ''In fort'' or s2_2a.loc_zq = ''In très fort''),0)),
			ceil(COALESCE(SUM(s2_2a.pop6_pp) FILTER (WHERE s2_2a.loc_zq = ''In faible'' or s2_2a.loc_zq = ''In moyen''),0)),
			ceil(COALESCE(SUM(s2_2a.pop6_pp) FILTER (WHERE s2_2a.loc_zq = ''Out''),0)),
			1 AS valid_result,
			s2_2a.date_calcul AS date_calcul,
			hexag.geom
		FROM s2_2a
		JOIN niv_zoom
		ON right(s2_2a.modalite_calcul,5) = niv_zoom.code_indic
		RIGHT JOIN '||valresult||' AS hexag
		ON ST_Intersects(s2_2a.geomloc, hexag.geom)
		WHERE s2_2a.territoire = ''' || nom_ter || '''
			AND s2_2a.type_alea = ''' || typ_alea || '''
			AND s2_2a.code_occurrence = ''' || code_occ || '''
			AND niv_zoom.niv_zoom = '||valzoom||'
		GROUP BY s2_2a.territoire, s2_2a.type_alea, s2_2a.code_occurrence, type_result, id_geom, nom_id_geom, s2_2a.date_calcul, hexag.geom
		';
	
	END LOOP;

	--************************************************************************
	-- Insertion des bâtiments "bruts" agglomérés à l'IRIS
    --************************************************************************
	RAISE NOTICE 'Insertion des bâtiments "bruts" agglomérés à l''IRIS';
	
	EXECUTE 'INSERT INTO s2_2a_rc(territoire, type_alea, code_occurrence, type_result, id_geom, nom_id_geom, loc_zx, typo_acb, cout_min_dmg_tot, cout_max_dmg_tot, date_actu_cout_dmg, date_calcul, geom)
			SELECT
				s2_2a.territoire,
				s2_2a.type_alea,
				s2_2a.code_occurrence,
				''Entite'' AS type_result,
				zt.id_iris AS id_geom,
				s2_2a.nom_iris,
				s2_2a.loc_zx,
				''tous logts confondus''::varchar(21) AS typo_acb,
				ROUND(COALESCE(SUM(s2_2a.cout_min_dmg_tot) FILTER (WHERE s2_2a.loc_zx = ''In''),0)::numeric,0),
				ROUND(COALESCE(SUM(s2_2a.cout_max_dmg_tot) FILTER (WHERE s2_2a.loc_zx = ''In''),0)::numeric,0),
				s2_2a.date_actu_cout_dmg AS date_actu_cout_dmg,
				s2_2a.date_calcul AS date_calcul,
				ST_Multi(ST_Simplify(ST_CollectionExtract(ST_ForceCollection(ST_MakeValid(ST_Union(s2_2a.geom))),3),0))
			FROM s2_2a
			RIGHT JOIN zt
			ON s2_2a.id_iris = zt.id_iris
			WHERE zt.territoire = ''' || nom_ter || '''
				AND s2_2a.territoire = ''' || nom_ter || '''
				AND s2_2a.type_alea = ''' || typ_alea || '''
 				AND s2_2a.code_occurrence = ''' || code_occ || '''
			GROUP BY s2_2a.territoire, s2_2a.type_alea, s2_2a.code_occurrence, type_result, id_geom, s2_2a.nom_iris, loc_zx, s2_2a.date_actu_cout_dmg, s2_2a.date_calcul
			';

	--************************************************************************
	-- Insertion des IRIS
    --************************************************************************
	RAISE NOTICE 'Insertion des IRIS';

	EXECUTE 'INSERT INTO s2_2a_rc(territoire, type_alea, code_occurrence, type_result, id_geom, nom_id_geom, loc_zx, typo_acb, cout_min_dmg_tot, cout_max_dmg_tot, date_actu_cout_dmg, date_calcul, geom)
			SELECT
				s2_2a.territoire,
				s2_2a.type_alea,
				s2_2a.code_occurrence,
				''IRIS'' AS type_result,
				zt.id_iris AS id_geom,
				s2_2a.nom_iris,
				''indéterminé''::varchar(30) AS loc_zx,
				''tous logts confondus''::varchar(21) AS typo_acb,
				ROUND(COALESCE(SUM(s2_2a.cout_min_dmg_tot) FILTER (WHERE s2_2a.loc_zx = ''In''),0)::numeric,0),
				ROUND(COALESCE(SUM(s2_2a.cout_max_dmg_tot) FILTER (WHERE s2_2a.loc_zx = ''In''),0)::numeric,0),
				s2_2a.date_actu_cout_dmg AS date_actu_cout_dmg,
				s2_2a.date_calcul AS date_calcul,
				zt.geom
			FROM s2_2a
			RIGHT JOIN zt
			ON s2_2a.id_iris = zt.id_iris
			WHERE zt.territoire = '''||nom_ter||'''
				AND s2_2a.territoire = ''' || nom_ter || '''
				AND s2_2a.type_alea = ''' || typ_alea || '''
 				AND s2_2a.code_occurrence = ''' || code_occ || '''
			GROUP BY s2_2a.territoire, s2_2a.type_alea, s2_2a.code_occurrence, type_result, id_geom, s2_2a.nom_iris, s2_2a.date_actu_cout_dmg, s2_2a.date_calcul, zt.geom
			';

	--************************************************************************
	-- Insertion des communes
    --************************************************************************
	RAISE NOTICE 'Insertion des communes';
	
	EXECUTE 'INSERT INTO s2_2a_rc(territoire, type_alea, code_occurrence, type_result, id_geom, nom_id_geom, loc_zx, typo_acb, cout_min_dmg_tot, cout_max_dmg_tot, date_actu_cout_dmg, date_calcul, geom)
			SELECT
				s2_2a.territoire,
				s2_2a.type_alea,
				s2_2a.code_occurrence,
				''Commune'' AS type_result,
				s2_2a.id_commune,
				s2_2a.nom_commune,
				''indéterminé''::varchar(30) AS loc_zx,
				''tous logts confondus''::varchar(21) AS typo_acb,
				ROUND(COALESCE(SUM(s2_2a.cout_min_dmg_tot) FILTER (WHERE s2_2a.loc_zx = ''In''),0)::numeric,0),
				ROUND(COALESCE(SUM(s2_2a.cout_max_dmg_tot) FILTER (WHERE s2_2a.loc_zx = ''In''),0)::numeric,0),
				s2_2a.date_actu_cout_dmg AS date_actu_cout_dmg,
				s2_2a.date_calcul AS date_calcul,
				com.geom
			FROM s2_2a, commune_' || an_bdtopo || ' AS com
			WHERE s2_2a.territoire = ''' || nom_ter || '''
				AND s2_2a.type_alea = ''' || typ_alea || '''
 				AND s2_2a.code_occurrence = ''' || code_occ || '''
				AND s2_2a.id_commune = com.insee_com
			GROUP BY s2_2a.territoire, s2_2a.type_alea, s2_2a.code_occurrence, type_result, s2_2a.id_commune, s2_2a.nom_commune, s2_2a.date_actu_cout_dmg, s2_2a.date_calcul, com.geom
			';

	--************************************************************************
	-- Insertion des EPCI
    --************************************************************************
	RAISE NOTICE 'Insertion des EPCI';

-- Version qui prend tous les EPCI, même ceux qui dépassent le périmètre du territoire d'étude (idem pour les communes ci-dessus)
	EXECUTE 'INSERT INTO s2_2a_rc(territoire, type_alea, code_occurrence, type_result, id_geom, nom_id_geom, loc_zx, typo_acb, cout_min_dmg_tot, cout_max_dmg_tot, date_actu_cout_dmg, date_calcul, geom)
			SELECT
				s2_2a.territoire,
				s2_2a.type_alea,
				s2_2a.code_occurrence,
				''EPCI'' AS type_result,
				s2_2a.id_epci,
				s2_2a.nom_epci,
				''indéterminé''::varchar(30) AS loc_zx,
				''tous logts confondus''::varchar(21) AS typo_acb,
				ROUND(COALESCE(SUM(s2_2a.cout_min_dmg_tot) FILTER (WHERE s2_2a.loc_zx = ''In''),0)::numeric,0),
				ROUND(COALESCE(SUM(s2_2a.cout_max_dmg_tot) FILTER (WHERE s2_2a.loc_zx = ''In''),0)::numeric,0),
				s2_2a.date_actu_cout_dmg AS date_actu_cout_dmg,
				s2_2a.date_calcul AS date_calcul,
				epci.geom
			FROM s2_2a, epci_' || an_bdtopo || ' AS epci
			WHERE s2_2a.territoire = ''' || nom_ter || '''
				AND s2_2a.type_alea = ''' || typ_alea || '''
 				AND s2_2a.code_occurrence = ''' || code_occ || '''
				AND s2_2a.id_epci = epci.code_siren
			GROUP BY s2_2a.territoire, s2_2a.type_alea, s2_2a.code_occurrence, type_result, s2_2a.id_epci, s2_2a.nom_epci, s2_2a.date_actu_cout_dmg, s2_2a.date_calcul, epci.geom
			';

/* Version de Sébastien qui ne récupère pas la géométrie de l'EPCI quand celui-ci dépasse le périmètre du territoire d'étude
	EXECUTE 'INSERT INTO s2_2a_rc(territoire, type_alea, code_occurrence, type_result, id_geom, nom_id_geom, loc_zx, typo_acb, cout_min_dmg_tot, cout_max_dmg_tot, date_actu_cout_dmg, date_calcul, geom)
			SELECT
				s2_2a.territoire,
				s2_2a.type_alea,
				s2_2a.code_occurrence,
				''EPCI'' AS type_result,
				s2_2a.id_epci,
				s2_2a.nom_epci,
				''indéterminé''::varchar(30) AS loc_zx,
				''tous logts confondus''::varchar(21) AS typo_acb,
				ROUND(COALESCE(SUM(s2_2a.cout_min_dmg_tot) FILTER (WHERE s2_2a.loc_zx = ''In''),0)::numeric,0),
				ROUND(COALESCE(SUM(s2_2a.cout_max_dmg_tot) FILTER (WHERE s2_2a.loc_zx = ''In''),0)::numeric,0),
				s2_2a.date_actu_cout_dmg AS date_actu_cout_dmg,
				s2_2a.date_calcul AS date_calcul,
				epci.geom
			FROM s2_2a, epci_' || an_bdtopo || ' AS epci, territoires AS ter
			WHERE s2_2a.territoire = ''' || nom_ter || '''
				AND s2_2a.type_alea = ''' || typ_alea || '''
 				AND s2_2a.code_occurrence = ''' || code_occ || '''
				AND s2_2a.id_epci = epci.code_siren
				AND ST_Within(epci.geom, ter.geom)
			GROUP BY s2_2a.territoire, s2_2a.type_alea, s2_2a.code_occurrence, type_result, s2_2a.id_epci, s2_2a.nom_epci, s2_2a.date_actu_cout_dmg, s2_2a.date_calcul, epci.geom
			';
*/

/* Script de Lucie issu de "__indic_s2_2a_rc", reproduit par Sébastien sur "__indic_s2_2a_rc", mais ne fonctionnant pas
	EXECUTE 'DROP TABLE IF EXISTS epci_temp CASCADE;
	CREATE TEMP TABLE epci_temp AS
	SELECT DISTINCT epci.*
	FROM epci_' || an_bdtopo || ' AS epci
	JOIN zt
	ON zt.id_epci = epci.code_siren
	WHERE zt.territoire = ''' || nom_ter || '''
	';

	EXECUTE 'CREATE INDEX ON epci_temp USING btree(code_siren)';
	EXECUTE 'CREATE INDEX ON epci_temp USING gist(geom)';

	EXECUTE 'DROP TABLE IF EXISTS epci_too_large CASCADE';
	EXECUTE 'CREATE TEMP TABLE epci_too_large AS
	WITH tempa AS (
		SELECT
			'''||nom_ter||''' as ter,
			SUM(ST_Area(geom))::double precision as s_epci
		FROM epci_temp
		GROUP BY ter
	)
	SELECT DISTINCT
		ST_Area(territoires.geom)::double precision as s_ter,
		tempa.s_epci,
		(ST_Area(territoires.geom) / tempa.s_epci)::double precision as r_ter_epci
	FROM territoires
	JOIN tempa
	ON territoires.territoire = tempa.ter
	';	
	
	IF EXISTS
	(
		SELECT *
		FROM epci_too_large
		WHERE r_ter_epci >= 0.95
	)
	THEN
	
		EXECUTE 'DROP TABLE IF EXISTS s2_2a_epci CASCADE;
		CREATE TEMP TABLE s2_2a_epci AS
		SELECT
			s2_2a.id_epci,
			s2_2a.nom_epci,
			s2_2a.date_calcul,
			ROUND(COALESCE(SUM(s2_2a.cout_min_dmg_tot) FILTER (WHERE s2_2a.loc_zx = ''In''),0)::numeric,2) AS cout_min_dmg_tot,
			ROUND(COALESCE(SUM(s2_2a.cout_max_dmg_tot) FILTER (WHERE s2_2a.loc_zx = ''Out''),0)::numeric,2) AS cout_max_dmg_tot
		FROM s2_2a
		WHERE s2_2a.territoire = ''' || nom_ter || '''
			AND s2_2a.code_occurrence = '''||code_occ||'''
			AND s2_2a.type_alea = '''||alea||'''
		GROUP BY s2_2a.territoire, s2_2a.type_alea, s2_2a.code_occurrence, s2_2a.id_epci, s2_2a.nom_epci, s2_2a.date_calcul
		';
			
		EXECUTE 'CREATE INDEX ON s2_2a_epci USING btree(id_epci)';
	
		EXECUTE 'INSERT INTO s2_2a_rc(territoire, type_alea, code_occurrence, type_result, id_geom, nom_id_geom, loc_zx, typo_acb, cout_min_dmg_tot, cout_max_dmg_tot, date_calcul, geom)
				SELECT DISTINCT
					'''||nom_ter||''' as ter,
					'''||alea||''' as alea,
					'''||code_occ||''' as occ,
					''EPCI'' AS type_result,
					epci.code_siren AS id_geom,
					s2_2a.nom_epci,
					''indéterminé''::varchar(30) as loc_zx,
					''tous logts confondus''::varchar(21) AS typo_acb,
					s2_2a.cout_min_dmg_tot,
					s2_2a.cout_max_dmg_tot,
					s2_2a.date_calcul AS date_calcul,
					epci.geom
				FROM s2_2a_epci as s2_2a
				RIGHT JOIN epci_temp AS epci
				ON s2_2a.id_epci = epci.code_siren
				';	
	ELSE
	
		EXECUTE 'DROP TABLE IF EXISTS ter_temp CASCADE;
		CREATE TEMP TABLE ter_temp AS
		SELECT DISTINCT *
		FROM territoires
		WHERE territoire = ''' || nom_ter || '''
		';
	
		EXECUTE 'CREATE INDEX ON ter_temp USING btree(id)';
		EXECUTE 'CREATE INDEX ON ter_temp USING gist(geom)';
	
		EXECUTE 'DROP TABLE IF EXISTS s2_2a_ter CASCADE;
		CREATE TEMP TABLE s2_2a_ter AS
		SELECT
			s2_2a.territoire,
			s2_2a.date_calcul,
			ROUND(COALESCE(SUM(s2_2a.cout_min_dmg_tot) FILTER (WHERE s2_2a.loc_zx = ''In''),0)::numeric,2) as cout_min_dmg_tot,
			ROUND(COALESCE(SUM(s2_2a.cout_max_dmg_tot) FILTER (WHERE s2_2a.loc_zx = ''Out''),0)::numeric,2) as cout_max_dmg_tot
		FROM s2_2a
		WHERE s2_2a.territoire = ''' || nom_ter || '''
			AND s2_2a.code_occurrence = '''||code_occ||'''
			AND s2_2a.type_alea = '''||alea||'''
		GROUP BY s2_2a.territoire, s2_2a.type_alea, s2_2a.code_occurrence, s2_2a.date_calcul
		';
			
		EXECUTE 'CREATE INDEX ON s2_2a_ter USING btree(territoire)';
	
		EXECUTE 'INSERT INTO s2_2a_rc(territoire, type_alea, code_occurrence, type_result, id_geom, nom_id_geom, loc_zx, typo_acb, cout_min_dmg_tot, cout_max_dmg_tot, date_calcul, geom)
				SELECT DISTINCT
					'''||nom_ter||''' as ter,
					'''||alea||''' as alea,
					'''||code_occ||''' as occ,
					''EPCI'' AS type_result,
					ter.id AS id_geom,
					'''||nom_ter||''',
					''indéterminé''::varchar(30) as loc_zx,
					''tous logts confondus''::varchar(21) AS typo_acb,
					s2_2a.cout_min_dmg_tot,
					s2_2a.cout_max_dmg_tot,
					s2_2a.date_calcul AS date_calcul,
					ter.geom
				FROM s2_2a_ter as s2_2a
				RIGHT JOIN ter_temp AS ter
				ON s2_2a.territoire = ter.territoire
				';
			
	END IF;
*/

	--************************************************************************
	-- Récupère le nombre d'entités ajoutées
	--************************************************************************
	GET DIAGNOSTICS c = row_count;

	--************************************************************************
	-- Création d'une vue matérialisée sur le territoire
	--************************************************************************
	EXECUTE '
		DROP MATERIALIZED VIEW IF EXISTS s2_2a_rc_' || __util_to_snake_case(nom_ter) || ';
		CREATE MATERIALIZED VIEW s2_2a_rc_' || __util_to_snake_case(nom_ter) || ' AS
		SELECT *
		FROM s2_2a_rc
		WHERE territoire = ''' || nom_ter || '''
		';

	EXECUTE 'CREATE UNIQUE INDEX
	ON s2_2a_rc_' || __util_to_snake_case(nom_ter) || ' (id)';
	
	--************************************************************************
	-- Création des index sur la vue de type s2_2a_rc
	--************************************************************************
	EXECUTE 'CREATE INDEX ON s2_2a_rc_' || __util_to_snake_case(nom_ter) || ' USING gist(geom)';
	EXECUTE 'CREATE INDEX ON s2_2a_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(id)';
	EXECUTE 'CREATE INDEX ON s2_2a_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(territoire)';
	EXECUTE 'CREATE INDEX ON s2_2a_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(type_alea)';
	EXECUTE 'CREATE INDEX ON s2_2a_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(code_occurrence)';
	EXECUTE 'CREATE INDEX ON s2_2a_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(type_result)';
	EXECUTE 'CREATE INDEX ON s2_2a_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(id_geom)';
	EXECUTE 'CREATE INDEX ON s2_2a_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(nom_id_geom)';
	EXECUTE 'CREATE INDEX ON s2_2a_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(loc_zx)';
	EXECUTE 'CREATE INDEX ON s2_2a_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(typo_acb)';
	EXECUTE 'CREATE INDEX ON s2_2a_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(cout_min_dmg_tot)';
	EXECUTE 'CREATE INDEX ON s2_2a_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(cout_max_dmg_tot)';
	EXECUTE 'CREATE INDEX ON s2_2a_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(date_actu_cout_dmg)';
	EXECUTE 'CREATE INDEX ON s2_2a_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(date_calcul)';
	
	--************************************************************************
	-- Conclusion
	--************************************************************************
	RAISE NOTICE '';
	RAISE NOTICE '====== FIN TRAITEMENT ======';
	RAISE NOTICE '[INFO] La table s2_2a_rc (représentation carto de l''indicateur sous forme d''hexagones + autres géométries administratives) a été mise à jour dans le schéma p_rep_carto pour le territoire ''%''', nom_ter;
	RAISE NOTICE '';
	RAISE NOTICE '====== RESULTATS ======';
	RAISE NOTICE '% entités ajoutées pour le territoire ''%'' dans p_rep_carto.s2_2a_rc', c, nom_ter;
	RAISE NOTICE 'Création de la vue "%"', 'p_rep_carto.s2_2a_rc' || __util_to_snake_case(nom_ter);
	heure2 = clock_timestamp();
	RAISE NOTICE 'Fin du traitement : %', heure2;
	RAISE NOTICE 'Durée du traitement : %', CAST(heure2 as time)-CAST(heure1 as time);
	RAISE NOTICE '';

END;
$function$
