CREATE OR REPLACE PROCEDURE public.__init_oc1()
 LANGUAGE plpgsql
AS $procedure$

-- Script d'initialisation de la table oc1 dans le schéma c_occupation_sol

BEGIN

	RAISE NOTICE '';
	RAISE NOTICE '====== RAPPORT ======';
	RAISE NOTICE 'Initialisation de la variable Oc1 (Bâtiments)';

	DROP TABLE IF EXISTS c_occupation_sol.oc1 CASCADE;
	CREATE TABLE c_occupation_sol.oc1(
			id serial primary key,
			territoire varchar(50),
			id_iris varchar(50),
			nom_iris varchar(200),
			id_bdt varchar(50),
			nature varchar(100),
			usage1 varchar(100),
			usage2 varchar(100),
			leger varchar(10),
			etat varchar(50),
			hauteur double precision,
			nb_logts integer,
			nb_etages integer,
			plainpied boolean,
			nombre_d_etages integer,
			haut_modif double precision,
			idtup varchar(50),
			oc2 boolean default false,
			oc3 boolean default false,
			pop1 double precision default 0,
			pop2_haut double precision default 0,
			pop2_bas double precision default 0,
			pop3 double precision default 0,
			pop4 double precision default 0,
			pop5 double precision default 0,
			pop6_haut double precision GENERATED ALWAYS AS (pop2_haut+pop3+pop4+pop5) STORED,
			pop6_bas double precision GENERATED ALWAYS AS (pop2_bas+pop3+pop4+pop5) STORED,
			capacite_touristique double precision default 0,
			sce_donnee varchar(200),
			url varchar(200),
			date_calcul date,
			modalite_calcul varchar(50),
			geom geometry(MultiPolygon,2154),
			geomloc geometry(POINT,2154)
			);
	
	RAISE NOTICE '';
	RAISE NOTICE 'Création de la table Oc1 effectuée';
	RAISE NOTICE '';
	
	COMMENT ON TABLE c_occupation_sol.oc1 IS 'Couche des bâtiments.';
	COMMENT ON COLUMN c_occupation_sol.oc1.id IS 'Identifiant unique non nul de type serial.';
	COMMENT ON COLUMN c_occupation_sol.oc1.territoire IS 'Nom du territoire d''étude';
    COMMENT ON COLUMN c_occupation_sol.oc1.id_iris IS 'Code de l''IRIS GE (maille de calcul élémentaire)';
    COMMENT ON COLUMN c_occupation_sol.oc1.nom_iris IS 'Nom de l''IRIS GE (maille de calcul élémentaire)';
	COMMENT ON COLUMN c_occupation_sol.oc1.id_bdt IS 'Identifiant issu de la BDTOPO, normalement unique, mais quelques doublons non parfaits (erreur BDTOPO) demeurent.';
	COMMENT ON COLUMN c_occupation_sol.oc1.plainpied IS 'Indique si le bâtiment est a priori de plain-pied ou non.';
	COMMENT ON COLUMN c_occupation_sol.oc1.nombre_d_etages IS 'Nombre d''étages obtenu à partir de la BDTOPOv3 lorsqu''elle est renseignée. Lorsqu''elle ne l''est pas, division de la hauteur (haut_modif) par 3 si le bâtiment est concerné par des locaux d''habitation, par 5 pour le reste des bâtiments.';
	COMMENT ON COLUMN c_occupation_sol.oc1.haut_modif IS 'Hauteur du bâtiment issue de la BDTOPOv3 lorsqu''elle est renseignée. Lorsqu''elle ne l''est pas, 3m si le bâtiment est concerné par des locaux d''habitation, sinon 5m.';
	COMMENT ON COLUMN c_occupation_sol.oc1.idtup IS 'Identifiant de parcelle dans laquelle se situe le bâtiment (issu de la TUP des Fichiers Fonciers).';
	COMMENT ON COLUMN c_occupation_sol.oc1.oc2 IS 'Indique si oui ou non le bâtiment est concerné par des locaux d''habitation. Champ booléen.';
	COMMENT ON COLUMN c_occupation_sol.oc1.oc3 IS 'Indique sur oui ou non le bâtiment est concerné par des locaux d''activité.';
	COMMENT ON COLUMN c_occupation_sol.oc1.pop1 IS 'Nombre de résidents permanents à l''intérieur du bâtiment.';
	COMMENT ON COLUMN c_occupation_sol.oc1.pop2_haut IS 'Nombre de salariés à l''intérieur du bâtiment, seuil haut (issue de la variable trancheeffectifsetablissementtriable de la table geosirene).';
	COMMENT ON COLUMN c_occupation_sol.oc1.pop2_bas IS 'Nombre de salariés à l''intérieur du bâtiment, seuil bas (issue de la variable trancheeffectifsetablissementtriable de la table geosirene).';
	COMMENT ON COLUMN c_occupation_sol.oc1.pop3 IS 'Nombre de personnes sensibles à l''intérieur du bâtiment.';
	COMMENT ON COLUMN c_occupation_sol.oc1.pop4 IS 'Nombre de personnes en zone de forte concentration à l''intérieur du bâtiment.';
	COMMENT ON COLUMN c_occupation_sol.oc1.pop5 IS 'Nombre de résidents saisonniers à l''intérieur du bâtiment.';
	COMMENT ON COLUMN c_occupation_sol.oc1.pop6_haut IS 'Nombre total d''occupants à l''intérieur du bâtiment (basé sur pop2_haut).';
	COMMENT ON COLUMN c_occupation_sol.oc1.pop6_bas IS 'Nombre total d''occupants à l''intérieur du bâtiment (basé sur pop2_bas).';
	COMMENT ON COLUMN c_occupation_sol.oc1.capacite_touristique IS 'Capacité touristique';
	COMMENT ON COLUMN c_occupation_sol.oc1.sce_donnee IS 'Source de la donnée pour chaque entité.';
    COMMENT ON COLUMN c_occupation_sol.oc1.url IS 'Lien de téléchargement des bâtiments';
	COMMENT ON COLUMN c_occupation_sol.oc1.date_calcul IS 'Date de création de la variable.';
    COMMENT ON COLUMN c_occupation_sol.oc1.modalite_calcul IS 'Nom de la fonction postgis telle que stockée dans la BDD';
	COMMENT ON COLUMN c_occupation_sol.oc1.geom IS 'Description géographique de l''entité (bâtiments)';
	COMMENT ON COLUMN c_occupation_sol.oc1.geomloc IS 'Centroïde des bâtiments';
	
	RAISE NOTICE '';
	RAISE NOTICE 'Commentaires ajoutés à la table Oc1.';
	RAISE NOTICE '';
	
	CREATE INDEX ON c_occupation_sol.oc1 USING gist(geom);
	CREATE INDEX ON c_occupation_sol.oc1 USING gist(geomloc);
	CREATE INDEX ON c_occupation_sol.oc1 USING btree(id);
	CREATE INDEX ON c_occupation_sol.oc1 USING btree(id_bdt);
	CREATE INDEX ON c_occupation_sol.oc1 USING btree(nb_logts);
	CREATE INDEX ON c_occupation_sol.oc1 USING btree(nb_etages);
	CREATE INDEX ON c_occupation_sol.oc1 USING btree(nature);
	CREATE INDEX ON c_occupation_sol.oc1 USING btree(usage1);
	CREATE INDEX ON c_occupation_sol.oc1 USING btree(usage2);
	CREATE INDEX ON c_occupation_sol.oc1 USING btree(hauteur);
	CREATE INDEX ON c_occupation_sol.oc1 USING btree(territoire);
	
	RAISE NOTICE '';
	RAISE NOTICE 'Index créés sur la table Oc1.';
	RAISE NOTICE '';

END;
$procedure$
;

CALL __init_oc1();