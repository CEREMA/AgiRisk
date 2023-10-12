SET client_encoding = 'UTF8';

CREATE OR REPLACE FUNCTION public.__indic_s2_6a(nom_ter text, typ_alea text, code_occ text, an_fct_dmg text, an_bdtopo text)
 RETURNS void
 LANGUAGE plpgsql
AS $function$

-- Fonction SQL d'incrémentation de la table p_indicateurs.s2_6a "Montant des dommages aux cultures"
-- © Cerema / GT AgiRisk (auteure principale du script : Tiffany)
-- Dernières mises à jour du script le 13/04/2023 par Lucie et le 25/08/2023 par Sébastien (test avec succès sur Longuyon le 24/08/2023)

-- Paramètres d'entrée :
-- nom_ter = nom du territoire d'étude tel que renseigné dans le champ `territoire` de la table c_general.territoires
-- typ_alea : type d'aléa considéré (ex : débordement de cours d'eau, submersion marine)
-- code_occ : période de retour considérée pour le type d'aléa choisi (ex : QRef, Q100, Q10)
-- an_fct_dmg : année (au format AAAA) d'actualisation des coûts dans les fonctions de dommages (dans l'objectif de suivi de l'évolution des coûts de dommages selon l'inflation)
-- an_bdtopo = millésime (année au format AAAA) de la BD TOPO®

-- Exemple d'appel à cette fonction :
-- SELECT public.__indic_s2_6a('Jura', 'débordement de cours d''eau', 'QRef', '2022', '2022');

DECLARE
	c integer; -- un compteur des lignes modifiées pour logging
	heure1 varchar; -- heure de début du traitement
	heure2 varchar; -- heure de fin du traitement
	-- zp_exists boolean; -- indique si des probabilités d'occurrence de crue par saison sont renseignées dans zp pour le territoire renseigné

