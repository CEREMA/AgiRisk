CREATE OR REPLACE PROCEDURE public.__indic_test1(IN nom_ter text, IN an_fch_acb text, IN an_bdtopo text, IN an_fct_dmg text)
 LANGUAGE plpgsql
AS $procedure$

-- Procédure SQL permettant de calculer en une fois tous les indicateurs pour tous les types d'aléa et toutes les occurrences de crue sur un territoire donné
-- Copyright Cerema / GT AgiRisk
-- Auteurs du script : Lucie et Sébastien

-- Paramètres d'entrée (nom du territoire d'étude en premier argument, puis tous les millésimes des référentiels nécessaires aux calculs des indicateurs) :
-- nom_ter = nom du territoire d'étude tel que renseigné dans le champ `territoire` de la table c_general.territoires
-- an_bdtopo = millésime (année au format AAAA) des tables de la BD TOPO®

-- TODO : les deux arguments suivants sont à supprimer à terme :
-- an_fch_acb : millésime (année au format AAAA) des fichiers "logements" et "sous-sols" produits par le Cerema Méditerranée pour l'Analyse Coûts-Bénéfices (ACB) des Projets de prévention des inondations (détail de la méthode dans cet article : https://www.cerema.fr/fr/actualites/cerema-ameliore-son-fichier-analyse-cout-benefice-projets)
-- an_fct_dmg : année (au format AAAA) d'actualisation des coûts dans les fonctions de dommages (dans l'objectif de suivi de l'évolution des coûts de dommages selon l'inflation)

/* Exemples de commandes d'appel à cette procédure :
CALL public.__indic_all('Baccarat IRIS GE', '2021', '2022', '2021');
CALL public.__indic_all('Clain amont', '2021', '2022', '2021');
CALL public.__indic_all('Jura', '2021', '2022', '2021');
CALL public.__indic_all('Sequana', '2021', '2022', '2021');
CALL public.__indic_all('Sequana Seine et Brevon', '2021', '2022', '2021');
CALL public.__indic_all('TRI Baccarat secteur 54', '2021', '2022', '2021');
CALL public.__indic_all('TRI Noirmoutier SJDM', '2021', '2022', '2021');
CALL public.__indic_all('TRI Verdun', '2021', '2022', '2021');
CALL public.__indic_all('Vienne Clain', '2021', '2022', '2021');
CALL public.__indic_all('Zorn', '2021', '2022', '2021');
*/

DECLARE
	heurea varchar; -- heure de début du traitement
	heureb varchar; -- heure de fin du traitement
	q text; -- itération sur le code_occurrence
	a text; -- itération sur le type_alea

BEGIN
	heurea = current_timestamp;
	
    RAISE NOTICE '';
    RAISE NOTICE '====== RAPPORT ======';
	RAISE NOTICE '====== CALCUL DE L''ENSEMBLE DES INDICATEURS POUR TOUS LES TYPES D''ALÉA ET TOUTES LES OCCURRENCES DE CRUE DISPONIBLES SUR LE TERRITOIRE RENSEIGNÉ ======';
	RAISE NOTICE 'Début du traitement : %', heurea;
	
	-- NOTA : Le calcul de certains indicateurs pouvant faire appel à d'autres tables qui doivent être préalablement incrémentées, un ordre d'exécution précis des scripts de calcul, qui ne suit pas forcément l'ordre croissant des numéros d'indicateurs, a été établi ci-après. Il convient par exemple de calculer S3/1f avant S2/6a, car le second utilise les résultats du premier.
