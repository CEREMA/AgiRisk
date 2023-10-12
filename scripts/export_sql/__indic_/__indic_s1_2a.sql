SET client_encoding = 'UTF8';

CREATE OR REPLACE FUNCTION public.__indic_s1_2a(nom_ter text, typ_alea text, code_occ text, an_bdtopo text)
 RETURNS void
 LANGUAGE plpgsql
AS $function$

-- Fonction SQL d'incrémentation de la table p_indicateurs.s1_2a "Occupants dans des bâtiments de plain-pied fortement inondables"
-- © Copyright Cerema / GT AgiRisk (auteures principales du script : Lucie, Anaïs)
-- Dernière mise à jour du script le 25/08/2023 par Sébastien (test avec succès sur Longuyon le 24/08/2023)

-- Paramètres d'entrée :
-- nom_ter = nom du territoire d'étude tel que renseigné dans le champ `territoire` de la table c_general.territoires
-- typ_alea : type d'aléa considéré (ex : débordement de cours d'eau, submersion marine)
-- code_occ : période de retour considérée pour le type d'aléa choisi (ex : QRef, Q100, Q10)
-- an_bdtopo = millésime (année au format AAAA) de la BD TOPO®

-- Exemple d'appel à cette fonction :
-- SELECT public.__indic_s1_2a('Jura', 'débordement de cours d''eau', 'QRef', '2022');

DECLARE
	c_in_tres_fort integer; -- un compteur des lignes modifiées pour logging
	c_in_fort integer; -- un compteur des lignes modifiées pour logging
	c_in_moyen integer; -- un compteur des lignes modifiées pour logging
	c_in_faible integer; -- un compteur des lignes modifiées pour logging
	c_out integer; -- un compteur des lignes modifiées pour logging
	heure1 varchar; -- heure de début du traitement
	heure2 varchar; -- heure de fin du traitement

