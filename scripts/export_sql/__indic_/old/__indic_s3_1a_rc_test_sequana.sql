CREATE OR REPLACE FUNCTION public.__indic_s3_1a_rc_test_sequana(nom_ter text, an_bdtopo text)
 RETURNS void
 LANGUAGE plpgsql
AS $function$

-- Fonction SQL de représentation cartographique de l'indicateur S3/1a "Occupants en zone inondable" pour le territoire Sequana / secteurs Seine et Brevon
-- Copyright Cerema / GT AgiRisk
-- Auteur du script : Sébastien

-- Exemple d'appel à cette fonction : SELECT public.__indic_s3_1a_rc_test_sequana('Sequana Seine et Brevon', '2022');

DECLARE
    c integer; -- un compteur des lignes modifiées pour logging
	heure1 varchar; -- heure de début du traitement
	heure2 varchar; -- heure de fin du traitement

BEGIN
	heure1 = current_timestamp;
	
	--************************************************************************
	-- Définition des schémas de travail
	--************************************************************************
    SET search_path TO p_rep_carto, p_indicateurs, c_phenomenes, r_ign_bdtopo, r_rep_carto, public;

    RAISE NOTICE '';
    RAISE NOTICE '====== RAPPORT ======';
    RAISE NOTICE 'Génération des représentations cartographiques pour l''indicateur S3/1a "Occupants en zone inondable" pour le territoire Sequana / secteurs Seine et Brevon';
    RAISE NOTICE 'Début du traitement : %', heure1;

    --************************************************************************
    -- Vérification de l'existence d'une table s3_1a_sequana_seine_brevon dans le schéma p_indicateurs
    --************************************************************************
    IF NOT EXISTS(
        SELECT *
        FROM p_indicateurs.s3_1a_sequana_seine_brevon
        WHERE territoire = nom_ter
    )
    THEN
        RAISE EXCEPTION 'L''indicateur S3/1a n''a pas encore été calculé sur le territoire ''%''. Fin de l''exécution', nom_ter;
    END IF;
	
	--************************************************************************
    -- Vérification de l'existence des données pour le territoire nom_ter dans la table s3_1a_rc_sequana_seine_brevon
    --************************************************************************
    IF EXISTS(
        SELECT *
        FROM p_rep_carto.s3_1a_rc_sequana_seine_brevon
		WHERE territoire = nom_ter
    )
    THEN
        RAISE EXCEPTION 'Il existe déjà des enregistrements pour le territoire ''%'' dans la table p_rep_carto.s3_1a_rc_sequana_seine_brevon. Pour les supprimer, lancer la requête suivante : DELETE FROM p_rep_carto.s3_1a_rc_sequana_seine_brevon WHERE territoire = ''%'';', nom_ter, nom_ter;
    END IF;

	--************************************************************************
	-- Insertion des bâtiments "bruts" agglomérés à la commune
    --************************************************************************
	RAISE NOTICE 'Insertion des bâtiments "bruts" agglomérés à la commune';
	
	EXECUTE 'INSERT INTO s3_1a_rc_sequana_seine_brevon(
		territoire, type_alea, code_occurrence, type_result, id_geom, nom_id_geom, loc_zx,
		pop1_in, pop1_out,
		pop2_haut_in, pop2_bas_in, pop2_haut_out, pop2_bas_out,
		pop6_haut_in, pop6_bas_in, pop6_haut_out, pop6_bas_out,
		date_calcul, geom)
			SELECT
				s3_1a_sequana_seine_brevon.territoire,
				s3_1a_sequana_seine_brevon.type_alea,
				s3_1a_sequana_seine_brevon.code_occurrence,
				''Entite'' AS type_result,
				com.insee_com AS id_geom,
				s3_1a_sequana_seine_brevon.nom_commune,
				s3_1a_sequana_seine_brevon.loc_zx,

				ROUND(COALESCE(SUM(s3_1a_sequana_seine_brevon.pop1) FILTER (WHERE s3_1a_sequana_seine_brevon.loc_zx = ''In''),0)::numeric,0),
				ROUND(COALESCE(SUM(s3_1a_sequana_seine_brevon.pop1) FILTER (WHERE s3_1a_sequana_seine_brevon.loc_zx = ''Out''),0)::numeric,0),

				ROUND(COALESCE(SUM(s3_1a_sequana_seine_brevon.pop2_haut) FILTER (WHERE s3_1a_sequana_seine_brevon.loc_zx = ''In''),0)::numeric,0),
				ROUND(COALESCE(SUM(s3_1a_sequana_seine_brevon.pop2_bas) FILTER (WHERE s3_1a_sequana_seine_brevon.loc_zx = ''In''),0)::numeric,0),
				ROUND(COALESCE(SUM(s3_1a_sequana_seine_brevon.pop2_haut) FILTER (WHERE s3_1a_sequana_seine_brevon.loc_zx = ''Out''),0)::numeric,0),
				ROUND(COALESCE(SUM(s3_1a_sequana_seine_brevon.pop2_bas) FILTER (WHERE s3_1a_sequana_seine_brevon.loc_zx = ''Out''),0)::numeric,0),

				ROUND(COALESCE(SUM(s3_1a_sequana_seine_brevon.pop6_haut) FILTER (WHERE s3_1a_sequana_seine_brevon.loc_zx = ''In''),0)::numeric,0),
				ROUND(COALESCE(SUM(s3_1a_sequana_seine_brevon.pop6_bas) FILTER (WHERE s3_1a_sequana_seine_brevon.loc_zx = ''In''),0)::numeric,0),
				ROUND(COALESCE(SUM(s3_1a_sequana_seine_brevon.pop6_haut) FILTER (WHERE s3_1a_sequana_seine_brevon.loc_zx = ''Out''),0)::numeric,0),
				ROUND(COALESCE(SUM(s3_1a_sequana_seine_brevon.pop6_bas) FILTER (WHERE s3_1a_sequana_seine_brevon.loc_zx = ''Out''),0)::numeric,0),

				s3_1a_sequana_seine_brevon.date_calcul AS date_calcul,
				ST_Multi(ST_Simplify(ST_CollectionExtract(ST_ForceCollection(ST_MakeValid(ST_Union(s3_1a_sequana_seine_brevon.geom))),3),0))
			FROM p_indicateurs.s3_1a_sequana_seine_brevon
			RIGHT JOIN commune_' || an_bdtopo || ' AS com
			ON s3_1a_sequana_seine_brevon.id_commune = com.insee_com
			WHERE s3_1a_sequana_seine_brevon.territoire = ''' || nom_ter || '''
			GROUP BY s3_1a_sequana_seine_brevon.territoire, s3_1a_sequana_seine_brevon.type_alea, s3_1a_sequana_seine_brevon.code_occurrence, type_result, id_geom, s3_1a_sequana_seine_brevon.nom_commune, s3_1a_sequana_seine_brevon.loc_zx, s3_1a_sequana_seine_brevon.date_calcul
			';

	--************************************************************************
	-- Insertion des communes
    --************************************************************************
	RAISE NOTICE 'Insertion des communes';
	
	EXECUTE 'INSERT INTO s3_1a_rc_sequana_seine_brevon(
		territoire, type_alea, code_occurrence, type_result, id_geom, nom_id_geom, loc_zx,
		pop1_in, pop1_out,
		pop2_haut_in, pop2_bas_in, pop2_haut_out, pop2_bas_out,
		pop6_haut_in, pop6_bas_in, pop6_haut_out, pop6_bas_out,
		date_calcul, geom)
			SELECT
				s3_1a_sequana_seine_brevon.territoire,
				s3_1a_sequana_seine_brevon.type_alea,
				s3_1a_sequana_seine_brevon.code_occurrence,
				''Commune'' AS type_result,
				com.insee_com AS id_geom,
				s3_1a_sequana_seine_brevon.nom_commune,
				''indéterminé''::varchar(30) as loc_zx,

				ROUND(COALESCE(SUM(s3_1a_sequana_seine_brevon.pop1) FILTER (WHERE s3_1a_sequana_seine_brevon.loc_zx = ''In''),0)::numeric,0),
				ROUND(COALESCE(SUM(s3_1a_sequana_seine_brevon.pop1) FILTER (WHERE s3_1a_sequana_seine_brevon.loc_zx = ''Out''),0)::numeric,0),

				ROUND(COALESCE(SUM(s3_1a_sequana_seine_brevon.pop2_haut) FILTER (WHERE s3_1a_sequana_seine_brevon.loc_zx = ''In''),0)::numeric,0),
				ROUND(COALESCE(SUM(s3_1a_sequana_seine_brevon.pop2_bas) FILTER (WHERE s3_1a_sequana_seine_brevon.loc_zx = ''In''),0)::numeric,0),
				ROUND(COALESCE(SUM(s3_1a_sequana_seine_brevon.pop2_haut) FILTER (WHERE s3_1a_sequana_seine_brevon.loc_zx = ''Out''),0)::numeric,0),
				ROUND(COALESCE(SUM(s3_1a_sequana_seine_brevon.pop2_bas) FILTER (WHERE s3_1a_sequana_seine_brevon.loc_zx = ''Out''),0)::numeric,0),

				ROUND(COALESCE(SUM(s3_1a_sequana_seine_brevon.pop6_haut) FILTER (WHERE s3_1a_sequana_seine_brevon.loc_zx = ''In''),0)::numeric,0),
				ROUND(COALESCE(SUM(s3_1a_sequana_seine_brevon.pop6_bas) FILTER (WHERE s3_1a_sequana_seine_brevon.loc_zx = ''In''),0)::numeric,0),
				ROUND(COALESCE(SUM(s3_1a_sequana_seine_brevon.pop6_haut) FILTER (WHERE s3_1a_sequana_seine_brevon.loc_zx = ''Out''),0)::numeric,0),
				ROUND(COALESCE(SUM(s3_1a_sequana_seine_brevon.pop6_bas) FILTER (WHERE s3_1a_sequana_seine_brevon.loc_zx = ''Out''),0)::numeric,0),

				s3_1a_sequana_seine_brevon.date_calcul AS date_calcul,
				com.geom
			FROM p_indicateurs.s3_1a_sequana_seine_brevon
			RIGHT JOIN commune_' || an_bdtopo || ' AS com
			ON s3_1a_sequana_seine_brevon.id_commune = com.insee_com
			WHERE s3_1a_sequana_seine_brevon.territoire = ''' || nom_ter || '''
			GROUP BY s3_1a_sequana_seine_brevon.territoire, s3_1a_sequana_seine_brevon.type_alea, s3_1a_sequana_seine_brevon.code_occurrence, type_result, id_geom, s3_1a_sequana_seine_brevon.nom_commune, s3_1a_sequana_seine_brevon.date_calcul, com.geom
			';

	--************************************************************************
	-- Récupère le nombre d'entités ajoutées
	--************************************************************************
	GET DIAGNOSTICS c = row_count;

	--************************************************************************
	-- Conclusion
	--************************************************************************
	RAISE NOTICE '';
	RAISE NOTICE '====== FIN TRAITEMENT ======';
	RAISE NOTICE '[INFO] La table s3_1a_rc_sequana_seine_brevon (représentation carto de l''indicateur sous forme d''hexagones + autres géométries administratives) a été mise à jour dans le schéma p_rep_carto pour le territoire ''%''', nom_ter;
	RAISE NOTICE '';
	RAISE NOTICE '====== RESULTATS ======';
	RAISE NOTICE '% entités ajoutées pour le territoire ''%'' dans p_rep_carto.s3_1a_rc_sequana_seine_brevon', c, nom_ter;
	RAISE NOTICE 'Création de la vue "%"', 'p_rep_carto.s3_1a_rc_sequana_seine_brevon';
	heure2 = clock_timestamp();
	RAISE NOTICE 'Fin du traitement : %', heure2;
	RAISE NOTICE 'Durée du traitement : %', CAST(heure2 as time)-CAST(heure1 as time);
	RAISE NOTICE '';

END;
$function$
