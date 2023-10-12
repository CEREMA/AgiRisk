SET client_encoding = 'UTF8';

CREATE OR REPLACE PROCEDURE public.__init_s1_2a()
 LANGUAGE plpgsql
AS $procedure$

-- Procédure SQL d'initialisation de la table s1_2a (personnes occupant des bâtiments de plain-pied fortement inondables) dans le schéma p_indicateurs
-- © Copyright Cerema / GT AgiRisk
-- Dernière mise à jour du script le 26/08/2023 par Sébastien

-- Commande d'appel à cette procédure :
-- CALL public.__init_s1_2a();

DECLARE
	com text; -- variable d'exécution des commentaires

BEGIN

	SET search_path TO p_indicateurs, public;

	RAISE NOTICE '';
	RAISE NOTICE '====== RAPPORT ======';
	RAISE NOTICE 'Initialisation de l''indicateur S1/2a (personnes occupant des bâtiments de plain-pied fortement inondables)';

	RAISE NOTICE 'Création de la structure de table attributaire s1_2a';
	EXECUTE 'DROP TABLE IF EXISTS s1_2a CASCADE';
	EXECUTE 'CREATE TABLE s1_2a (
		id serial PRIMARY KEY,
		territoire varchar(200),
		id_epci varchar(9),
		nom_epci varchar(200),
		id_commune varchar(5),
		nom_commune varchar(200),
		id_iris varchar(9),
		nom_iris varchar(200),
		id_bdt varchar(50),
		loc_zq varchar(50),
		type_alea varchar(200),
		code_occurrence varchar(200),
		pop6_pp double precision DEFAULT 0, -- à défaut de mieux, pop6_pp = oc1.pop6_haut lorsque oc1.plainpied IS true
		sce_donnee text,
		moda_calc text,
		date_calc date,
		geom geometry(MultiPolygon,2154),
		geomloc geometry(POINT,2154)
	)';
	RAISE NOTICE 'Création de la table s1_2a effectuée';

	com := '
	COMMENT ON TABLE s1_2a IS ''Couche des occupants dans les bâtiments de plain-pied fortement inondables'';
	COMMENT ON COLUMN s1_2a.id IS ''Identifiant unique non nul de type serial (clé primaire)'';
	COMMENT ON COLUMN s1_2a.territoire IS ''Nom du territoire d''''étude'';
	COMMENT ON COLUMN s1_2a.id_epci IS ''Numéro SIREN de l''''EPCI'';
	COMMENT ON COLUMN s1_2a.nom_epci IS ''Nom de l''''EPCI'';
	COMMENT ON COLUMN s1_2a.id_commune IS ''Code INSEE de la commune'';
	COMMENT ON COLUMN s1_2a.nom_commune IS ''Nom de la commune'';
	COMMENT ON COLUMN s1_2a.id_iris IS ''Code de l''''IRIS GE (maille de calcul élémentaire)'';
	COMMENT ON COLUMN s1_2a.nom_iris IS ''Nom de l''''IRIS GE (maille de calcul élémentaire)'';
	COMMENT ON COLUMN s1_2a.id_bdt IS ''Identifiant d''''origine de la couche des bâtiments issu de la BDTOPO'';
	COMMENT ON COLUMN s1_2a.loc_zq IS ''Indique si le bâtiment intersecte ("In") ou non ("Out") une zone d''''aléa de niveaux fort à très fort'';
	COMMENT ON COLUMN s1_2a.type_alea IS ''Type d''''aléa considéré (ex : débordement de cours d''''eau, submersion marine, ruissellement)'';
	COMMENT ON COLUMN s1_2a.code_occurrence IS ''Code de la période de retour (ex : QRef, Q100, Q10, Xynthia_2100, Q_freq, Q_moy, Q_extr, Qref_plus50)'';
	COMMENT ON COLUMN s1_2a.pop6_pp IS ''Nombre d''''occupants à l''''intérieur des bâtiments de plain-pied'';
	COMMENT ON COLUMN s1_2a.sce_donnee IS ''Données sources utilisées (référentiels + millésimes)'';
	COMMENT ON COLUMN s1_2a.moda_calc IS ''Nom de la fonction postgis telle que stockée dans la BDD'';
	COMMENT ON COLUMN s1_2a.date_calc IS ''Date de création de l''''indicateur'';
	COMMENT ON COLUMN s1_2a.geom IS ''Description géographique de l''''entité (zones à urbaniser inondables)'';
	COMMENT ON COLUMN s1_2a.geomloc IS ''Centroïde de la géométrie'';
	';
	EXECUTE (com);
	RAISE NOTICE 'Commentaires ajoutés à la table s1_2a';

	RAISE NOTICE '====== FIN TRAITEMENT ======';
	RAISE NOTICE '[INFO] La table s1_2a a été initialisée dans le schéma p_indicateurs';
	RAISE NOTICE '';

END;
$procedure$
