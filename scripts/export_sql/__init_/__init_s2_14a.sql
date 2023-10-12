SET client_encoding = 'UTF8';

CREATE OR REPLACE PROCEDURE public.__init_s2_14a()
 LANGUAGE plpgsql
AS $procedure$

-- Procédure SQL d'initialisation de la table s2_14a (surfaces à urbaniser inondables) dans le schéma p_indicateurs
-- © Cerema / GT AgiRisk
-- Dernière mise à jour du script le 26/08/2023 par Sébastien

-- Commande d'appel à cette procédure :
-- CALL public.__init_s2_14a();

DECLARE
	com text; -- variable d'exécution des commentaires

BEGIN

	SET search_path TO p_indicateurs, public;
	
	RAISE NOTICE '';
	RAISE NOTICE '====== RAPPORT ======';
	RAISE NOTICE 'Initialisation de l''indicateur S2/14a (surfaces à urbaniser inondables)';
	
	RAISE NOTICE 'Création de la structure de table attributaire s2_14a';
	EXECUTE 'DROP TABLE IF EXISTS s2_14a CASCADE';
	EXECUTE 'CREATE TABLE s2_14a (
		id serial PRIMARY KEY,
		territoire varchar(200),
		id_epci varchar(9),
		nom_epci varchar(200),
		id_commune varchar(5),
		nom_commune varchar(200),
		id_iris varchar(9),
		nom_iris varchar(200),
		loc_zx varchar(30),
		type_alea varchar(200),
		code_occurrence varchar(200),
		surf_au double precision DEFAULT 0,
		sce_donnee text,
		moda_calc text,
		date_calc date,
		geom geometry(MultiPolygon,2154)
	)';
	RAISE NOTICE 'Création de la table s2_14a effectuée';
	
	com := '
	COMMENT ON TABLE s2_14a IS ''Couche des zones à urbaniser inondables'';
	COMMENT ON COLUMN s2_14a.id IS ''Identifiant unique non nul de type serial (clé primaire)'';
	COMMENT ON COLUMN s2_14a.territoire IS ''Nom du territoire d''''étude'';
	COMMENT ON COLUMN s2_14a.id_epci IS ''Numéro SIREN de l''''EPCI'';
	COMMENT ON COLUMN s2_14a.nom_epci IS ''Nom de l''''EPCI'';
	COMMENT ON COLUMN s2_14a.id_commune IS ''Code INSEE de la commune'';
	COMMENT ON COLUMN s2_14a.nom_commune IS ''Nom de la commune'';
	COMMENT ON COLUMN s2_14a.id_iris IS ''Code de l''''IRIS GE (maille de calcul élémentaire)'';
	COMMENT ON COLUMN s2_14a.nom_iris IS ''Nom de l''''IRIS GE (maille de calcul élémentaire)'';
	COMMENT ON COLUMN s2_14a.loc_zx IS ''Indique si le bout de zone Au est à l''''intérieur ou à l''''extérieur de la zone inondable zx'';
	COMMENT ON COLUMN s2_14a.type_alea IS ''Type d''''aléa considéré : débordement de cours d''''eau, submersion marine, ruissellement'';
	COMMENT ON COLUMN s2_14a.code_occurrence IS ''Code de la période de retour (ex : QRef, Q100, Q10, Xynthia_2100, Q_freq, Q_moy, Q_extr, Qref_plus50)'';
	COMMENT ON COLUMN s2_14a.surf_au IS ''Surface de la zone AU (en hectares)'';
	COMMENT ON COLUMN s2_14a.sce_donnee IS ''Données sources utilisées (référentiels + millésimes)'';
	COMMENT ON COLUMN s2_14a.moda_calc IS ''Nom de la fonction postgis telle que stockée dans la BDD'';
	COMMENT ON COLUMN s2_14a.date_calc IS ''Date de création de l''''indicateur'';
	COMMENT ON COLUMN s2_14a.geom IS ''Description géographique de l''''entité (zones à urbaniser inondables)'';
	';
	EXECUTE (com);
	RAISE NOTICE 'Commentaires ajoutés à la table s2_14a';
	
	RAISE NOTICE '====== FIN TRAITEMENT ======';
	RAISE NOTICE '[INFO] La table s2_14a a été initialisée dans le schéma p_indicateurs';
	RAISE NOTICE '';

END;
$procedure$
