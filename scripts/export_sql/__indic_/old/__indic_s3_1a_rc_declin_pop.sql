CREATE OR REPLACE FUNCTION public.__indic_s3_1a_rc_declin_pop(nom_ter text, typ_alea text, code_occ text, an_bdtopo text, l_hexa character varying[])
 RETURNS void
 LANGUAGE plpgsql
AS $function$

-- Fonction SQL de représentation cartographique de l'indicateur S3/1a "Occupants en zone inondable"
-- Copyright Cerema / GT AgiRisk
-- Auteurs principaux du script : Anaïs (idée originale pour le croisement avec les hexagones), Lucie (optimisation du croisement avec les hexagones et avec les entités administratives), Sébastien (trame de départ puis mises à jour dans version 2)

-- La présente version 2 du script inclut la déclinaison Pop1...Pop6

-- Paramètres d'entrée :
-- nom_ter = nom du territoire d'étude tel que renseigné dans le champ `territoire` de la table c_general.territoires
-- typ_alea : type d'aléa considéré (ex : débordement de cours d'eau, submersion marine)
-- code_occ : période de retour considérée pour le type d'aléa choisi (ex : QRef, Q100, Q10)
-- an_bdtopo = millésime (année au format AAAA) de la BD TOPO®

-- Exemple d'appel à cette fonction : SELECT public.__indic_s3_1a_rc_declin_pop('Jura', 'débordement de cours d''''eau', 'QRef', '2022', ARRAY['1','5','10','50','100']);

DECLARE
    c integer; -- un compteur des lignes modifiées pour logging
	heure1 varchar; -- heure de début du traitement
	heure2 varchar; -- heure de fin du traitement
	hexa varchar; -- valeurs des hexagones
	nb_h integer; -- nombre d'éléments dans l_hexa
	i integer; -- numéro de l'élément dans l_hexa

BEGIN
	heure1 = clock_timestamp();
	
	--************************************************************************
	-- Définition des schémas de travail
	--************************************************************************
    SET search_path TO p_rep_carto, p_indicateurs, c_phenomenes, r_ign_bdtopo, r_rep_carto, public;

    RAISE NOTICE '';
    RAISE NOTICE '====== RAPPORT ======';
    RAISE NOTICE 'Génération des représentations cartographiques pour l''indicateur S3/1a (occupants en zone inondable)';
    RAISE NOTICE 'Début du traitement : %', heure1;

    --************************************************************************
    -- Vérification de l'existence d'une table s3_1a dans le schéma p_indicateurs
    --************************************************************************
    IF NOT EXISTS(
        SELECT *
        FROM s3_1a
        -- WHERE territoire = nom_ter
       	-- AND type_alea = typ_alea
       	-- AND code_occurrence = code_occ
    )
    THEN
        RAISE EXCEPTION 'L''indicateur S3/1a n''a pas encore été calculé sur le territoire ''%'' et l''aléa renseigné. Fin de l''exécution', nom_ter;
    END IF;
	
	--************************************************************************
    -- Vérification de l'existence des données dans la table s3_1a_rc
    --************************************************************************
    IF EXISTS(
        SELECT *
        FROM s3_1a_rc
		WHERE territoire = nom_ter
       	AND type_alea = typ_alea
       	AND code_occurrence = code_occ
    )
    THEN
        RAISE EXCEPTION 'Il existe déjà des enregistrements pour le territoire ''%'' et l''aléa renseigné dans la table p_rep_carto.s3_1a_rc. Pour les supprimer, lancer la requête suivante : DELETE FROM p_rep_carto.s3_1a_rc WHERE territoire = ''%'' AND type_alea = ''%'' AND code_occurrence = ''%'';', nom_ter, nom_ter, typ_alea, code_occ;
    END IF;

    --************************************************************************
    -- Insertion des données hexag_xxxha
    --************************************************************************
	RAISE NOTICE 'Insertion des données hexag_xxxha';
	
	nb_h:= array_length(l_hexa, 1);
	FOR i IN 1..nb_h
	
	LOOP
	
		hexa:= l_hexa[i];
		
		IF i >= 1 THEN
			EXECUTE 'INSERT INTO s3_1a_rc(
				territoire, type_alea, code_occurrence, type_result, id_geom, nom_id_geom, loc_zx,
				pop1_in, pop1_out,
				pop2_haut_in, pop2_bas_in, pop2_haut_out, pop2_bas_out,
				pop3_in, pop3_out,
				pop4_in, pop4_out,
				pop5_in, pop5_out,
				pop6_haut_in, pop6_bas_in, pop6_haut_out, pop6_bas_out,
				date_calcul, geom)
					SELECT DISTINCT
						s3_1a.territoire,
						s3_1a.type_alea,
						s3_1a.code_occurrence,
						''Hexag_'||hexa||'ha''::varchar(200) AS type_result,
						hexag.grid_id::varchar(200) AS id_geom,
						''indéterminé''::varchar(200) AS nom_id_geom,
						''indéterminé''::varchar(30) AS loc_zx,
						
						ROUND(COALESCE(SUM(s3_1a.pop1) FILTER (WHERE s3_1a.loc_zx = ''In''),0)::numeric,0),
						ROUND(COALESCE(SUM(s3_1a.pop1) FILTER (WHERE s3_1a.loc_zx = ''Out''),0)::numeric,0),
						
						ROUND(COALESCE(SUM(s3_1a.pop2_haut) FILTER (WHERE s3_1a.loc_zx = ''In''),0)::numeric,0),
						ROUND(COALESCE(SUM(s3_1a.pop2_bas) FILTER (WHERE s3_1a.loc_zx = ''In''),0)::numeric,0),
						ROUND(COALESCE(SUM(s3_1a.pop2_haut) FILTER (WHERE s3_1a.loc_zx = ''Out''),0)::numeric,0),
						ROUND(COALESCE(SUM(s3_1a.pop2_bas) FILTER (WHERE s3_1a.loc_zx = ''Out''),0)::numeric,0),
						
						ROUND(COALESCE(SUM(s3_1a.pop3) FILTER (WHERE s3_1a.loc_zx = ''In''),0)::numeric,0),
						ROUND(COALESCE(SUM(s3_1a.pop3) FILTER (WHERE s3_1a.loc_zx = ''Out''),0)::numeric,0),
						
						ROUND(COALESCE(SUM(s3_1a.pop4) FILTER (WHERE s3_1a.loc_zx = ''In''),0)::numeric,0),
						ROUND(COALESCE(SUM(s3_1a.pop4) FILTER (WHERE s3_1a.loc_zx = ''Out''),0)::numeric,0),
						
						ROUND(COALESCE(SUM(s3_1a.pop5) FILTER (WHERE s3_1a.loc_zx = ''In''),0)::numeric,0),
						ROUND(COALESCE(SUM(s3_1a.pop5) FILTER (WHERE s3_1a.loc_zx = ''Out''),0)::numeric,0),
						
						ROUND(COALESCE(SUM(s3_1a.pop6_haut) FILTER (WHERE s3_1a.loc_zx = ''In''),0)::numeric,0),
						ROUND(COALESCE(SUM(s3_1a.pop6_bas) FILTER (WHERE s3_1a.loc_zx = ''In''),0)::numeric,0),
						ROUND(COALESCE(SUM(s3_1a.pop6_haut) FILTER (WHERE s3_1a.loc_zx = ''Out''),0)::numeric,0),
						ROUND(COALESCE(SUM(s3_1a.pop6_bas) FILTER (WHERE s3_1a.loc_zx = ''Out''),0)::numeric,0),
						
						s3_1a.date_calcul AS date_calcul,
						hexag.geom
					FROM s3_1a
					RIGHT JOIN hexag_'||hexa||'ha AS hexag
					ON ST_Intersects(s3_1a.geomloc, hexag.geom)
					WHERE s3_1a.territoire = ''' || nom_ter || '''
						AND s3_1a.type_alea = ''' || typ_alea || '''
 						AND s3_1a.code_occurrence = ''' || code_occ || '''
					GROUP BY s3_1a.territoire, s3_1a.type_alea, s3_1a.code_occurrence, type_result, id_geom, s3_1a.date_calcul, hexag.geom
			';
		END IF;
		
	END LOOP;
	
	--************************************************************************
	-- Insertion des bâtiments "bruts" agglomérés à l'IRIS
    --************************************************************************
	RAISE NOTICE 'Insertion des bâtiments "bruts" agglomérés à l''IRIS';
	
	EXECUTE 'INSERT INTO s3_1a_rc(
		territoire, type_alea, code_occurrence, type_result, id_geom, nom_id_geom, loc_zx,
		pop1_in, pop1_out,
		pop2_haut_in, pop2_bas_in, pop2_haut_out, pop2_bas_out,
		pop3_in, pop3_out,
		pop4_in, pop4_out,
		pop5_in, pop5_out,
		pop6_haut_in, pop6_bas_in, pop6_haut_out, pop6_bas_out,
		date_calcul, geom)
			SELECT
				s3_1a.territoire,
				s3_1a.type_alea,
				s3_1a.code_occurrence,
				''Entite'' AS type_result,
				zt.id_iris AS id_geom,
				s3_1a.nom_iris,
				s3_1a.loc_zx,
				
				ROUND(COALESCE(SUM(s3_1a.pop1) FILTER (WHERE s3_1a.loc_zx = ''In''),0)::numeric,0),
				ROUND(COALESCE(SUM(s3_1a.pop1) FILTER (WHERE s3_1a.loc_zx = ''Out''),0)::numeric,0),
				
				ROUND(COALESCE(SUM(s3_1a.pop2_haut) FILTER (WHERE s3_1a.loc_zx = ''In''),0)::numeric,0),
				ROUND(COALESCE(SUM(s3_1a.pop2_bas) FILTER (WHERE s3_1a.loc_zx = ''In''),0)::numeric,0),
				ROUND(COALESCE(SUM(s3_1a.pop2_haut) FILTER (WHERE s3_1a.loc_zx = ''Out''),0)::numeric,0),
				ROUND(COALESCE(SUM(s3_1a.pop2_bas) FILTER (WHERE s3_1a.loc_zx = ''Out''),0)::numeric,0),
				
				ROUND(COALESCE(SUM(s3_1a.pop3) FILTER (WHERE s3_1a.loc_zx = ''In''),0)::numeric,0),
				ROUND(COALESCE(SUM(s3_1a.pop3) FILTER (WHERE s3_1a.loc_zx = ''Out''),0)::numeric,0),
				
				ROUND(COALESCE(SUM(s3_1a.pop4) FILTER (WHERE s3_1a.loc_zx = ''In''),0)::numeric,0),
				ROUND(COALESCE(SUM(s3_1a.pop4) FILTER (WHERE s3_1a.loc_zx = ''Out''),0)::numeric,0),
				
				ROUND(COALESCE(SUM(s3_1a.pop5) FILTER (WHERE s3_1a.loc_zx = ''In''),0)::numeric,0),
				ROUND(COALESCE(SUM(s3_1a.pop5) FILTER (WHERE s3_1a.loc_zx = ''Out''),0)::numeric,0),
				
				ROUND(COALESCE(SUM(s3_1a.pop6_haut) FILTER (WHERE s3_1a.loc_zx = ''In''),0)::numeric,0),
				ROUND(COALESCE(SUM(s3_1a.pop6_bas) FILTER (WHERE s3_1a.loc_zx = ''In''),0)::numeric,0),
				ROUND(COALESCE(SUM(s3_1a.pop6_haut) FILTER (WHERE s3_1a.loc_zx = ''Out''),0)::numeric,0),
				ROUND(COALESCE(SUM(s3_1a.pop6_bas) FILTER (WHERE s3_1a.loc_zx = ''Out''),0)::numeric,0),
				
				s3_1a.date_calcul AS date_calcul,
				ST_Multi(ST_Simplify(ST_CollectionExtract(ST_ForceCollection(ST_MakeValid(ST_Union(s3_1a.geom))),3),0))
			FROM s3_1a
			RIGHT JOIN zt
			ON s3_1a.id_iris = zt.id_iris
			WHERE zt.territoire = ''' || nom_ter || '''
				AND s3_1a.territoire = ''' || nom_ter || '''
				AND s3_1a.type_alea = ''' || typ_alea || '''
				AND s3_1a.code_occurrence = ''' || code_occ || '''
			GROUP BY s3_1a.territoire, s3_1a.type_alea, s3_1a.code_occurrence, type_result, id_geom, s3_1a.nom_iris, s3_1a.loc_zx, s3_1a.date_calcul
			';
			
	--************************************************************************
	-- Insertion des IRIS
    --************************************************************************
	RAISE NOTICE 'Insertion des IRIS';

	EXECUTE 'INSERT INTO s3_1a_rc(
		territoire, type_alea, code_occurrence, type_result, id_geom, nom_id_geom, loc_zx,
		pop1_in, pop1_out,
		pop2_haut_in, pop2_bas_in, pop2_haut_out, pop2_bas_out,
		pop3_in, pop3_out,
		pop4_in, pop4_out,
		pop5_in, pop5_out,
		pop6_haut_in, pop6_bas_in, pop6_haut_out, pop6_bas_out,
		date_calcul, geom)
			SELECT
				s3_1a.territoire,
				s3_1a.type_alea,
				s3_1a.code_occurrence,
				''IRIS'' AS type_result,
				zt.id_iris AS id_geom,
				s3_1a.nom_iris,
				''indéterminé''::varchar(30) as loc_zx,
				
				ROUND(COALESCE(SUM(s3_1a.pop1) FILTER (WHERE s3_1a.loc_zx = ''In''),0)::numeric,0),
				ROUND(COALESCE(SUM(s3_1a.pop1) FILTER (WHERE s3_1a.loc_zx = ''Out''),0)::numeric,0),
				
				ROUND(COALESCE(SUM(s3_1a.pop2_haut) FILTER (WHERE s3_1a.loc_zx = ''In''),0)::numeric,0),
				ROUND(COALESCE(SUM(s3_1a.pop2_bas) FILTER (WHERE s3_1a.loc_zx = ''In''),0)::numeric,0),
				ROUND(COALESCE(SUM(s3_1a.pop2_haut) FILTER (WHERE s3_1a.loc_zx = ''Out''),0)::numeric,0),
				ROUND(COALESCE(SUM(s3_1a.pop2_bas) FILTER (WHERE s3_1a.loc_zx = ''Out''),0)::numeric,0),
				
				ROUND(COALESCE(SUM(s3_1a.pop3) FILTER (WHERE s3_1a.loc_zx = ''In''),0)::numeric,0),
				ROUND(COALESCE(SUM(s3_1a.pop3) FILTER (WHERE s3_1a.loc_zx = ''Out''),0)::numeric,0),
				
				ROUND(COALESCE(SUM(s3_1a.pop4) FILTER (WHERE s3_1a.loc_zx = ''In''),0)::numeric,0),
				ROUND(COALESCE(SUM(s3_1a.pop4) FILTER (WHERE s3_1a.loc_zx = ''Out''),0)::numeric,0),
				
				ROUND(COALESCE(SUM(s3_1a.pop5) FILTER (WHERE s3_1a.loc_zx = ''In''),0)::numeric,0),
				ROUND(COALESCE(SUM(s3_1a.pop5) FILTER (WHERE s3_1a.loc_zx = ''Out''),0)::numeric,0),
				
				ROUND(COALESCE(SUM(s3_1a.pop6_haut) FILTER (WHERE s3_1a.loc_zx = ''In''),0)::numeric,0),
				ROUND(COALESCE(SUM(s3_1a.pop6_bas) FILTER (WHERE s3_1a.loc_zx = ''In''),0)::numeric,0),
				ROUND(COALESCE(SUM(s3_1a.pop6_haut) FILTER (WHERE s3_1a.loc_zx = ''Out''),0)::numeric,0),
				ROUND(COALESCE(SUM(s3_1a.pop6_bas) FILTER (WHERE s3_1a.loc_zx = ''Out''),0)::numeric,0),
				
				s3_1a.date_calcul AS date_calcul,
				zt.geom
			FROM s3_1a
			RIGHT JOIN zt
			ON s3_1a.id_iris = zt.id_iris
			WHERE s3_1a.territoire = ''' || nom_ter || '''
				AND s3_1a.type_alea = ''' || typ_alea || '''
				AND s3_1a.code_occurrence = ''' || code_occ || '''
			GROUP BY s3_1a.territoire, s3_1a.type_alea, s3_1a.code_occurrence, type_result, id_geom, s3_1a.nom_iris, s3_1a.date_calcul, zt.geom
			';

	--************************************************************************
	-- Insertion des communes
    --************************************************************************
	RAISE NOTICE 'Insertion des communes';
	
	EXECUTE 'INSERT INTO s3_1a_rc(
		territoire, type_alea, code_occurrence, type_result, id_geom, nom_id_geom, loc_zx,
		pop1_in, pop1_out,
		pop2_haut_in, pop2_bas_in, pop2_haut_out, pop2_bas_out,
		pop3_in, pop3_out,
		pop4_in, pop4_out,
		pop5_in, pop5_out,
		pop6_haut_in, pop6_bas_in, pop6_haut_out, pop6_bas_out,
		date_calcul, geom)
			SELECT
				s3_1a.territoire,
				s3_1a.type_alea,
				s3_1a.code_occurrence,
				''Commune'' AS type_result,
				com.insee_com AS id_geom,
				s3_1a.nom_commune,
				''indéterminé''::varchar(30) as loc_zx,
				
				ROUND(COALESCE(SUM(s3_1a.pop1) FILTER (WHERE s3_1a.loc_zx = ''In''),0)::numeric,0),
				ROUND(COALESCE(SUM(s3_1a.pop1) FILTER (WHERE s3_1a.loc_zx = ''Out''),0)::numeric,0),
				
				ROUND(COALESCE(SUM(s3_1a.pop2_haut) FILTER (WHERE s3_1a.loc_zx = ''In''),0)::numeric,0),
				ROUND(COALESCE(SUM(s3_1a.pop2_bas) FILTER (WHERE s3_1a.loc_zx = ''In''),0)::numeric,0),
				ROUND(COALESCE(SUM(s3_1a.pop2_haut) FILTER (WHERE s3_1a.loc_zx = ''Out''),0)::numeric,0),
				ROUND(COALESCE(SUM(s3_1a.pop2_bas) FILTER (WHERE s3_1a.loc_zx = ''Out''),0)::numeric,0),
				
				ROUND(COALESCE(SUM(s3_1a.pop3) FILTER (WHERE s3_1a.loc_zx = ''In''),0)::numeric,0),
				ROUND(COALESCE(SUM(s3_1a.pop3) FILTER (WHERE s3_1a.loc_zx = ''Out''),0)::numeric,0),
				
				ROUND(COALESCE(SUM(s3_1a.pop4) FILTER (WHERE s3_1a.loc_zx = ''In''),0)::numeric,0),
				ROUND(COALESCE(SUM(s3_1a.pop4) FILTER (WHERE s3_1a.loc_zx = ''Out''),0)::numeric,0),
				
				ROUND(COALESCE(SUM(s3_1a.pop5) FILTER (WHERE s3_1a.loc_zx = ''In''),0)::numeric,0),
				ROUND(COALESCE(SUM(s3_1a.pop5) FILTER (WHERE s3_1a.loc_zx = ''Out''),0)::numeric,0),
				
				ROUND(COALESCE(SUM(s3_1a.pop6_haut) FILTER (WHERE s3_1a.loc_zx = ''In''),0)::numeric,0),
				ROUND(COALESCE(SUM(s3_1a.pop6_bas) FILTER (WHERE s3_1a.loc_zx = ''In''),0)::numeric,0),
				ROUND(COALESCE(SUM(s3_1a.pop6_haut) FILTER (WHERE s3_1a.loc_zx = ''Out''),0)::numeric,0),
				ROUND(COALESCE(SUM(s3_1a.pop6_bas) FILTER (WHERE s3_1a.loc_zx = ''Out''),0)::numeric,0),
				
				s3_1a.date_calcul AS date_calcul,
				com.geom
			FROM s3_1a
			RIGHT JOIN commune_' || an_bdtopo || ' AS com
			ON s3_1a.id_commune = com.insee_com
			WHERE s3_1a.territoire = ''' || nom_ter || '''
				AND s3_1a.type_alea = ''' || typ_alea || '''
				AND s3_1a.code_occurrence = ''' || code_occ || '''
			GROUP BY s3_1a.territoire, s3_1a.type_alea, s3_1a.code_occurrence, type_result, id_geom, s3_1a.nom_commune, s3_1a.date_calcul, com.geom
			';
			
	--************************************************************************
	-- Insertion des EPCI
    --************************************************************************
	RAISE NOTICE 'Insertion des EPCI';
	
	EXECUTE 'INSERT INTO s3_1a_rc(
		territoire, type_alea, code_occurrence, type_result, id_geom, nom_id_geom, loc_zx,
		pop1_in, pop1_out,
		pop2_haut_in, pop2_bas_in, pop2_haut_out, pop2_bas_out,
		pop3_in, pop3_out,
		pop4_in, pop4_out,
		pop5_in, pop5_out,
		pop6_haut_in, pop6_bas_in, pop6_haut_out, pop6_bas_out,
		date_calcul, geom)
			SELECT
				s3_1a.territoire,
				s3_1a.type_alea,
				s3_1a.code_occurrence,
				''EPCI'' AS type_result,
				epci.code_siren AS id_geom,
				s3_1a.nom_epci,
				''indéterminé''::varchar(30) as loc_zx,
				
				ROUND(COALESCE(SUM(s3_1a.pop1) FILTER (WHERE s3_1a.loc_zx = ''In''),0)::numeric,0),
				ROUND(COALESCE(SUM(s3_1a.pop1) FILTER (WHERE s3_1a.loc_zx = ''Out''),0)::numeric,0),
				
				ROUND(COALESCE(SUM(s3_1a.pop2_haut) FILTER (WHERE s3_1a.loc_zx = ''In''),0)::numeric,0),
				ROUND(COALESCE(SUM(s3_1a.pop2_bas) FILTER (WHERE s3_1a.loc_zx = ''In''),0)::numeric,0),
				ROUND(COALESCE(SUM(s3_1a.pop2_haut) FILTER (WHERE s3_1a.loc_zx = ''Out''),0)::numeric,0),
				ROUND(COALESCE(SUM(s3_1a.pop2_bas) FILTER (WHERE s3_1a.loc_zx = ''Out''),0)::numeric,0),
				
				ROUND(COALESCE(SUM(s3_1a.pop3) FILTER (WHERE s3_1a.loc_zx = ''In''),0)::numeric,0),
				ROUND(COALESCE(SUM(s3_1a.pop3) FILTER (WHERE s3_1a.loc_zx = ''Out''),0)::numeric,0),
				
				ROUND(COALESCE(SUM(s3_1a.pop4) FILTER (WHERE s3_1a.loc_zx = ''In''),0)::numeric,0),
				ROUND(COALESCE(SUM(s3_1a.pop4) FILTER (WHERE s3_1a.loc_zx = ''Out''),0)::numeric,0),
				
				ROUND(COALESCE(SUM(s3_1a.pop5) FILTER (WHERE s3_1a.loc_zx = ''In''),0)::numeric,0),
				ROUND(COALESCE(SUM(s3_1a.pop5) FILTER (WHERE s3_1a.loc_zx = ''Out''),0)::numeric,0),
				
				ROUND(COALESCE(SUM(s3_1a.pop6_haut) FILTER (WHERE s3_1a.loc_zx = ''In''),0)::numeric,0),
				ROUND(COALESCE(SUM(s3_1a.pop6_bas) FILTER (WHERE s3_1a.loc_zx = ''In''),0)::numeric,0),
				ROUND(COALESCE(SUM(s3_1a.pop6_haut) FILTER (WHERE s3_1a.loc_zx = ''Out''),0)::numeric,0),
				ROUND(COALESCE(SUM(s3_1a.pop6_bas) FILTER (WHERE s3_1a.loc_zx = ''Out''),0)::numeric,0),
				
				s3_1a.date_calcul AS date_calcul,
				epci.geom
			FROM s3_1a
			RIGHT JOIN epci_' || an_bdtopo || ' AS epci
			ON s3_1a.id_epci = epci.code_siren
			WHERE s3_1a.territoire = ''' || nom_ter || '''
				AND s3_1a.type_alea = ''' || typ_alea || '''
				AND s3_1a.code_occurrence = ''' || code_occ || '''
			GROUP BY s3_1a.territoire, s3_1a.type_alea, s3_1a.code_occurrence, type_result, id_geom, s3_1a.nom_epci, s3_1a.date_calcul, epci.geom
			';

	--************************************************************************
	-- Récupère le nombre d'entités ajoutées
	--************************************************************************
	GET DIAGNOSTICS c = row_count;

	--************************************************************************
	-- Création d'une vue matérialisée sur le territoire
	--************************************************************************
	EXECUTE '
		DROP MATERIALIZED VIEW IF EXISTS s3_1a_rc_' || __util_to_snake_case(nom_ter) || ';
		CREATE MATERIALIZED VIEW s3_1a_rc_' || __util_to_snake_case(nom_ter) || ' AS
		SELECT *
		FROM s3_1a_rc
		WHERE territoire = ''' || nom_ter || '''
		';

	EXECUTE 'CREATE UNIQUE INDEX
	ON s3_1a_rc_' || __util_to_snake_case(nom_ter) || ' (id)';

	--************************************************************************
	-- Création des index sur la vue de type s3_1a_rc
	--************************************************************************
	EXECUTE 'CREATE INDEX ON s3_1a_rc_' || __util_to_snake_case(nom_ter) || ' USING gist(geom)';
	EXECUTE 'CREATE INDEX ON s3_1a_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(id)';
	EXECUTE 'CREATE INDEX ON s3_1a_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(territoire)';
	EXECUTE 'CREATE INDEX ON s3_1a_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(type_alea)';
	EXECUTE 'CREATE INDEX ON s3_1a_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(code_occurrence)';
	EXECUTE 'CREATE INDEX ON s3_1a_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(type_result)';
	EXECUTE 'CREATE INDEX ON s3_1a_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(id_geom)';
	EXECUTE 'CREATE INDEX ON s3_1a_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(nom_id_geom)';
	EXECUTE 'CREATE INDEX ON s3_1a_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(loc_zx)';
	
	EXECUTE 'CREATE INDEX ON s3_1a_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(pop1_in)';
	EXECUTE 'CREATE INDEX ON s3_1a_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(pop1_out)';
	
	EXECUTE 'CREATE INDEX ON s3_1a_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(pop2_haut_in)';
	EXECUTE 'CREATE INDEX ON s3_1a_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(pop2_bas_in)';
	EXECUTE 'CREATE INDEX ON s3_1a_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(pop2_haut_out)';
	EXECUTE 'CREATE INDEX ON s3_1a_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(pop2_bas_out)';
	
	EXECUTE 'CREATE INDEX ON s3_1a_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(pop3_in)';
	EXECUTE 'CREATE INDEX ON s3_1a_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(pop3_out)';
	
	EXECUTE 'CREATE INDEX ON s3_1a_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(pop4_in)';
	EXECUTE 'CREATE INDEX ON s3_1a_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(pop4_out)';
	
	EXECUTE 'CREATE INDEX ON s3_1a_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(pop5_in)';
	EXECUTE 'CREATE INDEX ON s3_1a_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(pop5_out)';
	
	EXECUTE 'CREATE INDEX ON s3_1a_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(pop6_haut_in)';
	EXECUTE 'CREATE INDEX ON s3_1a_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(pop6_bas_in)';
	EXECUTE 'CREATE INDEX ON s3_1a_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(pop6_haut_out)';
	EXECUTE 'CREATE INDEX ON s3_1a_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(pop6_bas_out)';
	
	EXECUTE 'CREATE INDEX ON s3_1a_rc_' || __util_to_snake_case(nom_ter) || ' USING btree(date_calcul)';

	--************************************************************************
	-- Conclusion
	--************************************************************************
	RAISE NOTICE '';
	RAISE NOTICE '====== FIN TRAITEMENT ======';
	RAISE NOTICE '[INFO] La table s3_1a_rc (représentation carto de l''indicateur sous forme d''hexagones + autres géométries administratives) a été mise à jour dans le schéma p_rep_carto pour le territoire ''%''', nom_ter;
	RAISE NOTICE '';
	RAISE NOTICE '====== RESULTATS ======';
	RAISE NOTICE '% entités ajoutées pour le territoire ''%'' dans p_rep_carto.s3_1a_rc', c, nom_ter;
	RAISE NOTICE 'Création de la vue "%"', 'p_rep_carto.s3_1a_rc' || __util_to_snake_case(nom_ter);
	heure2 = clock_timestamp();
	RAISE NOTICE 'Fin du traitement : %', heure2;
	RAISE NOTICE 'Durée du traitement : %', CAST(heure2 as time)-CAST(heure1 as time);
	RAISE NOTICE '';

END;
$function$
