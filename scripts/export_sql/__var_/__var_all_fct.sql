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

CREATE OR REPLACE FUNCTION public.__var_all_fct(nom_ter text, an_ff text, an_fch_acb text, an_lien text, an_bdtopo text, an_gpu text, an_iris text, an_rpg text, an_pop text, an_siren text, an_topage text, an_osm text)
 RETURNS void
 LANGUAGE plpgsql
AS $function$

-- Fonction SQL permettant de calculer en une fois toutes les variables sur un territoire donné (exécution à la suite de toutes les fonctions d'incrémentation des tables des variables)
-- © Cerema / GT AgiRisk (auteurs du script : Lucie, Sébastien)
-- Dernière mise à jour du script le 11/08/2023 par Sébastien

-- Paramètres d'entrée (nom du territoire d'étude en premier argument, puis tous les millésimes des référentiels nécessaires aux calculs des variables) :
-- nom_ter = nom du territoire d'étude tel que renseigné dans le champ `territoire` de la table c_general.territoires
-- an_ff = millésime (année au format AAAA) des Fichiers Fonciers (FF)
-- an_fch_acb : millésime (année au format AAAA) des fichiers "logements" et "sous-sols" produits par le Cerema Méditerranée pour l'Analyse Coûts-Bénéfices (ACB) des projets de prévention des inondations (détail de la méthode dans cet article : https://www.cerema.fr/fr/actualites/cerema-ameliore-son-fichier-analyse-cout-benefice-projets)
-- an_lien = millésime (année au format AAAA) de la base ADRESSE PREMIUM
-- an_bdtopo = millésime (année au format AAAA) des tables de la BD TOPO®
-- an_gpu = millésime (année au format AAAA) des données du Géoportail de l'Urbanisme (GPU)
-- an_iris = millésime (année au format AAAA) de la table des IRIS Grande Échelle
-- an_rpg = millésime (année au format AAAA) du RPG (Registre Parcellaire Graphique)
-- an_pop = millésime (année au format AAAA) de la couche population Insee
-- an_siren = millésime (année au format AAAA) des points SIRENE V3 récupérés depuis le site https://public.opendatasoft.com/explore/dataset/economicref-france-sirene-v3/
-- an_topage = millésime (année au format AAAA) de la BD TOPAGE® (qui remplace la BD CARTHAGE® depuis 2020)
-- an_osm = millésime (année au format AAAA) des données OSM

-- Exemples d'appels à cette fonction :
-- SELECT public.__var_all_fct('Baccarat''IRIS', '2021', '2021', '2022', '2022', '2022', '2022', '2021', '2015', '2022', '2019','2023');
-- SELECT public.__var_all_fct('Cap Atlantique', '2021', '2021', '2022', '2022', '2022', '2022', '2021', '2015', '2022', '2019','2023');
-- SELECT public.__var_all_fct('CARENE', '2021', '2021', '2022', '2022', '2022', '2022', '2021', '2015', '2022', '2019','2023');
-- SELECT public.__var_all_fct('CC_GST', '2021', '2021', '2022', '2022', '2022', '2022', '2021', '2015', '2022', '2019','2023');
-- SELECT public.__var_all_fct('CDA La Rochelle - CDC Aunis Atlantique', '2022', '2022', '2022', '2022', '2022', '2022', '2021', '2015', '2022', '2019','2023');
-- SELECT public.__var_all_fct('Clain amont', '2021', '2021', '2022', '2022', '2022', '2022', '2021', '2015', '2022', '2019','2023');
-- SELECT public.__var_all_fct('Communauté de Communes Terre Lorraine du Longuyonnais', '2022', '2022', '2022', '2022', '2022', '2022', '2021', '2015', '2022', '2019','2023');
-- SELECT public.__var_all_fct('Jura', '2021', '2021', '2022', '2022', '2022', '2022', '2021', '2015', '2022', '2019','2023');
-- SELECT public.__var_all_fct('Longuyon', '2022', '2022', '2022', '2022', '2022', '2022', '2021', '2015', '2022', '2019','2023');
-- SELECT public.__var_all_fct('Scot de Tours', '2021', '2021', '2022', '2022', '2022', '2022', '2021', '2015', '2022', '2019','2023');
-- SELECT public.__var_all_fct('Sequana', '2021', '2021', '2022', '2022', '2022', '2022', '2021', '2015', '2022', '2019','2023');
-- SELECT public.__var_all_fct('Sequana Ource et Digeanne', '2021', '2021', '2022', '2022', '2022', '2022', '2021', '2015', '2022', '2019','2023');
-- SELECT public.__var_all_fct('Sequana Seine et Brevon', '2021', '2021', '2022', '2022', '2022', '2022', '2021', '2015', '2022', '2019','2023');
-- SELECT public.__var_all_fct('TRI Baccarat secteur 54', '2021', '2021', '2022', '2022', '2022', '2022', '2021', '2015', '2022', '2019','2023');
-- SELECT public.__var_all_fct('TRI Nancy Damelevieres', '2021', '2021', '2022', '2022', '2022', '2022', '2021', '2015', '2022', '2019','2023');
-- SELECT public.__var_all_fct('TRI Noirmoutier SJDM', '2021', '2021', '2022', '2022', '2022', '2022', '2021', '2015', '2022', '2019','2023');
-- SELECT public.__var_all_fct('TRI Verdun', '2021', '2021', '2022', '2022', '2022', '2022', '2021', '2015', '2022', '2019','2023');
-- SELECT public.__var_all_fct('Vienne Clain', '2021', '2021', '2022', '2022', '2022', '2022', '2021', '2015', '2022', '2019','2023');
-- SELECT public.__var_all_fct('Wissant', '2021', '2021', '2022', '2022', '2022', '2022', '2021', '2015', '2022', '2019','2023');
-- SELECT public.__var_all_fct('Zorn', '2021', '2021', '2022', '2022', '2022', '2022', '2021', '2015', '2022', '2019','2023');

