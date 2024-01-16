SET client_encoding = 'UTF8';

CREATE OR REPLACE FUNCTION public.__indic_logt_zx(nom_ter text, typ_alea text, code_occ text, an_bdtopo text)
 RETURNS void
 LANGUAGE plpgsql
AS $function$

-- Fonction SQL d'incrémentation de la table p_indicateurs.logt_zx "Nombre de logements en zone inondable"
-- © Cerema / GT AgiRisk (auteure principale du script : Lucie)
-- Dernières mises à jour du script le 19/04/2023 par Lucie et le 25/08/2023 par Sébastien (test avec succès sur Longuyon le 24/08/2023)

-- Paramètres d'entrée :
-- nom_ter = nom du territoire d'étude tel que renseigné dans le champ `territoire` de la table c_general.territoires
-- typ_alea : type d'aléa considéré (ex : débordement de cours d'eau, submersion marine)
-- code_occ : période de retour considérée pour le type d'aléa choisi (ex : QRef, Q100, Q10)
-- an_bdtopo = millésime (année au format AAAA) de la BD TOPO®

-- Exemple d'appel à cette fonction :
-- SELECT public.__indic_logt_zx('Jura', 'débordement de cours d''eau', 'QRef', '2022');

DECLARE
	c_in integer; -- un compteur des lignes modifiées pour logging
	c_out integer; -- un compteur des lignes modifiées pour logging
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
	RAISE NOTICE 'Calcul de l''indicateur logt_zx (nombre de logements en zone inondable) sur le territoire "%" pour l''aléa "% - %"', nom_ter, typ_alea, code_occ;
	RAISE NOTICE '[INFO] Calcul basé sur les variables oc1 et zx disponibles dans la base de données';
	RAISE NOTICE 'Début du traitement : %', heure1;

	--************************************************************************
	-- Vérification de l'existence du territoire renseigné dans la table c_general.territoires
	--************************************************************************
	IF NOT EXISTS (
		SELECT *
		FROM c_general.territoires
		WHERE territoire = ''||nom_ter||''
	)
	THEN
		RAISE EXCEPTION 'Il n''y a pas de territoire "%" dans la table c_general.territoires. Fin de l''exécution', nom_ter;
	END IF;

	--************************************************************************
	-- Vérification de l'absence de données pour le territoire, le type d'aléa et l'occurrence de crue renseignés dans la table p_indicateurs.logt_zx
	--************************************************************************
	IF EXISTS (
		SELECT *
		FROM p_indicateurs.logt_zx
		WHERE territoire = ''||nom_ter||''
			AND type_alea = ''||typ_alea||''
			AND code_occurrence = ''||code_occ||''
	)
	THEN
		RAISE EXCEPTION 'Il existe déjà des enregistrements pour le territoire "%" avec l''aléa "% - %" dans la table p_indicateurs.logt_zx. 
		Pour les supprimer, lancer la requête suivante : 
		DELETE FROM p_indicateurs.logt_zx WHERE territoire = ''%'' AND type_alea = ''%'' AND code_occurrence = ''%'';', nom_ter, typ_alea, code_occ, REPLACE(nom_ter,'''',''''''), REPLACE(typ_alea,'''',''''''), REPLACE(code_occ,'''','''''');
	END IF;

	--************************************************************************
	-- ÉTAPE 1 : Croisement des bâtiments (Oc1) avec la zone inondable (Zx) sur le territoire d'étude
	--************************************************************************
	RAISE NOTICE '';
	-- 1a. Logements en zone inondable (In)
	RAISE NOTICE 'Etape 1a : récupération des logements en zone inondable sur le territoire "%" pour l''aléa "% - %"', nom_ter, typ_alea, code_occ;
	EXECUTE 'INSERT INTO p_indicateurs.logt_zx (
			territoire,
			id_iris,
			nom_iris,
			id_bdt,
			nb_logts,
			loc_zx,
			type_alea,
			code_occurrence,
			sce_donnee,
			moda_calc,
			date_calc,
			geom,
			geomloc
		)
		SELECT DISTINCT
			oc1.territoire,
			oc1.id_iris,
			oc1.nom_iris,
			oc1.id_bdt,
			oc1.nb_logts_corr,
			''In'',
			zx.type_alea,
			zx.code_occurrence,
			oc1.sce_donnee,
			''__indic_logt_zx'',
			current_date,
			oc1.geom,
			oc1.geomloc
		FROM oc1
		JOIN zx
		ON ST_Intersects(oc1.geom, zx.geom)
		WHERE __util_to_snake_case(oc1.territoire) = '''||__util_to_snake_case(nom_ter)||'''
			AND __util_to_snake_case(zx.territoire) = '''||__util_to_snake_case(nom_ter)||'''
			AND __util_to_snake_case(zx.type_alea) = '''||__util_to_snake_case(typ_alea)||'''
			AND __util_to_snake_case(zx.code_occurrence) = '''||__util_to_snake_case(code_occ)||'''
			AND oc1.oc2 is true
		';

	-- Récupération du nombre d'entités ajoutées
	GET DIAGNOSTICS c_in = row_count; -- nombre de logements en zone inondable insérés dans la table

	-- 1b. Logements hors zone inondable (Out)
	RAISE NOTICE 'Etape 1b : insertion des logements qui se trouvent en dehors de la zone inondable (Zx) sur le territoire "%" pour l''aléa "% - %"', nom_ter, typ_alea, code_occ;
	EXECUTE 'INSERT INTO p_indicateurs.logt_zx (
			territoire,
			id_iris,
			nom_iris,
			id_bdt,
			nb_logts,
			loc_zx,
			type_alea,
			code_occurrence,
			sce_donnee,
			moda_calc,
			date_calc,
			geom,
			geomloc
		)
		SELECT DISTINCT
			oc1.territoire,
			oc1.id_iris,		
			oc1.nom_iris,
			oc1.id_bdt,
			oc1.nb_logts_corr,
			''Out'',
			'''||REPLACE(typ_alea,'''','''''')||''' as alea,
			'''||REPLACE(code_occ,'''','''''')||''' as occ,
			oc1.sce_donnee,
			''__indic_logt_zx'',
			current_date,
			oc1.geom,
			oc1.geomloc
		FROM oc1
		WHERE __util_to_snake_case(oc1.territoire) = '''||__util_to_snake_case(nom_ter)||'''
			AND oc1.id_bdt NOT IN
				(
				SELECT id_bdt
				FROM logt_zx
				WHERE loc_zx = ''In''
					AND __util_to_snake_case(territoire) = '''||__util_to_snake_case(nom_ter)||'''
					AND __util_to_snake_case(type_alea) = '''||__util_to_snake_case(typ_alea)||'''
					AND __util_to_snake_case(code_occurrence) = '''||__util_to_snake_case(code_occ)||'''
				)
			AND oc1.oc2 is true
		';

	-- Récupération du nombre d'entités ajoutées
	GET DIAGNOSTICS c_out = row_count; -- nombre de logements hors zone inondable insérés dans la table

	--************************************************************************
	-- ÉTAPE 2 : Attribution des codes et des noms de périmètres
	--************************************************************************
	RAISE NOTICE 'Etape 2 : attribution des codes et des noms de périmètres';

	-- 2a. Attribution des codes INSEE et noms de communes
		EXECUTE '
			UPDATE p_indicateurs.logt_zx
			SET id_commune = com.insee_com, nom_commune = com.nom
			FROM c_phenomenes.zt, commune_'||an_bdtopo||' AS com
			WHERE __util_to_snake_case(logt_zx.territoire) = '''||__util_to_snake_case(nom_ter)||'''
				AND __util_to_snake_case(logt_zx.type_alea) = '''||__util_to_snake_case(typ_alea)||'''
				AND __util_to_snake_case(logt_zx.code_occurrence) = '''||__util_to_snake_case(code_occ)||'''
				AND __util_to_snake_case(zt.territoire) = '''||__util_to_snake_case(nom_ter)||'''
				AND logt_zx.id_iris = zt.id_iris
				AND zt.id_commune = com.insee_com';

	-- 2b. Attribution des codes et noms EPCI
		EXECUTE '
			UPDATE p_indicateurs.logt_zx
			SET id_epci = epci.code_siren, nom_epci = epci.nom
			FROM c_phenomenes.zt, epci_'||an_bdtopo||' AS epci
			WHERE __util_to_snake_case(logt_zx.territoire) = '''||__util_to_snake_case(nom_ter)||'''
				AND __util_to_snake_case(logt_zx.type_alea) = '''||__util_to_snake_case(typ_alea)||'''
				AND __util_to_snake_case(logt_zx.code_occurrence) = '''||__util_to_snake_case(code_occ)||'''
				AND __util_to_snake_case(zt.territoire) = '''||__util_to_snake_case(nom_ter)||'''
				AND logt_zx.id_iris = zt.id_iris
				AND zt.id_epci = epci.code_siren';

	--************************************************************************
	-- Conclusion
	--************************************************************************
	RAISE NOTICE '';
	RAISE NOTICE '====== FIN TRAITEMENT ======';
	RAISE NOTICE '[INFO] La table logt_zx (logements en zx) a été mise à jour dans le schéma p_indicateurs pour le territoire "%" et l''aléa "% - %"', nom_ter, typ_alea, code_occ;
	RAISE NOTICE '';
	RAISE NOTICE '====== RÉSULTATS ======';

	IF c_in+c_out > 1
		THEN RAISE NOTICE '% enregistrements insérés au total dans la table p_indicateurs.logt_zx pour le territoire "%" et l''aléa "% - %"', c_in+c_out, nom_ter, typ_alea, code_occ;
		ELSE RAISE NOTICE '% enregistrement inséré dans la table p_indicateurs.logt_zx pour le territoire "%" et l''aléa "% - %"', c_in+c_out, nom_ter, typ_alea, code_occ;
	END IF;

	RAISE NOTICE 'dont :';
	
		IF c_in > 1
			THEN RAISE NOTICE '- % logements en zone inondable', c_in;
			ELSE RAISE NOTICE '- % logement en zone inondable', c_in;
		END IF;
	
		IF c_out > 1
			THEN RAISE NOTICE '- % logements hors zone inondable', c_out;
			ELSE RAISE NOTICE '- % logement hors zone inondable', c_out;
		END IF;

	RAISE NOTICE '';
	heure2 = clock_timestamp();
	RAISE NOTICE 'Fin du traitement : %', heure2;
	RAISE NOTICE 'Durée du traitement : %', CAST(heure2 as time)-CAST(heure1 as time);
	RAISE NOTICE '';

END;
$function$
