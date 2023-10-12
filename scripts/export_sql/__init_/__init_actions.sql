SET client_encoding = 'UTF8';

CREATE OR REPLACE PROCEDURE public.__init_actions()
 LANGUAGE plpgsql
AS $procedure$

-- Procédure SQL d'initialisation des tables permettant la définition des actions de gestion des inondations
-- © Cerema / GT AgiRisk
-- Dernière mise à jour du script le 08/09/2023 par Christophe

-- Commande d'appel à cette procédure :
-- CALL public.__init_actions();

DECLARE
	com text; -- variable d'exécution des commentaires
	val text; -- variable de peuplement des valeurs
	ind text; -- variable d'exécution des index

BEGIN

	SET search_path TO r_ressources, public;

	RAISE NOTICE '';
	RAISE NOTICE '====== RAPPORT ======';
	RAISE NOTICE 'Initialisation de la liste des actions de gestion';

	RAISE NOTICE 'Création de la structure de table attributaire actions_possibles';
	EXECUTE 'DROP TABLE IF EXISTS actions_possibles CASCADE';
	EXECUTE 'CREATE TABLE actions_possibles (
		id serial4 NOT NULL,
		code varchar NULL,
		niveau varchar NULL,
		code_sup varchar NULL,
		nom varchar NULL,
		nom_long varchar NULL,
		axe varchar NULL,
		doc_fiche_action varchar NULL,
		CONSTRAINT actions_possibles_pkey PRIMARY KEY (id),
		CONSTRAINT code_action_unique UNIQUE (code)
		);';	

	RAISE NOTICE 'Création de la table actions_possibles effectuée';

	com := '
	COMMENT ON TABLE actions_possibles IS ''Liste des actions de gestion des inondations'';
	COMMENT ON COLUMN actions_possibles.id IS ''Identifiant unique non nul de type integer'';
	COMMENT ON COLUMN actions_possibles.code IS ''Code de l''''action'';
	COMMENT ON COLUMN actions_possibles.niveau IS ''Niveau de détail l''''action parmi 1, 2 ou 3'';
	COMMENT ON COLUMN actions_possibles.code_sup IS ''Code de l''''action parente'';
	COMMENT ON COLUMN actions_possibles.nom IS ''Nom simplifié de l''''action'';
	COMMENT ON COLUMN actions_possibles.nom IS ''Nom complet de l''''action'';
	COMMENT ON COLUMN actions_possibles.axe IS ''Axe du PAPI auquel l''''action est rattachée'';	
	COMMENT ON COLUMN actions_possibles.doc_fiche_action IS ''Nom du document présentant la fiche action'';	
	';
	EXECUTE (com);
	RAISE NOTICE 'Commentaires ajoutés à la table actions_possibles';

	RAISE NOTICE 'Peuplement des valeurs';
	val := '			
		INSERT INTO actions_possibles VALUES (7, ''act_1_5'', ''2'', ''act_1'', ''Modéliser les écoulements'', ''Modéliser les écoulements'', ''Amélioration de la connaissance et de la conscience du risque'', NULL);
		INSERT INTO actions_possibles VALUES (10, ''act_1_8'', ''2'', ''act_1'', ''Réaliser un protocole de REX'', ''Réaliser un protocole de REX'', ''Amélioration de la connaissance et de la conscience du risque'', NULL);
		INSERT INTO actions_possibles VALUES (14, ''act_2_2'', ''2'', ''act_2'', ''Réaliser un diagnostic des réseaux et des infrastructures publiques'', ''Réaliser un diagnostic des réseaux et des infrastructures publiques'', ''Amélioration de la connaissance et de la conscience du risque'', NULL);
		INSERT INTO actions_possibles VALUES (15, ''act_2_3'', ''2'', ''act_2'', ''Étudier la vulnérabilité d’enjeux spécifiques'', ''Étudier la vulnérabilité d’enjeux spécifiques'', ''Amélioration de la connaissance et de la conscience du risque'', NULL);
		INSERT INTO actions_possibles VALUES (16, ''act_2_4'', ''2'', ''act_2'', ''Réaliser un protocole de REX'', ''Réaliser un protocole de REX'', ''Amélioration de la connaissance et de la conscience du risque'', NULL);
		INSERT INTO actions_possibles VALUES (20, ''act_3_3'', ''2'', ''act_3'', ''Réaliser des documents réglementaires : TIM, DICRIM, IAL'', ''Réaliser des documents réglementaires : TIM, DICRIM, IAL'', ''Amélioration de la connaissance et de la conscience du risque'', NULL);
		INSERT INTO actions_possibles VALUES (21, ''act_3_4'', ''2'', ''act_3'', ''Poser des repères de crue'', ''Poser des repères de crue'', ''Amélioration de la connaissance et de la conscience du risque'', NULL);
		INSERT INTO actions_possibles VALUES (27, ''act_5_1'', ''2'', ''act_5'', ''Intégrer dans la planification générale (SCOT)'', ''Intégrer dans la planification générale (SCOT)'', ''Prise en compte du risque inondation dans l’aménagement et l’urbanisme'', NULL);
		INSERT INTO actions_possibles VALUES (29, ''act_5_3'', ''2'', ''act_5'', ''Établir des PPRi'', ''Établir des PPRi'', ''Prise en compte du risque inondation dans l’aménagement et l’urbanisme'', NULL);
		INSERT INTO actions_possibles VALUES (5, ''act_1_3'', ''2'', ''act_1'', ''Réaliser une étude de connaissance du cours d’eau'', ''Réaliser une étude de connaissance du fonctionnement du cours d’eau (morphologie, érosion)'', ''Amélioration de la connaissance et de la conscience du risque'', NULL);
		INSERT INTO actions_possibles VALUES (6, ''act_1_4'', ''2'', ''act_1'', ''Réaliser une étude hydrologique'', ''Réaliser une étude hydrologique (dont modélisation)'', ''Amélioration de la connaissance et de la conscience du risque'', NULL);
		INSERT INTO actions_possibles VALUES (8, ''act_1_6'', ''2'', ''act_1'', ''Analyser les phénomènes selon une méthode naturaliste'', ''Analyser les phénomènes selon une méthode naturaliste (HGM par ex.)'', ''Amélioration de la connaissance et de la conscience du risque'', NULL);
		INSERT INTO actions_possibles VALUES (9, ''act_1_7'', ''2'', ''act_1'', ''Constituer un observatoire'', ''Constituer un observatoire (levé de trait de côte, terrain régulier)'', ''Amélioration de la connaissance et de la conscience du risque'', NULL);
		INSERT INTO actions_possibles VALUES (11, ''act_1_9'', ''2'', ''act_1'', ''Collecter des informations de terrain après un évènement'', ''Collecter des informations de terrain (PHE, nivellements) après un évènement'', ''Amélioration de la connaissance et de la conscience du risque'', NULL);
		INSERT INTO actions_possibles VALUES (13, ''act_2_1'', ''2'', ''act_2'', ''Réaliser une étude préalable générale'', ''Réaliser une étude préalable générale (vulnérabilité territoriale)'', ''Amélioration de la connaissance et de la conscience du risque'', NULL);
		INSERT INTO actions_possibles VALUES (18, ''act_3_1'', ''2'', ''act_3'', ''Concevoir des supports communicants'', ''Concevoir des journaux, sites web, expositions, plaquettes, jeux de rôles, documents de formation…'', ''Amélioration de la connaissance et de la conscience du risque'', NULL);
		INSERT INTO actions_possibles VALUES (24, ''act_4_1'', ''2'', ''act_4'', ''Concevoir des supports communicants'', ''Concevoir des journaux, sites web, expositions, plaquettes, jeux de rôles, documents de formation…'', ''Amélioration de la connaissance et de la conscience du risque'', NULL);
		INSERT INTO actions_possibles VALUES (28, ''act_5_2'', ''2'', ''act_5'', ''Intégrer dans la planification : PLU(i) , cartes communales'', ''Intégrer dans la planification (inter-)communale : PLU(i) (zonage réglementaire, règlement, OAP), cartes communales'', ''Prise en compte du risque inondation dans l’aménagement et l’urbanisme'', NULL);
		INSERT INTO actions_possibles VALUES (30, ''act_5_4'', ''2'', ''act_5'', ''Lutter contre les occupations illégales'', ''Lutter contre les occupations illégales (identification des occupations, mise en place de mesures )'', ''Prise en compte du risque inondation dans l’aménagement et l’urbanisme'', NULL);
		INSERT INTO actions_possibles VALUES (19, ''act_3_2'', ''2'', ''act_3'', ''Mettre en œuvre des actions de communication'', ''Mettre en œuvre des actions (évènements, supports…) de toute sorte (expositions, ouverture de lieu dédiés à la prévention du risque, mailing, réalisation de spots…)'', ''Amélioration de la connaissance et de la conscience du risque'', NULL);
		INSERT INTO actions_possibles VALUES (25, ''act_4_2'', ''2'', ''act_4'', ''Mettre en œuvre des actions de communication'', ''Mettre en œuvre des actions (évènements, supports…) de toute sorte (expositions, ouverture de lieu dédiés à la prévention du risque, mailing, réalisation de spots…)'', ''Amélioration de la connaissance et de la conscience du risque'', NULL);
		INSERT INTO actions_possibles VALUES (31, ''act_5_5'', ''2'', ''act_5'', ''Prévoir des espaces refuges collectifs'', ''Prévoir des espaces refuges collectifs (y/c terres agricoles)'', ''Prise en compte du risque inondation dans l’aménagement et l’urbanisme'', NULL);
		INSERT INTO actions_possibles VALUES (32, ''act_5_6'', ''2'', ''act_5'', ''Remettre en état des sites'', ''Remettre en état des sites'', ''Prise en compte du risque inondation dans l’aménagement et l’urbanisme'', NULL);
		INSERT INTO actions_possibles VALUES (34, ''act_6_1'', ''2'', ''act_6'', ''Verrouiller les tampons de visite'', ''Verrouiller les tampons de visite'', ''Réduction de la vulnérabilité des personnes et des biens'', NULL);
		INSERT INTO actions_possibles VALUES (35, ''act_6_2'', ''2'', ''act_6'', ''Installer des diapositifs de visualisation des hauteurs d’eau'', ''Installer des diapositifs de visualisation des hauteurs d’eau'', ''Réduction de la vulnérabilité des personnes et des biens'', NULL);
		INSERT INTO actions_possibles VALUES (63, ''act_10'', ''1'', NULL, ''Protéger par des ouvrages'', ''Protéger par des ouvrages'', ''Gestion des ouvrages de protection hydrauliques'', NULL);
		INSERT INTO actions_possibles VALUES (36, ''act_6_3'', ''2'', ''act_6'', ''Renforcer les couches de surface des voiries et parkings'', ''Renforcer les couches de surface des voiries et parkings'', ''Réduction de la vulnérabilité des personnes et des biens'', NULL);
		INSERT INTO actions_possibles VALUES (37, ''act_6_4'', ''2'', ''act_6'', ''Mailler le réseau pour réduire ses dysfonctionnements éventuels'', ''Mailler le réseau pour réduire ses dysfonctionnements éventuels'', ''Réduction de la vulnérabilité des personnes et des biens'', NULL);
		INSERT INTO actions_possibles VALUES (39, ''act_7_1'', ''2'', ''act_7'', ''Adapter l’occupation des bâtiment'', ''Adapter l’occupation des bâtiment'', ''Réduction de la vulnérabilité des personnes et des biens'', NULL);
		INSERT INTO actions_possibles VALUES (41, ''act_7_3'', ''2'', ''act_7'', ''Adapter les cultures à la saisonnalité des crues'', ''Adapter les cultures à la saisonnalité des crues'', ''Réduction de la vulnérabilité des personnes et des biens'', NULL);
		INSERT INTO actions_possibles VALUES (42, ''act_7_4'', ''2'', ''act_7'', ''Adapter l’occupation et le stationnement des voiries et parkings'', ''Adapter l’occupation et le stationnement des voiries et parkings'', ''Réduction de la vulnérabilité des personnes et des biens'', NULL);
		INSERT INTO actions_possibles VALUES (45, ''act_8_1'', ''2'', ''act_8'', ''Réaliser une étude de vulnérabilité'', ''Réaliser une étude de vulnérabilité'', ''Réduction de la vulnérabilité des personnes et des biens'', NULL);
		INSERT INTO actions_possibles VALUES (46, ''act_8_2'', ''2'', ''act_8'', ''Définir des règles de construction pour les bâtiments neufs'', ''Définir des règles de construction pour les bâtiments neufs'', ''Réduction de la vulnérabilité des personnes et des biens'', NULL);
		INSERT INTO actions_possibles VALUES (47, ''act_8_3'', ''2'', ''act_8'', ''Rendre le bâtiment moins dangereux'', ''Rendre le bâtiment moins dangereux'', ''Réduction de la vulnérabilité des personnes et des biens'', NULL);
		INSERT INTO actions_possibles VALUES (48, ''act_8_3_1'', ''3'', ''act_8_3'', ''Le renforcer structurellement'', ''Le renforcer structurellement'', ''Réduction de la vulnérabilité des personnes et des biens'', NULL);
		INSERT INTO actions_possibles VALUES (52, ''act_8_4_1'', ''3'', ''act_8_4'', ''Créer ou identifier un espace refuge pour mettre des biens à l’abri'', ''Créer ou identifier un espace refuge pour mettre des biens à l’abri'', ''Réduction de la vulnérabilité des personnes et des biens'', NULL);
		INSERT INTO actions_possibles VALUES (57, ''act_8_5_3'', ''3'', ''act_8_5'', ''Éliminer les eaux résiduelles'', ''Éliminer les eaux résiduelles'', ''Réduction de la vulnérabilité des personnes et des biens'', NULL);
		INSERT INTO actions_possibles VALUES (58, ''act_8_6'', ''2'', ''act_8'', ''Adapter les réseaux raccordés au bâtiment'', ''Adapter les réseaux raccordés au bâtiment'', ''Réduction de la vulnérabilité des personnes et des biens'', NULL);
		INSERT INTO actions_possibles VALUES (60, ''act_9_1'', ''2'', ''act_9'', ''Exproprier l’enjeu'', ''Exproprier l’enjeu'', ''Réduction de la vulnérabilité des personnes et des biens'', NULL);
		INSERT INTO actions_possibles VALUES (61, ''act_9_2'', ''2'', ''act_9'', ''Acquérir l’enjeu à l’amiable'', ''Acquérir l’enjeu à l’amiable'', ''Réduction de la vulnérabilité des personnes et des biens'', NULL);
		INSERT INTO actions_possibles VALUES (62, ''act_9_3'', ''2'', ''act_9'', ''Gérer le terrain libéré'', ''Gérer le terrain libéré'', ''Réduction de la vulnérabilité des personnes et des biens'', NULL);
		INSERT INTO actions_possibles VALUES (67, ''act_10_4'', ''2'', ''act_10'', ''Réaliser l’AMC / ACB des projets'', ''Réaliser l’AMC / ACB des projets'', ''Gestion des ouvrages de protection hydrauliques'', NULL);
		INSERT INTO actions_possibles VALUES (40, ''act_7_2'', ''2'', ''act_7'', ''Adapter l’exploitation d’un enjeu'', ''Adapter l’exploitation d’un enjeu (heures et période ouverture, publics)'', ''Réduction de la vulnérabilité des personnes et des biens'', NULL);
		INSERT INTO actions_possibles VALUES (49, ''act_8_3_2'', ''3'', ''act_8_3'', ''Créer ou identifier un espace refuge'', ''Créer ou identifier un espace refuge pour s’extraire du rez-de-chaussée'', ''Réduction de la vulnérabilité des personnes et des biens'', NULL);
		INSERT INTO actions_possibles VALUES (51, ''act_8_4'', ''2'', ''act_8'', ''Prévoir les entrées d''''eau à l’intérieur du bâtiment'', ''Rendre l’intérieur du bâtiment moins vulnérable (en prévoyant les entrées d’eau)'', ''Réduction de la vulnérabilité des personnes et des biens'', NULL);
		INSERT INTO actions_possibles VALUES (54, ''act_8_5'', ''2'', ''act_8'', ''Empêcher les entrées d''''eau dans le bâtiment'', ''Rendre l’intérieur du bâtiment moins vulnérable (en empêchant les entrées d’eau)'', ''Réduction de la vulnérabilité des personnes et des biens'', NULL);
		INSERT INTO actions_possibles VALUES (55, ''act_8_5_1'', ''3'', ''act_8_5'', ''Mettre en place des dispositifs d’étanchéité temporaires'', ''Mettre en place des dispositifs d’étanchéité temporaires dont batardeaux'', ''Réduction de la vulnérabilité des personnes et des biens'', NULL);
		INSERT INTO actions_possibles VALUES (56, ''act_8_5_2'', ''3'', ''act_8_5'', ''Colmater définitivement les voies d’eau'', ''Colmater définitivement les voies d’eau (fissures, réseaux)'', ''Réduction de la vulnérabilité des personnes et des biens'', NULL);
		INSERT INTO actions_possibles VALUES (53, ''act_8_4_2'', ''3'', ''act_8_4'', ''Mettre en place des matériaux et dispositifs insensibles à l’eau'', ''Mettre en place des matériaux insensibles à l’eau / un réseau électrique descendant …'', ''Réduction de la vulnérabilité des personnes et des biens'', NULL);
		INSERT INTO actions_possibles VALUES (43, ''act_7_5'', ''2'', ''act_7'', ''Adapter les stocks'', ''Adapter les stocks (entreprises, caravanes…)'', ''Réduction de la vulnérabilité des personnes et des biens'', NULL);
		INSERT INTO actions_possibles VALUES (4, ''act_1_2'', ''2'', ''act_1'', ''Rechercher et collecter des éléments historiques'', ''Rechercher et collecter des éléments historiques (témoignages, PHE, photographies, documents,…)'', ''Amélioration de la connaissance et de la conscience du risque'', NULL);
		INSERT INTO actions_possibles VALUES (3, ''act_1_1'', ''2'', ''act_1'', ''Collecter les études sur les inondations / érosions'', ''Collecter / synthétiser les études existantes sur les phénomènes d’inondation (débordement, submersion, ruissellement) ou d’érosion (trait de côte, berges)'', ''Amélioration de la connaissance et de la conscience du risque'', NULL);
		INSERT INTO actions_possibles VALUES (74, ''act_10_11'', ''2'', ''act_10'', ''Réaliser des travaux sur les systèmes de protection'', ''Réaliser des travaux sur les systèmes d’endiguements, aménagements hydrauliques, zones d’expansion des crues'', ''Gestion des ouvrages de protection hydrauliques'', NULL);
		INSERT INTO actions_possibles VALUES (50, ''act_8_3_3'', ''3'', ''act_8_3'', ''Adapter les ouvrants'', ''Adapter les ouvrants (portes, fenêtres) pour ne pas être surpris par leur rupture'', ''Réduction de la vulnérabilité des personnes et des biens'', NULL);
		INSERT INTO actions_possibles VALUES (64, ''act_10_1'', ''2'', ''act_10'', ''Réaliser une étude préalable'', ''Réaliser une étude préalable (opportunité, identification de sites, estimations financières…)'', ''Gestion des ouvrages de protection hydrauliques'', NULL);
		INSERT INTO actions_possibles VALUES (65, ''act_10_2'', ''2'', ''act_10'', ''Mettre en place un plan de gestion'', ''Mettre en place un plan de gestion'', ''Gestion des ouvrages de protection hydrauliques'', NULL);
		INSERT INTO actions_possibles VALUES (66, ''act_10_3'', ''2'', ''act_10'', ''Étudier la conception ou les modalités de réalisation'', ''Étudier la conception ou les modalités de réalisation'', ''Gestion des ouvrages de protection hydrauliques'', NULL);
		INSERT INTO actions_possibles VALUES (83, ''act_13_1'', ''2'', ''act_13'', ''Disposer d’un plan de gestion adapté'', ''Disposer d’un plan de gestion adapté'', ''Alerte et la gestion de crise'', NULL);
		INSERT INTO actions_possibles VALUES (68, ''act_10_5'', ''2'', ''act_10'', ''Réaliser une étude de danger'', ''Réaliser une étude de danger'', ''Gestion des ouvrages de protection hydrauliques'', NULL);
		INSERT INTO actions_possibles VALUES (69, ''act_10_6'', ''2'', ''act_10'', ''Établir des conventions'', ''Établir des conventions'', ''Gestion des ouvrages de protection hydrauliques'', NULL);
		INSERT INTO actions_possibles VALUES (70, ''act_10_7'', ''2'', ''act_10'', ''Organiser la communication'', ''Organiser la communication'', ''Gestion des ouvrages de protection hydrauliques'', NULL);
		INSERT INTO actions_possibles VALUES (71, ''act_10_8'', ''2'', ''act_10'', ''Organisation de la concertation'', ''Organisation de la concertation'', ''Gestion des ouvrages de protection hydrauliques'', NULL);
		INSERT INTO actions_possibles VALUES (72, ''act_10_9'', ''2'', ''act_10'', ''Mettre en place une médiation'', ''Mettre en place une médiation'', ''Gestion des ouvrages de protection hydrauliques'', NULL);
		INSERT INTO actions_possibles VALUES (73, ''act_10_10'', ''2'', ''act_10'', ''Constituer les dossiers réglementaires'', ''Constituer les dossiers réglementaires'', ''Gestion des ouvrages de protection hydrauliques'', NULL);
		INSERT INTO actions_possibles VALUES (77, ''act_11_1'', ''2'', ''act_11'', ''Mettre en place une déclaration d’intérêt général'', ''Mettre en place une déclaration d’intérêt général'', ''Gestion des écoulements'', NULL);
		INSERT INTO actions_possibles VALUES (78, ''act_11_2'', ''2'', ''act_11'', ''Réaliser des travaux d’entretien ou de restauration d’un cours d’eau'', ''Réaliser des travaux d’entretien ou de restauration d’un cours d’eau'', ''Gestion des écoulements'', NULL);
		INSERT INTO actions_possibles VALUES (80, ''act_12_1'', ''2'', ''act_12'', ''Améliorer l’anticipation par une surveillance plus efficace'', ''Améliorer l’anticipation par une surveillance plus efficace'', ''Surveillance, la prévision des crues et des inondations'', NULL);
		INSERT INTO actions_possibles VALUES (81, ''act_12_2'', ''2'', ''act_12'', ''Mettre en place canaux d’information pour la vigilance et l’alerte'', ''Mettre en place canaux d’information pour la vigilance et l’alerte'', ''Alerte et la gestion de crise'', NULL);
		INSERT INTO actions_possibles VALUES (84, ''act_13_1_1'', ''3'', ''act_13_1'', ''Disposer d’un plan familial de mise en sécurité (PFMS)'', ''Disposer d’un plan familial de mise en sécurité (PFMS)'', ''Alerte et la gestion de crise'', NULL);
		INSERT INTO actions_possibles VALUES (85, ''act_13_1_2'', ''3'', ''act_13_1'', ''Disposer d’un plan de sauvegarde des collections (PSC)'', ''Disposer d’un plan de sauvegarde des collections (PSC)'', ''Alerte et la gestion de crise'', NULL);
		INSERT INTO actions_possibles VALUES (86, ''act_13_1_3'', ''3'', ''act_13_1'', ''Disposer d’un plan de gestion des déchets post-inondation'', ''Disposer d’un plan de gestion des déchets post-inondation'', ''Alerte et la gestion de crise'', NULL);
		INSERT INTO actions_possibles VALUES (87, ''act_13_1_4'', ''3'', ''act_13_1'', ''Disposer d’un plan de gestion de trafic (PGT)'', ''Disposer d’un plan de gestion de trafic (PGT)'', ''Alerte et la gestion de crise'', NULL);
		INSERT INTO actions_possibles VALUES (88, ''act_13_1_5'', ''3'', ''act_13_1'', ''Disposer d’un plan communal de sauvegarde (PCS)'', ''Disposer d’un plan communal de sauvegarde (PCS)'', ''Alerte et la gestion de crise'', NULL);
		INSERT INTO actions_possibles VALUES (89, ''act_13_1_6'', ''3'', ''act_13_1'', ''Disposer d’un plan d’organisation des secours (ORSEC)'', ''Disposer d’un plan d’organisation des secours (ORSEC)'', ''Alerte et la gestion de crise'', NULL);
		INSERT INTO actions_possibles VALUES (90, ''act_13_1_7'', ''3'', ''act_13_1'', ''Disposer d’un plan d’intervention d’urgence (ouvrages de protection)'', ''Disposer d’un plan d’intervention d’urgence (ouvrages de protection)'', ''Alerte et la gestion de crise'', NULL);
		INSERT INTO actions_possibles VALUES (91, ''act_13_2'', ''2'', ''act_13'', ''Mener une réflexion sur les enjeux utiles à la gestion de crise'', ''Mener une réflexion sur les enjeux utiles à la gestion de crise'', ''Alerte et la gestion de crise'', NULL);
		INSERT INTO actions_possibles VALUES (92, ''act_13_3'', ''2'', ''act_13'', ''Disposer d’un plan de continuité d’activité'', ''Disposer d’un plan de continuité d’activité'', ''Alerte et la gestion de crise'', NULL);
		INSERT INTO actions_possibles VALUES (93, ''act_13_4'', ''2'', ''act_13'', ''Organiser le maintien sur place d’un quartier'', ''Organiser le maintien sur place d’un quartier'', ''Alerte et la gestion de crise'', NULL);
		INSERT INTO actions_possibles VALUES (94, ''act_13_5'', ''2'', ''act_13'', ''Organiser le maintien sur place dans une zones de concentration'', ''Organiser le maintien sur place dans une zones de concentration'', ''Alerte et la gestion de crise'', NULL);
		INSERT INTO actions_possibles VALUES (95, ''act_13_6'', ''2'', ''act_13'', ''Mettre en place des outils d’aide à la décision pour la gestion de crise'', ''Mettre en place des outils d’aide à la décision pour la gestion de crise'', ''Alerte et la gestion de crise'', NULL);
		INSERT INTO actions_possibles VALUES (96, ''act_13_7'', ''2'', ''act_13'', ''Se former'', ''Se former'', ''Alerte et la gestion de crise'', NULL);
		INSERT INTO actions_possibles VALUES (97, ''act_13_8'', ''2'', ''act_13'', ''Réaliser des exercices'', ''Réaliser des exercices'', ''Alerte et la gestion de crise'', NULL);
		INSERT INTO actions_possibles VALUES (98, ''act_13_9'', ''2'', ''act_13'', ''Installer une instrumentation / signalisation des passages dangereux'', ''Installer une instrumentation / signalisation des passages dangereux'', ''Alerte et la gestion de crise'', NULL);
		INSERT INTO actions_possibles VALUES (100, ''act_13_11'', ''2'', ''act_13'', ''Organiser un REX sur le thème de la gestion de crise'', ''Organiser un REX sur le thème de la gestion de crise'', ''Alerte et la gestion de crise'', NULL);
		INSERT INTO actions_possibles VALUES (102, ''act_14_1'', ''2'', ''act_14'', ''Identifier des hébergements d’urgence supplémentaires'', ''Identifier des hébergements d’urgence supplémentaires'', ''Alerte et la gestion de crise'', NULL);
		INSERT INTO actions_possibles VALUES (103, ''act_14_2'', ''2'', ''act_14'', ''Mettre en place un guichet d’aide aux habitants sinistrés'', ''Mettre en place un guichet d’aide aux habitants sinistrés'', ''Alerte et la gestion de crise'', NULL);
		INSERT INTO actions_possibles VALUES (104, ''act_14_3'', ''2'', ''act_14'', ''Mettre en place un guichet d’aide aux activités'', ''Mettre en place un guichet d’aide aux activités'', ''Alerte et la gestion de crise'', NULL);
		INSERT INTO actions_possibles VALUES (105, ''act_14_4'', ''2'', ''act_14'', ''Mettre en place un soutien psychologique'', ''Mettre en place un soutien psychologique'', ''Alerte et la gestion de crise'', NULL);
		INSERT INTO actions_possibles VALUES (1, ''act_0'', ''1'', NULL, ''Vérifier la réalité du diagnostic sur le terrain'', ''Vérifier la réalité du diagnostic sur le terrain'', ''NULL'', NULL);
		INSERT INTO actions_possibles VALUES (2, ''act_1'', ''1'', NULL, ''Connaître les inondations'', ''Connaître les inondations'', ''Amélioration de la connaissance et de la conscience du risque'', NULL);
		INSERT INTO actions_possibles VALUES (75, ''act_10_12'', ''2'', ''act_10'', ''Installer des dispositifs de protection collectifs'', ''Installer des dispositifs de protection collectifs (barrières anti-inondation, pompages…)'', ''Gestion des ouvrages de protection hydrauliques'', NULL);
		INSERT INTO actions_possibles VALUES (99, ''act_13_10'', ''2'', ''act_13'', ''Constituer des relais de quartier ou des réserves communales de sécurité civile'', ''Identifier des relais de « quartier », constitution de réserves communales de sécurité civile'', ''Alerte et la gestion de crise'', NULL);
		INSERT INTO actions_possibles VALUES (12, ''act_2'', ''1'', NULL, ''Connaître les risques'', ''Connaître les risques'', ''Amélioration de la connaissance et de la conscience du risque'', NULL);
		INSERT INTO actions_possibles VALUES (33, ''act_6'', ''1'', NULL, ''Adapter le réseau'', ''Adapter le réseau'', ''Réduction de la vulnérabilité des personnes et des biens'', NULL);
		INSERT INTO actions_possibles VALUES (76, ''act_11'', ''1'', NULL, ''Entretenir les cours d’eau'', ''Entretenir les cours d’eau'', ''Gestion des écoulements'', NULL);
		INSERT INTO actions_possibles VALUES (79, ''act_12'', ''1'', NULL, ''Avertir de la survenance d’une inondation'', ''Avertir de la survenance d’une inondation'', ''Alerte et la gestion de crise'', NULL);
		INSERT INTO actions_possibles VALUES (101, ''act_14'', ''1'', NULL, ''Aider les sinistrés'', ''Aider les sinistrés'', ''Alerte et la gestion de crise'', NULL);
		INSERT INTO actions_possibles VALUES (82, ''act_13'', ''1'', NULL, ''Savoir réagir à la survenance d’une inondation'', ''Savoir réagir à la survenance d’une inondation'', ''Alerte et la gestion de crise'', ''act_13__savoir_reagir_a_la_survenance_d_une_inondation.pdf'');
		INSERT INTO actions_possibles VALUES (17, ''act_3'', ''1'', NULL, ''Faire connaître les inondations'', ''Faire connaître les inondations'', ''Amélioration de la connaissance et de la conscience du risque'', ''act_3__faire_connaitre_les_inondations.pdf'');
		INSERT INTO actions_possibles VALUES (22, ''act_3_5'', ''2'', ''act_3'', ''Établir un porté à connaissance'', ''Établir un porté à connaissance'', ''Amélioration de la connaissance et de la conscience du risque'', ''act_3_5_poser_des_reperes_de_crue.pdf'');
		INSERT INTO actions_possibles VALUES (23, ''act_4'', ''1'', NULL, ''Faire connaître les risques'', ''Faire connaître les risques'', ''Amélioration de la connaissance et de la conscience du risque'', ''act_4__faire_connaitre_les_risques.pdf'');
		INSERT INTO actions_possibles VALUES (26, ''act_5'', ''1'', NULL, ''Adapter l’aménagement'', ''Adapter l’aménagement'', ''Prise en compte du risque inondation dans l’aménagement et l’urbanisme'', ''act_5__adapter_l_amenagement.pdf'');
		INSERT INTO actions_possibles VALUES (38, ''act_7'', ''1'', NULL, ''Adapter l’usage'', ''Adapter l’usage'', ''Réduction de la vulnérabilité des personnes et des biens'', ''act_7__adapter_l_usage.pdf'');
		INSERT INTO actions_possibles VALUES (44, ''act_8'', ''1'', NULL, ''Adapter le bâtiment'', ''Adapter le bâtiment'', ''Réduction de la vulnérabilité des personnes et des biens'', ''act_8__adapter_le_batiment.pdf'');
		INSERT INTO actions_possibles VALUES (59, ''act_9'', ''1'', NULL, ''Déplacer l’enjeu'', ''Déplacer l’enjeu'', ''Réduction de la vulnérabilité des personnes et des biens'', ''act_9__deplacer_l_enjeu.pdf'');
	';
	EXECUTE (val);
	RAISE NOTICE 'Valeurs ajoutées à la table actions_possibles';

	ind := '   
	CREATE INDEX ON actions_possibles USING btree(id);
	CREATE INDEX ON actions_possibles USING btree(code);	
	';
	EXECUTE (ind);
	RAISE NOTICE 'Index créés sur la table actions_possibles';

	RAISE NOTICE '';
	RAISE NOTICE 'Initialisation de la liste des indicateurs';

	RAISE NOTICE 'Création de la structure de table attributaire indicateurs';
	EXECUTE 'DROP TABLE IF EXISTS indicateurs CASCADE';
	EXECUTE 'CREATE TABLE indicateurs (
		id serial4 NOT NULL,
		"version" varchar NULL,
		code varchar NULL,
		"source" varchar NULL,
		nom varchar NULL,
		CONSTRAINT code_indicateur_unique UNIQUE (code),
		CONSTRAINT indicateurs_pkey PRIMARY KEY (id)
	);';	

	RAISE NOTICE 'Création de la table indicateurs effectuée';

	com := '
	COMMENT ON TABLE indicateurs IS ''Liste des indicateurs'';
	COMMENT ON COLUMN indicateurs.id IS ''Identifiant unique non nul de type integer'';
	COMMENT ON COLUMN indicateurs.code IS ''Code de l''''indicateur'';
	COMMENT ON COLUMN indicateurs.source IS ''Source du référentiel correspondant à l''''indicateur'';
	COMMENT ON COLUMN indicateurs.nom IS ''Nom de l''''indicateur'';
	';
	EXECUTE (com);
	RAISE NOTICE 'Commentaires ajoutés à la table indicateurs';

	RAISE NOTICE 'Peuplement des valeurs';
	val := '	
		INSERT INTO indicateurs VALUES (1, '''', ''s1_1'', ''s1_1'', ''Nombre de personnes dans des bâtiments susceptibles d’être détruits'');
		INSERT INTO indicateurs VALUES (2, ''1'', ''s1_2a'', ''s1_2'', ''Nombre de personnes occupant des bâtiments de plain-pied fortement inondables'');
		INSERT INTO indicateurs VALUES (3, ''1'', ''s1_2b'', ''s1_2'', ''Nombre de personnes occupant des locaux fortement inondables'');
		INSERT INTO indicateurs VALUES (4, '''', ''s1_3'', ''s1_3'', ''Nombre de personnes occupant une habitation légère de loisirs, un mobile home, un camping - car, une caravane, une tente (hors camping et enjeux gérés) dans les zones d’aléa dangereuses pour une personne'');
		INSERT INTO indicateurs VALUES (5, '''', ''s1_6a'', ''s1_6'', ''Proportion de tampons non verrouillés'');
		INSERT INTO indicateurs VALUES (6, '''', ''s1_6b'', ''s1_6'', ''Nombre d’itinéraires routiers interceptés par des zones d’aléa dangereuses pour une personne'');
		INSERT INTO indicateurs VALUES (7, '''', ''s1_7'', ''s1_7'', ''Nombre d’habitants dans des zones accessibles par des axes dangereux'');
		INSERT INTO indicateurs VALUES (8, '''', ''s1_8'', ''s1_8'', ''Nombre de personnes au sein des zones urbanisées longtemps inaccessibles, et n’étant pas organisées pour le maintien sur place'');
		INSERT INTO indicateurs VALUES (9, '''', ''s1_9'', ''s1_9'', ''Nombre de personnes dans des zones de concentration'');
		INSERT INTO indicateurs VALUES (10, '''', ''s1_10'', ''s1_10'', ''Nombre de personnes dépendantes en zone de fragilité électrique'');
		INSERT INTO indicateurs VALUES (11, '''', ''s2_1'', ''s2_1'', ''Dommages aux bâtiments susceptibles d’être détruits'');
		INSERT INTO indicateurs VALUES (12, ''1'', ''s2_2a'', ''s2_2'', ''Dommages aux logements'');
		INSERT INTO indicateurs VALUES (13, '''', ''s2_3'', ''s2_3'', ''Nombre d’habitations légères de loisirs inondables'');
		INSERT INTO indicateurs VALUES (14, '''', ''s2_4a'', ''s2_4'', ''Nombre de musées et bâtiments patrimoniaux susceptibles d’être endommagés'');
		INSERT INTO indicateurs VALUES (15, '''', ''s2_4b'', ''s2_4'', ''Nombre de monuments, édifices patrimoniaux, remarquables, historiques susceptibles d’être endommagés'');
		INSERT INTO indicateurs VALUES (16, '''', ''s2_5a'', ''s2_5'', ''Volumes issus des stockages et dépôts susceptibles d’être emportés'');
		INSERT INTO indicateurs VALUES (17, ''1'', ''s2_6a'', ''s2_6'', ''Dommages aux cultures'');
		INSERT INTO indicateurs VALUES (18, '''', ''s2_7a'', ''s2_7'', ''Dommages aux entreprises'');
		INSERT INTO indicateurs VALUES (19, '''', ''s2_8'', ''s2_8'', ''Dommages aux établissements publics'');
		INSERT INTO indicateurs VALUES (20, '''', ''s2_9'', ''s2_9'', ''Nombre de véhicules (terrestres) exposés à l’aléa'');
		INSERT INTO indicateurs VALUES (21, '''', ''s2_10a'', ''s2_10'', ''Nombre de parties de réseaux (nœuds, liaisons) susceptibles d’être endommagés par l’inondation'');
		INSERT INTO indicateurs VALUES (22, ''1'', ''s2_14a'', ''s2_14'', ''Surface de zones à urbaniser en zone inondable'');
		INSERT INTO indicateurs VALUES (23, ''1'', ''s3_1a'', ''s3_1'', ''Nombre et proportion de personnes en zone inondable'');
		INSERT INTO indicateurs VALUES (24, ''1'', ''s3_1f'', ''s3_1'', ''Surfaces agricoles inondées'');
		INSERT INTO indicateurs VALUES (25, '''', ''s3_2b'', ''s3_2'', ''Capacités d’hébergement du territoire situées hors zones inondables'');
		INSERT INTO indicateurs VALUES (26, '''', ''s3_3'', ''s3_3'', ''Niveau social de la population'');
		INSERT INTO indicateurs VALUES (27, '''', ''s3_4a'', ''s3_4'', ''Part des établissements publics prioritaires ne disposant pas d’un PCA'');
		INSERT INTO indicateurs VALUES (28, '''', ''s3_5a'', ''s3_5'', ''Part des autres établissements publics ne disposant pas d’un PCA'');
		INSERT INTO indicateurs VALUES (29, '''', ''s3_6a'', ''s3_6'', ''Nombre de zones ou centres ne disposant pas d’un plan de continuité d’activité de type PCA'');
		INSERT INTO indicateurs VALUES (30, '''', ''s3_7'', ''s3_7'', ''Proportion du territoire non concernée par l’existence d’un plan de gestion des déchets post – inondation'');
		INSERT INTO indicateurs VALUES (31, '''', ''s3_8'', ''s3_8'', ''Proportion d’établissements patrimoniaux ne disposant pas d’un plan de sauvegarde des collections'');
		INSERT INTO indicateurs VALUES (32, '''', ''s3_9a'', ''s3_9'', ''Nombre de véhicules / jours gênés sur les réseaux de transit prenant en compte les itinéraires alternatifs'');
		INSERT INTO indicateurs VALUES (33, '''', ''s3_10'', ''s3_10'', ''Proportion de linéaire d’ouvrages de protection non concernés par un dispositif d’intervention d’urgence et délai de remise en état'');
	';
	
	EXECUTE (val);
	RAISE NOTICE 'Valeurs ajoutées à la table indicateurs';

	ind := '   
	CREATE INDEX ON indicateurs USING btree(id);
	CREATE INDEX ON indicateurs USING btree(code);	
	';
	EXECUTE (ind);
	RAISE NOTICE 'Index créés sur la table indicateurs';

	RAISE NOTICE '';
	RAISE NOTICE 'Initialisation de la table de liaison entre indicateurs et actions';

	RAISE NOTICE 'Création de la structure de table attributaire lien_indicateurs_actions';
	EXECUTE 'DROP TABLE IF EXISTS lien_indicateurs_actions CASCADE';
	EXECUTE 'CREATE TABLE lien_indicateurs_actions (
		id serial4 NOT NULL,
		code_action varchar NULL,
		code_indicateur varchar NULL,
		CONSTRAINT lien_indicateurs_actions_pkey PRIMARY KEY (id),
		CONSTRAINT lien_indicateurs_actions_code_action_fkey1 FOREIGN KEY (code_action) REFERENCES actions_possibles(code),
		CONSTRAINT lien_indicateurs_actions_code_indicateurs_fkey FOREIGN KEY (code_indicateur) REFERENCES indicateurs(code)
	);';		

	RAISE NOTICE 'Création de la table lien_indicateurs_actions effectuée';

	com := '
	COMMENT ON TABLE lien_indicateurs_actions IS ''Table de liaison entre indicateurs et actions'';
	COMMENT ON COLUMN lien_indicateurs_actions.id IS ''Identifiant unique non nul de type integer'';
	COMMENT ON COLUMN lien_indicateurs_actions.code_indicateur IS ''Code de l''''indicateur'';
	COMMENT ON COLUMN lien_indicateurs_actions.code_action IS ''Code de l''''action'';	   
	';
	EXECUTE (com);
	RAISE NOTICE 'Commentaires ajoutés à la table lien_indicateurs_actions';

	RAISE NOTICE 'Peuplement des valeurs';
	val := '	
		INSERT INTO lien_indicateurs_actions VALUES (1, ''act_1'', ''s2_14a'');
		INSERT INTO lien_indicateurs_actions VALUES (2, ''act_1'', ''s3_1a'');
		INSERT INTO lien_indicateurs_actions VALUES (3, ''act_2'', ''s3_1a'');
		INSERT INTO lien_indicateurs_actions VALUES (4, ''act_3'', ''s3_1a'');
		INSERT INTO lien_indicateurs_actions VALUES (5, ''act_3_1'', ''s1_2a'');
		INSERT INTO lien_indicateurs_actions VALUES (6, ''act_3_1'', ''s1_2b'');
		INSERT INTO lien_indicateurs_actions VALUES (7, ''act_3_1'', ''s2_2a'');
		INSERT INTO lien_indicateurs_actions VALUES (8, ''act_3_2'', ''s1_2a'');
		INSERT INTO lien_indicateurs_actions VALUES (9, ''act_3_2'', ''s1_2b'');
		INSERT INTO lien_indicateurs_actions VALUES (10, ''act_3_2'', ''s2_2a'');
		INSERT INTO lien_indicateurs_actions VALUES (11, ''act_3_3'', ''s1_2a'');
		INSERT INTO lien_indicateurs_actions VALUES (12, ''act_3_3'', ''s1_2b'');
		INSERT INTO lien_indicateurs_actions VALUES (13, ''act_3_3'', ''s2_2a'');
		INSERT INTO lien_indicateurs_actions VALUES (14, ''act_3_4'', ''s1_2a'');
		INSERT INTO lien_indicateurs_actions VALUES (15, ''act_3_4'', ''s1_2b'');
		INSERT INTO lien_indicateurs_actions VALUES (16, ''act_3_4'', ''s2_2a'');
		INSERT INTO lien_indicateurs_actions VALUES (17, ''act_3_5'', ''s1_2a'');
		INSERT INTO lien_indicateurs_actions VALUES (18, ''act_3_5'', ''s1_2b'');
		INSERT INTO lien_indicateurs_actions VALUES (19, ''act_3_5'', ''s2_2a'');
		INSERT INTO lien_indicateurs_actions VALUES (20, ''act_4'', ''s3_1a'');
		INSERT INTO lien_indicateurs_actions VALUES (21, ''act_4_1'', ''s1_2a'');
		INSERT INTO lien_indicateurs_actions VALUES (22, ''act_4_1'', ''s1_2b'');
		INSERT INTO lien_indicateurs_actions VALUES (23, ''act_4_1'', ''s2_2a'');
		INSERT INTO lien_indicateurs_actions VALUES (24, ''act_4_2'', ''s1_2a'');
		INSERT INTO lien_indicateurs_actions VALUES (25, ''act_4_2'', ''s1_2b'');
		INSERT INTO lien_indicateurs_actions VALUES (26, ''act_4_2'', ''s2_2a'');
		INSERT INTO lien_indicateurs_actions VALUES (27, ''act_5_2'', ''s2_14a'');
		INSERT INTO lien_indicateurs_actions VALUES (28, ''act_5_3'', ''s2_14a'');
		INSERT INTO lien_indicateurs_actions VALUES (29, ''act_5_5'', ''s2_14a'');
		INSERT INTO lien_indicateurs_actions VALUES (30, ''act_5_6'', ''s2_14a'');
		INSERT INTO lien_indicateurs_actions VALUES (31, ''act_6_1'', ''s1_6a'');
		INSERT INTO lien_indicateurs_actions VALUES (32, ''act_6_2'', ''s1_6b'');
		INSERT INTO lien_indicateurs_actions VALUES (33, ''act_6_2'', ''s1_7'');
		INSERT INTO lien_indicateurs_actions VALUES (34, ''act_6_3'', ''s2_10a'');
		INSERT INTO lien_indicateurs_actions VALUES (35, ''act_6_4'', ''s1_10'');
		INSERT INTO lien_indicateurs_actions VALUES (36, ''act_7_1'', ''s1_2a'');
		INSERT INTO lien_indicateurs_actions VALUES (37, ''act_7_3'', ''s2_6a'');
		INSERT INTO lien_indicateurs_actions VALUES (38, ''act_7_4'', ''s2_9'');
		INSERT INTO lien_indicateurs_actions VALUES (39, ''act_7_5'', ''s2_5a'');
		INSERT INTO lien_indicateurs_actions VALUES (40, ''act_8'', ''s2_7a'');
		INSERT INTO lien_indicateurs_actions VALUES (41, ''act_8'', ''s2_8'');
		INSERT INTO lien_indicateurs_actions VALUES (42, ''act_8_1'', ''s1_2a'');
		INSERT INTO lien_indicateurs_actions VALUES (43, ''act_8_1'', ''s1_2b'');
		INSERT INTO lien_indicateurs_actions VALUES (44, ''act_8_2'', ''s2_14a'');
		INSERT INTO lien_indicateurs_actions VALUES (45, ''act_8_3_1'', ''s1_1'');
		INSERT INTO lien_indicateurs_actions VALUES (46, ''act_8_3_1'', ''s2_1'');
		INSERT INTO lien_indicateurs_actions VALUES (47, ''act_8_3_2'', ''s1_2a'');
		INSERT INTO lien_indicateurs_actions VALUES (48, ''act_8_3_3'', ''s1_2b'');
		INSERT INTO lien_indicateurs_actions VALUES (49, ''act_8_4_1'', ''s2_2a'');
		INSERT INTO lien_indicateurs_actions VALUES (50, ''act_8_4_2'', ''s2_2a'');
		INSERT INTO lien_indicateurs_actions VALUES (51, ''act_8_5_1'', ''s2_2a'');
		INSERT INTO lien_indicateurs_actions VALUES (52, ''act_8_5_2'', ''s2_2a'');
		INSERT INTO lien_indicateurs_actions VALUES (53, ''act_8_5_3'', ''s2_2a'');
		INSERT INTO lien_indicateurs_actions VALUES (54, ''act_8_6'', ''s2_14a'');
		INSERT INTO lien_indicateurs_actions VALUES (55, ''act_9'', ''s2_3'');
		INSERT INTO lien_indicateurs_actions VALUES (56, ''act_9_1'', ''s1_2a'');
		INSERT INTO lien_indicateurs_actions VALUES (57, ''act_9_1'', ''s1_2b'');
		INSERT INTO lien_indicateurs_actions VALUES (58, ''act_9_2'', ''s1_2a'');
		INSERT INTO lien_indicateurs_actions VALUES (59, ''act_9_2'', ''s1_2b'');
		INSERT INTO lien_indicateurs_actions VALUES (60, ''act_10'', ''s2_2a'');
		INSERT INTO lien_indicateurs_actions VALUES (61, ''act_12'', ''s1_3'');
		INSERT INTO lien_indicateurs_actions VALUES (62, ''act_12'', ''s2_4a'');
		INSERT INTO lien_indicateurs_actions VALUES (63, ''act_12_1'', ''s1_2a'');
		INSERT INTO lien_indicateurs_actions VALUES (64, ''act_12_1'', ''s2_2a'');
		INSERT INTO lien_indicateurs_actions VALUES (65, ''act_12_2'', ''s1_2a'');
		INSERT INTO lien_indicateurs_actions VALUES (66, ''act_12_2'', ''s2_2a'');
		INSERT INTO lien_indicateurs_actions VALUES (67, ''act_13'', ''s3_1a'');
		INSERT INTO lien_indicateurs_actions VALUES (68, ''act_13_1_2'', ''s2_4a'');
		INSERT INTO lien_indicateurs_actions VALUES (69, ''act_13_1_2'', ''s3_8'');
		INSERT INTO lien_indicateurs_actions VALUES (70, ''act_13_1_3'', ''s3_7'');
		INSERT INTO lien_indicateurs_actions VALUES (71, ''act_13_1_4'', ''s3_9a'');
		INSERT INTO lien_indicateurs_actions VALUES (72, ''act_13_1_5'', ''s1_2a'');
		INSERT INTO lien_indicateurs_actions VALUES (73, ''act_13_1_5'', ''s1_2b'');
		INSERT INTO lien_indicateurs_actions VALUES (74, ''act_13_1_5'', ''s2_2a'');
		INSERT INTO lien_indicateurs_actions VALUES (75, ''act_13_1_7'', ''s3_10'');
		INSERT INTO lien_indicateurs_actions VALUES (76, ''act_13_3'', ''s3_1f'');
		INSERT INTO lien_indicateurs_actions VALUES (77, ''act_13_3'', ''s3_4a'');
		INSERT INTO lien_indicateurs_actions VALUES (78, ''act_13_3'', ''s3_5a'');
		INSERT INTO lien_indicateurs_actions VALUES (79, ''act_13_3'', ''s3_6a'');
		INSERT INTO lien_indicateurs_actions VALUES (80, ''act_13_4'', ''s1_8'');
		INSERT INTO lien_indicateurs_actions VALUES (81, ''act_13_5'', ''s1_9'');
		INSERT INTO lien_indicateurs_actions VALUES (82, ''act_13_8'', ''s1_2a'');
		INSERT INTO lien_indicateurs_actions VALUES (83, ''act_13_8'', ''s1_2b'');
		INSERT INTO lien_indicateurs_actions VALUES (84, ''act_14'', ''s3_1a'');
		INSERT INTO lien_indicateurs_actions VALUES (85, ''act_14_1'', ''s2_2a'');
		INSERT INTO lien_indicateurs_actions VALUES (86, ''act_14_1'', ''s3_2b'');
		INSERT INTO lien_indicateurs_actions VALUES (87, ''act_14_1'', ''s2_3'');
		INSERT INTO lien_indicateurs_actions VALUES (88, ''act_14_2'', ''s2_2a'');
		INSERT INTO lien_indicateurs_actions VALUES (89, ''act_14_2'', ''s2_3'');
		INSERT INTO lien_indicateurs_actions VALUES (90, ''act_14_3'', ''s3_1f'');
		INSERT INTO lien_indicateurs_actions VALUES (91, ''act_14_4'', ''s3_3'');
	';	
	EXECUTE (val);
	RAISE NOTICE 'Valeurs ajoutées à la table lien_indicateurs_actions';

	ind := '   
	CREATE INDEX ON lien_indicateurs_actions USING btree(id);
	CREATE INDEX ON lien_indicateurs_actions USING btree(code_indicateur);   
	CREATE INDEX ON lien_indicateurs_actions USING btree(code_action);		
	';
	EXECUTE (ind);
	RAISE NOTICE 'Index créés sur la table lien_indicateurs_actions';


	RAISE NOTICE '====== FIN TRAITEMENT ======';
	RAISE NOTICE '[INFO] Les tables actions_possibles, indicateurs et lien_indicateurs_actions ont été initialisées dans le schéma r_ressources';
	RAISE NOTICE '';

END;
$procedure$
