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

CREATE OR REPLACE FUNCTION public.__indic_s3_2b(nom_ter text, typ_alea text, code_occ text, an_bdtopo text)
 RETURNS void
 LANGUAGE plpgsql
AS $function$

-- Fonction SQL d'incrémentation de la table p_indicateurs.s3_2b "Capacités d'accueil et d'hébergement du territoire situées hors zone inondable"
-- © Copyright Cerema / GT AgiRisk (auteure principale du script : Anaïs)
-- Dernières mises à jour du script le 20/04/2023 par Lucie et le 25/08/2023 par Sébastien (test avec succès sur Longuyon le 24/08/2023)

-- Paramètres d'entrée :
-- nom_ter = nom du territoire d'étude tel que renseigné dans le champ `territoire` de la table c_general.territoires
-- typ_alea : type d'aléa considéré (ex : débordement de cours d'eau, submersion marine)
-- code_occ : période de retour considérée pour le type d'aléa choisi (ex : QRef, Q100, Q10)
-- an_bdtopo = millésime (année au format AAAA) de la BD TOPO®

-- Exemple d'appel à cette fonction :
-- SELECT public.__indic_s3_2b('TRI Verdun', 'débordement de cours d''eau + remontée de nappe', 'QRef diag', '2022');

DECLARE
	c_in integer; -- un compteur des lignes modifiées pour logging
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
	RAISE NOTICE 'Calcul de l''indicateur S3/2b (capacités d''accueil et d''hébergement du territoire situées hors zone inondable) sur le territoire "%" pour l''aléa "% - %"', nom_ter, typ_alea, code_occ;
	RAISE NOTICE '[NOTA] Calcul basé sur les variables oc11 et zx disponibles dans la base de données';
	RAISE NOTICE 'Début du traitement : %', heure1;

	--************************************************************************
	-- Vérification de l'existence du territoire renseigné dans la table des territoires (c_general.territoires)
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
	-- Vérification de l'existence du territoire renseigné dans la table c_phenomenes.zx
	--************************************************************************
	IF NOT EXISTS (
		SELECT *
		FROM c_phenomenes.zx
		WHERE territoire = ''||nom_ter||''
	)
	THEN
		RAISE EXCEPTION 'Il n''y a pas de territoire "%" dans la table c_phenomenes.zx. Fin de l''exécution', nom_ter;
	END IF;

	--************************************************************************
	-- Vérification de l'absence de données pour le territoire, le type d'aléa et l'occurrence de crue renseignés dans la table p_indicateurs.s3_2b
	--************************************************************************
	IF EXISTS (
		SELECT *
		FROM p_indicateurs.s3_2b
		WHERE territoire = ''||nom_ter||''
			AND type_alea = ''||typ_alea||''
			AND code_occurrence = ''||code_occ||''
	)
	THEN
		RAISE EXCEPTION 'Il existe déjà des enregistrements pour le territoire "%" avec l''aléa "% - %" dans la table p_indicateurs.s3_2b. 
		Pour les supprimer, lancer la requête suivante : 
		DELETE FROM p_indicateurs.s3_2b WHERE territoire = ''%'' AND type_alea = ''%'' AND code_occurrence = ''%'';', nom_ter, typ_alea, code_occ, REPLACE(nom_ter,'''',''''''), REPLACE(typ_alea,'''',''''''), REPLACE(code_occ,'''','''''');
	END IF;
	
	--************************************************************************
	-- A) Croisement des ERP avec la zone inondable (zx) du territoire d'étude
	--************************************************************************
	RAISE NOTICE '';
	RAISE NOTICE 'Récupération des géométries et affectation des noms de périmètres de calcul';
	RAISE NOTICE 'Etape 1a : insertion des ERP inondables sur le territoire "%" pour l''aléa "% - %"', nom_ter, typ_alea, code_occ;
  
	-- 1a. Insertion des ERP en zone inondable
		
	-- On considère qu'un ERP est inondable à partir du moment ou il intersecte la zone inondable même très faiblement
	
	-- a) Insertion des bâtiments oc1 qui intersectent Zx
	
	EXECUTE 'INSERT INTO p_indicateurs.s3_2b(
			territoire,
			id_iris,
			nom_iris,
			id_erp,
			nom_erp,
			loc_zx,
			type_alea,
			code_occurrence,
			cap_acc,
			cap_heberg,
			sce_donnee,
			moda_calc,
			date_calc,
			geom,
			geomloc
		)
		SELECT
			oc11.territoire,
			oc11.id_iris,
			oc11.nom_iris,
			oc11.id_sce,
			oc11.libelle,
			''In'',
			zx.type_alea,
			zx.code_occurrence,
			oc11.cap_acc,
			oc11.cap_heberg,
			oc11.sce_donnee,
			''__indic_s3_2b'' AS moda_calc,
			current_date AS date_calc,
			oc11.geom,
			oc11.geomloc
		FROM oc11
		JOIN zx
		ON ST_Intersects(ST_Buffer(oc11.geom, 20), zx.geom)
		WHERE __util_to_snake_case(oc11.territoire) = ''' ||__util_to_snake_case(nom_ter) || '''
			AND __util_to_snake_case(zx.territoire) IN (''' ||__util_to_snake_case(nom_ter) || ''')
			AND __util_to_snake_case(zx.code_occurrence) IN (''' ||__util_to_snake_case(code_occ) || ''')
			AND __util_to_snake_case(zx.type_alea) IN (''' ||__util_to_snake_case(typ_alea) || ''')
			AND oc11.type_etab = ''ERP''
		';

	-- Récupération du nombre d'entités ajoutées
	GET DIAGNOSTICS c_in = row_count; -- nombre d'ERP en zone inondable insérés dans la table

	-- 1b. Insertion des ERP situés hors zone inondable

	RAISE NOTICE 'Etape 1b : insertion des bâtiments avec occupants qui se trouvent en dehors de la zone inondable (Zx) sur le territoire "%" pour l''aléa "% - %"', nom_ter, typ_alea, code_occ;

	EXECUTE 'INSERT INTO p_indicateurs.s3_2b(
			territoire,
			id_iris,
			nom_iris,
			id_erp,
			nom_erp,
			loc_zx,
			type_alea,
			code_occurrence,
			cap_acc,
			cap_heberg,
			sce_donnee,
			moda_calc,
			date_calc,
			geom,
			geomloc
		)
		SELECT
			oc11.territoire,
			oc11.id_iris,
			oc11.nom_iris,
			oc11.id_sce,
			oc11.libelle,
			''Out'',
			'''||REPLACE(typ_alea,'''','''''')||''' as alea,
			'''||REPLACE(code_occ,'''','''''')||''' as occ,
			oc11.cap_acc,
			oc11.cap_heberg,
			oc11.sce_donnee,
			''__indic_s3_2b'' AS moda_calc,
			current_date AS date_calc,
			oc11.geom,
			oc11.geomloc
		FROM oc11
		WHERE __util_to_snake_case(oc11.territoire) = ''' ||__util_to_snake_case(nom_ter) || '''
			AND oc11.id_sce NOT IN (
									SELECT id_erp FROM s3_2b
									WHERE loc_zx = ''In''
										AND __util_to_snake_case(territoire) = ''' ||__util_to_snake_case(nom_ter) || '''
										AND __util_to_snake_case(code_occurrence) IN (''' ||__util_to_snake_case(code_occ) || ''')
										AND __util_to_snake_case(type_alea) IN (''' ||__util_to_snake_case(typ_alea) || ''')
									)
			AND oc11.type_etab = ''ERP''
		';

	-- Récupération du nombre d'entités ajoutées
	GET DIAGNOSTICS c_out = row_count; -- nombre d'ERP hors zone inondable insérés dans la table

	--************************************************************************
	-- B) Attribution des codes et des noms de périmètres
	--************************************************************************
	RAISE NOTICE 'Etape 2 : attribution des codes et des noms de périmètres';

	-- 2a. Attribution des codes INSEE et noms de communes
		EXECUTE '
			UPDATE p_indicateurs.s3_2b
			SET id_commune = com.insee_com, nom_commune = com.nom
			FROM c_phenomenes.zt, commune_'||an_bdtopo||' AS com
			WHERE __util_to_snake_case(s3_2b.territoire) = '''||__util_to_snake_case(nom_ter)||'''
				AND __util_to_snake_case(s3_2b.type_alea) = '''||__util_to_snake_case(typ_alea)||'''
				AND __util_to_snake_case(s3_2b.code_occurrence) = '''||__util_to_snake_case(code_occ)||'''
				AND __util_to_snake_case(zt.territoire) = '''||__util_to_snake_case(nom_ter)||'''
				AND s3_2b.id_iris = zt.id_iris
				AND zt.id_commune = com.insee_com';

	-- 2b. Attribution des codes et noms EPCI
		EXECUTE '
			UPDATE p_indicateurs.s3_2b
			SET id_epci = epci.code_siren, nom_epci = epci.nom
			FROM c_phenomenes.zt, epci_'||an_bdtopo||' AS epci
			WHERE __util_to_snake_case(s3_2b.territoire) = '''||__util_to_snake_case(nom_ter)||'''
				AND __util_to_snake_case(s3_2b.type_alea) = '''||__util_to_snake_case(typ_alea)||'''
				AND __util_to_snake_case(s3_2b.code_occurrence) = '''||__util_to_snake_case(code_occ)||'''
				AND __util_to_snake_case(zt.territoire) = '''||__util_to_snake_case(nom_ter)||'''
				AND s3_2b.id_iris = zt.id_iris
				AND zt.id_epci = epci.code_siren';

	--************************************************************************
	-- Conclusion
	--************************************************************************
	RAISE NOTICE '';
	RAISE NOTICE '====== FIN TRAITEMENT ======';
	RAISE NOTICE '[INFO] La table s3_2b (capacités d''hébergement du territoire situées hors zones inondables) a été mise à jour dans le schéma p_indicateurs pour le territoire "%" et l''aléa "% - %"', nom_ter, typ_alea, code_occ;
	RAISE NOTICE '';
	RAISE NOTICE '====== RÉSULTATS ======';

	IF c_in+c_out > 1
		THEN RAISE NOTICE '% enregistrements insérés au total dans la table p_indicateurs.s3_2b pour le territoire "%" et l''aléa "% - %"', c_in+c_out, nom_ter, typ_alea, code_occ;
		ELSE RAISE NOTICE '% enregistrement inséré dans la table p_indicateurs.s3_2b pour le territoire "%" et l''aléa "% - %"', c_in+c_out, nom_ter, typ_alea, code_occ;
	END IF;
	RAISE NOTICE 'dont :';
	RAISE NOTICE '- % ERP hors zone inondable', c_out;
	RAISE NOTICE '- % ERP en zone inondable', c_in;

	RAISE NOTICE '';
	heure2 = clock_timestamp();
	RAISE NOTICE 'Fin du traitement : %', heure2;
	RAISE NOTICE 'Durée du traitement : %', CAST(heure2 as time)-CAST(heure1 as time);
	RAISE NOTICE '';

END;
$function$
