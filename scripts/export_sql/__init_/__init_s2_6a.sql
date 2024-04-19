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

CREATE OR REPLACE PROCEDURE public.__init_s2_6a()
 LANGUAGE plpgsql
AS $procedure$

-- Procédure SQL d'initialisation de la table s2_6a (montant des dommages aux cultures) dans le schéma p_indicateurs
-- © Cerema / GT AgiRisk (auteure principale du script : Tiffany)
-- Dernière mise à jour du script le 26/08/2023 par Sébastien

-- Commande d'appel à cette procédure :
-- CALL public.__init_s2_6a();

DECLARE
	com text; -- variable d'exécution des commentaires

BEGIN

	SET search_path TO p_indicateurs, public;
	
	RAISE NOTICE '';
	RAISE NOTICE '====== RAPPORT ======';
	RAISE NOTICE 'Initialisation de l''indicateur S2/6a (dommages aux cultures en fonction de paramètres hydrauliques)';
	
	RAISE NOTICE 'Création de la structure de table attributaire s2_6a';
	EXECUTE 'DROP TABLE IF EXISTS s2_6a CASCADE';
	EXECUTE 'CREATE TABLE s2_6a (
		id serial PRIMARY KEY,
		territoire varchar(200),
		id_epci varchar(9),
		nom_epci varchar(200),
		id_commune varchar(5),
		nom_commune varchar(200),
		id_iris varchar(9),
		nom_iris varchar(200),
		type_alea varchar(200),
		code_occurrence varchar(200),
		code_rpg varchar(30),
		lib_culture varchar(50),
		surf_parc decimal,
		h_eau_min varchar(5),
		h_eau_max varchar(5),
		vitesse varchar(30),
		duree_sub varchar(30),
		ct_domm_prin numeric(10,2) DEFAULT 0,
		ct_domm_ete numeric(10,2) DEFAULT 0,
		ct_domm_aut numeric(10,2) DEFAULT 0,
		ct_domm_hiv numeric(10,2) DEFAULT 0,
		ct_domm_ann numeric(10,2) DEFAULT 0,
		date_actu_cout_dmg varchar(4),
		sce_donnee text,
		moda_calc text,
		date_calc date,
		geom geometry(MultiPolygon,2154),
		geomloc geometry(POINT,2154)
		)';
	RAISE NOTICE 'Création de la table s2_6a effectuée';
	
	com := '
	COMMENT ON TABLE s2_6a IS ''Couche des occupants en zone inondable (Zx)'';
	COMMENT ON COLUMN s2_6a.id IS ''Identifiant unique non nul de type serial correspondant à l''''identifiant dans oc7'';
	COMMENT ON COLUMN s2_6a.territoire IS ''Nom du territoire d''''étude'';
	COMMENT ON COLUMN s2_6a.id_epci IS ''Numéro SIREN de l''''EPCI'';
	COMMENT ON COLUMN s2_6a.nom_epci IS ''Nom de l''''EPCI'';
	COMMENT ON COLUMN s2_6a.id_commune IS ''Code INSEE de la commune'';
	COMMENT ON COLUMN s2_6a.nom_commune IS ''Nom de la commune'';
	COMMENT ON COLUMN s2_6a.id_iris IS ''Code de l''''IRIS GE (maille de calcul élémentaire)'';
	COMMENT ON COLUMN s2_6a.nom_iris IS ''Nom de l''''IRIS GE (maille de calcul élémentaire)'';
	COMMENT ON COLUMN s2_6a.type_alea IS ''Type d''''aléa considéré (ex : débordement de cours d''''eau, submersion marine, ruissellement)'';
	COMMENT ON COLUMN s2_6a.code_occurrence IS ''Code de la période de retour (ex : QRef, Q100, Q10, Xynthia_2100, Q_freq, Q_moy, Q_extr, Qref_plus50)'';
	COMMENT ON COLUMN s2_6a.code_rpg IS ''Code du groupe de culture selon le RPG'';
	COMMENT ON COLUMN s2_6a.lib_culture IS ''Libellé de la culture selon le RPG'';
	COMMENT ON COLUMN s2_6a.surf_parc IS ''Surface de la parcelle'';
	COMMENT ON COLUMN s2_6a.h_eau_min IS ''Hauteur min de la hauteur d''''eau au centroïde de la parcelle'';
	COMMENT ON COLUMN s2_6a.h_eau_max IS ''Hauteur max de la hauteur d''''eau au centroïde de la parcelle'';
	COMMENT ON COLUMN s2_6a.vitesse IS ''Vitesse au centroïde de la parcelle'';
	COMMENT ON COLUMN s2_6a.duree_sub IS ''Durée de submersion au centroïde de la parcelle'';
	COMMENT ON COLUMN s2_6a.ct_domm_prin IS ''Coût des dommages de la parcelle en € pour le printemps'';
	COMMENT ON COLUMN s2_6a.ct_domm_ete IS ''Coût des dommages de la parcelle en € pour l''''été'';
	COMMENT ON COLUMN s2_6a.ct_domm_aut IS ''Coût des dommages de la parcelle en € pour l''''automne'';
	COMMENT ON COLUMN s2_6a.ct_domm_hiv IS ''Coût des dommages de la parcelle en € pour l''''hivers'';
	COMMENT ON COLUMN s2_6a.ct_domm_ann IS ''Coût annuel des dommages de la parcelle en €'';
	COMMENT ON COLUMN s2_6a.date_actu_cout_dmg IS ''Date d''''actualisation des fonctions de dommages utilisées'';
	COMMENT ON COLUMN s2_6a.sce_donnee IS ''Données sources utilisées (référentiels + millésimes)'';
	COMMENT ON COLUMN s2_6a.moda_calc IS ''Nom de la fonction postgis telle que stockée dans la BDD'';
	COMMENT ON COLUMN s2_6a.date_calc IS ''Date de création de l''''indicateur'';
	COMMENT ON COLUMN s2_6a.geom IS ''Description géographique de l''''entité parcelle'';
	COMMENT ON COLUMN s2_6a.geomloc IS ''Centroïde de l''''entité parcelle'';
	';
	EXECUTE (com);
	RAISE NOTICE 'Commentaires ajoutés à la table s2_6a';
	
	RAISE NOTICE '====== FIN TRAITEMENT ======';
	RAISE NOTICE '[INFO] La table s2_6a a été initialisée dans le schéma p_indicateurs';
	RAISE NOTICE '';

END;
$procedure$
