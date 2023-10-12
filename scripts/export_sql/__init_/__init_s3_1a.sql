SET client_encoding = 'UTF8';

CREATE OR REPLACE PROCEDURE public.__init_s3_1a()
 LANGUAGE plpgsql
AS $procedure$

-- Procédure SQL d'initialisation de la table s3_1a (occupants en zone inondable) dans le schéma p_indicateurs
-- © Cerema / GT Agirisk
-- Dernière mise à jour du script le 26/08/2023 par Sébastien

-- Commande d'appel à cette procédure :
-- CALL public.__init_s3_1a();

DECLARE
	com text; -- variable d'exécution des commentaires

BEGIN

	SET search_path TO p_indicateurs, public;

	RAISE NOTICE '';
	RAISE NOTICE '====== RAPPORT ======';
	RAISE NOTICE 'Initialisation de l''indicateur S3/1a (occupants en zone inondable)';

	RAISE NOTICE 'Création de la structure de table attributaire s3_1a';
	EXECUTE 'DROP TABLE IF EXISTS s3_1a CASCADE';
	EXECUTE 'CREATE TABLE s3_1a (
		id serial PRIMARY KEY,
		territoire varchar(200),
		id_epci varchar(9),
		nom_epci varchar(200),
		id_commune varchar(5),
		nom_commune varchar(200),
		id_iris varchar(9),
		nom_iris varchar(200),
		id_bdt varchar(50),
		loc_zx varchar(30),
		type_alea varchar(200),
		code_occurrence varchar(200),
		pop1 double precision DEFAULT 0,
		pop1_agee double precision DEFAULT 0,
		pop2_bas double precision DEFAULT 0,
		pop2_haut double precision DEFAULT 0,
		pop3 double precision DEFAULT 0,
		pop4 double precision DEFAULT 0,
		pop5 double precision DEFAULT 0,
		pop6_bas double precision DEFAULT 0,
		pop6_haut double precision DEFAULT 0,
		sce_donnee text,
		moda_calc text,
		date_calc date,
		geom geometry(MultiPolygon,2154),
		geomloc geometry(POINT,2154)
	)';
	RAISE NOTICE 'Création de la table s3_1a effectuée';

	com := '
	COMMENT ON TABLE s3_1a IS ''Couche des occupants en zone inondable (Zx)'';
	COMMENT ON COLUMN s3_1a.id IS ''Identifiant unique non nul de type serial (clé primaire)'';
	COMMENT ON COLUMN s3_1a.territoire IS ''Nom du territoire d''''étude'';
	COMMENT ON COLUMN s3_1a.id_epci IS ''Numéro SIREN de l''''EPCI'';
	COMMENT ON COLUMN s3_1a.nom_epci IS ''Nom de l''''EPCI'';
	COMMENT ON COLUMN s3_1a.id_commune IS ''Code INSEE de la commune'';
	COMMENT ON COLUMN s3_1a.nom_commune IS ''Nom de la commune'';
	COMMENT ON COLUMN s3_1a.id_iris IS ''Code de l''''IRIS GE (maille de calcul élémentaire)'';
	COMMENT ON COLUMN s3_1a.nom_iris IS ''Nom de l''''IRIS GE (maille de calcul élémentaire)'';
	COMMENT ON COLUMN s3_1a.id_bdt IS ''Identifiant du bâtiment issu de la BDTOPO'';
	COMMENT ON COLUMN s3_1a.loc_zx IS ''Indique si le bâtiment intersecte ("In") ou non ("Out") la zone inondable (Zx)'';
	COMMENT ON COLUMN s3_1a.type_alea IS ''Type d''''aléa considéré (ex : débordement de cours d''''eau, submersion marine, ruissellement)'';
	COMMENT ON COLUMN s3_1a.code_occurrence IS ''Code de la période de retour (ex : QRef, Q100, Q10, Xynthia_2100, Q_freq, Q_moy, Q_extr, Qref_plus50)'';
	COMMENT ON COLUMN s3_1a.pop1 IS ''Nombre d''''habitants à l''''intérieur du bâtiment'';
	COMMENT ON COLUMN s3_1a.pop1_agee IS ''Nombre de résidents permanents âgés de plus de 65 ans dans le bâtiment'';
	COMMENT ON COLUMN s3_1a.pop2_bas IS ''Seuil bas du nombre d''''employés à l''''intérieur du bâtiment'';
	COMMENT ON COLUMN s3_1a.pop2_haut IS ''Seuil haut du nombre d''''employés à l''''intérieur du bâtiment'';
	COMMENT ON COLUMN s3_1a.pop3 IS ''Nombre de personnes sensibles à l''''intérieur du bâtiment'';
	COMMENT ON COLUMN s3_1a.pop4 IS ''Zones de concentration de personnes'';
	COMMENT ON COLUMN s3_1a.pop5 IS ''Nombre de résidents saisonniers à l''''intérieur du bâtiment'';
	COMMENT ON COLUMN s3_1a.pop6_bas IS ''Seuil bas du nombre d''''occupants à l''''intérieur du bâtiment'';
	COMMENT ON COLUMN s3_1a.pop6_haut IS ''Seuil haut du nombre d''''occupants à l''''intérieur du bâtiment'';
	COMMENT ON COLUMN s3_1a.sce_donnee IS ''Données sources utilisées (référentiels + millésimes)'';
	COMMENT ON COLUMN s3_1a.moda_calc IS ''Nom de la fonction postgis telle que stockée dans la BDD'';
	COMMENT ON COLUMN s3_1a.date_calc IS ''Date de création de l''''indicateur'';
	COMMENT ON COLUMN s3_1a.geom IS ''Description géographique de l''''entité (bâtiments inondables)'';
	COMMENT ON COLUMN s3_1a.geomloc IS ''Centroïde de la géométrie'';
	';
	EXECUTE (com);
	RAISE NOTICE 'Commentaires ajoutés à la table s3_1a';

	RAISE NOTICE '====== FIN TRAITEMENT ======';
	RAISE NOTICE '[INFO] La table s3_1a a été initialisée dans le schéma p_indicateurs';
	RAISE NOTICE '';

END;
$procedure$
