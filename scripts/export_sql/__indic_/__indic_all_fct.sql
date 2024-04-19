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

CREATE OR REPLACE FUNCTION public.__indic_all_fct(nom_ter text, an_bdtopo text, an_fct_dmg text)
 RETURNS void
 LANGUAGE plpgsql
AS $function$

-- Fonction SQL permettant de calculer en une fois tous les indicateurs pour tous les types d'aléa et toutes les occurrences de crue sur un territoire donné
-- © Cerema / GT AgiRisk (auteurs du script : Lucie, Sébastien)
-- Dernière mise à jour du script le 24/08/2023 par Sébastien

-- Paramètres d'entrée (nom du territoire d'étude en premier argument, puis tous les millésimes des référentiels nécessaires aux calculs des indicateurs) :
-- nom_ter = nom du territoire d'étude tel que renseigné dans le champ `territoire` de la table c_general.territoires
-- an_bdtopo = millésime (année au format AAAA) des tables de la BD TOPO®
-- an_fct_dmg : année (au format AAAA) d'actualisation des coûts dans les fonctions de dommages (dans l'objectif de suivi de l'évolution des coûts de dommages selon l'inflation)

-- Exemples d'appels à cette fonction :
-- SELECT public.__indic_all_fct('Baccarat''IRIS', '2022', '2022');
-- SELECT public.__indic_all_fct('Cap Atlantique', '2022', '2022');
-- SELECT public.__indic_all_fct('CARENE', '2022', '2022');
-- SELECT public.__indic_all_fct('CC_GST', '2022', '2022');
-- SELECT public.__indic_all_fct('CDA La Rochelle - CDC Aunis Atlantique', '2022', '2022');
-- SELECT public.__indic_all_fct('Clain amont', '2022', '2022');
-- SELECT public.__indic_all_fct('Communauté de Communes Terre Lorraine du Longuyonnais', '2022', '2022');
-- SELECT public.__indic_all_fct('Jura', '2022', '2022');
-- SELECT public.__indic_all_fct('Longuyon', '2022', '2022');
-- SELECT public.__indic_all_fct('Scot de Tours', '2022', '2022');
-- SELECT public.__indic_all_fct('Sequana', '2022', '2022');
-- SELECT public.__indic_all_fct('Sequana Ource et Digeanne', '2022', '2022');
-- SELECT public.__indic_all_fct('Sequana Seine et Brevon', '2022', '2022');
-- SELECT public.__indic_all_fct('TRI Baccarat secteur 54', '2022', '2022');
-- SELECT public.__indic_all_fct('TRI Nancy Damelevieres', '2022', '2022');
-- SELECT public.__indic_all_fct('TRI Noirmoutier SJDM', '2022', '2022');
-- SELECT public.__indic_all_fct('TRI Verdun', '2022', '2022');
-- SELECT public.__indic_all_fct('Vienne Clain', '2022', '2022');
-- SELECT public.__indic_all_fct('Wissant', '2022', '2022');
-- SELECT public.__indic_all_fct('Zorn', '2022', '2022');

DECLARE
	heurea varchar; -- heure de début du traitement
	heureb varchar; -- heure de fin du traitement
	a text; -- itération sur le type_alea
	q text; -- itération sur le code_occurrence

