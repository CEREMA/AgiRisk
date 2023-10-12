SET client_encoding = 'UTF8';

CREATE OR REPLACE PROCEDURE public.__indic_rc_all(IN nom_ter text, IN an_bdtopo text)
 LANGUAGE plpgsql
AS $procedure$

-- Procédure SQL permettant de générer en une fois les représentations cartographiques de tous les indicateurs pour tous les types d'aléa et toutes les occurrences de crue sur un territoire donné
-- © Cerema / GT AgiRisk (auteurs du script : Lucie, Sébastien)
-- Dernière mise à jour du script le 24/08/2023 par Sébastien

-- Paramètres d'entrée (nom du territoire d'étude en premier argument, puis tous les millésimes des référentiels nécessaires aux calculs) :
-- nom_ter = nom du territoire d'étude tel que renseigné dans le champ `territoire` de la table c_general.territoires
-- an_bdtopo = millésime (année au format AAAA) des tables de la BD TOPO®

-- Exemples de commandes d'appel à cette procédure :
-- CALL public.__indic_rc_all('Baccarat''IRIS', '2022');
-- CALL public.__indic_rc_all('Cap Atlantique', '2022');
-- CALL public.__indic_rc_all('CARENE', '2022');
-- CALL public.__indic_rc_all('CC_GST', '2022');
-- CALL public.__indic_rc_all('CDA La Rochelle - CDC Aunis Atlantique', '2022');
-- CALL public.__indic_rc_all('Clain amont', '2022');
-- CALL public.__indic_rc_all('Communauté de Communes Terre Lorraine du Longuyonnais', '2022');
-- CALL public.__indic_rc_all('Jura', '2022');
-- CALL public.__indic_rc_all('Longuyon', '2022');
-- CALL public.__indic_rc_all('Scot de Tours', '2022');
-- CALL public.__indic_rc_all('Sequana', '2022');
-- CALL public.__indic_rc_all('Sequana Ource et Digeanne', '2022');
-- CALL public.__indic_rc_all('Sequana Seine et Brevon', '2022');
-- CALL public.__indic_rc_all('TRI Baccarat secteur 54', '2022');
-- CALL public.__indic_rc_all('TRI Nancy Damelevieres', '2022');
-- CALL public.__indic_rc_all('TRI Noirmoutier SJDM', '2022');
-- CALL public.__indic_rc_all('TRI Verdun', '2022');
-- CALL public.__indic_rc_all('Vienne Clain', '2022');
-- CALL public.__indic_rc_all('Wissant', '2022');
-- CALL public.__indic_rc_all('Zorn', '2022');

DECLARE
	heurea varchar; -- heure de début du traitement
	heureb varchar; -- heure de fin du traitement
	a text; -- itération sur le type_alea
	q text; -- itération sur le code_occurrence

