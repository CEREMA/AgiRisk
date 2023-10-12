SET client_encoding = 'UTF8';

CREATE OR REPLACE PROCEDURE public.__init_oc5()
 LANGUAGE plpgsql
AS $procedure$

-- Procédure SQL d'initialisation de la table oc5 (campings) dans le schéma c_occupation_sol
-- © Cerema / GT AgiRisk (auteures principales du script : Anaïs, Gaëlle)
-- Dernière mise à jour du script le 26/08/2023 par Sébastien

-- Commande d'appel à cette procédure :
-- CALL public.__init_oc5();

DECLARE
	com text; -- variable d'exécution des commentaires

BEGIN

	SET search_path TO c_occupation_sol, public;

	RAISE NOTICE '';
	RAISE NOTICE '====== RAPPORT ======';
	RAISE NOTICE 'Initialisation de la variable Oc5 (campings)';

	RAISE NOTICE 'Création de la structure de table attributaire oc5';
   	EXECUTE 'DROP TABLE IF EXISTS oc5 CASCADE';
	EXECUTE 'CREATE TABLE oc5 (
		id serial PRIMARY KEY,
		territoire varchar(200),
		id_bdt varchar(24),
		nature varchar(50),
		nom varchar(300),
		cap_acc integer,
		contact_tel varchar(20),
		contact_mail varchar(100),
		website varchar(200),
		sce_donnee text,
		moda_calc text,
		date_calc date,
		geom geometry(MultiPolygon,2154)
	)';
	RAISE NOTICE 'Création de la table oc5 effectuée';

	com := '
	COMMENT ON TABLE oc5 IS ''Couche des campings'';
	COMMENT ON COLUMN oc5.id IS ''Identifiant unique non nul de type serial (clé primaire)'';
	COMMENT ON COLUMN oc5.territoire IS ''Nom du territoire d''''étude'';
	COMMENT ON COLUMN oc5.id_bdt IS ''Identifiant issu de la BDTOPO'';
	COMMENT ON COLUMN oc5.nature IS ''Type de structure'';
	COMMENT ON COLUMN oc5.nom IS ''Nom de la structure'';
	COMMENT ON COLUMN oc5.cap_acc IS ''Nom de l''''IRIS GE (maille de calcul élémentaire)'';
	COMMENT ON COLUMN oc5.contact_tel IS ''Numéro de téléphone de la structure'';
	COMMENT ON COLUMN oc5.contact_mail IS ''Adresse mail de la structure'';
	COMMENT ON COLUMN oc5.website IS ''Adresse du site Web de la structure'';
	COMMENT ON COLUMN oc5.sce_donnee IS ''Données sources utilisées (référentiels + millésimes)'';
	COMMENT ON COLUMN oc5.moda_calc IS ''Nom de la fonction postgis telle que stockée dans la BDD'';
	COMMENT ON COLUMN oc5.date_calc IS ''Date de création de la variable'';
	COMMENT ON COLUMN oc5.geom IS ''Description géographique de l''''entité (campings)'';
	';
	EXECUTE (com);
	RAISE NOTICE 'Commentaires ajoutés à la table oc5';

	RAISE NOTICE '====== FIN TRAITEMENT ======';
	RAISE NOTICE '[INFO] La table oc5 a été initialisée dans le schéma c_occupation_sol';
	RAISE NOTICE '';

END;
$procedure$