BEGIN
	heurea = current_timestamp;

	RAISE NOTICE '';
	RAISE NOTICE '====== RAPPORT ======';
	RAISE NOTICE '====== CALCUL DE L''ENSEMBLE DES INDICATEURS POUR TOUS LES TYPES D''ALÉA ET TOUTES LES OCCURRENCES DE CRUE DISPONIBLES SUR LE TERRITOIRE RENSEIGNÉ ======';
	RAISE NOTICE 'Début du traitement : %', heurea;

	-- NOTA : le calcul de certains indicateurs pouvant faire appel à d'autres tables qui doivent être préalablement incrémentées, un ordre d'exécution précis des scripts de calcul, qui ne suit pas forcément l'ordre croissant des numéros d'indicateurs, a été établi ci-après (il convient par exemple de calculer S3/1f avant S2/6a, car le second utilise les résultats du premier).

	--************************************************************************
	-- Indicateur S1/2a (population occupant des bâtiments de plain-pied fortement inondables)
	--************************************************************************
	BEGIN
		RAISE NOTICE '';
		RAISE NOTICE '====== Calcul de l''indicateur S1/2a (population occupant des bâtiments de plain-pied fortement inondables) ======';
		
			-- Inventaire de tous les types d'aléa et de toutes les occurrences de crue disponibles dans la table zx
			FOR a, q IN SELECT DISTINCT REPLACE(type_alea,'''',''''''), REPLACE(code_occurrence,'''','''''')
			FROM c_phenomenes.zx
			WHERE territoire = ''||nom_ter||''
			
			-- Exécution de la fonction d'incrémentation de la table s1_2a pour tous les types d'aléa et occurrences de crue disponibles
			LOOP
				EXECUTE 'DELETE FROM p_indicateurs.s1_2a WHERE territoire = '''||REPLACE(nom_ter,'''','''''')||''' AND type_alea = '''||a||''' AND code_occurrence = '''||q||'''';
				EXECUTE 'SELECT public.__indic_s1_2a('''||REPLACE(nom_ter,'''','''''')||''', '''||a||''', '''||q||''', '''||an_bdtopo||''')';
				--COMMIT;
			END LOOP;
		
		RAISE NOTICE 'Incrémentation de la table s1_2a terminée pour le territoire "%"', nom_ter;
	
		-- Bout de code permettant d'ignorer le calcul de l'indicateur en cas d'erreur
		 EXCEPTION WHEN OTHERS THEN
		 RAISE NOTICE 's1_2a ne peut pas être calculé pour le territoire "%"', nom_ter;
		 RAISE NOTICE '% %', SQLERRM, SQLSTATE;
	END;

	--************************************************************************
	-- Indicateur S1/2b (population occupant un rez-de-chaussée fortement inondable)
	--************************************************************************
	BEGIN
		RAISE NOTICE '';
		RAISE NOTICE '====== Calcul de l''indicateur S1/2b (population occupant un rez-de-chaussée fortement inondable) ======';
		
			-- Inventaire de tous les types d'aléa et de toutes les occurrences de crue disponibles dans la table zx
			FOR a, q IN SELECT DISTINCT REPLACE(type_alea,'''',''''''), REPLACE(code_occurrence,'''','''''')
			FROM c_phenomenes.zx
			WHERE territoire = ''||nom_ter||''
			
			-- Exécution de la fonction d'incrémentation de la table s1_2b pour tous les types d'aléa et occurrences de crue disponibles
			LOOP
				EXECUTE 'DELETE FROM p_indicateurs.s1_2b WHERE territoire = '''||REPLACE(nom_ter,'''','''''')||''' AND type_alea = '''||a||''' AND code_occurrence = '''||q||'''';
				EXECUTE 'SELECT public.__indic_s1_2b('''||REPLACE(nom_ter,'''','''''')||''', '''||a||''', '''||q||''', '''||an_bdtopo||''')';
				--COMMIT;
			END LOOP;
		
		RAISE NOTICE 'Incrémentation de la table s1_2b terminée pour le territoire "%"', nom_ter;
	
		-- Bout de code permettant d'ignorer le calcul de l'indicateur en cas d'erreur
		 EXCEPTION WHEN OTHERS THEN
		 RAISE NOTICE 's1_2b ne peut pas être calculé pour le territoire "%"', nom_ter;
		 RAISE NOTICE '% %', SQLERRM, SQLSTATE;
	END;

	--************************************************************************
	-- Indicateur S3/1a (occupants en zone inondable)
	--************************************************************************
	BEGIN
		RAISE NOTICE '';
		RAISE NOTICE '====== Calcul de l''indicateur S3/1a (occupants en zone inondable) ======';
		
			-- Inventaire de tous les types d'aléa et de toutes les occurrences de crue disponibles dans la table zx
			FOR a, q IN SELECT DISTINCT REPLACE(type_alea,'''',''''''), REPLACE(code_occurrence,'''','''''')
			FROM c_phenomenes.zx
			WHERE territoire = ''||nom_ter||''
			
			-- Exécution de la fonction d'incrémentation de la table s3_1a pour tous les types d'aléa et occurrences de crue disponibles
			LOOP
				EXECUTE 'DELETE FROM p_indicateurs.s3_1a WHERE territoire = '''||REPLACE(nom_ter,'''','''''')||''' AND type_alea = '''||a||''' AND code_occurrence = '''||q||'''';
				EXECUTE 'SELECT public.__indic_s3_1a('''||REPLACE(nom_ter,'''','''''')||''', '''||a||''', '''||q||''', '''||an_bdtopo||''')';
				--COMMIT;
			END LOOP;
		
		RAISE NOTICE 'Incrémentation de la table s3_1a terminée pour le territoire "%"', nom_ter;
	
		-- Bout de code permettant d'ignorer le calcul de l'indicateur en cas d'erreur
		 EXCEPTION WHEN OTHERS THEN
		 RAISE NOTICE 's3_1a ne peut pas être calculé pour le territoire "%"', nom_ter;
		 RAISE NOTICE '% %', SQLERRM, SQLSTATE;
	END;

	--************************************************************************
	-- Indicateur S3/1f (surfaces agricoles inondables)
	--************************************************************************
	BEGIN
		RAISE NOTICE '';
		RAISE NOTICE '====== Calcul de l''indicateur S3/1f (surfaces agricoles inondables) ======';
		
			-- Inventaire de tous les types d'aléa et de toutes les occurrences de crue disponibles dans la table zx
			FOR a, q IN SELECT DISTINCT REPLACE(type_alea,'''',''''''), REPLACE(code_occurrence,'''','''''')
			FROM c_phenomenes.zx
			WHERE territoire = ''||nom_ter||''
			
			-- Exécution de la fonction d'incrémentation de la table s3_1f pour tous les types d'aléa et occurrences de crue disponibles
			LOOP
				EXECUTE 'DELETE FROM p_indicateurs.s3_1f WHERE territoire = '''||REPLACE(nom_ter,'''','''''')||''' AND type_alea = '''||a||''' AND code_occurrence = '''||q||'''';
				EXECUTE 'SELECT public.__indic_s3_1f('''||REPLACE(nom_ter,'''','''''')||''', '''||a||''', '''||q||''', '''||an_bdtopo||''')';
				--COMMIT;
			END LOOP;
		
		RAISE NOTICE 'Incrémentation de la table s3_1f terminée pour le territoire "%"', nom_ter;
	
		-- Bout de code permettant d'ignorer le calcul de l'indicateur en cas d'erreur
		 EXCEPTION WHEN OTHERS THEN
		 RAISE NOTICE 's3_1f ne peut pas être calculé pour le territoire "%"', nom_ter;
		 RAISE NOTICE '% %', SQLERRM, SQLSTATE;
	END;

	--************************************************************************
	-- Indicateur S3/2b (capacités d'hébergement du territoire situées hors zone inondable)
	--************************************************************************
	BEGIN
		RAISE NOTICE '';
		RAISE NOTICE '====== Calcul de l''indicateur S3/2b (capacités d''hébergement du territoire situées hors zone inondable) ======';
		
			-- Inventaire de tous les types d'aléa et de toutes les occurrences de crue disponibles dans la table zx
			FOR a, q IN SELECT DISTINCT REPLACE(type_alea,'''',''''''), REPLACE(code_occurrence,'''','''''')
			FROM c_phenomenes.zx
			WHERE territoire = ''||nom_ter||''
			
			-- Exécution de la fonction d'incrémentation de la table s3_2b pour tous les types d'aléa et occurrences de crue disponibles
			LOOP
				EXECUTE 'DELETE FROM p_indicateurs.s3_2b WHERE territoire = '''||REPLACE(nom_ter,'''','''''')||''' AND type_alea = '''||a||''' AND code_occurrence = '''||q||'''';
				EXECUTE 'SELECT public.__indic_s3_2b('''||REPLACE(nom_ter,'''','''''')||''', '''||a||''', '''||q||''', '''||an_bdtopo||''')';
				--COMMIT;
			END LOOP;
		
		RAISE NOTICE 'Incrémentation de la table s3_2b terminée pour le territoire "%"', nom_ter;
	
		-- Bout de code permettant d'ignorer le calcul de l'indicateur en cas d'erreur
		 EXCEPTION WHEN OTHERS THEN
		 RAISE NOTICE 's3_2b ne peut pas être calculé pour le territoire "%"', nom_ter;
		 RAISE NOTICE '% %', SQLERRM, SQLSTATE;
	END;

	--************************************************************************
	-- Indicateur S2/2a (montant des dommages aux logements)
	--************************************************************************

	-- Modalité de calcul n°1 de s2/2a (__indic_s2_2a_amc)
	BEGIN
		RAISE NOTICE '';
		RAISE NOTICE '====== Calcul de l''indicateur S2/2a suivant la modalité de calcul AMC (montant des dommages aux logements d''après les fichiers AMC du Cerema Med) ======';
		
			-- Inventaire de tous les types d'aléa et de toutes les occurrences de crue disponibles dans la table zx
			FOR a, q IN SELECT DISTINCT REPLACE(type_alea,'''',''''''), REPLACE(code_occurrence,'''','''''')
			FROM c_phenomenes.zx
			WHERE territoire = ''||nom_ter||''
			
			-- Exécution de la fonction d'incrémentation de la table s2_2a_amc pour tous les types d'aléa et occurrences de crue disponibles
			LOOP
				EXECUTE 'DELETE FROM p_indicateurs.s2_2a_amc WHERE territoire = '''||REPLACE(nom_ter,'''','''''')||''' AND type_alea = '''||a||''' AND code_occurrence = '''||q||''' AND date_actu_cout_dmg = '''||REPLACE(an_fct_dmg,'''','''''')||'''';
				EXECUTE 'SELECT public.__indic_s2_2a_amc('''||REPLACE(nom_ter,'''','''''')||''', '''||a||''', '''||q||''', '''||an_fct_dmg||''', '''||an_bdtopo||''')';
				--COMMIT;
			END LOOP;
		
		RAISE NOTICE 'Incrémentation de la table s2_2a_amc terminée pour le territoire "%"', nom_ter;
	
		-- Bout de code permettant d'ignorer le calcul de l'indicateur en cas d'erreur
		 EXCEPTION WHEN OTHERS THEN
		 RAISE NOTICE 's2_2a_amc ne peut pas être calculé pour le territoire "%"', nom_ter;
		 RAISE NOTICE '% %', SQLERRM, SQLSTATE;
	END;

	--************************************************************************
	-- Indicateur S2/6a (montant des dommages aux cultures agricoles)
	--************************************************************************
	BEGIN
		RAISE NOTICE '';
		RAISE NOTICE '====== Calcul de l''indicateur S2/6a (montant des dommages aux cultures agricoles) ======';
		
			-- Inventaire de tous les types d'aléa et de toutes les occurrences de crue disponibles dans la table zx
			FOR a, q IN SELECT DISTINCT REPLACE(type_alea,'''',''''''), REPLACE(code_occurrence,'''','''''')
			FROM c_phenomenes.zx
			WHERE territoire = ''||nom_ter||''
			
			-- Exécution de la fonction d'incrémentation de la table s2_6a pour tous les types d'aléa et occurrences de crue disponibles
			LOOP
				EXECUTE 'DELETE FROM p_indicateurs.s2_6a WHERE territoire = '''||REPLACE(nom_ter,'''','''''')||''' AND type_alea = '''||a||''' AND code_occurrence = '''||q||''' AND date_actu_cout_dmg = '''||REPLACE(an_fct_dmg,'''','''''')||'''';
				EXECUTE 'SELECT public.__indic_s2_6a('''||REPLACE(nom_ter,'''','''''')||''', '''||a||''', '''||q||''', '''||an_fct_dmg||''', '''||an_bdtopo||''')';
				--COMMIT;
			END LOOP;
		
		RAISE NOTICE 'Incrémentation de la table s2_6a terminée pour le territoire "%"', nom_ter;
	
		-- Bout de code permettant d'ignorer le calcul de l'indicateur en cas d'erreur
		 EXCEPTION WHEN OTHERS THEN
		 RAISE NOTICE 's2_6a ne peut pas être calculé pour le territoire "%"', nom_ter;
		 RAISE NOTICE '% %', SQLERRM, SQLSTATE;
	END;

	--************************************************************************
	-- Indicateur S2/14a (surfaces à urbaniser inondables)
	--************************************************************************
	BEGIN
		RAISE NOTICE '';
		RAISE NOTICE '====== Calcul de l''indicateur S2/14a (surfaces à urbaniser inondables) ======';
		
			-- Inventaire de tous les types d'aléa et de toutes les occurrences de crue disponibles dans la table zx
			FOR a, q IN SELECT DISTINCT REPLACE(type_alea,'''',''''''), REPLACE(code_occurrence,'''','''''')
			FROM c_phenomenes.zx
			WHERE territoire = ''||nom_ter||''
			
			-- Exécution de la fonction d'incrémentation de la table s2_14a pour tous les types d'aléa et occurrences de crue disponibles
			LOOP
				EXECUTE 'DELETE FROM p_indicateurs.s2_14a WHERE territoire = '''||REPLACE(nom_ter,'''','''''')||''' AND type_alea = '''||a||''' AND code_occurrence = '''||q||'''';
				EXECUTE 'SELECT public.__indic_s2_14a('''||REPLACE(nom_ter,'''','''''')||''', '''||a||''', '''||q||''', '''||an_bdtopo||''')';
				--COMMIT;
			END LOOP;
		
		RAISE NOTICE 'Incrémentation de la table s2_14a terminée pour le territoire "%"', nom_ter;
	
		-- Bout de code permettant d'ignorer le calcul de l'indicateur en cas d'erreur
		 EXCEPTION WHEN OTHERS THEN
		 RAISE NOTICE 's2_14a ne peut pas être calculé pour le territoire "%"', nom_ter;
		 RAISE NOTICE '% %', SQLERRM, SQLSTATE;
	END;

	--************************************************************************
	-- Indicateur logt_zx (nombre de logements en zone inondable)
	--************************************************************************
	BEGIN
		RAISE NOTICE '';
		RAISE NOTICE '====== Calcul de l''indicateur logt_zx (nombre de logements en zone inondable) ======';
		
			-- Inventaire de tous les types d'aléa et de toutes les occurrences de crue disponibles dans la table zx
			FOR a, q IN SELECT DISTINCT REPLACE(type_alea,'''',''''''), REPLACE(code_occurrence,'''','''''')
			FROM c_phenomenes.zx
			WHERE territoire = ''||nom_ter||''
			
			-- Exécution de la fonction d'incrémentation de la table logt_zx pour tous les types d'aléa et occurrences de crue disponibles
			LOOP
				EXECUTE 'DELETE FROM p_indicateurs.logt_zx WHERE territoire = '''||REPLACE(nom_ter,'''','''''')||''' AND type_alea = '''||a||''' AND code_occurrence = '''||q||'''';
				EXECUTE 'SELECT public.__indic_logt_zx('''||REPLACE(nom_ter,'''','''''')||''', '''||a||''', '''||q||''', '''||an_bdtopo||''')';
				--COMMIT;
			END LOOP;
		
		RAISE NOTICE 'Incrémentation de la table logt_zx terminée pour le territoire "%"', nom_ter;
	
		-- Bout de code permettant d'ignorer le calcul de l'indicateur en cas d'erreur
		 EXCEPTION WHEN OTHERS THEN
		 RAISE NOTICE 'logt_zx ne peut pas être calculé pour le territoire "%"', nom_ter;
		 RAISE NOTICE '% %', SQLERRM, SQLSTATE;
	END;

	--************************************************************************
	-- Indicateur pop_agee_zx (habitants de plus de 65 ans en zone inondable)
	--************************************************************************
	BEGIN
		RAISE NOTICE '';
		RAISE NOTICE '====== Calcul de l''indicateur pop_agee_zx (habitants de plus de 65 ans en zone inondable) ======';
		
			-- Inventaire de tous les types d'aléa et de toutes les occurrences de crue disponibles dans la table zx
			FOR a, q IN SELECT DISTINCT REPLACE(type_alea,'''',''''''), REPLACE(code_occurrence,'''','''''')
			FROM c_phenomenes.zx
			WHERE territoire = ''||nom_ter||''
			
			-- Exécution de la fonction d'incrémentation de la table pop_agee_zx pour tous les types d'aléa et occurrences de crue disponibles
			LOOP
				EXECUTE 'DELETE FROM p_indicateurs.pop_agee_zx WHERE territoire = '''||REPLACE(nom_ter,'''','''''')||''' AND type_alea = '''||a||''' AND code_occurrence = '''||q||'''';
				EXECUTE 'SELECT public.__indic_pop_agee_zx('''||REPLACE(nom_ter,'''','''''')||''', '''||a||''', '''||q||''', '''||an_bdtopo||''')';
				--COMMIT;
			END LOOP;
		
		RAISE NOTICE 'Incrémentation de la table pop_agee_zx terminée pour le territoire "%"', nom_ter;
	
		-- Bout de code permettant d'ignorer le calcul de l'indicateur en cas d'erreur
		 EXCEPTION WHEN OTHERS THEN
		 RAISE NOTICE 'pop_agee_zx ne peut pas être calculé pour le territoire "%"', nom_ter;
		 RAISE NOTICE '% %', SQLERRM, SQLSTATE;
	END;

	--************************************************************************
	-- Indicateur salaries_zx (salariés en zone inondable)
	--************************************************************************
	BEGIN
		RAISE NOTICE '';
		RAISE NOTICE '====== Calcul de l''indicateur salaries_zx (salariés en zone inondable) ======';
		
			-- Inventaire de tous les types d'aléa et de toutes les occurrences de crue disponibles dans la table zx
			FOR a, q IN SELECT DISTINCT REPLACE(type_alea,'''',''''''), REPLACE(code_occurrence,'''','''''')
			FROM c_phenomenes.zx
			WHERE territoire = ''||nom_ter||''
			
			-- Exécution de la fonction d'incrémentation de la table salaries_zx pour tous les types d'aléa et occurrences de crue disponibles
			LOOP
				EXECUTE 'DELETE FROM p_indicateurs.salaries_zx WHERE territoire = '''||REPLACE(nom_ter,'''','''''')||''' AND type_alea = '''||a||''' AND code_occurrence = '''||q||'''';
				EXECUTE 'SELECT public.__indic_salaries_zx('''||REPLACE(nom_ter,'''','''''')||''', '''||a||''', '''||q||''', '''||an_bdtopo||''')';
				--COMMIT;
			END LOOP;
		
		RAISE NOTICE 'Incrémentation de la table salaries_zx terminée pour le territoire "%"', nom_ter;
	
		-- Bout de code permettant d'ignorer le calcul de l'indicateur en cas d'erreur
		 EXCEPTION WHEN OTHERS THEN
		 RAISE NOTICE 'salaries_zx ne peut pas être calculé pour le territoire "%"', nom_ter;
		 RAISE NOTICE '% %', SQLERRM, SQLSTATE;
	END;

	--************************************************************************
	-- Conclusion
	--************************************************************************
	RAISE NOTICE '';
	RAISE NOTICE '====== FIN TRAITEMENT ======';
	RAISE NOTICE '[INFO] Tous les indicateurs ont été calculés pour le territoire "%"', nom_ter;
   	heureb = clock_timestamp();
	RAISE NOTICE 'Fin du traitement : %', heureb;
	RAISE NOTICE 'Durée du traitement : %', CAST(heureb as time)-CAST(heurea as time);
	RAISE NOTICE '';

END;
$function$