BEGIN
	heurea = current_timestamp;

	RAISE NOTICE '';
	RAISE NOTICE '====== RAPPORT ======';
	RAISE NOTICE '====== GÉNÉRATION DE L''ENSEMBLE DES REPRÉSENTATIONS CARTOGRAPHIQUES DES INDICATEURS POUR TOUS LES TYPES D''ALÉA ET TOUTES LES OCCURRENCES DE CRUE DISPONIBLES SUR LE TERRITOIRE RENSEIGNÉ ======';
	RAISE NOTICE 'Début du traitement : %', heurea;

	--************************************************************************
	-- Représentation cartographique de l'indicateur S1/2a (population occupant des bâtiments de plain-pied fortement inondables)
	--************************************************************************
	BEGIN
		RAISE NOTICE '';
		RAISE NOTICE '====== Représentation cartographique de l''indicateur S1/2a (population occupant des bâtiments de plain-pied fortement inondables) ======';
		
			-- Inventaire de tous les types d'aléa et de toutes les occurrences de crue disponibles dans la table zx
			FOR a, q IN SELECT DISTINCT REPLACE(type_alea,'''',''''''), REPLACE(code_occurrence,'''','''''')
			FROM c_phenomenes.zx
			WHERE territoire = ''||nom_ter||''
			
			-- Exécution de la fonction d'incrémentation de la table s1_2a_rc pour tous les types d'aléa et occurrences de crue disponibles
			LOOP
				EXECUTE 'DELETE FROM p_rep_carto.s1_2a_rc WHERE territoire = '''||REPLACE(nom_ter,'''','''''')||''' AND type_alea = '''||a||''' AND code_occurrence = '''||q||'''';
				EXECUTE 'SELECT public.__indic_s1_2a_rc('''||REPLACE(nom_ter,'''','''''')||''', '''||a||''', '''||q||''', '''||an_bdtopo||''')';
				--COMMIT;
			END LOOP;
		
		RAISE NOTICE 'Incrémentation de la table s1_2a_rc terminée pour le territoire "%"', nom_ter;
	
		-- Bout de code permettant d'ignorer la production de la représentation cartographique en cas d'erreur
		 EXCEPTION WHEN OTHERS THEN
			 RAISE NOTICE 's1_2a_rc ne peut pas être calculé pour le territoire "%"', nom_ter;
			 RAISE NOTICE '% %', SQLERRM, SQLSTATE;
	END;

	--************************************************************************
	-- Représentation cartographique de l'indicateur S1/2b (population occupant un rez-de-chaussée fortement inondable)
	--************************************************************************
	BEGIN
		RAISE NOTICE '';
		RAISE NOTICE '====== Représentation cartographique de l''indicateur S1/2b (population occupant un rez-de-chaussée fortement inondable) ======';
		
			-- Inventaire de tous les types d'aléa et de toutes les occurrences de crue disponibles dans la table zx
			FOR a, q IN SELECT DISTINCT REPLACE(type_alea,'''',''''''), REPLACE(code_occurrence,'''','''''')
			FROM c_phenomenes.zx
			WHERE territoire = ''||nom_ter||''
			
			-- Exécution de la fonction d'incrémentation de la table s1_2b_rc pour tous les types d'aléa et occurrences de crue disponibles
			LOOP
				EXECUTE 'DELETE FROM p_rep_carto.s1_2b_rc WHERE territoire = '''||REPLACE(nom_ter,'''','''''')||''' AND type_alea = '''||a||''' AND code_occurrence = '''||q||'''';
				EXECUTE 'SELECT public.__indic_s1_2b_rc('''||REPLACE(nom_ter,'''','''''')||''', '''||a||''', '''||q||''', '''||an_bdtopo||''')';
				--COMMIT;
			END LOOP;
		
		RAISE NOTICE 'Incrémentation de la table s1_2b_rc terminée pour le territoire "%"', nom_ter;
	
		-- Bout de code permettant d'ignorer la production de la représentation cartographique en cas d'erreur
		 EXCEPTION WHEN OTHERS THEN
			 RAISE NOTICE 's1_2b_rc ne peut pas être calculé pour le territoire "%"', nom_ter;
			 RAISE NOTICE '% %', SQLERRM, SQLSTATE;
	END;

	--************************************************************************
	-- Représentation cartographique de l'indicateur S3/1a (occupants en zone inondable)
	--************************************************************************
	BEGIN
		RAISE NOTICE '';
		RAISE NOTICE '====== Représentation cartographique de l''indicateur S3/1a (occupants en zone inondable) ======';
		
			-- Inventaire de tous les types d'aléa et de toutes les occurrences de crue disponibles dans la table zx
			FOR a, q IN SELECT DISTINCT REPLACE(type_alea,'''',''''''), REPLACE(code_occurrence,'''','''''')
			FROM c_phenomenes.zx
			WHERE territoire = ''||nom_ter||''
			
			-- Exécution de la fonction d'incrémentation de la table s3_1a_rc pour tous les types d'aléa et occurrences de crue disponibles
			LOOP
				EXECUTE 'DELETE FROM p_rep_carto.s3_1a_rc WHERE territoire = '''||REPLACE(nom_ter,'''','''''')||''' AND type_alea = '''||a||''' AND code_occurrence = '''||q||'''';
				EXECUTE 'SELECT public.__indic_s3_1a_rc('''||REPLACE(nom_ter,'''','''''')||''', '''||a||''', '''||q||''', '''||an_bdtopo||''')';
				--COMMIT;
			END LOOP;
		
		RAISE NOTICE 'Incrémentation de la table s3_1a_rc terminée pour le territoire "%"', nom_ter;
	
		-- Bout de code permettant d'ignorer la production de la représentation cartographique en cas d'erreur
		 EXCEPTION WHEN OTHERS THEN
			 RAISE NOTICE 's3_1a_rc ne peut pas être calculé pour le territoire "%"', nom_ter;
			 RAISE NOTICE '% %', SQLERRM, SQLSTATE;
	END;

	--************************************************************************
	-- Représentation cartographique de l'indicateur S3/1f (surfaces agricoles inondables)
	--************************************************************************
	BEGIN
		RAISE NOTICE '';
		RAISE NOTICE '====== Représentation cartographique de l''indicateur S3/1f (surfaces agricoles inondables) ======';
		
			-- Inventaire de tous les types d'aléa et de toutes les occurrences de crue disponibles dans la table zx
			FOR a, q IN SELECT DISTINCT REPLACE(type_alea,'''',''''''), REPLACE(code_occurrence,'''','''''')
			FROM c_phenomenes.zx
			WHERE territoire = ''||nom_ter||''
			
			-- Exécution de la fonction d'incrémentation de la table s3_1f_rc pour tous les types d'aléa et occurrences de crue disponibles
			LOOP
				EXECUTE 'DELETE FROM p_rep_carto.s3_1f_rc WHERE territoire = '''||REPLACE(nom_ter,'''','''''')||''' AND type_alea = '''||a||''' AND code_occurrence = '''||q||'''';
				EXECUTE 'SELECT public.__indic_s3_1f_rc('''||REPLACE(nom_ter,'''','''''')||''', '''||a||''', '''||q||''', '''||an_bdtopo||''')';
				--COMMIT;
			END LOOP;
		
		RAISE NOTICE 'Incrémentation de la table s3_1f_rc terminée pour le territoire "%"', nom_ter;
	
		-- Bout de code permettant d'ignorer la production de la représentation cartographique en cas d'erreur
		 EXCEPTION WHEN OTHERS THEN
			 RAISE NOTICE 's3_1f_rc ne peut pas être calculé pour le territoire "%"', nom_ter;
			 RAISE NOTICE '% %', SQLERRM, SQLSTATE;
	END;

	--************************************************************************
	-- Représentation cartographique de l'indicateur S3/2b (capacités d'hébergement du territoire situées hors zone inondable)
	--************************************************************************
	BEGIN
		RAISE NOTICE '';
		RAISE NOTICE '====== Représentation cartographique de l''indicateur S3/2b (capacités d''hébergement du territoire situées hors zone inondable) ======';
		
			-- Inventaire de tous les types d'aléa et de toutes les occurrences de crue disponibles dans la table zx
			FOR a, q IN SELECT DISTINCT REPLACE(type_alea,'''',''''''), REPLACE(code_occurrence,'''','''''')
			FROM c_phenomenes.zx
			WHERE territoire = ''||nom_ter||''
			
			-- Exécution de la fonction d'incrémentation de la table s3_2b_rc pour tous les types d'aléa et occurrences de crue disponibles
			LOOP
				EXECUTE 'DELETE FROM p_rep_carto.s3_2b_rc WHERE territoire = '''||REPLACE(nom_ter,'''','''''')||''' AND type_alea = '''||a||''' AND code_occurrence = '''||q||'''';
				EXECUTE 'SELECT public.__indic_s3_2b_rc('''||REPLACE(nom_ter,'''','''''')||''', '''||a||''', '''||q||''', '''||an_bdtopo||''')';
				--COMMIT;
			END LOOP;
		
		RAISE NOTICE 'Incrémentation de la table s3_2b_rc terminée pour le territoire "%"', nom_ter;
	
		-- Bout de code permettant d'ignorer la production de la représentation cartographique en cas d'erreur
		 EXCEPTION WHEN OTHERS THEN
			 RAISE NOTICE 's3_2b_rc ne peut pas être calculé pour le territoire "%"', nom_ter;
			 RAISE NOTICE '% %', SQLERRM, SQLSTATE;
	END;

	--************************************************************************
	-- Représentation cartographique de l'indicateur S2/2a (montant des dommages aux logements)
	--************************************************************************

	-- Modalité de calcul n°1 de s2/2a (__indic_s2_2a_amc_rc)
	BEGIN
		RAISE NOTICE '';
		RAISE NOTICE '====== Représentation cartographique de l''indicateur S2/2a suivant la modalité de calcul AMC (montant des dommages aux logements d''après les fichiers AMC du Cerema Méditerranée) ======';
		
			-- Inventaire de tous les types d'aléa et de toutes les occurrences de crue disponibles dans la table zx
			FOR a, q IN SELECT DISTINCT REPLACE(type_alea,'''',''''''), REPLACE(code_occurrence,'''','''''')
			FROM c_phenomenes.zx
			WHERE territoire = ''||nom_ter||''
			
			-- Exécution de la fonction d'incrémentation de la table s2_2a_amc_rc pour tous les types d'aléa et occurrences de crue disponibles
			LOOP
				EXECUTE 'DELETE FROM p_rep_carto.s2_2a_amc_rc WHERE territoire = '''||REPLACE(nom_ter,'''','''''')||''' AND type_alea = '''||a||''' AND code_occurrence = '''||q||'''';
				EXECUTE 'SELECT public.__indic_s2_2a_amc_rc('''||REPLACE(nom_ter,'''','''''')||''', '''||a||''', '''||q||''', '''||an_bdtopo||''')';
				--COMMIT;
			END LOOP;
		
		RAISE NOTICE 'Incrémentation de la table s2_2a_amc_rc terminée pour le territoire "%"', nom_ter;
	
		-- Bout de code permettant d'ignorer la production de la représentation cartographique en cas d'erreur
		 EXCEPTION WHEN OTHERS THEN
			 RAISE NOTICE 's2_2a_amc_rc ne peut pas être calculé pour le territoire "%"', nom_ter;
			 RAISE NOTICE '% %', SQLERRM, SQLSTATE;
	END;

	--************************************************************************
	-- Représentation cartographique de l'indicateur S2/6a (montant des dommages aux cultures agricoles)
	--************************************************************************
	BEGIN
		RAISE NOTICE '';
		RAISE NOTICE '====== Représentation cartographique de l''indicateur S2/6a (montant des dommages aux cultures agricoles) ======';
		
			-- Inventaire de tous les types d'aléa et de toutes les occurrences de crue disponibles dans la table zx
			FOR a, q IN SELECT DISTINCT REPLACE(type_alea,'''',''''''), REPLACE(code_occurrence,'''','''''')
			FROM c_phenomenes.zx
			WHERE territoire = ''||nom_ter||''
			
			-- Exécution de la fonction d'incrémentation de la table s2_6a_rc pour tous les types d'aléa et occurrences de crue disponibles
			LOOP
				EXECUTE 'DELETE FROM p_rep_carto.s2_6a_rc WHERE territoire = '''||REPLACE(nom_ter,'''','''''')||''' AND type_alea = '''||a||''' AND code_occurrence = '''||q||'''';
				EXECUTE 'SELECT public.__indic_s2_6a_rc('''||REPLACE(nom_ter,'''','''''')||''', '''||a||''', '''||q||''', '''||an_bdtopo||''')';
				--COMMIT;
			END LOOP;
		
		RAISE NOTICE 'Incrémentation de la table s2_6a_rc terminée pour le territoire "%"', nom_ter;
	
		-- Bout de code permettant d'ignorer la production de la représentation cartographique en cas d'erreur
		 EXCEPTION WHEN OTHERS THEN
			 RAISE NOTICE 's2_6a_rc ne peut pas être calculé pour le territoire "%"', nom_ter;
			 RAISE NOTICE '% %', SQLERRM, SQLSTATE;
	END;

	--************************************************************************
	-- Représentation cartographique de l'indicateur S2/14a (surfaces à urbaniser inondables)
	--************************************************************************
	BEGIN
		RAISE NOTICE '';
		RAISE NOTICE '====== Représentation cartographique de l''indicateur S2/14a (surfaces à urbaniser inondables) ======';
		
			-- Inventaire de tous les types d'aléa et de toutes les occurrences de crue disponibles dans la table zx
			FOR a, q IN SELECT DISTINCT REPLACE(type_alea,'''',''''''), REPLACE(code_occurrence,'''','''''')
			FROM c_phenomenes.zx
			WHERE territoire = ''||nom_ter||''
			
			-- Exécution de la fonction d'incrémentation de la table s2_14a_rc pour tous les types d'aléa et occurrences de crue disponibles
			LOOP
				EXECUTE 'DELETE FROM p_rep_carto.s2_14a_rc WHERE territoire = '''||REPLACE(nom_ter,'''','''''')||''' AND type_alea = '''||a||''' AND code_occurrence = '''||q||'''';
				EXECUTE 'SELECT public.__indic_s2_14a_rc('''||REPLACE(nom_ter,'''','''''')||''', '''||a||''', '''||q||''', '''||an_bdtopo||''')';
				--COMMIT;
			END LOOP;
		
		RAISE NOTICE 'Incrémentation de la table s2_14a_rc terminée pour le territoire "%"', nom_ter;
	
		-- Bout de code permettant d'ignorer la production de la représentation cartographique en cas d'erreur
		 EXCEPTION WHEN OTHERS THEN
			 RAISE NOTICE 's2_14a_rc ne peut pas être calculé pour le territoire "%"', nom_ter;
			 RAISE NOTICE '% %', SQLERRM, SQLSTATE;
	END;

	--************************************************************************
	-- Représentation cartographique de l'indicateur logt_zx (nombre de logements en zone inondable)
	--************************************************************************
	BEGIN
		RAISE NOTICE '';
		RAISE NOTICE '====== Représentation cartographique de l''indicateur logt_zx (nombre de logements en zone inondable) ======';
		
			-- Inventaire de tous les types d'aléa et de toutes les occurrences de crue disponibles dans la table zx
			FOR a, q IN SELECT DISTINCT REPLACE(type_alea,'''',''''''), REPLACE(code_occurrence,'''','''''')
			FROM c_phenomenes.zx
			WHERE territoire = ''||nom_ter||''
			
			-- Exécution de la fonction d'incrémentation de la table logt_zx_rc pour tous les types d'aléa et occurrences de crue disponibles
			LOOP
				EXECUTE 'DELETE FROM p_rep_carto.logt_zx_rc WHERE territoire = '''||REPLACE(nom_ter,'''','''''')||''' AND type_alea = '''||a||''' AND code_occurrence = '''||q||'''';
				EXECUTE 'SELECT public.__indic_logt_zx_rc('''||REPLACE(nom_ter,'''','''''')||''', '''||a||''', '''||q||''', '''||an_bdtopo||''')';
				--COMMIT;
			END LOOP;
		
		RAISE NOTICE 'Incrémentation de la table logt_zx_rc terminée pour le territoire "%"', nom_ter;
	
		-- Bout de code permettant d'ignorer la production de la représentation cartographique en cas d'erreur
		 EXCEPTION WHEN OTHERS THEN
			 RAISE NOTICE 'logt_zx_rc ne peut pas être calculé pour le territoire "%"', nom_ter;
			 RAISE NOTICE '% %', SQLERRM, SQLSTATE;
	END;

	--************************************************************************
	-- Représentation cartographique de l'indicateur pop_agee_zx (habitants âgés de plus de 65 ans en zone inondable)
	--************************************************************************
	BEGIN
		RAISE NOTICE '';
		RAISE NOTICE '====== Représentation cartographique de l''indicateur pop_agee_zx (habitants âgés de plus de 65 ans en zone inondable) ======';
		
			-- Inventaire de tous les types d'aléa et de toutes les occurrences de crue disponibles dans la table zx
			FOR a, q IN SELECT DISTINCT REPLACE(type_alea,'''',''''''), REPLACE(code_occurrence,'''','''''')
			FROM c_phenomenes.zx
			WHERE territoire = ''||nom_ter||''
			
			-- Exécution de la fonction d'incrémentation de la table pop_agee_zx_rc pour tous les types d'aléa et occurrences de crue disponibles
			LOOP
				EXECUTE 'DELETE FROM p_rep_carto.pop_agee_zx_rc WHERE territoire = '''||REPLACE(nom_ter,'''','''''')||''' AND type_alea = '''||a||''' AND code_occurrence = '''||q||'''';
				EXECUTE 'SELECT public.__indic_pop_agee_zx_rc('''||REPLACE(nom_ter,'''','''''')||''', '''||a||''', '''||q||''', '''||an_bdtopo||''')';
				--COMMIT;
			END LOOP;
		
		RAISE NOTICE 'Incrémentation de la table pop_agee_zx_rc terminée pour le territoire "%"', nom_ter;
	
		-- Bout de code permettant d'ignorer la production de la représentation cartographique en cas d'erreur
		 EXCEPTION WHEN OTHERS THEN
			 RAISE NOTICE 'pop_agee_zx_rc ne peut pas être calculé pour le territoire "%"', nom_ter;
			 RAISE NOTICE '% %', SQLERRM, SQLSTATE;
	END;

	--************************************************************************
	-- Représentation cartographique de l'indicateur salaries_zx (salariés en zone inondable)
	--************************************************************************
	BEGIN
		RAISE NOTICE '';
		RAISE NOTICE '====== Représentation cartographique de l''indicateur salaries_zx (salariés en zone inondable) ======';
		
			-- Inventaire de tous les types d'aléa et de toutes les occurrences de crue disponibles dans la table zx
			FOR a, q IN SELECT DISTINCT REPLACE(type_alea,'''',''''''), REPLACE(code_occurrence,'''','''''')
			FROM c_phenomenes.zx
			WHERE territoire = ''||nom_ter||''
			
			-- Exécution de la fonction d'incrémentation de la table salaries_zx_rc pour tous les types d'aléa et occurrences de crue disponibles
			LOOP
				EXECUTE 'DELETE FROM p_rep_carto.salaries_zx_rc WHERE territoire = '''||REPLACE(nom_ter,'''','''''')||''' AND type_alea = '''||a||''' AND code_occurrence = '''||q||'''';
				EXECUTE 'SELECT public.__indic_salaries_zx_rc('''||REPLACE(nom_ter,'''','''''')||''', '''||a||''', '''||q||''', '''||an_bdtopo||''')';
				--COMMIT;
			END LOOP;
		
		RAISE NOTICE 'Incrémentation de la table salaries_zx_rc terminée pour le territoire "%"', nom_ter;
	
		-- Bout de code permettant d'ignorer la production de la représentation cartographique en cas d'erreur
		 EXCEPTION WHEN OTHERS THEN
			 RAISE NOTICE 'salaries_zx_rc ne peut pas être calculé pour le territoire "%"', nom_ter;
			 RAISE NOTICE '% %', SQLERRM, SQLSTATE;
	END;

	--************************************************************************
	-- Conclusion
	--************************************************************************
	RAISE NOTICE '';
	RAISE NOTICE '====== FIN TRAITEMENT ======';
	RAISE NOTICE '[INFO] Toutes les représentations cartographiques des indicateurs ont été générées pour le territoire "%"', nom_ter;
   	heureb = clock_timestamp();
	RAISE NOTICE 'Fin du traitement : %', heureb;
	RAISE NOTICE 'Durée du traitement : %', CAST(heureb as time)-CAST(heurea as time);
	RAISE NOTICE '';

END;
$procedure$