BEGIN
	heure1 = clock_timestamp();

	--************************************************************************
	-- Définition des schémas de travail
	--************************************************************************
    SET search_path TO p_indicateurs, c_general, c_phenomenes, c_occupation_sol, r_ign_bdtopo, public;

	RAISE NOTICE '';
	RAISE NOTICE '====== RAPPORT ======';
	RAISE NOTICE 'Calcul de l''indicateur S1/2a (occupants dans des bâtiments de plain-pied) sur le territoire "%" pour l''aléa "% - %"', nom_ter, typ_alea, code_occ;
	RAISE NOTICE '[INFO] Calcul basé sur les variables oc1 et zq disponibles dans la base de données';
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
    -- Vérification de l'existence du territoire renseigné dans la table c_phenomenes.zq
    --************************************************************************
	IF NOT EXISTS (
		SELECT *
		FROM c_phenomenes.zq
		WHERE territoire = ''||nom_ter||''
	)
	THEN
		RAISE EXCEPTION 'Il n''y a pas de territoire "%" dans la table c_phenomenes.zq. Fin de l''exécution', nom_ter;
    END IF;

    --************************************************************************
    -- Vérification de l'absence de données pour le territoire, le type d'aléa et l'occurrence de crue renseignés dans la table p_indicateurs.s1_2a
	--************************************************************************
	IF EXISTS (
		SELECT *
		FROM p_indicateurs.s1_2a
		WHERE territoire = ''||nom_ter||''
			AND type_alea = ''||typ_alea||''
			AND code_occurrence = ''||code_occ||''
	)
	THEN
		RAISE EXCEPTION 'Il existe déjà des enregistrements pour le territoire "%" avec l''aléa "% - %" dans la table p_indicateurs.s1_2a. 
		Pour les supprimer, lancer la requête suivante : 
		DELETE FROM p_indicateurs.s1_2a WHERE territoire = ''%'' AND type_alea = ''%'' AND code_occurrence = ''%'';', nom_ter, typ_alea, code_occ, REPLACE(nom_ter,'''',''''''), REPLACE(typ_alea,'''',''''''), REPLACE(code_occ,'''','''''');
	END IF;

	--************************************************************************
	-- ÉTAPE 1 : Croisement des bâtiments de plain-pied avec les zones fortement inondables sur le territoire d'étude
	--************************************************************************
	RAISE NOTICE '';
	RAISE NOTICE 'Récupération des géométries et affectation des noms de périmètres de calcul';
	RAISE NOTICE 'Etape 1a : récupération des bâtiments inondables sur le territoire "%" pour l''aléa "% - %"', nom_ter, typ_alea, code_occ;

	-- INFO : On considère qu'un bâtiment est fortement inondable à partir du moment où il intersecte les zonages d'aléa fort ou très fort, même très partiellement
	-- INFO : 03/10/2022 - Pas de champ pop6_bas considéré ... pop6_pp = pop6_haut

	-- a) Insertion des bâtiments oc1 qui intersectent une zone d''aléa très fort
	EXECUTE 'INSERT INTO p_indicateurs.s1_2a (
			territoire,
			id_iris,
			nom_iris,
			id_bdt,
			loc_zq,
			type_alea,
			code_occurrence,
			pop6_pp,
			sce_donnee,
			moda_calc,
			date_calc,
			geom,
			geomloc
		)
		SELECT
			oc1.territoire,
			oc1.id_iris,
			oc1.nom_iris,
			oc1.id_bdt,
			''In très fort'',
			zq.type_alea,
			zq.code_occurrence,
			oc1.pop6_haut,
			oc1.sce_donnee,
			''__indic_s1_2a'',
			current_date,
			oc1.geom,
			oc1.geomloc
		FROM oc1
		JOIN zq
		ON ST_Intersects(oc1.geom, zq.geom)
		WHERE __util_to_snake_case(oc1.territoire) = '''||__util_to_snake_case(nom_ter)||'''
			AND __util_to_snake_case(zq.territoire) = '''||__util_to_snake_case(nom_ter)||'''
			AND __util_to_snake_case(zq.type_alea) = '''||__util_to_snake_case(typ_alea)||'''
			AND __util_to_snake_case(zq.code_occurrence) = '''||__util_to_snake_case(code_occ)||'''
			AND zq.intensite_alea = ''très fort''
			AND oc1.pop6_haut > 0
			AND oc1.plainpied IS true
		';

	-- Récupération du nombre d'entités ajoutées
	GET DIAGNOSTICS c_in_tres_fort = row_count; -- nombre de bâtiments de plain-pied en zone d'aléa très fort insérés dans la table

	-- b) Insertion des bâtiments oc1 qui intersectent une zone d''aléa fort mais qui n'intersectent pas la zone d'aléa très fort (puisqu'ils ont déjà été pris en compte ci-dessus)
	EXECUTE 'INSERT INTO p_indicateurs.s1_2a (
			territoire,
			id_iris,
			nom_iris,
			id_bdt,
			loc_zq,
			type_alea,
			code_occurrence,
			pop6_pp,
			sce_donnee,
			moda_calc,
			date_calc,
			geom,
			geomloc
		)
		SELECT
			oc1.territoire,
			oc1.id_iris,
			oc1.nom_iris,
			oc1.id_bdt,
			''In fort'',
			zq.type_alea,
			zq.code_occurrence,
			oc1.pop6_haut,
			oc1.sce_donnee,
			''__indic_s1_2a'',
			current_date,
			oc1.geom,
			oc1.geomloc
		FROM oc1
		JOIN zq
		ON ST_Intersects(oc1.geom, zq.geom)
		WHERE __util_to_snake_case(oc1.territoire) = '''||__util_to_snake_case(nom_ter)||'''
			AND __util_to_snake_case(zq.territoire) = '''||__util_to_snake_case(nom_ter)||'''
			AND __util_to_snake_case(zq.type_alea) = '''||__util_to_snake_case(typ_alea)||'''
			AND __util_to_snake_case(zq.code_occurrence) = '''||__util_to_snake_case(code_occ)||'''
			AND zq.intensite_alea = ''fort''
			AND oc1.pop6_haut > 0
			AND oc1.plainpied IS true
			AND oc1.id_bdt NOT IN
				(
				SELECT id_bdt
				FROM s1_2a
				WHERE loc_zq = ''In très fort''
					AND __util_to_snake_case(territoire) = '''||__util_to_snake_case(nom_ter)||'''
					AND __util_to_snake_case(type_alea) = '''||__util_to_snake_case(typ_alea)||'''
					AND __util_to_snake_case(code_occurrence) = '''||__util_to_snake_case(code_occ)||'''
				)
	';

	-- Récupération du nombre d'entités ajoutées
	GET DIAGNOSTICS c_in_fort = row_count; -- nombre de bâtiments de plain-pied en zone d'aléa fort insérés dans la table

	-- c) Insertion des bâtiments oc1 qui intersectent une zone d''aléa moyen mais qui n'intersectent pas la zone d''aléa fort ni très fort (puisqu'ils ont déjà été pris en compte ci-dessus)
	EXECUTE 'INSERT INTO p_indicateurs.s1_2a (
			territoire,
			id_iris,
			nom_iris,
			id_bdt,
			loc_zq,
			type_alea,
			code_occurrence,
			pop6_pp,
			sce_donnee,
			moda_calc,
			date_calc,
			geom,
			geomloc
		)
		SELECT
			oc1.territoire,
			oc1.id_iris,
			oc1.nom_iris,
			oc1.id_bdt,
			''In moyen'',
			zq.type_alea,
			zq.code_occurrence,
			oc1.pop6_haut,
			oc1.sce_donnee,
			''__indic_s1_2a'',
			current_date,
			oc1.geom,
			oc1.geomloc
		FROM oc1
		JOIN zq
		ON ST_Intersects(oc1.geom, zq.geom)
		WHERE __util_to_snake_case(oc1.territoire) = '''||__util_to_snake_case(nom_ter)||'''
			AND __util_to_snake_case(zq.territoire) = '''||__util_to_snake_case(nom_ter)||'''
			AND __util_to_snake_case(zq.type_alea) = '''||__util_to_snake_case(typ_alea)||'''
			AND __util_to_snake_case(zq.code_occurrence) = '''||__util_to_snake_case(code_occ)||'''
			AND zq.intensite_alea = ''moyen''
			AND oc1.pop6_haut > 0
			AND oc1.plainpied IS true
			AND oc1.id_bdt NOT IN
				(
				SELECT id_bdt
				FROM s1_2a
				WHERE loc_zq IN (''In très fort'',''In fort'')
					AND __util_to_snake_case(territoire) = '''||__util_to_snake_case(nom_ter)||'''
					AND __util_to_snake_case(type_alea) = '''||__util_to_snake_case(typ_alea)||'''
					AND __util_to_snake_case(code_occurrence) = '''||__util_to_snake_case(code_occ)||'''
				)
	';

	-- Récupération du nombre d'entités ajoutées
	GET DIAGNOSTICS c_in_moyen = row_count; -- nombre de bâtiments de plain-pied en zone d'aléa moyen insérés dans la table

	-- d) Insertion des bâtiments oc1 qui intersectent une zone d''aléa faible mais qui n'intersectent pas la zone d''aléa fort ni très fort (puisqu'ils ont déjà été pris en compte ci-dessus)
	EXECUTE 'INSERT INTO p_indicateurs.s1_2a (
			territoire,
			id_iris,
			nom_iris,
			id_bdt,
			loc_zq,
			type_alea,
			code_occurrence,
			pop6_pp,
			sce_donnee,
			moda_calc,
			date_calc,
			geom,
			geomloc
		)
		SELECT
			oc1.territoire,
			oc1.id_iris,
			oc1.nom_iris,
			oc1.id_bdt,
			''In faible'',
			zq.type_alea,
			zq.code_occurrence,
			oc1.pop6_haut,
			oc1.sce_donnee,
			''__indic_s1_2a'',
			current_date,
			oc1.geom,
			oc1.geomloc
		FROM oc1
		JOIN zq
		ON ST_Intersects(oc1.geom, zq.geom)
		WHERE __util_to_snake_case(oc1.territoire) = '''||__util_to_snake_case(nom_ter)||'''
			AND __util_to_snake_case(zq.territoire) = '''||__util_to_snake_case(nom_ter)||'''
			AND __util_to_snake_case(zq.type_alea) = '''||__util_to_snake_case(typ_alea)||'''
			AND __util_to_snake_case(zq.code_occurrence) = '''||__util_to_snake_case(code_occ)||'''
			AND zq.intensite_alea = ''faible''
			AND oc1.pop6_haut > 0
			AND oc1.plainpied IS true
			AND oc1.id_bdt NOT IN
				(
				SELECT id_bdt
				FROM s1_2a
				WHERE loc_zq IN (''In très fort'',''In fort'',''In moyen'')
					AND __util_to_snake_case(territoire) = '''||__util_to_snake_case(nom_ter)||'''
					AND __util_to_snake_case(type_alea) = '''||__util_to_snake_case(typ_alea)||'''
					AND __util_to_snake_case(code_occurrence) = '''||__util_to_snake_case(code_occ)||'''
				)
	';

	-- Récupération du nombre d'entités ajoutées
	GET DIAGNOSTICS c_in_faible = row_count; -- nombre de bâtiments de plain-pied en zone d'aléa faible insérés dans la table

	-- e) Insertion des bâtiments oc1 qui se trouvent hors de la zone d'aléa (Zq)
	RAISE NOTICE 'Etape 1b : insertion des bâtiments avec occupants qui se trouvent en dehors de la zone inondable (Zq) sur le territoire "%" pour l''aléa "% - %"', nom_ter, typ_alea, code_occ;
	EXECUTE 'INSERT INTO p_indicateurs.s1_2a (
			territoire,
			id_iris,
			nom_iris,
			id_bdt,
			loc_zq,
			type_alea,
			code_occurrence,
			pop6_pp,
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
			''Out'',
			'''||REPLACE(typ_alea,'''','''''')||''' as alea,
			'''||REPLACE(code_occ,'''','''''')||''' as occ,
			oc1.pop6_haut,
			oc1.sce_donnee,
			''__indic_s1_2a'',
			current_date,
			oc1.geom,
			oc1.geomloc
		FROM oc1
		WHERE __util_to_snake_case(oc1.territoire) = '''||__util_to_snake_case(nom_ter)||'''
			AND oc1.pop6_haut > 0
			AND oc1.plainpied IS true
			AND oc1.id_bdt NOT IN
				(
				SELECT id_bdt
				FROM s1_2a
				WHERE loc_zq LIKE ''In%''
					AND __util_to_snake_case(territoire) = '''||__util_to_snake_case(nom_ter)||'''
					AND __util_to_snake_case(type_alea) = '''||__util_to_snake_case(typ_alea)||'''
					AND __util_to_snake_case(code_occurrence) = '''||__util_to_snake_case(code_occ)||'''
				)
	';

	-- Récupération du nombre d'entités ajoutées
	GET DIAGNOSTICS c_out = row_count; -- nombre de bâtiments de plain-pied hors zone inondable insérés dans la table

	--************************************************************************
	-- ÉTAPE 2 : Attribution des codes et des noms de périmètres
	--************************************************************************
	RAISE NOTICE 'Etape 2 : attribution des codes et des noms de périmètres';

	-- 2a. Attribution des codes INSEE et noms de communes
		EXECUTE '
			UPDATE p_indicateurs.s1_2a
			SET id_commune = com.insee_com, nom_commune = com.nom
			FROM c_phenomenes.zt, commune_'||an_bdtopo||' AS com
			WHERE __util_to_snake_case(s1_2a.territoire) = '''||__util_to_snake_case(nom_ter)||'''
				AND __util_to_snake_case(s1_2a.type_alea) = '''||__util_to_snake_case(typ_alea)||'''
				AND __util_to_snake_case(s1_2a.code_occurrence) = '''||__util_to_snake_case(code_occ)||'''
				AND __util_to_snake_case(zt.territoire) = '''||__util_to_snake_case(nom_ter)||'''
				AND s1_2a.id_iris = zt.id_iris
				AND zt.id_commune = com.insee_com';

	-- 2b. Attribution des codes et noms EPCI
		EXECUTE '
			UPDATE p_indicateurs.s1_2a
			SET id_epci = epci.code_siren, nom_epci = epci.nom
			FROM c_phenomenes.zt, epci_'||an_bdtopo||' AS epci
			WHERE __util_to_snake_case(s1_2a.territoire) = '''||__util_to_snake_case(nom_ter)||'''
				AND __util_to_snake_case(s1_2a.type_alea) = '''||__util_to_snake_case(typ_alea)||'''
				AND __util_to_snake_case(s1_2a.code_occurrence) = '''||__util_to_snake_case(code_occ)||'''
				AND __util_to_snake_case(zt.territoire) = '''||__util_to_snake_case(nom_ter)||'''
				AND s1_2a.id_iris = zt.id_iris
				AND zt.id_epci = epci.code_siren';

	--************************************************************************
	-- Conclusion
	--************************************************************************
	RAISE NOTICE '';
	RAISE NOTICE '====== FIN TRAITEMENT ======';
	RAISE NOTICE '[INFO] La table s1_2a (occupants dans des bâtiments de plain-pied) a été mise à jour dans le schéma p_indicateurs pour le territoire "%" et l''aléa "% - %"', nom_ter, typ_alea, code_occ;
	RAISE NOTICE '';
	RAISE NOTICE '====== RÉSULTATS ======';

	IF c_in_tres_fort+c_in_fort+c_in_moyen+c_in_faible+c_out > 1
		THEN RAISE NOTICE '% enregistrements insérés au total dans la table p_indicateurs.s1_2a pour le territoire "%" et l''aléa "% - %"', c_in_tres_fort+c_in_fort+c_in_moyen+c_in_faible+c_out, nom_ter, typ_alea, code_occ;
		ELSE RAISE NOTICE '% enregistrement inséré dans la table p_indicateurs.s1_2a pour le territoire "%" et l''aléa "% - %"', c_in_tres_fort+c_in_fort+c_in_moyen+c_in_faible+c_out, nom_ter, typ_alea, code_occ;
	END IF;

	RAISE NOTICE 'dont :';
	
		IF c_in_tres_fort > 1
			THEN RAISE NOTICE '- % bâtiments de plain-pied en zone d''aléa très fort', c_in_tres_fort;
			ELSE RAISE NOTICE '- % bâtiment de plain-pied en zone d''aléa très fort', c_in_tres_fort;
		END IF;
	
		IF c_in_fort > 1
			THEN RAISE NOTICE '- % bâtiments de plain-pied en zone d''aléa fort', c_in_fort;
			ELSE RAISE NOTICE '- % bâtiment de plain-pied en zone d''aléa fort', c_in_fort;
		END IF;
	
		IF c_in_moyen > 1
			THEN RAISE NOTICE '- % bâtiments de plain-pied en zone d''aléa moyen', c_in_moyen;
			ELSE RAISE NOTICE '- % bâtiment de plain-pied en zone d''aléa moyen', c_in_moyen;
		END IF;
	
		IF c_in_faible > 1
			THEN RAISE NOTICE '- % bâtiments de plain-pied en zone d''aléa faible', c_in_faible;
			ELSE RAISE NOTICE '- % bâtiment de plain-pied en zone d''aléa faible', c_in_faible;
		END IF;
	
		IF c_out > 1
			THEN RAISE NOTICE '- % bâtiments de plain-pied hors zone inondable', c_out;
			ELSE RAISE NOTICE '- % bâtiment de plain-pied hors zone inondable', c_out;
		END IF;

	RAISE NOTICE '';
	heure2 = clock_timestamp();
	RAISE NOTICE 'Fin du traitement : %', heure2;
	RAISE NOTICE 'Durée du traitement : %', CAST(heure2 as time)-CAST(heure1 as time);
	RAISE NOTICE '';

END;
$function$