BEGIN
	heure1 = clock_timestamp();
	
	--************************************************************************
	-- Définition des schémas de travail
	--************************************************************************
	SET search_path TO p_indicateurs, c_general, c_phenomenes, c_occupation_sol, public;

	RAISE NOTICE '';
	RAISE NOTICE '====== RAPPORT ======';
	RAISE NOTICE 'Calcul de l''indicateur s2/6a (dommages aux cultures en fonction de paramètres hydrauliques) sur le territoire "%" pour l''aléa "% - %" et l''année %', nom_ter, typ_alea, code_occ, an_fct_dmg;
	RAISE NOTICE '[INFO] Calcul basé sur la variable oc7, l''indicateur s3_1f et les couches d''aléas disponibles dans la base de données';
	RAISE NOTICE 'Début du traitement : %', heure1;

	--************************************************************************
	-- Vérification de l'existence du territoire renseigné dans la table des territoires (c_general.territoires)
	--************************************************************************
	IF NOT EXISTS(
		SELECT *
		FROM territoires
		WHERE territoire = ''||nom_ter||''
	)
	THEN
		RAISE EXCEPTION 'Il n''y a pas de territoire "%" dans la table c_general.territoires. Fin de l''exécution', nom_ter;
	END IF;

 	--************************************************************************
	-- Vérification de l'existence du territoire et de l'aléa renseignés dans la table public.s3_1f
	--************************************************************************
	IF NOT EXISTS(
		SELECT *
		FROM s3_1f
		WHERE s3_1f.territoire = ''||nom_ter||''
			AND type_alea = ''||typ_alea||''
			AND code_occurrence = ''||code_occ||''
	)
	THEN
		RAISE EXCEPTION 'Il n''y a pas de territoire "%" avec l''aléa "% - %" dans la table p_indicateurs.s3_1f. Veuillez d''abord calculer cet indicateur pour votre territoire et votre aléa. Fin de l''exécution', nom_ter, typ_alea, code_occ;
	END IF;

	--************************************************************************
	-- Vérification de l'absence de données pour le territoire, le type d'aléa, l'occurrence de crue et l'année d'actualisation des fonctions de dommages renseignés dans la table p_indicateurs.s2_6a
	--************************************************************************
	IF EXISTS(
		SELECT *
		FROM s2_6a
		WHERE territoire = ''||nom_ter||''
			AND type_alea = ''||typ_alea||''
			AND code_occurrence = ''||code_occ||''
			AND date_actu_cout_dmg = ''||an_fct_dmg||''
	)
	THEN
		RAISE EXCEPTION 'Il existe déjà des enregistrements en euros % pour le territoire "%" et l''aléa "% - %" dans la table p_indicateurs.s2_6a. 
		Pour les supprimer, lancer la requête suivante : 
		DELETE FROM p_indicateurs.s2_6a WHERE territoire = ''%'' AND type_alea = ''%'' AND code_occurrence = ''%'' AND date_actu_cout_dmg = ''%'';', an_fct_dmg, nom_ter, typ_alea, code_occ, REPLACE(nom_ter,'''',''''''), REPLACE(typ_alea,'''',''''''), REPLACE(code_occ,'''',''''''), REPLACE(an_fct_dmg,'''','''''');
	END IF;

	--************************************************************************
	-- A.1) Récupération des parcelles situées en zone inondable dans S3/1f
	--************************************************************************
	-- Création d'un geomloc sur le morceaux de parcelle découpés par la zone inondable (la forme des parcelles découpée fait qu'on avait des centroïdes hors des parcelles, ce qui donnait des données inondation à 0)
	RAISE NOTICE '';
	RAISE NOTICE 'Etape 1 : Récupération des parcelles en zone inondable et affectation d''une hauteur d''eau au centroïde';
	EXECUTE 'INSERT INTO p_indicateurs.s2_6a(
			territoire,
			id_iris,
			nom_iris,
			type_alea,
			code_occurrence,
			code_rpg,
			lib_culture,
			surf_parc,
			date_actu_cout_dmg,
			sce_donnee,
			moda_calc,
			date_calc,
			geom,
			geomloc
		)
		SELECT DISTINCT
			s3_1f.territoire,
			s3_1f.id_iris,
			s3_1f.nom_iris,
			s3_1f.type_alea,
			s3_1f.code_occurrence,
			s3_1f.code_rpg,
			s3_1f.lib_culture,
			ROUND(s3_1f.surf_parc,2),
			'||an_fct_dmg||' AS date_actu_cout_dmg,
			s3_1f.sce_donnee,
			''__indic_s2_6a''::varchar(50) AS moda_calc,
			current_date AS date_calc,
			s3_1f.geom AS geom,
			ST_PointOnSurface(s3_1f.geom)
		FROM s3_1f
		WHERE s3_1f.loc_zx=''In''
			AND __util_to_snake_case(s3_1f.territoire) = ''' ||__util_to_snake_case(nom_ter) || '''
			AND __util_to_snake_case(s3_1f.type_alea) IN (''' ||__util_to_snake_case(typ_alea) || ''')
			AND __util_to_snake_case(s3_1f.code_occurrence) IN (''' ||__util_to_snake_case(code_occ) || ''')
	';

	--************************************************************************
	-- A.2) Récupération des données hydrauliques
	--************************************************************************
	RAISE NOTICE '';
	RAISE NOTICE 'Etape 2 : Récupération des données hydrauliques';

	--************************************************************************
	-- Hauteurs d'eau min et max
	--************************************************************************
	-- Vérification de l'existence d'une table c_phenomenes.zh pour le territoire, le type d'aléa et l'occurrence de crue renseignés
	IF EXISTS(
		SELECT *
		FROM c_phenomenes.zh
		WHERE territoire = ''||nom_ter||''
			AND type_alea = ''||typ_alea||''
			AND code_occurrence = ''||code_occ||''
	)

	THEN -- Méthode de calcul avec couche Zh existante dans le schéma c_phenomenes
	RAISE NOTICE 'Table Zh existante pour le territoire "%" et l''aléa "% - %". Poursuite du traitement', nom_ter, typ_alea, code_occ;
	RAISE NOTICE 'Récupération des hauteurs d''eau minimum en un point du polygone';
	EXECUTE 'UPDATE p_indicateurs.s2_6a
		SET h_eau_min = zh.h_eau_min
		FROM zh
		WHERE ST_Intersects(s2_6a.geomloc,zh.geom)';	
	RAISE NOTICE 'Récupération des hauteurs d''eau maximum en un point du polygone';
	EXECUTE 'UPDATE p_indicateurs.s2_6a
		SET h_eau_max = zh.h_eau_max
		FROM zh
		WHERE ST_Intersects(s2_6a.geomloc,zh.geom)';
		-- Modification des '>200' en 999
		EXECUTE 'UPDATE p_indicateurs.s2_6a
			SET h_eau_max=(
			CASE h_eau_max WHEN ''>200'' THEN ''999''
			ELSE h_eau_max
			END)';

	ELSE -- Méthode de calcul avec couche Zq, en l'absence de couche Zh dans le schéma c_phenomenes
	RAISE NOTICE 'Aucune couche Zh n''est disponible pour le territoire "%" et l''aléa "% - %". Vérification de l''existence d''une couche Zq dans le schéma c_phenomenes', nom_ter, typ_alea, code_occ;
	-- Vérification de l'existence d'une table c_phenomenes.zq pour le territoire, le type d'aléa et l'occurrence de crue renseignés
	IF EXISTS(
		SELECT *
		FROM c_phenomenes.zq
		WHERE territoire = ''||nom_ter||''
			AND type_alea = ''||typ_alea||''
			AND code_occurrence = ''||code_occ||''
	)

	THEN -- Affectation de hauteurs d'eau arbitraires selon l'intensité d'aléa dans la couche Zq
   	RAISE NOTICE 'Table Zq existante pour le territoire "%" et l''aléa "% - %". Poursuite du traitement', nom_ter, typ_alea, code_occ;
	RAISE NOTICE 'Affectation des hauteurs d''eau minimum en un point du polygone selon le niveau d''aléa';
	EXECUTE 'UPDATE p_indicateurs.s2_6a
		SET h_eau_min =
			CASE
				WHEN zq.intensite_alea = ''faible'' THEN ''0''
				WHEN zq.intensite_alea = ''moyen'' THEN ''50''
				WHEN zq.intensite_alea = ''fort'' THEN ''100''
				WHEN zq.intensite_alea = ''très fort'' THEN ''200''
				ELSE h_eau_min
			END
		FROM zq
		WHERE ST_Intersects(s2_6a.geomloc,zq.geom)';
	RAISE NOTICE 'Affectation des hauteurs d''eau maximum en un point du polygone selon le niveau d''aléa';
	EXECUTE 'UPDATE p_indicateurs.s2_6a
		SET h_eau_max =
			CASE
				WHEN zq.intensite_alea = ''faible'' THEN ''50''
				WHEN zq.intensite_alea = ''moyen'' THEN ''100''
				WHEN zq.intensite_alea = ''fort'' THEN ''200''
				WHEN zq.intensite_alea = ''très fort'' THEN ''999''
				ELSE h_eau_max
			END
		FROM zq
		WHERE ST_Intersects(s2_6a.geomloc,zq.geom)';
	
	ELSE RAISE NOTICE 'Aucune couche Zh ou Zq n''est disponible pour le territoire "%" et l''aléa "% - %" dans le schéma c_phenomenes. Fin de l''exécution', nom_ter, typ_alea, code_occ;
	END IF;
	END IF;

	--************************************************************************
	-- Vitesse de courant
	--************************************************************************
 	RAISE NOTICE 'Attribution d''une vitesse de courant arbitraire faible';
	EXECUTE 'UPDATE p_indicateurs.s2_6a 
		SET vitesse= ''faible''';

	--************************************************************************
	-- Durée de submersion
	--************************************************************************
	RAISE NOTICE 'Attribution d''une durée de submersion arbitraire longue';
	EXECUTE 'UPDATE p_indicateurs.s2_6a 
		SET duree_sub=''longue''';

	RAISE NOTICE '';
	RAISE NOTICE 'Etapes 1 et 2 terminées : les parcelles en zone inondable ont bien été insérées dans la table s2/6a sur le territoire "%" pour l''aléa "% - %"', nom_ter, typ_alea, code_occ;

	--************************************************************************
	-- A.3) Calcul du coût des dommages à la parcelle découpée par la zone inondable
	--************************************************************************
	RAISE NOTICE '';
	RAISE NOTICE 'Etape 3 : Calcul du coût des dommages à la parcelle découpée par la zone inondable';

	--************************************************************************
	-- Printemps
	--************************************************************************
	RAISE NOTICE 'Calcul du coût des dommages au printemps';
	EXECUTE 'UPDATE p_indicateurs.s2_6a
		SET ct_domm_prin =
			(WITH temp as(
			SELECT
				a.id,
				CASE
					WHEN a.code_rpg::integer=1 AND a.date_actu_cout_dmg='''||an_fct_dmg||''' THEN a.surf_parc*b.ble_tendre
					WHEN a.code_rpg::integer=2 AND a.date_actu_cout_dmg='''||an_fct_dmg||''' THEN a.surf_parc*b.mais_grain_et_ensilage
					WHEN a.code_rpg::integer=3 AND a.date_actu_cout_dmg='''||an_fct_dmg||''' THEN a.surf_parc*b.orge
					WHEN a.code_rpg::integer IN(4,14) AND a.date_actu_cout_dmg='''||an_fct_dmg||''' THEN a.surf_parc*b.autres_cereales
					WHEN a.code_rpg::integer=5 AND a.date_actu_cout_dmg='''||an_fct_dmg||''' THEN a.surf_parc*b.colza
					WHEN a.code_rpg::integer=6 AND a.date_actu_cout_dmg='''||an_fct_dmg||''' THEN a.surf_parc*b.tournesol
					WHEN a.code_rpg::integer=7 AND a.date_actu_cout_dmg='''||an_fct_dmg||''' THEN a.surf_parc*b.autres_oleagineux
					WHEN a.code_rpg::integer IN (8,9,15,24,26,28) AND a.date_actu_cout_dmg='''||an_fct_dmg||''' THEN a.surf_parc*b.autres_cultures_industrielles
					WHEN a.code_rpg::integer=16 AND a.date_actu_cout_dmg='''||an_fct_dmg||''' THEN a.surf_parc*b.fourrage
					WHEN a.code_rpg::integer=18 AND a.date_actu_cout_dmg='''||an_fct_dmg||''' THEN a.surf_parc*b.prairies_permanentes
					WHEN a.code_rpg::integer=19 AND a.date_actu_cout_dmg='''||an_fct_dmg||''' THEN a.surf_parc*b.prairies_temporaires
					WHEN a.code_rpg::integer IN(20,22,23) AND a.date_actu_cout_dmg='''||an_fct_dmg||''' THEN a.surf_parc*b.arboriculture_et_vergers
					WHEN a.code_rpg::integer=25 AND a.date_actu_cout_dmg='''||an_fct_dmg||''' THEN a.surf_parc*b.autres_cereales
					WHEN a.code_rpg::integer=4 AND a.date_actu_cout_dmg='''||an_fct_dmg||''' THEN a.surf_parc*b.legumes_fleurs
					ELSE p_indicateurs.s2_6a.ct_domm_prin
				END AS dommage
			FROM p_indicateurs.s2_6a a,r_inrae_amc.fct_dmg_agri_'||an_fct_dmg||' b
			WHERE ((a.h_eau_max::integer+a.h_eau_min::integer)/2)>b.h_eau_min 
				AND ((a.h_eau_max::integer+a.h_eau_min::integer)/2)<=b.h_eau_max
				AND a.vitesse=b.vitesse_courant
				AND a.duree_sub=b.duree_submersion
				AND b.saison=''printemps''
				AND b.alea=''fluvial'')
		SELECT dommage
		FROM temp
		WHERE s2_6a.id = temp.id)';

	--************************************************************************
	-- Été
	--************************************************************************
	RAISE NOTICE 'Calcul du coût des dommages à l''été';
	EXECUTE 'UPDATE p_indicateurs.s2_6a
		SET ct_domm_ete =
			(WITH temp as(
			SELECT
				a.id,
				CASE
					WHEN a.code_rpg::integer=1 AND a.date_actu_cout_dmg='''||an_fct_dmg||''' THEN a.surf_parc*b.ble_tendre
					WHEN a.code_rpg::integer=2 AND a.date_actu_cout_dmg='''||an_fct_dmg||''' THEN a.surf_parc*b.mais_grain_et_ensilage
					WHEN a.code_rpg::integer=3 AND a.date_actu_cout_dmg='''||an_fct_dmg||''' THEN a.surf_parc*b.orge
					WHEN a.code_rpg::integer IN(4,14) AND a.date_actu_cout_dmg='''||an_fct_dmg||''' THEN a.surf_parc*b.autres_cereales
					WHEN a.code_rpg::integer=5 AND a.date_actu_cout_dmg='''||an_fct_dmg||''' THEN a.surf_parc*b.colza
					WHEN a.code_rpg::integer=6 AND a.date_actu_cout_dmg='''||an_fct_dmg||''' THEN a.surf_parc*b.tournesol
					WHEN a.code_rpg::integer=7 AND a.date_actu_cout_dmg='''||an_fct_dmg||''' THEN a.surf_parc*b.autres_oleagineux
					WHEN a.code_rpg::integer IN (8,9,15,24,26,28) AND a.date_actu_cout_dmg='''||an_fct_dmg||''' THEN a.surf_parc*b.autres_cultures_industrielles
					WHEN a.code_rpg::integer=16 AND a.date_actu_cout_dmg='''||an_fct_dmg||''' THEN a.surf_parc*b.fourrage
					WHEN a.code_rpg::integer=18 AND a.date_actu_cout_dmg='''||an_fct_dmg||''' THEN a.surf_parc*b.prairies_permanentes
					WHEN a.code_rpg::integer=19 AND a.date_actu_cout_dmg='''||an_fct_dmg||''' THEN a.surf_parc*b.prairies_temporaires
					WHEN a.code_rpg::integer IN(20,22,23) AND a.date_actu_cout_dmg='''||an_fct_dmg||''' THEN a.surf_parc*b.arboriculture_et_vergers
					WHEN a.code_rpg::integer=25 AND a.date_actu_cout_dmg='''||an_fct_dmg||''' THEN a.surf_parc*b.autres_cereales
					WHEN a.code_rpg::integer=4 AND a.date_actu_cout_dmg='''||an_fct_dmg||''' THEN a.surf_parc*b.legumes_fleurs
					ELSE p_indicateurs.s2_6a.ct_domm_prin
				END AS dommage
			FROM p_indicateurs.s2_6a a,r_inrae_amc.fct_dmg_agri_'||an_fct_dmg||' b
			WHERE ((a.h_eau_max::integer+a.h_eau_min::integer)/2)>b.h_eau_min 
			AND ((a.h_eau_max::integer+a.h_eau_min::integer)/2)<=b.h_eau_max
			AND a.vitesse=b.vitesse_courant
			AND a.duree_sub=b.duree_submersion
			AND b.saison=''été''
			AND b.alea=''fluvial'')
		SELECT dommage
		FROM temp
		WHERE s2_6a.id = temp.id)';

	--************************************************************************
	-- Automne
	--************************************************************************
	RAISE NOTICE 'Calcul du coût des dommages à l''automne';
	EXECUTE 'UPDATE p_indicateurs.s2_6a
		SET ct_domm_aut =
			(WITH temp as(
			SELECT
				a.id,
				CASE
					WHEN a.code_rpg::integer=1 AND a.date_actu_cout_dmg='''||an_fct_dmg||''' THEN a.surf_parc*b.ble_tendre
					WHEN a.code_rpg::integer=2 AND a.date_actu_cout_dmg='''||an_fct_dmg||''' THEN a.surf_parc*b.mais_grain_et_ensilage
					WHEN a.code_rpg::integer=3 AND a.date_actu_cout_dmg='''||an_fct_dmg||''' THEN a.surf_parc*b.orge
					WHEN a.code_rpg::integer IN(4,14) AND a.date_actu_cout_dmg='''||an_fct_dmg||''' THEN a.surf_parc*b.autres_cereales
					WHEN a.code_rpg::integer=5 AND a.date_actu_cout_dmg='''||an_fct_dmg||''' THEN a.surf_parc*b.colza
					WHEN a.code_rpg::integer=6 AND a.date_actu_cout_dmg='''||an_fct_dmg||''' THEN a.surf_parc*b.tournesol
					WHEN a.code_rpg::integer=7 AND a.date_actu_cout_dmg='''||an_fct_dmg||''' THEN a.surf_parc*b.autres_oleagineux
					WHEN a.code_rpg::integer IN (8,9,15,24,26,28) AND a.date_actu_cout_dmg='''||an_fct_dmg||''' THEN a.surf_parc*b.autres_cultures_industrielles
					WHEN a.code_rpg::integer=16 AND a.date_actu_cout_dmg='''||an_fct_dmg||''' THEN a.surf_parc*b.fourrage
					WHEN a.code_rpg::integer=18 AND a.date_actu_cout_dmg='''||an_fct_dmg||''' THEN a.surf_parc*b.prairies_permanentes
					WHEN a.code_rpg::integer=19 AND a.date_actu_cout_dmg='''||an_fct_dmg||''' THEN a.surf_parc*b.prairies_temporaires
					WHEN a.code_rpg::integer IN(20,22,23) AND a.date_actu_cout_dmg='''||an_fct_dmg||''' THEN a.surf_parc*b.arboriculture_et_vergers
					WHEN a.code_rpg::integer=25 AND a.date_actu_cout_dmg='''||an_fct_dmg||''' THEN a.surf_parc*b.autres_cereales
					WHEN a.code_rpg::integer=4 AND a.date_actu_cout_dmg='''||an_fct_dmg||''' THEN a.surf_parc*b.legumes_fleurs
					ELSE p_indicateurs.s2_6a.ct_domm_prin
				END AS dommage
			FROM p_indicateurs.s2_6a a,r_inrae_amc.fct_dmg_agri_'||an_fct_dmg||' b
			WHERE ((a.h_eau_max::integer+a.h_eau_min::integer)/2)>b.h_eau_min 
			AND ((a.h_eau_max::integer+a.h_eau_min::integer)/2)<=b.h_eau_max
			AND a.vitesse=b.vitesse_courant
			AND a.duree_sub=b.duree_submersion
			AND b.saison=''automne''
			AND b.alea=''fluvial'')
		SELECT dommage
		FROM temp
		WHERE s2_6a.id = temp.id)';

	--************************************************************************
	-- Hiver
	--************************************************************************
	RAISE NOTICE 'Calcul du coût des dommages à l''hiver';
	EXECUTE 'UPDATE p_indicateurs.s2_6a
		SET ct_domm_hiv =
			(WITH temp as(
			SELECT
				a.id,
				CASE
					WHEN a.code_rpg::integer=1 AND a.date_actu_cout_dmg='''||an_fct_dmg||''' THEN a.surf_parc*b.ble_tendre
					WHEN a.code_rpg::integer=2 AND a.date_actu_cout_dmg='''||an_fct_dmg||''' THEN a.surf_parc*b.mais_grain_et_ensilage
					WHEN a.code_rpg::integer=3 AND a.date_actu_cout_dmg='''||an_fct_dmg||''' THEN a.surf_parc*b.orge
					WHEN a.code_rpg::integer IN(4,14) AND a.date_actu_cout_dmg='''||an_fct_dmg||''' THEN a.surf_parc*b.autres_cereales
					WHEN a.code_rpg::integer=5 AND a.date_actu_cout_dmg='''||an_fct_dmg||''' THEN a.surf_parc*b.colza
					WHEN a.code_rpg::integer=6 AND a.date_actu_cout_dmg='''||an_fct_dmg||''' THEN a.surf_parc*b.tournesol
					WHEN a.code_rpg::integer=7 AND a.date_actu_cout_dmg='''||an_fct_dmg||''' THEN a.surf_parc*b.autres_oleagineux
					WHEN a.code_rpg::integer IN (8,9,15,24,26,28) AND a.date_actu_cout_dmg='''||an_fct_dmg||''' THEN a.surf_parc*b.autres_cultures_industrielles
					WHEN a.code_rpg::integer=16 AND a.date_actu_cout_dmg='''||an_fct_dmg||''' THEN a.surf_parc*b.fourrage
					WHEN a.code_rpg::integer=18 AND a.date_actu_cout_dmg='''||an_fct_dmg||''' THEN a.surf_parc*b.prairies_permanentes
					WHEN a.code_rpg::integer=19 AND a.date_actu_cout_dmg='''||an_fct_dmg||''' THEN a.surf_parc*b.prairies_temporaires
					WHEN a.code_rpg::integer IN(20,22,23) AND a.date_actu_cout_dmg='''||an_fct_dmg||''' THEN a.surf_parc*b.arboriculture_et_vergers
					WHEN a.code_rpg::integer=25 AND a.date_actu_cout_dmg='''||an_fct_dmg||''' THEN a.surf_parc*b.autres_cereales
					WHEN a.code_rpg::integer=4 AND a.date_actu_cout_dmg='''||an_fct_dmg||''' THEN a.surf_parc*b.legumes_fleurs
					ELSE p_indicateurs.s2_6a.ct_domm_prin
				END AS dommage
			FROM p_indicateurs.s2_6a a,r_inrae_amc.fct_dmg_agri_'||an_fct_dmg||' b
			WHERE ((a.h_eau_max::integer+a.h_eau_min::integer)/2)>b.h_eau_min 
			AND ((a.h_eau_max::integer+a.h_eau_min::integer)/2)<=b.h_eau_max
			AND a.vitesse=b.vitesse_courant
			AND a.duree_sub=b.duree_submersion
			AND b.saison=''hiver''
			AND b.alea=''fluvial'')
		SELECT dommage
		FROM temp
		WHERE s2_6a.id = temp.id)';

	--************************************************************************
	-- Dommages annuels
	--************************************************************************
	/* Calcul du coût des dommages annuels basé sur les proba d'occurrence des crues. 
	Pour mémoire, le script avait été adapté dans le cadre des ANRN 2022 sur le TRI de Verdun et le Jura mais l'idée à terme est d'avoir une table alimentée avec les
	proba d'occurence de crue + des fictives adaptées au type de crue ou au secteur geo si le territoire n'en possède pas et de taper
	dans ce tableau pour pondérer le coût des dommages annuel */

	RAISE NOTICE 'Calcul du coût des dommages annuels';
	RAISE NOTICE 'Vérification de l''existence de probabilités d''occurrence de crue par saison dans la table c_phenomenes.zp';
	IF EXISTS(
		SELECT *
		FROM c_phenomenes.zp
		WHERE territoire = ''||nom_ter||''
			AND type_alea = ''||typ_alea||''
			AND code_occurrence = ''||code_occ||''
	)
	THEN
		RAISE NOTICE 'Application des probabilités d''occurrence de crue disponibles pour chaque saison';
		EXECUTE '
			WITH tempb as
			(
				SELECT 
				s2_6a.id,
				ct_domm_prin*zp.proba_prin + ct_domm_ete*zp.proba_ete + ct_domm_aut*zp.proba_aut + ct_domm_hiv*zp.proba_hiv AS dommage_annuel
				FROM p_indicateurs.s2_6a, c_phenomenes.zp
				WHERE __util_to_snake_case(zp.territoire) = ''' ||__util_to_snake_case(nom_ter) || '''
					AND __util_to_snake_case(zp.type_alea) = ''' ||__util_to_snake_case(typ_alea) || '''
					AND __util_to_snake_case(zp.code_occurrence) = ''' ||__util_to_snake_case(code_occ) || '''
					AND __util_to_snake_case(s2_6a.date_actu_cout_dmg) = ''' ||__util_to_snake_case(an_fct_dmg) || '''
			)
		UPDATE p_indicateurs.s2_6a
		SET ct_domm_ann = dommage_annuel
		FROM tempb
		WHERE s2_6a.id = tempb.id';
	ELSE
		RAISE NOTICE 'Hypothèses sur les probabilités d''occurrence de crue pour chaque saison';
		EXECUTE '
			WITH tempb as
			(
				SELECT 
				s2_6a.id,
				ct_domm_prin*0.4 + ct_domm_ete*0.1 + ct_domm_aut*0.4 + ct_domm_hiv*0.1 AS dommage_annuel
				FROM p_indicateurs.s2_6a
				WHERE __util_to_snake_case(s2_6a.date_actu_cout_dmg) = ''' ||__util_to_snake_case(an_fct_dmg) || '''
			)
		UPDATE p_indicateurs.s2_6a
		SET ct_domm_ann = dommage_annuel
		FROM tempb
		WHERE s2_6a.id = tempb.id';
	END IF;
	
	--************************************************************************
	-- B) Attribution des codes et des noms de périmètres
	--************************************************************************
	RAISE NOTICE '';
	RAISE NOTICE 'Etape 4 : attribution des codes et des noms de périmètres';

	-- a. Attribution des codes INSEE et noms de communes
		EXECUTE '
			UPDATE p_indicateurs.s2_6a
			SET id_commune = com.insee_com, nom_commune = com.nom
			FROM c_phenomenes.zt, r_ign_bdtopo.commune_'||an_bdtopo||' AS com
			WHERE __util_to_snake_case(s2_6a.territoire) = '''||__util_to_snake_case(nom_ter)||'''
				AND __util_to_snake_case(s2_6a.type_alea) = '''||__util_to_snake_case(typ_alea)||'''
				AND __util_to_snake_case(s2_6a.code_occurrence) = '''||__util_to_snake_case(code_occ)||'''
				AND __util_to_snake_case(s2_6a.date_actu_cout_dmg) = '''||__util_to_snake_case(an_fct_dmg)||'''
				AND __util_to_snake_case(zt.territoire) = '''||__util_to_snake_case(nom_ter)||'''
				AND s2_6a.id_iris = zt.id_iris
				AND zt.id_commune = com.insee_com';

	-- b. Attribution des codes et noms EPCI
		EXECUTE '
			UPDATE p_indicateurs.s2_6a
			SET id_epci = epci.code_siren, nom_epci = epci.nom
			FROM c_phenomenes.zt,  r_ign_bdtopo.epci_'||an_bdtopo||' AS epci
			WHERE __util_to_snake_case(s2_6a.territoire) = '''||__util_to_snake_case(nom_ter)||'''
				AND __util_to_snake_case(s2_6a.type_alea) = '''||__util_to_snake_case(typ_alea)||'''
				AND __util_to_snake_case(s2_6a.code_occurrence) = '''||__util_to_snake_case(code_occ)||'''
				AND __util_to_snake_case(s2_6a.date_actu_cout_dmg) = '''||__util_to_snake_case(an_fct_dmg)||'''
				AND __util_to_snake_case(zt.territoire) = '''||__util_to_snake_case(nom_ter)||'''
				AND s2_6a.id_iris = zt.id_iris
				AND zt.id_epci = epci.code_siren';

	--************************************************************************
	-- Récupération du nombre d'entités ajoutées
	--************************************************************************
	EXECUTE '
		SELECT count(*)
		FROM s2_6a
		WHERE __util_to_snake_case(territoire) = '''||__util_to_snake_case(nom_ter)||'''
			AND __util_to_snake_case(type_alea) = '''||__util_to_snake_case(typ_alea)||'''
			AND __util_to_snake_case(code_occurrence) = '''||__util_to_snake_case(code_occ)||'''
			AND __util_to_snake_case(date_actu_cout_dmg) = '''||__util_to_snake_case(an_fct_dmg)||''''
	INTO c; -- nombre total d'enregistrements insérés dans la table

	--************************************************************************
	-- Conclusion
	--************************************************************************
	RAISE NOTICE '';
	RAISE NOTICE '====== FIN TRAITEMENT ======';
	RAISE NOTICE '[INFO] La table s2_6a (dommages aux cultures en fonction de paramètres hydrauliques) a été mise à jour dans le schéma p_indicateurs pour le territoire "%", l''aléa "% - %" et l''année %', nom_ter, typ_alea, code_occ, an_fct_dmg;
	RAISE NOTICE '';
	RAISE NOTICE '====== RÉSULTATS ======';

	IF c > 1
		THEN RAISE NOTICE '% enregistrements insérés au total dans la table p_indicateurs.s2_6a pour le territoire "%", l''aléa "% - %" et l''année %', c, nom_ter, typ_alea, code_occ, an_fct_dmg;
		ELSE RAISE NOTICE '% enregistrement inséré dans la table p_indicateurs.s2_6a pour le territoire "%", l''aléa "% - %" et l''année %', c, nom_ter, typ_alea, code_occ, an_fct_dmg;
	END IF;

	RAISE NOTICE '';
	heure2 = clock_timestamp();
	RAISE NOTICE 'Fin du traitement : %', heure2;
	RAISE NOTICE 'Durée du traitement : %', CAST(heure2 as time)-CAST(heure1 as time);
	RAISE NOTICE '';
	
END;
$function$
