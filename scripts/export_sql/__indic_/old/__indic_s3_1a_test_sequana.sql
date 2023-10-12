CREATE OR REPLACE FUNCTION public.__indic_s3_1a_test_sequana(nom_ter text, an_bdtopo text, type_alea text, code_occ text)
 RETURNS void
 LANGUAGE plpgsql
AS $function$

-- Fonction SQL d'incrémentation de la table p_indicateurs.s3_1a_sequana_seine_brevon "Occupants en zone inondable sur le territoire Sequana - secteurs Seine et Brevon"
-- Copyright Cerema / GT AgiRisk
-- Auteur du script : Sébastien

-- Exemple d'appel à cette fonction : SELECT public.__indic_s3_1a_test_sequana('Sequana Seine et Brevon', '2022', 'débordement de cours d''''eau', 'T2');

DECLARE
	c integer; -- un compteur des lignes modifiées pour logging
	heure1 varchar; -- heure de début du traitement
	heure2 varchar; -- heure de fin du traitement

BEGIN
	heure1 = current_timestamp;
	
	--************************************************************************
	-- Définition des schémas de travail
	--************************************************************************
    SET search_path TO p_indicateurs, c_general, c_phenomenes, c_occupation_sol, r_ign_bdtopo, public;

    RAISE NOTICE '';
    RAISE NOTICE '====== RAPPORT ======';
    RAISE NOTICE 'Calcul de l''indicateur S3/1a (nombre et proportion de personnes en zone inondable) sur le territoire "%" pour l''aléa %', nom_ter, code_occ;
	RAISE NOTICE '[RAPPEL] Calcul basé sur les variables oc1 et zx disponibles dans la base de données';
    RAISE NOTICE 'Début du traitement : %', heure1;

    --************************************************************************
    -- Vérification de l'existence du territoire renseigné dans la table des territoires (c_general.territoires)
    --************************************************************************
    IF NOT EXISTS(
        SELECT *
        FROM territoires
        WHERE territoire = nom_ter
    )
    THEN
        RAISE EXCEPTION 'Il n''y a pas de territoire ''%'' dans la table c_general.territoires. Fin de l''exécution', nom_ter;
    END IF;

    --************************************************************************
    -- Vérification de l'absence dans la table p_indicateurs.s3_1a_sequana_seine_brevon à la fois du territoire et de l'occurrence de crue renseignés
	--************************************************************************
	IF EXISTS(
		SELECT *
		FROM s3_1a_sequana_seine_brevon
		WHERE territoire = nom_ter
		AND code_occurrence = code_occ
	)
	THEN
		RAISE EXCEPTION 'Il existe déjà des enregistrements pour le territoire ''%'' avec l''aléa ''%'' dans la table p_indicateurs.s3_1a_sequana_seine_brevon. Pour les supprimer, lancer la requête suivante : DELETE FROM p_indicateurs.s3_1a_sequana_seine_brevon WHERE territoire = ''%'' AND code_occurrence = ''%'';', nom_ter, code_occ, nom_ter, code_occ;
	END IF;
	
	--************************************************************************
	-- A) Croisement des bâtiments (Oc1) avec la zone inondable (Zx) sur le territoire d'étude
	--************************************************************************
	RAISE NOTICE '';
	RAISE NOTICE '====== Récupération des géométries et affectation des noms de périmètres de calcul ======';
	RAISE NOTICE 'Etape 1a : récupération des bâtiments inondables, avec occupants, sur le territoire ''%'' pour l''aléa ''%''', nom_ter, code_occ;
  
	EXECUTE 'INSERT INTO p_indicateurs.s3_1a_sequana_seine_brevon(id_bdt, territoire, id_iris, nom_iris, loc_zx, code_occurrence, type_alea, date_calcul, modalite_calcul, pop1, pop2_haut, pop2_bas, pop6_haut, pop6_bas, geom, geomloc)
	SELECT
		oc1.id_bdt,
		oc1.territoire,
		oc1.id_iris,
		oc1.nom_iris,
		''In'',
		zx.code_occurrence,
		zx.type_alea,
		current_date AS date_calcul,
		''__indic_s3_1a_sequana_seine_brevon''::varchar(50) AS modalite_calcul,
		ROUND(oc1.pop1::numeric,4),
		ROUND(oc1.pop2_haut::numeric,4),
		ROUND(oc1.pop2_bas::numeric,4),
		ROUND(oc1.pop6_haut::numeric,4),
		ROUND(oc1.pop6_bas::numeric,4),
		oc1.geom,
		oc1.geomloc
	FROM oc1
	JOIN zx
	ON ST_Intersects(oc1.geom, zx.geom)
	WHERE oc1.territoire = ''' || nom_ter || '''
		AND zx.code_occurrence IN (''' || code_occ || ''')
		AND zx.type_alea IN (''' || type_alea || ''')
	';

	RAISE NOTICE '';
	RAISE NOTICE 'Etape 1b : insertion des bâtiments avec occupants qui se trouvent en dehors de la zone inondable (Zx) sur le territoire ''%'' pour l''aléa ''%''', nom_ter, code_occ;

	EXECUTE 'INSERT INTO p_indicateurs.s3_1a_sequana_seine_brevon(id_bdt, territoire, id_iris, nom_iris, loc_zx, code_occurrence, type_alea, date_calcul, modalite_calcul, pop1, pop2_haut, pop2_bas, pop6_haut, pop6_bas, geom, geomloc)
	SELECT
		oc1.id_bdt,
		oc1.territoire,
		oc1.id_iris,
		oc1.nom_iris,
		''Out'',
		''' || code_occ || ''',
		''' || type_alea || ''',
		current_date AS date_calcul,
		''__indic_s3_1a_sequana_seine_brevon''::varchar(50) AS modalite_calcul,
		ROUND(oc1.pop1::numeric,4),
		ROUND(oc1.pop2_haut::numeric,4),
		ROUND(oc1.pop2_bas::numeric,4),
		ROUND(oc1.pop6_haut::numeric,4),
		ROUND(oc1.pop6_bas::numeric,4),
		oc1.geom,
		oc1.geomloc
	FROM oc1
	WHERE oc1.territoire = ''' || nom_ter || '''
		AND oc1.id_bdt NOT IN (
								SELECT id_bdt FROM s3_1a_sequana_seine_brevon
								WHERE loc_zx = ''In''
									AND territoire = ''' || nom_ter || '''
									AND code_occurrence IN (''' || code_occ || ''')
									AND type_alea IN (''' || type_alea || ''')
								)
	';
	
	--************************************************************************
	-- B) Attribution des codes et des noms de périmètres
	--************************************************************************
	RAISE NOTICE '';
	RAISE NOTICE 'Etape 2 : attribution des codes et des noms de périmètres';
	-- 2a. Attribution des codes INSEE et noms de communes
		EXECUTE '
			UPDATE p_indicateurs.s3_1a_sequana_seine_brevon
			SET id_commune = com.insee_com, nom_commune = com.nom
			FROM c_phenomenes.zt, commune_' || an_bdtopo || ' AS com
			WHERE s3_1a_sequana_seine_brevon.id_iris = zt.id_iris
			AND zt.id_commune = com.insee_com';
			
	-- 2b. Attribution des codes et noms EPCI
		EXECUTE '
			UPDATE p_indicateurs.s3_1a_sequana_seine_brevon
			SET id_epci = epci.code_siren, nom_epci = epci.nom
			FROM c_phenomenes.zt, epci_' || an_bdtopo || ' AS epci
			WHERE s3_1a_sequana_seine_brevon.id_iris = zt.id_iris
			AND zt.id_epci = epci.code_siren';

	--************************************************************************
	-- Récupère le nombre d'entités ajoutées
	--************************************************************************
	GET DIAGNOSTICS c = row_count;

	--************************************************************************
	-- Conclusion
	--************************************************************************
	RAISE NOTICE '';
	RAISE NOTICE '====== FIN TRAITEMENT ======';
	RAISE NOTICE '[INFO] La table s3_1a_sequana_seine_brevon (occupants en zx) a été mise à jour dans le schéma p_indicateurs pour le territoire ''%'' et l''aléa ''%''', nom_ter, code_occ;
	RAISE NOTICE '';
	RAISE NOTICE '====== RESULTATS ======';
	RAISE NOTICE '% entités ajoutées pour le territoire ''%'' et l''aléa ''%'' % dans p_indicateurs.s3_1a_sequana_seine_brevon', c, nom_ter, code_occ, type_alea;
	heure2 = clock_timestamp();
	RAISE NOTICE 'Fin du traitement : %', heure2;
	RAISE NOTICE 'Durée du traitement : %', CAST(heure2 as time)-CAST(heure1 as time);
	RAISE NOTICE '';

END;
$function$
