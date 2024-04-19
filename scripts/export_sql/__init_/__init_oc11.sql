--***************************************************************************
--        Fonction de la base de données du projet AgiRisk
--        begin                : 2022-04-06
--        copyright            : (C) 2023 by Cerema
--        email                : agirisk@cerema.fr
--***************************************************************************/

--/***************************************************************************
--*                                                                         *
--*   Ce programme est un logiciel libre, distribué selon les termes de la  *
--*   licence CeCILL v2.1 disponible à l'adresse suivante :                 *
--*   http://www.cecill.info/licences/Licence_CeCILL_V2.1-fr.html           *
--*   ou toute autre version ultérieure.                                    *
--*                                                                         *
--/***************************************************************************/

SET client_encoding = 'UTF8';

CREATE OR REPLACE PROCEDURE public.__init_oc11()
 LANGUAGE plpgsql
AS $procedure$

-- Procédure SQL d'initialisation de la table oc11 (établissements publics) dans le schéma c_occupation_sol
-- © Cerema / GT AgiRisk (auteure principale du script : Anaïs)
-- Dernière mise à jour du script le 26/08/2023 par Sébastien

-- Commande d'appel à cette procédure :
-- CALL public.__init_oc11();

DECLARE
	com text; -- variable d'exécution des commentaires

BEGIN

	SET search_path TO c_occupation_sol, public;

	RAISE NOTICE '';
	RAISE NOTICE '====== RAPPORT ======';
	RAISE NOTICE 'Initialisation de la variable Oc11 (établissements publics)';

	RAISE NOTICE 'Création de la structure de table attributaire oc11';
	EXECUTE 'DROP TABLE IF EXISTS oc11 CASCADE';
	EXECUTE 'CREATE TABLE oc11 (
		id serial PRIMARY KEY,
		territoire varchar(200),
		id_iris varchar(9),
		nom_iris varchar(200),
		id_sce varchar(100),
		type_etab varchar(200),
		cap_acc integer DEFAULT 0,
		cap_heberg integer DEFAULT 0,
		categorie varchar(10),
		libelle varchar(100),
		sce_donnee text,
		url varchar(200),
		moda_calc text,
		date_calc date,
		geom geometry(MultiPolygon,2154),
		geomloc geometry(POINT,2154)
	)';
	RAISE NOTICE 'Création de la table oc11 effectuée';

	com := '
	COMMENT ON TABLE oc11 IS ''Couche des établissements publics'';
	COMMENT ON COLUMN oc11.id IS ''Identifiant unique non nul de type serial (clé primaire)'';
	COMMENT ON COLUMN oc11.territoire IS ''Nom du territoire d''''étude'';
	COMMENT ON COLUMN oc11.id_iris IS ''Code de l''''IRIS GE (maille de calcul élémentaire)'';
	COMMENT ON COLUMN oc11.nom_iris IS ''Nom de l''''IRIS GE (maille de calcul élémentaire)'';
	COMMENT ON COLUMN oc11.id_sce IS ''Identifiant unique de la base de données source'';
	COMMENT ON COLUMN oc11.type_etab IS ''Type d''''établissement (ERP, école, hôpital, etc.)'';
	COMMENT ON COLUMN oc11.cap_acc IS ''Capacité d''''accueil de l''''établissement lorsque celle-ci est connue'';
	COMMENT ON COLUMN oc11.cap_heberg IS ''Capacité d''''hébergement de l''''établissement lorsque celle-ci est connue'';
	COMMENT ON COLUMN oc11.categorie IS ''Catégorie de l''''établissement lorsque celle-ci est connue'';
	COMMENT ON COLUMN oc11.libelle IS ''Libellé du type d''''établissement lorsque celui-ci est connu'';
	COMMENT ON COLUMN oc11.sce_donnee IS ''Source de la donnée pour chaque entité (référentiel + millésime)'';
	COMMENT ON COLUMN oc11.url IS ''Lien de téléchargement de la base de données source'';	
	COMMENT ON COLUMN oc11.moda_calc IS ''Nom de la fonction postgis telle que stockée dans la BDD'';
	COMMENT ON COLUMN oc11.date_calc IS ''Date de création de la variable'';
	COMMENT ON COLUMN oc11.geom IS ''Description géographique de l''''entité (centroïde de l''''établissement affecté d''''un tampon de 10m)'';
	COMMENT ON COLUMN oc11.geomloc IS ''Centroïde de l''''établissement'';
	';
	EXECUTE (com);
	RAISE NOTICE 'Commentaires ajoutés à la table oc11';

	RAISE NOTICE '====== FIN TRAITEMENT ======';
	RAISE NOTICE '[INFO] La table oc11 a été initialisée dans le schéma c_occupation_sol';
	RAISE NOTICE '';

END;
$procedure$
