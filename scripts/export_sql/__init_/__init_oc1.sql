SET client_encoding = 'UTF8';

CREATE OR REPLACE PROCEDURE public.__init_oc1()
 LANGUAGE plpgsql
AS $procedure$

-- Procédure SQL d'initialisation de la table oc1 (bâtiments) dans le schéma c_occupation_sol
-- © Cerema / GT AgiRisk
-- Dernière mise à jour du script le 26/08/2023 par Sébastien

-- Commande d'appel à cette procédure :
-- CALL public.__init_oc1();

DECLARE
	com text; -- variable d'exécution des commentaires

BEGIN

	SET search_path TO c_occupation_sol, public;

	RAISE NOTICE '';
	RAISE NOTICE '====== RAPPORT ======';
	RAISE NOTICE 'Initialisation de la variable Oc1 (bâtiments)';

	RAISE NOTICE 'Création de la structure de table attributaire oc1';
	EXECUTE 'DROP TABLE IF EXISTS oc1 CASCADE';
	EXECUTE 'CREATE TABLE oc1 (
		id serial PRIMARY KEY,
		territoire varchar(200),
		id_iris varchar(9),
		nom_iris varchar(200),
		id_bdt varchar(50),
		nature varchar(100),
		usage1 varchar(100),
		usage2 varchar(100),
		leger varchar(10),
		etat varchar(50),
		hauteur_bdt double precision,
		hauteur_corr double precision,
		nb_etages_bdt integer,
		nb_etages_corr integer,
		plainpied boolean,
		nb_logts_bdt integer,
		nb_logts_corr integer,
		idtup varchar(50),
		tlocdomin_ff varchar(50),
		oc2 boolean DEFAULT false,
		oc3 boolean DEFAULT false,
		pop1 double precision DEFAULT 0,
		pop1_agee double precision DEFAULT 0,
		pop2_bas double precision DEFAULT 0,		
		pop2_haut double precision DEFAULT 0,
		pop3 double precision DEFAULT 0,
		pop4 double precision DEFAULT 0,
		pop5 double precision DEFAULT 0,
		pop6_bas double precision GENERATED ALWAYS AS (pop1+pop2_bas+pop3+pop4) STORED,
		pop6_haut double precision GENERATED ALWAYS AS (pop1+pop2_haut+pop3+pop4+pop5) STORED,
		capacite_touristique double precision DEFAULT 0,
		sce_donnee text,
		moda_calc text,
		date_calc date,
		geom geometry(MultiPolygon,2154),
		geomloc geometry(POINT,2154)
	)';
	RAISE NOTICE 'Création de la table oc1 effectuée';

	com := '
	COMMENT ON TABLE oc1 IS ''Couche des bâtiments'';
	COMMENT ON COLUMN oc1.id IS ''Identifiant unique non nul de type serial (clé primaire)'';
	COMMENT ON COLUMN oc1.territoire IS ''Nom du territoire d''''étude'';
	COMMENT ON COLUMN oc1.id_iris IS ''Code de l''''IRIS GE (maille de calcul élémentaire)'';
	COMMENT ON COLUMN oc1.nom_iris IS ''Nom de l''''IRIS GE (maille de calcul élémentaire)'';
	COMMENT ON COLUMN oc1.id_bdt IS ''Identifiant d''''origine de la couche des bâtiments issu de la BDTOPO, normalement unique, mais quelques doublons non parfaits (erreur BDTOPO) demeurent'';
	COMMENT ON COLUMN oc1.nature IS ''Attribut hérité de la BDTOPOv3 permettant de distinguer les différents types de bâtiments selon leur architecture'';
	COMMENT ON COLUMN oc1.usage1 IS ''Usage du bâtiment ou d''''une partie du bâtiment (attribut hérité de la BDTOPOv3, lui-même hérité de l''''ancien champ Fonction de la BDUni et enrichi par appariement avec les fichiers fonciers de la DGFiP anonymisé par le Cerema)'';
	COMMENT ON COLUMN oc1.usage2 IS ''Autre usage d''''un bâtiment de fonction mixte (attribut hérité de la BDTOPOv3)'';
	COMMENT ON COLUMN oc1.leger IS ''Indique si oui ou non le bâtiment est une construction légère, non attachée au sol par l''''intermédiaire de fondations, ou d''''un bâtiment ou partie de bâtiment ouvert sur au moins un côté (attribut hérité de la BDTOPOv3)'';
	COMMENT ON COLUMN oc1.etat IS ''Indique l''''état administratif du bâtiment (attribut hérité de la BDTOPOv3)'';
	COMMENT ON COLUMN oc1.hauteur_bdt IS ''Hauteur en mètres du bâtiment mesurée entre le sol et le point haut de la gouttière (attribut hérité de la BDTOPOv3)'';
	COMMENT ON COLUMN oc1.hauteur_corr IS ''Hauteur du bâtiment issue de la BDTOPOv3 lorsqu''''elle est renseignée. Lorsqu''''elle ne l''''est pas, 3m si le bâtiment est concerné par des locaux d''''habitation, sinon 5m'';
	COMMENT ON COLUMN oc1.nb_logts_bdt IS ''Nombre de logements à l''''intérieur du bâtiment, calculé dans la BDTOPOv3 à partir de l''''attribut nloclog des fichiers fonciers'';
	COMMENT ON COLUMN oc1.nb_logts_corr IS ''Nombre de logements à l''''intérieur du bâtiment, corrigé lors du calcul de la variable Oc2'';
	COMMENT ON COLUMN oc1.nb_etages_bdt IS ''Nombre total d''''étages du bâtiment, rez-de-chaussée compris, hors sous-sols (attribut hérité de la BDTOPOv3)'';
	COMMENT ON COLUMN oc1.nb_etages_corr IS ''Nombre d''''étages obtenu à partir de la BDTOPOv3 lorsque la donnée est renseignée. Lorsqu''''elle ne l''''est pas, division de la hauteur (haut_modif) par 3 si le bâtiment est concerné par des locaux d''''habitation, par 5 pour le reste des bâtiments'';
	COMMENT ON COLUMN oc1.plainpied IS ''Indique si le bâtiment est a priori de plain-pied ou non (selon la valeur du champ nb_etages_corr)'';
	COMMENT ON COLUMN oc1.idtup IS ''Identifiant de la parcelle TUP à laquelle appartient le bâtiment (issu de la TUP des Fichiers Fonciers)'';
	COMMENT ON COLUMN oc1.tlocdomin_ff IS ''Type de local dominant sur la parcelle (donnée issue des Fichiers Fonciers)'';
	COMMENT ON COLUMN oc1.oc2 IS ''Champ booléen indiquant si oui ou non le bâtiment comprend au moins un local d''''habitation'';
	COMMENT ON COLUMN oc1.oc3 IS ''Champ booléen indiquant si oui ou non le bâtiment comprend au moins un local d''''activité'';
	COMMENT ON COLUMN oc1.pop1 IS ''Nombre de résidents permanents à l''''intérieur du bâtiment'';
	COMMENT ON COLUMN oc1.pop1_agee IS ''Nombre de résidents permanents âgés de plus de 65 ans à l''''intérieur du bâtiment'';
	COMMENT ON COLUMN oc1.pop2_bas IS ''Nombre de salariés à l''''intérieur du bâtiment, seuil bas (issue de la variable trancheeffectifsetablissementtriable de la table geosirene)'';
	COMMENT ON COLUMN oc1.pop2_haut IS ''Nombre de salariés à l''''intérieur du bâtiment, seuil haut (issue de la variable trancheeffectifsetablissementtriable de la table geosirene)'';
	COMMENT ON COLUMN oc1.pop3 IS ''Nombre de personnes sensibles à l''''intérieur du bâtiment'';
	COMMENT ON COLUMN oc1.pop4 IS ''Nombre de personnes en zone de forte concentration à l''''intérieur du bâtiment'';
	COMMENT ON COLUMN oc1.pop5 IS ''Nombre de résidents saisonniers à l''''intérieur du bâtiment'';
	COMMENT ON COLUMN oc1.pop6_bas IS ''Nombre total d''''occupants à l''''intérieur du bâtiment, basé sur pop2_bas (colonne générée pop1+pop2_bas+pop3+pop4)'';
	COMMENT ON COLUMN oc1.pop6_haut IS ''Nombre total d''''occupants à l''''intérieur du bâtiment, basé sur pop2_haut (colonne générée pop1+pop2_haut+pop3+pop4+pop5)'';
	COMMENT ON COLUMN oc1.capacite_touristique IS ''Estimation de la capacité d''''accueil maximale des résidences de tourisme (dont hôtels)'';
	COMMENT ON COLUMN oc1.sce_donnee IS ''Données sources utilisées (référentiels + millésimes)'';
	COMMENT ON COLUMN oc1.moda_calc IS ''Nom de la fonction postgis telle que stockée dans la BDD'';
	COMMENT ON COLUMN oc1.date_calc IS ''Date de création de la variable'';
	COMMENT ON COLUMN oc1.geom IS ''Description géographique de l''''entité (bâtiments)'';
	COMMENT ON COLUMN oc1.geomloc IS ''Centroïde des bâtiments'';
	';
	EXECUTE (com);
	RAISE NOTICE 'Commentaires ajoutés à la table oc1';

	RAISE NOTICE '====== FIN TRAITEMENT ======';
	RAISE NOTICE '[INFO] La table oc1 a été initialisée dans le schéma c_occupation_sol';
	RAISE NOTICE '';

END;
$procedure$
