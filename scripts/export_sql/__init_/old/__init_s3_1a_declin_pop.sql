CREATE OR REPLACE PROCEDURE public.__init_s3_1a_declin_pop()
 LANGUAGE plpgsql
AS $procedure$

-- Procédure SQL d'initialisation de la table s3_1a (occupants en zone inondable) dans le schéma p_indicateurs
-- Copyright Cerema / GT Agirisk

-- La présente version 2 du script inclut la déclinaison Pop1...Pop6

-- Commande d'appel à cette procédure : CALL public.__init_s3_1a_DECLIN_POP();

DECLARE
	com text; -- variable d'exécution des commentaires
	ind text; -- variable d'exécution des index

BEGIN

	SET search_path TO p_indicateurs, public;
	
    RAISE NOTICE '';
    RAISE NOTICE '====== RAPPORT ======';
    RAISE NOTICE 'Initialisation de l''indicateur S3/1a (occupants en zone inondable)';
	
	RAISE NOTICE 'Création de la structure de table attributaire s3_1a';

	-- TODO : champ id_bdt à confirmer

	EXECUTE 'DROP TABLE IF EXISTS s3_1a CASCADE';
	EXECUTE 'CREATE TABLE s3_1a (
		id serial primary key,
		id_bdt varchar(50),
		territoire varchar(200),
		id_epci varchar(30),
		nom_epci varchar(200),
		id_commune varchar(10),
		nom_commune varchar(200),
		id_iris varchar(30),
		nom_iris varchar(200),
		loc_zx varchar(30),
		type_alea varchar(50),
		code_occurrence varchar(200),
		pop1 double precision DEFAULT 0,
		pop2_haut double precision DEFAULT 0,
		pop2_bas double precision DEFAULT 0,
		pop3 double precision DEFAULT 0,
		pop4 double precision DEFAULT 0,
		pop5 double precision DEFAULT 0,
		pop6_haut double precision DEFAULT 0,
		pop6_bas double precision DEFAULT 0,
		date_calcul date,
		modalite_calcul varchar(50),
		geom geometry (MultiPolygon,2154),
		geomloc geometry (POINT,2154)
	)';
	RAISE NOTICE 'Création de la table s3_1a effectuée';
	
	com := '
	COMMENT ON TABLE s3_1a IS ''Couche des occupants en zone inondable (Zx)'';
	COMMENT ON COLUMN s3_1a.id IS ''Identifiant unique non nul de type serial'';
	COMMENT ON COLUMN s3_1a.territoire IS ''Nom du territoire d''''étude'';
	COMMENT ON COLUMN s3_1a.id_epci IS ''Numéro SIREN de l''''EPCI'';
	COMMENT ON COLUMN s3_1a.nom_epci IS ''Nom de l''''EPCI'';
	COMMENT ON COLUMN s3_1a.id_commune IS ''Code INSEE de la commune'';
	COMMENT ON COLUMN s3_1a.nom_commune IS ''Nom de la commune'';
	COMMENT ON COLUMN s3_1a.id_iris IS ''Code de l''''IRIS GE (maille de calcul élémentaire)'';
	COMMENT ON COLUMN s3_1a.nom_iris IS ''Nom de l''''IRIS GE (maille de calcul élémentaire)'';
	COMMENT ON COLUMN s3_1a.loc_zx IS ''Indique si le bâtiment intersecte ("in") ou non ("out") la zone inondable (Zx)'';
	COMMENT ON COLUMN s3_1a.type_alea IS ''Type d''''aléa considéré (ex : débordement de cours d''''eau, submersion marine, ruissellement)'';
	COMMENT ON COLUMN s3_1a.code_occurrence IS ''Code de la période de retour (ex : QRef, Q100, Q10, Xynthia_2100, Q_freq, Q_moy, Q_extr, Qref_plus50)'';
	COMMENT ON COLUMN s3_1a.pop1 IS ''Nombre d''''habitants à l''''intérieur du bâtiment'';
	COMMENT ON COLUMN s3_1a.pop2_haut IS ''Seuil haut du nombre d''''employés à l''''intérieur du bâtiment'';
	COMMENT ON COLUMN s3_1a.pop2_bas IS ''Seuil bas du nombre d''''employés à l''''intérieur du bâtiment'';
	COMMENT ON COLUMN s3_1a.pop3 IS ''Nombre de personnes sensibles à l''''intérieur du bâtiment'';
	COMMENT ON COLUMN s3_1a.pop4 IS ''Zones de concentration de personnes'';
	COMMENT ON COLUMN s3_1a.pop5 IS ''Nombre de résidents saisonniers à l''''intérieur du bâtiment'';
	COMMENT ON COLUMN s3_1a.pop6_haut IS ''Seuil haut du nombre d''''occupants à l''''intérieur du bâtiment'';
	COMMENT ON COLUMN s3_1a.pop6_bas IS ''Seuil bas du nombre d''''occupants à l''''intérieur du bâtiment'';
	COMMENT ON COLUMN s3_1a.date_calcul IS ''Date de création de l''''indicateur'';
	COMMENT ON COLUMN s3_1a.modalite_calcul IS ''Nom de la fonction postgis telle que stockée dans la BDD'';
	COMMENT ON COLUMN s3_1a.geom IS ''Description géographique de l''''entité (bâtiments inondables)'';
	COMMENT ON COLUMN s3_1a.geomloc IS ''Centroïde de la géométrie'';
	';
	EXECUTE (com);
	RAISE NOTICE 'Commentaires ajoutés à la table s3_1a';
	
	ind := '
	CREATE INDEX ON s3_1a USING gist(geom);
	CREATE INDEX ON s3_1a USING gist(geomloc);
	CREATE INDEX ON s3_1a USING btree(id);
	CREATE INDEX ON s3_1a USING btree(territoire);
	CREATE INDEX ON s3_1a USING btree(id_epci);
	CREATE INDEX ON s3_1a USING btree(nom_epci);
	CREATE INDEX ON s3_1a USING btree(id_commune);
	CREATE INDEX ON s3_1a USING btree(nom_commune);
	CREATE INDEX ON s3_1a USING btree(id_iris);
	CREATE INDEX ON s3_1a USING btree(nom_iris);
	CREATE INDEX ON s3_1a USING btree(loc_zx);
	CREATE INDEX ON s3_1a USING btree(type_alea);
	CREATE INDEX ON s3_1a USING btree(code_occurrence);
	CREATE INDEX ON s3_1a USING btree(pop1);
	CREATE INDEX ON s3_1a USING btree(pop2_haut);
	CREATE INDEX ON s3_1a USING btree(pop2_bas);
	CREATE INDEX ON s3_1a USING btree(pop3);
	CREATE INDEX ON s3_1a USING btree(pop4);
	CREATE INDEX ON s3_1a USING btree(pop5);
	CREATE INDEX ON s3_1a USING btree(pop6_haut);
	CREATE INDEX ON s3_1a USING btree(pop6_bas);
	CREATE INDEX ON s3_1a USING btree(date_calcul);
	CREATE INDEX ON s3_1a USING btree(modalite_calcul);
	';
	EXECUTE (ind);
	RAISE NOTICE 'Index créés sur la table s3_1a';
	
	RAISE NOTICE '====== FIN TRAITEMENT ======';
	RAISE NOTICE '[INFO] La table s3_1a a été initialisée dans le schéma p_indicateurs';
	RAISE NOTICE '';

END;
$procedure$