/*
	--************************************************************************
	-- Indicateur S1/2a (population occupant des bâtiments de plain-pied fortement inondables)
	--************************************************************************
	BEGIN
		
		RAISE NOTICE '';
		RAISE NOTICE '====== Calcul de l''indicateur S1/2a (population occupant des bâtiments de plain-pied fortement inondables) ======';
		
			-- Inventaire de tous les types d'aléa et de toutes les occurrences de crue disponibles dans la table zx
			FOR q, a IN SELECT DISTINCT code_occurrence,
			REPLACE(type_alea,'''','''''''''')
			FROM c_phenomenes.zx
			WHERE territoire = ''||nom_ter||''
			
			-- Exécution de la fonction d'incrémentation de la table s1_2a pour tous les types d'aléa et occurrences de crue disponibles
			LOOP
				EXECUTE 'DELETE FROM p_indicateurs.s1_2a WHERE territoire = '''||nom_ter||''' AND code_occurrence = '''||q||''' AND type_alea = '''||a||'''';
				EXECUTE 'SELECT public.__indic_s1_2a('''||nom_ter||''', '''||a||''', '''||q||''', '''||an_bdtopo||''')';
				
				COMMIT;
			
			END LOOP;
		
		RAISE NOTICE 'Incrémentation de la table s1_2a terminée pour ''%''', nom_ter;
	
		-- Bout de code permettant d'ignorer le calcul de l'indicateur en cas d'erreur
		EXCEPTION WHEN OTHERS THEN
		RAISE NOTICE 's1_2a ne peut pas être calculé pour le territoire %', nom_ter;
	
		RAISE NOTICE '% %', SQLERRM, SQLSTATE;
	
	END;

	--************************************************************************
	-- Indicateur S1/2b (population occupant un rez-de-chaussée fortement inondable)
	--************************************************************************
	BEGIN
	
		RAISE NOTICE '';
		RAISE NOTICE '====== Calcul de l''indicateur S1/2b (population occupant un rez-de-chaussée fortement inondable) ======';
		
			-- Inventaire de tous les types d'aléa et de toutes les occurrences de crue disponibles dans la table zx
			FOR q, a IN SELECT DISTINCT code_occurrence,
			REPLACE(type_alea,'''','''''''''')
			FROM c_phenomenes.zx
			WHERE territoire = ''||nom_ter||''
			
			-- Exécution de la fonction d'incrémentation de la table s1_2b pour tous les types d'aléa et occurrences de crue disponibles
			LOOP
				EXECUTE 'DELETE FROM p_indicateurs.s1_2b WHERE territoire = '''||nom_ter||''' AND code_occurrence = '''||q||''' AND type_alea = '''||a||'''';
				EXECUTE 'SELECT public.__indic_s1_2b('''||nom_ter||''', '''||a||''', '''||q||''', '''||an_bdtopo||''')';
				
				COMMIT;
			
			END LOOP;
		
		RAISE NOTICE 'Incrémentation de la table s1_2b terminée pour ''%''', nom_ter;
	
		-- Bout de code permettant d'ignorer le calcul de l'indicateur en cas d'erreur
		EXCEPTION WHEN OTHERS THEN
		RAISE NOTICE 's1_2b ne peut pas être calculé pour le territoire %', nom_ter;
	
		RAISE NOTICE '% %', SQLERRM, SQLSTATE;

	END;

	--************************************************************************
	-- Indicateur S3/1a (occupants en zone inondable)
	--************************************************************************
	BEGIN
	
		RAISE NOTICE '';
		RAISE NOTICE '====== Calcul de l''indicateur S3/1a (occupants en zone inondable) ======';
		
			-- Inventaire de tous les types d'aléa et de toutes les occurrences de crue disponibles dans la table zx
			FOR q, a IN SELECT DISTINCT code_occurrence,
			REPLACE(type_alea,'''','''''''''')
			FROM c_phenomenes.zx
			WHERE territoire = ''||nom_ter||''
			
			-- Exécution de la fonction d'incrémentation de la table s3_1a pour tous les types d'aléa et occurrences de crue disponibles
			LOOP
				EXECUTE 'DELETE FROM p_indicateurs.s3_1a WHERE territoire = '''||nom_ter||''' AND code_occurrence = '''||q||''' AND type_alea = '''||a||'''';
				EXECUTE 'SELECT public.__indic_s3_1a('''||nom_ter||''', '''||a||''', '''||q||''', '''||an_bdtopo||''')';
				
				COMMIT;
			
			END LOOP;
		
		RAISE NOTICE 'Incrémentation de la table s3_1a terminée pour ''%''', nom_ter;
	
		-- Bout de code permettant d'ignorer le calcul de l'indicateur en cas d'erreur
		EXCEPTION WHEN OTHERS THEN
		RAISE NOTICE 's3_1a ne peut pas être calculé pour le territoire %', nom_ter;
	
		RAISE NOTICE '% %', SQLERRM, SQLSTATE;

	END;

/*
	--************************************************************************
	-- Indicateur S3/1f (surfaces agricoles inondables)
	--************************************************************************
	BEGIN
	
		RAISE NOTICE '';
		RAISE NOTICE '====== Calcul de l''indicateur S3/1f (surfaces agricoles inondables) ======';
		
			-- Inventaire de tous les types d'aléa et de toutes les occurrences de crue disponibles dans la table zx
			FOR q, a IN SELECT DISTINCT code_occurrence,
			REPLACE(type_alea,'''','''''''''')
			FROM c_phenomenes.zx
			WHERE territoire = ''||nom_ter||''
			
			-- Exécution de la fonction d'incrémentation de la table s3_1f pour tous les types d'aléa et occurrences de crue disponibles
			LOOP
				EXECUTE 'DELETE FROM p_indicateurs.s3_1f WHERE territoire = '''||nom_ter||''' AND code_occurrence = '''||q||''' AND type_alea = '''||a||'''';
				EXECUTE 'SELECT public.__indic_s3_1f('''||nom_ter||''', '''||a||''', '''||q||''', '''||an_bdtopo||''')';
						
				COMMIT;
			
			END LOOP;
		
		RAISE NOTICE 'Incrémentation de la table s3_1f terminée pour ''%''', nom_ter;
		
		-- Bout de code permettant d'ignorer le calcul de l'indicateur en cas d'erreur
		EXCEPTION WHEN OTHERS THEN
		RAISE NOTICE 's3_1f ne peut pas être calculé pour le territoire %', nom_ter;
	
		RAISE NOTICE '% %', SQLERRM, SQLSTATE;
	
	END;
*/
	--************************************************************************
	-- Indicateur S3/2b (capacités d'hébergement du territoire situées hors zone inondable)
	--************************************************************************
	BEGIN
		
		RAISE NOTICE '';
		RAISE NOTICE '====== Calcul de l''indicateur S3/2b (capacités d''hébergement du territoire situées hors zone inondable) ======';
		
			-- Inventaire de tous les types d'aléa et de toutes les occurrences de crue disponibles dans la table zx
			FOR q, a IN SELECT DISTINCT code_occurrence,
			REPLACE(type_alea,'''','''''''''')
			FROM c_phenomenes.zx
			WHERE territoire = ''||nom_ter||''
			
			-- Exécution de la fonction d'incrémentation de la table s3_2b pour tous les types d'aléa et occurrences de crue disponibles
			LOOP
				EXECUTE 'DELETE FROM p_indicateurs.s3_2b WHERE territoire = '''||nom_ter||''' AND code_occurrence = '''||q||''' AND type_alea = '''||a||'''';
				EXECUTE 'SELECT public.__indic_s3_2b('''||nom_ter||''', '''||a||''', '''||q||''', '''||an_bdtopo||''')';
				
				COMMIT;
			
			END LOOP;
		
		RAISE NOTICE 'Incrémentation de la table s3_2b terminée pour ''%''', nom_ter;
	
		-- Bout de code permettant d'ignorer le calcul de l'indicateur en cas d'erreur
		EXCEPTION WHEN OTHERS THEN
		RAISE NOTICE 's3_2b ne peut pas être calculé pour le territoire %', nom_ter;
	
		RAISE NOTICE '% %', SQLERRM, SQLSTATE;

	END;
*/
	--************************************************************************
	-- Indicateur S2/2a (montant des dommages aux logements)
	--************************************************************************
	BEGIN
		
		RAISE NOTICE '';
		RAISE NOTICE '====== Calcul de l''indicateur S2/2a (montant des dommages aux logements) ======';
		
			-- Inventaire de tous les types d'aléa et de toutes les occurrences de crue disponibles dans la table zx
			FOR a, q IN SELECT DISTINCT REPLACE(type_alea,'''',''''''), code_occurrence
			FROM c_phenomenes.zx
			WHERE territoire = ''||nom_ter||''

			-- Exécution de la fonction d'incrémentation de la table s2_2a pour tous les types d'aléa et occurrences de crue disponibles
			LOOP
				EXECUTE 'DELETE FROM p_indicateurs.s2_2a WHERE territoire = '''||REPLACE(nom_ter,'''','''''')||''' AND type_alea = '''||a||''' AND code_occurrence = '''||q||'''';
				EXECUTE 'SELECT public.__indic_s2_2a('''||REPLACE(nom_ter,'''','''''')||''', '''||a||''', '''||q||''', '''||an_fch_acb||''', '''||an_bdtopo||''', '''||an_fct_dmg||''')';
				
				COMMIT;
			
			END LOOP;

		RAISE NOTICE 'Incrémentation de la table s2_2a terminée pour ''%''', nom_ter;

		-- Bout de code permettant d'ignorer le calcul de l'indicateur en cas d'erreur
		EXCEPTION WHEN OTHERS THEN
		RAISE NOTICE 's2_2a ne peut pas être calculé pour le territoire %', nom_ter;
	
		RAISE NOTICE '% %', SQLERRM, SQLSTATE;

	END;
/*
	--************************************************************************
	-- Indicateur S2/6a (montant des dommages aux cultures agricoles)
	--************************************************************************
	BEGIN
	
		RAISE NOTICE '';
		RAISE NOTICE '====== Calcul de l''indicateur S2/6a (montant des dommages aux cultures agricoles) ======';
		
			-- Inventaire de tous les types d'aléa et de toutes les occurrences de crue disponibles dans la table zx
			FOR q, a IN SELECT DISTINCT code_occurrence,
			REPLACE(type_alea,'''','''''''''')
			FROM c_phenomenes.zx
			WHERE territoire = ''||nom_ter||''
			
			-- Exécution de la fonction d'incrémentation de la table s2_6a pour tous les types d'aléa et occurrences de crue disponibles
			LOOP
				EXECUTE 'DELETE FROM p_indicateurs.s2_6a WHERE territoire = '''||nom_ter||''' AND code_occurrence = '''||q||''' AND type_alea = '''||a||'''';
				EXECUTE 'SELECT public.__indic_s2_6a('''||nom_ter||''', '''||a||''', '''||q||''', '''||an_bdtopo||''')';
				
				COMMIT;
			
			END LOOP;
		
		RAISE NOTICE 'Incrémentation de la table s2_6a terminée pour ''%''', nom_ter;
		
		-- Bout de code permettant d'ignorer le calcul de l'indicateur en cas d'erreur
		EXCEPTION WHEN OTHERS THEN
		RAISE NOTICE 's2_6a ne peut pas être calculé pour le territoire %', nom_ter;
	
		RAISE NOTICE '% %', SQLERRM, SQLSTATE;
	
	END;

	--************************************************************************
	-- Indicateur S2/14a (surfaces à urbaniser inondables)
	--************************************************************************
	BEGIN
		
		RAISE NOTICE '';
		RAISE NOTICE '====== Calcul de l''indicateur S2/14a (surfaces à urbaniser inondables) ======';
		
			-- Inventaire de tous les types d'aléa et de toutes les occurrences de crue disponibles dans la table zx
			FOR q, a IN SELECT DISTINCT code_occurrence,
			REPLACE(type_alea,'''','''''''''')
			FROM c_phenomenes.zx
			WHERE territoire = ''||nom_ter||''
			
			-- Exécution de la fonction d'incrémentation de la table s2_14a pour tous les types d'aléa et occurrences de crue disponibles
			LOOP
				EXECUTE 'DELETE FROM p_indicateurs.s2_14a WHERE territoire = '''||nom_ter||''' AND code_occurrence = '''||q||''' AND type_alea = '''||a||'''';
				EXECUTE 'SELECT public.__indic_s2_14a('''||nom_ter||''', '''||a||''', '''||q||''', '''||an_bdtopo||''')';
				
				COMMIT;
			
			END LOOP;
		
		RAISE NOTICE 'Incrémentation de la table s2_14a terminée pour ''%''', nom_ter;
	
		-- Bout de code permettant d'ignorer le calcul de l'indicateur en cas d'erreur
		EXCEPTION WHEN OTHERS THEN
		RAISE NOTICE 's2_14a ne peut pas être calculé pour le territoire %', nom_ter;
	
		RAISE NOTICE '% %', SQLERRM, SQLSTATE;
	
	END;

	--************************************************************************
	-- Indicateur logt_zx (nombre de logements en zone inondable)
	--************************************************************************
	BEGIN
		
		RAISE NOTICE '';
		RAISE NOTICE '====== Calcul de l''indicateur logt_zx (nombre de logements en zone inondable) ======';
		
			-- Inventaire de tous les types d'aléa et de toutes les occurrences de crue disponibles dans la table zx
			FOR q, a IN SELECT DISTINCT code_occurrence,
			REPLACE(type_alea,'''','''''''''')
			FROM c_phenomenes.zx
			WHERE territoire = ''||nom_ter||''
			
			-- Exécution de la fonction d'incrémentation de la table logt_zx pour tous les types d'aléa et occurrences de crue disponibles
			LOOP
				EXECUTE 'DELETE FROM p_indicateurs.logt_zx WHERE territoire = '''||nom_ter||''' AND code_occurrence = '''||q||''' AND type_alea = '''||a||'''';
				EXECUTE 'SELECT public.__indic_logt_zx('''||nom_ter||''', '''||a||''', '''||q||''', '''||an_bdtopo||''')';
					
				COMMIT;
			
			END LOOP;
		
		RAISE NOTICE 'Incrémentation de la table logt_zx terminée pour ''%''', nom_ter;

		-- Bout de code permettant d'ignorer le calcul de l'indicateur en cas d'erreur
		EXCEPTION WHEN OTHERS THEN
		RAISE NOTICE 'logt_zx ne peut pas être calculé pour le territoire %', nom_ter;
	
		RAISE NOTICE '% %', SQLERRM, SQLSTATE;
	
	END;

	--************************************************************************
	-- Indicateur pop_agee_zx (habitants de plus de 65 ans en zone inondable)
	--************************************************************************
	BEGIN
	
		RAISE NOTICE '';
		RAISE NOTICE '====== Calcul de l''indicateur pop_agee_zx (habitants de plus de 65 ans en zone inondable) ======';
		
			-- Inventaire de tous les types d'aléa et de toutes les occurrences de crue disponibles dans la table zx
			FOR q, a IN SELECT DISTINCT code_occurrence,
			REPLACE(type_alea,'''','''''''''')
			FROM c_phenomenes.zx
			WHERE territoire = ''||nom_ter||''
			
			-- Exécution de la fonction d'incrémentation de la table pop_agee_zx pour tous les types d'aléa et occurrences de crue disponibles
			LOOP
				EXECUTE 'DELETE FROM p_indicateurs.pop_agee_zx WHERE territoire = '''||nom_ter||''' AND code_occurrence = '''||q||''' AND type_alea = '''||a||'''';
				EXECUTE 'SELECT public.__indic_pop_agee_zx('''||nom_ter||''', '''||a||''', '''||q||''', '''||an_bdtopo||''')';
					
				COMMIT;
			
			END LOOP;
		
		RAISE NOTICE 'Incrémentation de la table pop_agee_zx terminée pour ''%''', nom_ter;
	
		-- Bout de code permettant d'ignorer le calcul de l'indicateur en cas d'erreur
		EXCEPTION WHEN OTHERS THEN
		RAISE NOTICE 'pop_agee_zx ne peut pas être calculé pour le territoire %', nom_ter;
	
		RAISE NOTICE '% %', SQLERRM, SQLSTATE;
	
	END;

	--************************************************************************
	-- Indicateur salaries_zx (salariés en zone inondable)
	--************************************************************************
	BEGIN
		
		RAISE NOTICE '';
		RAISE NOTICE '====== Calcul de l''indicateur salaries_zx (salariés en zone inondable) ======';
		
			-- Inventaire de tous les types d'aléa et de toutes les occurrences de crue disponibles dans la table zx
			FOR q, a IN SELECT DISTINCT code_occurrence,
			REPLACE(type_alea,'''','''''''''')
			FROM c_phenomenes.zx
			WHERE territoire = ''||nom_ter||''
			
			-- Exécution de la fonction d'incrémentation de la table salaries_zx pour tous les types d'aléa et occurrences de crue disponibles
			LOOP
				EXECUTE 'DELETE FROM p_indicateurs.pop_agee_zx WHERE territoire = '''||nom_ter||''' AND code_occurrence = '''||q||''' AND type_alea = '''||a||'''';
				EXECUTE 'SELECT public.__indic_salaries_zx('''||nom_ter||''', '''||a||''', '''||q||''', '''||an_bdtopo||''')';
					
				COMMIT;
			
			END LOOP;
		
		RAISE NOTICE 'Incrémentation de la table salaries_zx terminée pour ''%''', nom_ter;

		-- Bout de code permettant d'ignorer le calcul de l'indicateur en cas d'erreur
		EXCEPTION WHEN OTHERS THEN
		RAISE NOTICE 'salaries_zx ne peut pas être calculé pour le territoire %', nom_ter;
	
		RAISE NOTICE '% %', SQLERRM, SQLSTATE;
	
	END;
*/
	--************************************************************************
	-- Conclusion
	--************************************************************************
    RAISE NOTICE '';
    RAISE NOTICE '====== FIN TRAITEMENT ======';
	RAISE NOTICE '[INFO] Tous les indicateurs ont été calculés';
   	heureb = clock_timestamp();
	RAISE NOTICE 'Fin du traitement : %', heureb;
	RAISE NOTICE 'Durée du traitement : %', CAST(heureb as time)-CAST(heurea as time);
	RAISE NOTICE '';

END;
$procedure$
