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

CREATE OR REPLACE PROCEDURE public.__init_s3_2b_rc()
 LANGUAGE plpgsql
AS $procedure$

-- Procédure SQL d'initialisation de la table s3_2b_rc (représentation cartographique des capacités d'accueil ou d'hébergement du territoire situées hors zone inondable) dans le schéma p_rep_carto
-- © Cerema / GT AgiRisk
-- Dernière mise à jour du script le 26/08/2023 par Sébastien

-- Commande d'appel à cette procédure :
-- CALL public.__init_s3_2b_rc();

DECLARE
	com text; -- variable d'exécution des commentaires

BEGIN

	SET search_path TO p_rep_carto, public;
	
	RAISE NOTICE '';
	RAISE NOTICE '====== RAPPORT ======';
	RAISE NOTICE 'Initialisation de la table de représentation cartographique de l''indicateur S3/2b (capacités d''accueil ou d''hébergement du territoire situées hors zone inondable)';
	
	RAISE NOTICE 'Création de la structure de table attributaire s3_2b_rc';
	EXECUTE 'DROP TABLE IF EXISTS s3_2b_rc CASCADE';
	EXECUTE 'CREATE TABLE s3_2b_rc (
		id serial PRIMARY KEY,
		territoire varchar(200),
		type_alea varchar(200),
		code_occurrence varchar(200),
		type_result varchar(200),
		id_geom varchar(200),
		nom_id_geom varchar(200),
		loc_zx varchar(30),
		cap_acc_in float DEFAULT 0,
		cap_heberg_in float DEFAULT 0,
		cap_acc_out float DEFAULT 0,
		cap_heberg_out float DEFAULT 0,
		valid_result integer,
		date_calc date,
		geom geometry(MultiPolygon,2154)
	)';
	RAISE NOTICE 'Création de la table s3_2b_rc effectuée';
	
	com := '
	COMMENT ON TABLE s3_2b_rc IS ''Représentation cartographique des capacités d''''accueil et d''''hébergement du territoire situées hors zone inondable (hors Zx)'';
	COMMENT ON COLUMN s3_2b_rc.id IS ''Identifiant unique non nul de type serial (clé primaire)'';
	COMMENT ON COLUMN s3_2b_rc.territoire IS ''Nom du territoire d''''étude'';
	COMMENT ON COLUMN s3_2b_rc.type_alea IS ''Type d''''aléa considéré (ex : débordement de cours d''''eau, submersion marine, ruissellement)'';
	COMMENT ON COLUMN s3_2b_rc.code_occurrence IS ''Code de la période de retour (ex : QRef, Q100, Q10, Xynthia_2100, Q_freq, Q_moy, Q_extr, Qref_plus50)'';
	COMMENT ON COLUMN s3_2b_rc.type_result IS ''Type d''''affichage carto : hexagones selon nb hectare, limites administratives, etc.'';
	COMMENT ON COLUMN s3_2b_rc.id_geom IS ''Code de la géométrie de la représentation cartographique'';
	COMMENT ON COLUMN s3_2b_rc.nom_id_geom IS ''Nom de la géométrie (IRIS, Commune, EPCI) de la représentation cartographique'';
	COMMENT ON COLUMN s3_2b_rc.loc_zx IS ''Pour le niveau d''''agrégation ''''Bâtiments IRIS'''', indique si l''''entité intersecte ("In") ou non ("Out") la zone inondable (Zx), "indéterminé" pour les niveaux d''''agrégation ''''Hexag_*ha'''' et entités administratives'';
	COMMENT ON COLUMN s3_2b_rc.cap_acc_in IS ''Capacité d''''accueil totale en ZI dans la géométrie'';
	COMMENT ON COLUMN s3_2b_rc.cap_heberg_in IS ''Capacité d''''hébergement totale en ZI dans la géométrie'';
	COMMENT ON COLUMN s3_2b_rc.cap_acc_out IS ''Capacité d''''accueil totale hors ZI dans la géométrie'';
	COMMENT ON COLUMN s3_2b_rc.cap_heberg_out IS ''Capacité d''''hébergement totale hors ZI dans la géométrie'';
	COMMENT ON COLUMN s3_2b_rc.date_calc IS ''Date de création de l''''indicateur brut'';
	COMMENT ON COLUMN s3_2b_rc.geom IS ''Description géographique de l''''entité'';
	';
	EXECUTE (com);
	RAISE NOTICE 'Commentaires ajoutés à la table s3_2b_rc';
	
	RAISE NOTICE '====== FIN TRAITEMENT ======';
	RAISE NOTICE '[INFO] La table s3_2b_rc a été initialisée dans le schéma p_rep_carto';
	RAISE NOTICE '';

END;
$procedure$