DECLARE
	heurea varchar; -- heure de début du traitement
	heureb varchar; -- heure de fin du traitement

BEGIN
	heurea = current_timestamp;

	RAISE NOTICE '';
	RAISE NOTICE '====== CALCUL DE L''ENSEMBLE DES VARIABLES SUR LE TERRITOIRE "%" ======', nom_ter;
	RAISE NOTICE 'Début du traitement : %', heurea;

	-- NOTA : le calcul de certaines variables pouvant faire appel à d'autres tables qui doivent être préalablement incrémentées, un ordre d'exécution précis des scripts de calcul a été établi ci-après (il convient par exemple de calculer Oc1 avant Oc2, car le second utilise les résultats du premier).

	--************************************************************************
	-- Variable Zt (maille de calcul élémentaire constituée des contours IRIS GE®)
	--************************************************************************
	BEGIN
		RAISE NOTICE '';
		RAISE NOTICE '====== Calcul de la variable Zt (maille de calcul élémentaire constituée des contours IRIS GE®) ======';
			EXECUTE 'DELETE FROM c_phenomenes.zt WHERE territoire = '''||REPLACE(nom_ter,'''','''''')||'''';
			EXECUTE 'SELECT public.__var_zt('''||REPLACE(nom_ter,'''','''''')||''', '''||an_bdtopo||''', '''||an_iris||''', '''||an_topage||''')';
			--COMMIT;
		RAISE NOTICE 'Incrémentation de la table zt terminée pour le territoire "%"', nom_ter;
	
		-- Bout de code permettant d'ignorer le calcul de la variable en cas d'erreur
		 EXCEPTION WHEN OTHERS THEN
			 RAISE NOTICE 'Zt ne peut pas être calculé pour le territoire "%"', nom_ter;
			 RAISE NOTICE '% %', SQLERRM, SQLSTATE;
	END;

	--************************************************************************
	-- Variable Oc0 (zones à urbaniser)
	--************************************************************************
	BEGIN
		RAISE NOTICE '';
		RAISE NOTICE '====== Calcul de la variable Oc0 (zones à urbaniser) ======';
			EXECUTE 'DELETE FROM c_occupation_sol.oc0 WHERE territoire = '''||REPLACE(nom_ter,'''','''''')||'''';
			EXECUTE 'SELECT public.__var_oc0('''||REPLACE(nom_ter,'''','''''')||''', '''||an_gpu||''')';
			--COMMIT;
		RAISE NOTICE 'Incrémentation de la table oc0 terminée pour le territoire "%"', nom_ter;
	
		-- Bout de code permettant d'ignorer le calcul de la variable en cas d'erreur
		 EXCEPTION WHEN OTHERS THEN
			 RAISE NOTICE 'Oc0 ne peut pas être calculé pour le territoire "%"', nom_ter;
			 RAISE NOTICE '% %', SQLERRM, SQLSTATE;
	END;

	--************************************************************************
	-- Variable Oc1 (bâtiments)
	--************************************************************************
	-- Modalité de calcul n°1 d'Oc1 (__var_oc1_geom)
	BEGIN
		RAISE NOTICE '';
		RAISE NOTICE '====== Calcul de la variable Oc1 (bâtiments) selon la modalité __var_oc1_geom ======';
			EXECUTE 'DELETE FROM c_occupation_sol.oc1 WHERE territoire = '''||REPLACE(nom_ter,'''','''''')||'''';
			EXECUTE 'SELECT public.__var_oc1_geom('''||REPLACE(nom_ter,'''','''''')||''', '''||an_bdtopo||''')';
			--COMMIT;
		RAISE NOTICE 'Incrémentation de la table oc1 terminée pour le territoire "%"', nom_ter;
	
		-- Bout de code permettant d'ignorer le calcul de la variable en cas d'erreur
		 EXCEPTION WHEN OTHERS THEN
			 RAISE NOTICE 'Oc1 (modalité __var_oc1_geom) ne peut pas être calculé pour le territoire "%"', nom_ter;
			 RAISE NOTICE '% %', SQLERRM, SQLSTATE;
	END;
	
	/* Modalité de calcul n°2 d'Oc1 (__var_oc1_geomloc)
	BEGIN
		RAISE NOTICE '';
		RAISE NOTICE '====== Calcul de la variable Oc1 (bâtiments) selon la modalité __var_oc1_geomloc ======';
			EXECUTE 'DELETE FROM c_occupation_sol.oc1 WHERE territoire = '''||REPLACE(nom_ter,'''','''''')||'''';
			EXECUTE 'SELECT public.__var_oc1_geomloc('''||REPLACE(nom_ter,'''','''''')||''', '''||an_bdtopo||''')';
			--COMMIT;
		RAISE NOTICE 'Incrémentation de la table oc1 terminée pour le territoire "%"', nom_ter;
	
		-- Bout de code permettant d'ignorer le calcul de la variable en cas d'erreur
		 EXCEPTION WHEN OTHERS THEN
			 RAISE NOTICE 'Oc1 (modalité __var_oc1_geomloc) ne peut pas être calculé pour le territoire "%"', nom_ter;
			 RAISE NOTICE '% %', SQLERRM, SQLSTATE;
	END; */

	--************************************************************************
	-- Variable Oc2 (logements)
	--************************************************************************
	-- Modalité de calcul n°1 d'Oc2 (__var_oc2_amc)
	BEGIN
		RAISE NOTICE '';
		RAISE NOTICE '====== Calcul de la variable Oc2 (logements) selon la modalité __var_oc2_amc ======';
		-- NOTA : oc2 est un champ booléen de la table oc1. Une table oc2_amc est créée dans le schéma c_occupation_sol.
			EXECUTE 'SELECT public.__var_oc2_amc('''||REPLACE(nom_ter,'''','''''')||''', '''||an_ff||''', '''||an_fch_acb||''','''||an_bdtopo||''')';
			--COMMIT;
		RAISE NOTICE 'Incrémentation de la table oc1 (mise à jour du champ oc2) terminée pour le territoire "%"', nom_ter;
	
		-- Bout de code permettant d'ignorer le calcul de la variable en cas d'erreur
		 EXCEPTION WHEN OTHERS THEN
			 RAISE NOTICE 'Oc2 (modalité __var_oc2_amc) ne peut pas être calculé pour le territoire "%"', nom_ter;
			 RAISE NOTICE '% %', SQLERRM, SQLSTATE;
	END;
	
	/* Modalité de calcul n°2 d'Oc2 (__var_oc2_ref)
	BEGIN
		RAISE NOTICE '';
		RAISE NOTICE '====== Calcul de la variable Oc2 (logements) selon la modalité __var_oc2_ref ======';
		-- NOTA : oc2 est un champ booléen de la table oc1. Il n'y pas de création de table oc2_ref en tant que telle.
			EXECUTE 'SELECT public.__var_oc2_ref('''||REPLACE(nom_ter,'''','''''')||''', '''||an_ff||''', '''||an_bdtopo||''')';
			--COMMIT;
		RAISE NOTICE 'Incrémentation de la table oc1 (mise à jour du champ oc2) terminée pour le territoire "%"', nom_ter;
		
		-- Bout de code permettant d'ignorer le calcul de la variable en cas d'erreur
		 EXCEPTION WHEN OTHERS THEN
			 RAISE NOTICE 'Oc2 (modalité __var_oc2_ref) ne peut pas être calculé pour le territoire "%"', nom_ter;
			 RAISE NOTICE '% %', SQLERRM, SQLSTATE;
	END; */

	--************************************************************************
	-- Variables Oc3 (activités) et Pop2 (employés)
	--************************************************************************
	BEGIN
		RAISE NOTICE '';
		RAISE NOTICE '====== Calcul des variables Oc3 (activités) et Pop2 (employés) ======';
		-- NOTA : la fonction __var_oc3 crée une table oc3 sans géométrie, servant à l'identification des bâtiments d'activité et au calcul du nombre d'employés. Elle met à jour le champ oc3 (booléen) de la table oc1. pop2 est décliné en pop2_haut et pop2_bas qui sont deux champs attributaires de la table oc1. Il n'y a pas de création de table pop2 en tant que telle.
		-- EXECUTE 'DELETE FROM c_occupation_sol.oc3 WHERE territoire = '''||REPLACE(nom_ter,'''','''''')||''''; -- ligne commentée car déjà prise en compte dans le script __var_oc3 (comme la procédure __init_oc3 n'existe pas, si la table oc3 n'existe pas déjà dans la base, la ligne ci-contre est bloquante)
			EXECUTE 'SELECT public.__var_oc3('''||REPLACE(nom_ter,'''','''''')||''', '''||an_lien||''', '''||an_bdtopo||''', '''||an_siren||''')';
			--COMMIT;
		RAISE NOTICE 'Incrémentation de la table oc3 et de la table oc1 (mise à jour des champs oc3, pop2_haut et pop2_bas) terminée pour le territoire "%"', nom_ter;
	
		-- Bout de code permettant d'ignorer le calcul de la variable en cas d'erreur
		 EXCEPTION WHEN OTHERS THEN
			 RAISE NOTICE 'Oc3 et Pop2 ne peuvent pas être calculés pour le territoire "%"', nom_ter;
			 RAISE NOTICE '% %', SQLERRM, SQLSTATE;
	END;

	--************************************************************************
	-- Variable Oc5 (campings et aires d'accueil des gens du voyage)
	--************************************************************************
	BEGIN
		RAISE NOTICE '';
		RAISE NOTICE '====== Calcul de la variable Oc5 (campings et aires d''accueil des gens du voyage) ======';
			EXECUTE 'DELETE FROM c_occupation_sol.oc5 WHERE territoire = '''||REPLACE(nom_ter,'''','''''')||'''';
			EXECUTE 'SELECT public.__var_oc5('''||REPLACE(nom_ter,'''','''''')||''', '''||an_bdtopo||''', '''||an_osm||''')';
			--COMMIT;
		RAISE NOTICE 'Incrémentation de la table oc5 terminée pour le territoire "%"', nom_ter;
	
		-- Bout de code permettant d'ignorer le calcul de la variable en cas d'erreur
		 EXCEPTION WHEN OTHERS THEN
			 RAISE NOTICE 'Oc5 ne peut pas être calculé pour le territoire "%"', nom_ter;
			 RAISE NOTICE '% %', SQLERRM, SQLSTATE;
	END;

	--************************************************************************
	-- Variable Oc7 (cultures agricoles)
	--************************************************************************
	BEGIN
		RAISE NOTICE '';
		RAISE NOTICE '====== Calcul de la variable Oc7 (cultures agricoles) ======';
			EXECUTE 'DELETE FROM c_occupation_sol.oc7 WHERE territoire = '''||REPLACE(nom_ter,'''','''''')||'''';
			EXECUTE 'SELECT public.__var_oc7('''||REPLACE(nom_ter,'''','''''')||''', '''||an_bdtopo||''', '''||an_rpg||''')';
			--COMMIT;
		RAISE NOTICE 'Incrémentation de la table oc7 terminée pour le territoire "%"', nom_ter;
	
		-- Bout de code permettant d'ignorer le calcul de la variable en cas d'erreur
		 EXCEPTION WHEN OTHERS THEN
			 RAISE NOTICE 'Oc7 ne peut pas être calculé pour le territoire "%"', nom_ter;
			 RAISE NOTICE '% %', SQLERRM, SQLSTATE;
	END;

	--************************************************************************
	-- Variable Oc11 (ERP)
	--************************************************************************
	BEGIN
		RAISE NOTICE '';
		RAISE NOTICE '====== Calcul de la variable Oc11 (ERP) ======';
			EXECUTE 'DELETE FROM c_occupation_sol.oc11 WHERE territoire = '''||REPLACE(nom_ter,'''','''''')||'''';
			EXECUTE 'SELECT public.__var_oc11('''||REPLACE(nom_ter,'''','''''')||''', '''||an_bdtopo||''')';
			--COMMIT;
		RAISE NOTICE 'Incrémentation de la table oc11 terminée pour le territoire "%"', nom_ter;
	
		-- Bout de code permettant d'ignorer le calcul de la variable en cas d'erreur
		 EXCEPTION WHEN OTHERS THEN
			 RAISE NOTICE 'Oc11 ne peut pas être calculé pour le territoire "%"', nom_ter;
			 RAISE NOTICE '% %', SQLERRM, SQLSTATE;
	END;

	--************************************************************************
	-- Variable Pop1 (habitants)
	--************************************************************************
	BEGIN
		RAISE NOTICE '';
		RAISE NOTICE '====== Calcul de la variable Pop1 (habitants) ======';
		-- NOTA : pop1 est un champ attributaire de la table oc1. Il n'y a pas de création de table pop1 en tant que telle.
			EXECUTE 'SELECT public.__var_pop1('''||REPLACE(nom_ter,'''','''''')||''', '''||an_ff||''', '''||an_pop||''')';
			--COMMIT;
		RAISE NOTICE 'Incrémentation de la table oc1 (mise à jour du champ pop1) terminée pour le territoire "%"', nom_ter;
	
		-- Bout de code permettant d'ignorer le calcul de la variable en cas d'erreur
		 EXCEPTION WHEN OTHERS THEN
			 RAISE NOTICE 'Pop1 ne peut pas être calculé pour le territoire "%"', nom_ter;
			 RAISE NOTICE '% %', SQLERRM, SQLSTATE;
	END;

	--************************************************************************
	-- Variable Pop5 (population saisonnière)
	--************************************************************************
	BEGIN
		RAISE NOTICE '';
		RAISE NOTICE '====== Calcul de la variable Pop5 (population saisonnière) ======';
		-- NOTA : pop5 est un champ attributaire de la table oc1. Il n'y a pas de création de table pop5 en tant que telle.
			EXECUTE 'SELECT public.__var_pop5('''||REPLACE(nom_ter,'''','''''')||''', '''||an_ff||''')';
			--COMMIT;
		RAISE NOTICE 'Incrémentation de la table oc1 (mise à jour du champ pop5) terminée pour le territoire "%"', nom_ter;
	
		-- Bout de code permettant d'ignorer le calcul de la variable en cas d'erreur
		 EXCEPTION WHEN OTHERS THEN
			 RAISE NOTICE 'Pop5 ne peut pas être calculé pour le territoire "%"', nom_ter;
			 RAISE NOTICE '% %', SQLERRM, SQLSTATE;
	END;

	--************************************************************************
	-- Conclusion
	--************************************************************************
	RAISE NOTICE '';
	RAISE NOTICE '====== FIN TRAITEMENT ======';
	RAISE NOTICE '[INFO] Toutes les variables ont été calculées pour le territoire "%"', nom_ter;
   	heureb = clock_timestamp();
	RAISE NOTICE 'Fin du traitement : %', heureb;
	RAISE NOTICE 'Durée du traitement : %', CAST(heureb as time)-CAST(heurea as time);
	RAISE NOTICE '';

END;
$function$
