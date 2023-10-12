SET client_encoding = 'UTF8';

CREATE OR REPLACE PROCEDURE public.__init_oc0()
 LANGUAGE plpgsql
AS $procedure$

-- Procédure SQL d'initialisation de la table oc0 (zones en voie d'urbanisation) dans le schéma c_occupation_sol
-- © Cerema / GT AgiRisk
-- Dernière mise à jour du script le 26/08/2023 par Sébastien

-- Commande d'appel à cette procédure :
-- CALL public.__init_oc0();

DECLARE
	com text; -- variable d'exécution des commentaires

BEGIN

	SET search_path TO c_occupation_sol, public;

	RAISE NOTICE '';
	RAISE NOTICE '====== RAPPORT ======';
	RAISE NOTICE 'Initialisation de la variable Oc0 (zones en voie d''urbanisation)';

	RAISE NOTICE 'Création de la structure de table attributaire oc0';
	EXECUTE 'DROP TABLE IF EXISTS oc0 CASCADE';
	EXECUTE 'CREATE TABLE oc0 (
		id serial PRIMARY KEY,
		territoire varchar(200),
		id_iris varchar(9),
		nom_iris varchar(200),
		type_zone_urba varchar(5),
		sce_donnee text,
		url_doc_urba varchar(254),
		moda_calc text,
		date_calc date,
		geom geometry(MultiPolygon,2154)
	)';
	RAISE NOTICE 'Création de la table oc0 effectuée';

	com := '
	COMMENT ON TABLE oc0 IS ''Couche des zones à urbaniser'';
	COMMENT ON COLUMN oc0.id IS ''Identifiant unique non nul de type serial (clé primaire)'';
	COMMENT ON COLUMN oc0.territoire IS ''Nom du territoire d''''étude'';
	COMMENT ON COLUMN oc0.id_iris IS ''Code de l''''IRIS GE (maille de calcul élémentaire)'';
	COMMENT ON COLUMN oc0.nom_iris IS ''Nom de l''''IRIS GE (maille de calcul élémentaire)'';
	COMMENT ON COLUMN oc0.type_zone_urba IS ''Type de zone réglementée dans les documents d''''urbanisme locaux'';
	COMMENT ON COLUMN oc0.sce_donnee IS ''Données sources utilisées (référentiels + millésimes)'';
	COMMENT ON COLUMN oc0.url_doc_urba IS ''Lien de téléchargement des pièces des documents d''''urbanisme'';
	COMMENT ON COLUMN oc0.moda_calc IS ''Nom de la fonction postgis telle que stockée dans la BDD'';
	COMMENT ON COLUMN oc0.date_calc IS ''Date de création de la variable'';
	COMMENT ON COLUMN oc0.geom IS ''Description géographique de l''''entité (zones à urbaniser)'';
	';
	EXECUTE (com);
	RAISE NOTICE 'Commentaires ajoutés à la table oc0';

	RAISE NOTICE '====== FIN TRAITEMENT ======';
	RAISE NOTICE '[INFO] La table oc0 a été initialisée dans le schéma c_occupation_sol';
	RAISE NOTICE '';

END;
$procedure$
