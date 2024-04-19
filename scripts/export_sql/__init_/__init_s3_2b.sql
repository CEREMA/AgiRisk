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

CREATE OR REPLACE PROCEDURE public.__init_s3_2b()
 LANGUAGE plpgsql
AS $procedure$

-- Procédure SQL d'initialisation de la table s3_2b (capacités d'accueil ou d'hébergement du territoire situées hors zone inondable) dans le schéma p_indicateurs
-- © Cerema / GT AgiRisk
-- Dernière mise à jour du script le 26/08/2023 par Sébastien

-- Commande d'appel à cette procédure :
-- CALL public.__init_s3_2b();

DECLARE
	com text; -- variable d'exécution des commentaires

BEGIN

	SET search_path TO p_indicateurs, public;
	
	RAISE NOTICE '';
	RAISE NOTICE '====== RAPPORT ======';
	RAISE NOTICE 'Initialisation de l''indicateur S3/2b (capacités d''accueil ou d''hébergement du territoire situées hors zone inondable)';
	
	RAISE NOTICE 'Création de la structure de table attributaire s3_2b';
	EXECUTE 'DROP TABLE IF EXISTS s3_2b CASCADE';
	EXECUTE 'CREATE TABLE s3_2b (
		id serial PRIMARY KEY,
		territoire varchar(200),
		id_epci varchar(9),
		nom_epci varchar(200),
		id_commune varchar(5),
		nom_commune varchar(200),
		id_iris varchar(9),
		nom_iris varchar(200),
		id_erp varchar(200),
		nom_erp varchar(200),
		loc_zx varchar(30),
		type_alea varchar(200),
		code_occurrence varchar(200),
		cap_acc float DEFAULT 0,
		cap_heberg float DEFAULT 0,
		sce_donnee text,
		moda_calc text,
		date_calc date,
		geom geometry(MultiPolygon,2154),
		geomloc geometry(POINT,2154)
	)';
	RAISE NOTICE 'Création de la table s3_2b effectuée';
	
	com := '
	COMMENT ON TABLE s3_2b IS ''Couche des capacités d''''accueil et d''''hébergement du territoire situées hors zone inondable (hors Zx)'';
	COMMENT ON COLUMN s3_2b.id IS ''Identifiant unique non nul de type serial (clé primaire)'';
	COMMENT ON COLUMN s3_2b.territoire IS ''Nom du territoire d''''étude'';
	COMMENT ON COLUMN s3_2b.id_epci IS ''Numéro SIREN de l''''EPCI'';
	COMMENT ON COLUMN s3_2b.nom_epci IS ''Nom de l''''EPCI'';
	COMMENT ON COLUMN s3_2b.id_commune IS ''Code INSEE de la commune'';
	COMMENT ON COLUMN s3_2b.nom_commune IS ''Nom de la commune'';
	COMMENT ON COLUMN s3_2b.id_iris IS ''Code de l''''IRIS GE (maille de calcul élémentaire)'';
	COMMENT ON COLUMN s3_2b.nom_iris IS ''Nom de l''''IRIS GE (maille de calcul élémentaire)'';
	COMMENT ON COLUMN s3_2b.id_erp IS ''Identifiant de l''''ERP'';
	COMMENT ON COLUMN s3_2b.nom_erp IS ''Nom de l''''ERP'';
	COMMENT ON COLUMN s3_2b.loc_zx IS ''Indique si le bâtiment intersecte ("in") ou non ("out") la zone inondable (Zx)'';
	COMMENT ON COLUMN s3_2b.type_alea IS ''Type d''''aléa considéré (ex : débordement de cours d''''eau, submersion marine, ruissellement)'';
	COMMENT ON COLUMN s3_2b.code_occurrence IS ''Code de la période de retour (ex : QRef, Q100, Q10, Xynthia_2100, Q_freq, Q_moy, Q_extr, Qref_plus50)'';
	COMMENT ON COLUMN s3_2b.cap_acc IS ''Capacité d''''accueil dans la géométrie'';
	COMMENT ON COLUMN s3_2b.cap_heberg IS ''Capacité d''''hébergement dans la géométrie'';
	COMMENT ON COLUMN s3_2b.sce_donnee IS ''Données sources utilisées (référentiels + millésimes)'';
	COMMENT ON COLUMN s3_2b.moda_calc IS ''Nom de la fonction postgis telle que stockée dans la BDD'';
	COMMENT ON COLUMN s3_2b.date_calc IS ''Date de création de l''''indicateur'';
	COMMENT ON COLUMN s3_2b.geom IS ''Description géographique de l''''entité (établissements hors zone inondable)'';
	COMMENT ON COLUMN s3_2b.geom IS ''Centroïde des établissements hors zone inondable'';
	';
	EXECUTE (com);
	RAISE NOTICE 'Commentaires ajoutés à la table s3_2b';
	
	RAISE NOTICE '====== FIN TRAITEMENT ======';
	RAISE NOTICE '[INFO] La table s3_2b a été initialisée dans le schéma p_indicateurs';
	RAISE NOTICE '';

END;
$procedure$
