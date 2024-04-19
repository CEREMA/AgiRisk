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

CREATE OR REPLACE PROCEDURE public.__init_oc2_ref()
 LANGUAGE plpgsql
AS $procedure$

-- Procédure SQL d'initialisation de la table oc2_ref (logements FF + BDTOPO) dans le schéma c_occupation_sol
-- © Cerema / GT AgiRisk
-- Dernières mises à jour du script le 12/04/2023 par Lucie et le 26/08/2023 par Sébastien

-- Commande d'appel à cette procédure :
-- CALL public.__init_oc2_ref();

DECLARE
	com text; -- variable d'exécution des commentaires

BEGIN

	SET search_path TO c_occupation_sol, public;

	RAISE NOTICE '';
	RAISE NOTICE '====== RAPPORT ======';
	RAISE NOTICE 'Initialisation de la variable oc2_ref (logements FF + BDTOPO)';

	RAISE NOTICE 'Création de la structure de table attributaire oc2_ref';
	EXECUTE 'DROP TABLE IF EXISTS oc2_ref CASCADE';
	EXECUTE 'CREATE TABLE oc2_ref (
		id serial PRIMARY KEY,
		territoire varchar(200),
		id_bdt varchar(50),
		nb_logts_ind integer,
		nb_appts integer,
		id_logt float,
		type_logt varchar(20),
		niv_logt varchar(50),
		typo_acb varchar(50),
		surf_polygon_tot double precision,
		surf_rdc_rect_tot double precision,
		sous_sol boolean,
		surf_ssol_tot_bat double precision,
		surf_ssol_rap_logt double precision,
		sce_donnee text,
		moda_calc text,
		date_calc date,
		geom geometry(MultiPolygon,2154),
		geomloc geometry(POINT, 2154)
	)';
	RAISE NOTICE 'Création de la table oc2_ref effectuée';

	com := '
	COMMENT ON TABLE oc2_ref IS ''Couche des logements identifiés à partir des Fichiers Fonciers (FF) et de la BD TOPO®'';
	COMMENT ON COLUMN oc2_ref.id IS ''Identifiant unique non nul de type serial (clé primaire)'';
	COMMENT ON COLUMN oc2_ref.territoire IS ''Nom du territoire d''''étude'';
	COMMENT ON COLUMN oc2_ref.id_bdt IS ''Identifiant d''''origine de la couche des bâtiments issu de la BDTOPO'';
	COMMENT ON COLUMN oc2_ref.nb_logts_ind IS ''Nombre de logements individuels'';
	COMMENT ON COLUMN oc2_ref.nb_appts IS ''Nombre d''''appartements'';
	COMMENT ON COLUMN oc2_ref.id_logt IS ''Identifiant de logement issu des fichiers ACB'';
	COMMENT ON COLUMN oc2_ref.type_logt IS ''Type de logement général issu des Fichiers Fonciers ("APPARTEMENT","MAISON","AUTRE") et ce, quel que soit l''''étage'';
	COMMENT ON COLUMN oc2_ref.niv_logt IS ''Niveau du logement à l''''intérieur du bâtiment ("REZ-DE-CHAUSSÉE", "ÉTAGE" ou "NON PRÉCISÉ")'';
	COMMENT ON COLUMN oc2_ref.typo_acb IS ''Typologie des logements d''''habitation (en rez-de-chaussée) issue des fichiers ACB pour l''''application des courbes ACB : "INDIVIDUEL SANS ETAGE","INDIVIDUEL AVEC ETAGE","COLLECTIF","AUTRE"(correspond à un logement à l''''étage)'';
	COMMENT ON COLUMN oc2_ref.surf_polygon_tot IS ''Emprise au sol du bâtiment qui contient le logement FF + BDTOPO'';
	COMMENT ON COLUMN oc2_ref.surf_rdc_rect_tot IS ''Surface totale de RDC rectifiée à l''''aide de la BDTOPO (en m²). Surface issue des fichiers ACB'';
	COMMENT ON COLUMN oc2_ref.sous_sol IS ''Indique si le logement possède un sous-sol'';
	COMMENT ON COLUMN oc2_ref.surf_ssol_tot_bat IS ''Surface totale des sous-sols (en m²). Surface issue des fichiers ACB'';
	COMMENT ON COLUMN oc2_ref.surf_ssol_rap_logt IS ''Surface des sous-sols (en m²) rapportée au logement pour le COLLECTIF. Surface issue des fichiers ACB'';
	COMMENT ON COLUMN oc2_ref.sce_donnee IS ''Données sources utilisées (référentiels + millésimes)'';
	COMMENT ON COLUMN oc2_ref.moda_calc IS ''Nom de la fonction postgis telle que stockée dans la BDD'';
	COMMENT ON COLUMN oc2_ref.date_calc IS ''Date de création de la variable'';
	COMMENT ON COLUMN oc2_ref.geom IS ''Description géographique de l''''entité (bâtiments BDTOPO)'';
	COMMENT ON COLUMN oc2_ref.geomloc IS ''Centroïde du bâtiment'';
	';
	EXECUTE (com);
	RAISE NOTICE 'Commentaires ajoutés à la table oc2_ref';

	RAISE NOTICE '====== FIN TRAITEMENT ======';
	RAISE NOTICE '[INFO] La table oc2_ref a été initialisée dans le schéma c_occupation_sol';
	RAISE NOTICE '';

END;
$procedure$
