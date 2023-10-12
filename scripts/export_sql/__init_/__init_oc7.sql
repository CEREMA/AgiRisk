SET client_encoding = 'UTF8';

CREATE OR REPLACE PROCEDURE public.__init_oc7()
 LANGUAGE plpgsql
AS $procedure$

-- Procédure SQL d'initialisation de la table oc7 (cultures agricoles) dans le schéma c_occupation_sol
-- © Cerema / GT AgiRisk (auteure principale du script : Tiffany)
-- Dernière mise à jour du script le 26/08/2023 par Sébastien

-- Commande d'appel à cette procédure :
-- CALL public.__init_oc7();

DECLARE
	com text; -- variable d'exécution des commentaires

BEGIN

	SET search_path TO c_occupation_sol, public;

	RAISE NOTICE '';
	RAISE NOTICE '====== RAPPORT ======';
	RAISE NOTICE 'Initialisation de la variable Oc7 (parcelles agricoles)';

	RAISE NOTICE 'Création de la structure de table attributaire oc7';
	EXECUTE 'DROP TABLE IF EXISTS c_occupation_sol.oc7 CASCADE';
	EXECUTE 'CREATE TABLE c_occupation_sol.oc7 (
		id serial PRIMARY KEY,
		territoire varchar(200),
		id_iris varchar(9),
		nom_iris varchar(200),
		id_parc integer,
		code_rpg varchar(30),
		lib_culture varchar(50),
		sce_donnee text,
		url_rpg varchar(200),
		url_bdtopo varchar(200),
		moda_calc text,
		date_calc date,
		geom geometry(MultiPolygon,2154),
		geomloc geometry(POINT,2154)
		)';
	RAISE NOTICE 'Création de la table oc7 effectuée';

	com := '
	COMMENT ON TABLE oc7 IS ''Table des parcelles agricoles'';
	COMMENT ON COLUMN oc7.id IS ''Identifiant unique non nul de type serial (clé primaire)'';
	COMMENT ON COLUMN oc7.territoire IS ''Nom du territoire d''''étude'';
	COMMENT ON COLUMN oc7.id_iris IS ''Code de l''''IRIS GE (maille de calcul élémentaire)'';
	COMMENT ON COLUMN oc7.nom_iris IS ''Nom de l''''IRIS GE (maille de calcul élémentaire)'';
	COMMENT ON COLUMN oc7.id_parc IS ''Identifiant de la parcelle'';
	COMMENT ON COLUMN oc7.code_rpg IS ''Code permettant d''''identifier le groupe de la culture déclarée sur la parcelle - nomenclature RPG'';
	COMMENT ON COLUMN oc7.lib_culture IS ''Libellé pour reconnaître le code_rpg'';
	COMMENT ON COLUMN oc7.sce_donnee IS ''Données sources utilisées (référentiels + millésimes) - source de la parcelle (BDTOPO ou RPG)'';
	COMMENT ON COLUMN oc7.url_rpg IS ''Lien de téléchargement du RPG'';
	COMMENT ON COLUMN oc7.url_bdtopo IS ''Lien de téléchargement de la BDTOPO'';
	COMMENT ON COLUMN oc7.moda_calc IS ''Nom de la fonction postgis telle que stockée dans la BDD'';
	COMMENT ON COLUMN oc7.date_calc IS ''Date de création de la variable'';
	COMMENT ON COLUMN oc7.geom IS ''Description géographique de l''''entité parcelle'';
	COMMENT ON COLUMN oc7.geomloc IS ''Centroïde de l''''entité parcelle'';
	';
	EXECUTE (com);
	RAISE NOTICE 'Commentaires ajoutés à la table oc7';

	RAISE NOTICE '====== FIN TRAITEMENT ======';
	RAISE NOTICE '[INFO] La table oc7 a été initialisée dans le schéma c_occupation_sol';
	RAISE NOTICE '';

END;
$procedure$
