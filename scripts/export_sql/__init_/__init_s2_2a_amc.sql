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

CREATE OR REPLACE PROCEDURE public.__init_s2_2a_amc()
 LANGUAGE plpgsql
AS $procedure$

-- Procédure SQL d'initialisation de la table s2_2a_amc (montant des dommages aux logements) dans le schéma p_indicateurs
-- © Cerema / GT AgiRisk (auteur principal du script : Sébastien)
-- Dernières mises à jour du script le 22/05/2023 par Lucie et le 26/08/2023 par Sébastien

-- Commande d'appel à cette procédure :
-- CALL public.__init_s2_2a_amc();

DECLARE
	com text; -- variable d'exécution des commentaires

BEGIN

	SET search_path TO p_indicateurs, public;
	
	RAISE NOTICE '';
	RAISE NOTICE '====== RAPPORT ======';
	RAISE NOTICE 'Initialisation de l''indicateur S2/2a (montant des dommages aux logements)';
	
	RAISE NOTICE 'Création de la structure de table attributaire s2_2a_amc';
	EXECUTE 'DROP TABLE IF EXISTS s2_2a_amc CASCADE';
	EXECUTE 'CREATE TABLE s2_2a_amc (
		id serial PRIMARY KEY,
		territoire varchar(200),
		id_epci varchar(9),
		nom_epci varchar(200),
		id_commune varchar(5),
		nom_commune varchar(200),
		id_iris varchar(9),
		nom_iris varchar(200),
		loc_zx varchar(30),
		type_alea varchar(200),
		type_alea_fct_dmg varchar(7),
		code_occurrence varchar(200),
		duree_subm varchar(4),
		h_eau_min float,
		h_eau_max float,
		intensite_alea varchar(50),
		id_bdt varchar(50),
		nb_logts_ind float DEFAULT 0,
		nb_appts float DEFAULT 0,
		id_logt integer,
		type_logt varchar(11),
		niv_logt varchar(15),
		typo_acb varchar(21),
		surf_polygon_tot float DEFAULT 0,
		surf_polygon_alea float DEFAULT 0,
		surf_rdc_rect_tot float DEFAULT 0,
		surf_rdc_rect_alea float DEFAULT 0,
		sous_sol boolean DEFAULT false,
		surf_ssol_tot_bat float DEFAULT 0,
		surf_ssol_rap_logt float DEFAULT 0,
		surf_ssol_alea float DEFAULT 0,
		cout_min_dmg_bati float DEFAULT 0,
		cout_max_dmg_bati float DEFAULT 0,
		cout_min_dmg_mob float DEFAULT 0,
		cout_max_dmg_mob float DEFAULT 0,
		cout_min_dmg_ssol float DEFAULT 0,
		cout_max_dmg_ssol float DEFAULT 0,
		cout_min_dmg_tot float DEFAULT 0,
		cout_max_dmg_tot float DEFAULT 0,
		date_actu_cout_dmg varchar(4),
		sce_donnee text,
		moda_calc text,
		date_calc date,
		geom geometry(MultiPolygon,2154),
		geomloc geometry(POINT,2154)
	)';
	RAISE NOTICE 'Création de la table s2_2a_amc effectuée';
	
	com := '
	COMMENT ON TABLE s2_2a_amc IS ''Couche des logements et montants des dommages liés à l''''inondation'';
	COMMENT ON COLUMN s2_2a_amc.id IS ''Identifiant unique non nul de type serial (clé primaire)'';
	COMMENT ON COLUMN s2_2a_amc.territoire IS ''Nom du territoire d''''étude'';
	COMMENT ON COLUMN s2_2a_amc.id_epci IS ''Numéro SIREN de l''''EPCI'';
	COMMENT ON COLUMN s2_2a_amc.nom_epci IS ''Nom de l''''EPCI'';
	COMMENT ON COLUMN s2_2a_amc.id_commune IS ''Code INSEE de la commune'';
	COMMENT ON COLUMN s2_2a_amc.nom_commune IS ''Nom de la commune'';
	COMMENT ON COLUMN s2_2a_amc.id_iris IS ''Code de l''''IRIS GE (maille de calcul élémentaire)'';
	COMMENT ON COLUMN s2_2a_amc.nom_iris IS ''Nom de l''''IRIS GE (maille de calcul élémentaire)'';
	COMMENT ON COLUMN s2_2a_amc.loc_zx IS ''Indique si le bâtiment intersecte ("In") ou non ("Out") la zone inondable (plus exactement Zh ou Zq selon disponibilité de la donnée sur l''''aléa)'';
	COMMENT ON COLUMN s2_2a_amc.type_alea IS ''Type d''''aléa considéré (ex : débordement de cours d''''eau, submersion marine, ruissellement)'';
	COMMENT ON COLUMN s2_2a_amc.type_alea_fct_dmg IS ''Correspondance du type d''''aléa considéré dans les fonctions de dommages (fluvial ou marin)'';
	COMMENT ON COLUMN s2_2a_amc.code_occurrence IS ''Code de la période de retour (ex : QRef, Q100, Q10, Xynthia_2100, Q_freq, Q_moy, Q_extr, Qref_plus50)'';
	COMMENT ON COLUMN s2_2a_amc.duree_subm IS ''Durée de submersion (<48h ou >48h)'';
	COMMENT ON COLUMN s2_2a_amc.h_eau_min IS ''Hauteur d''''eau minimum au droit du logement (en cm)'';
	COMMENT ON COLUMN s2_2a_amc.h_eau_max IS ''Hauteur d''''eau maximum au droit du logement (en cm)'';
	COMMENT ON COLUMN s2_2a_amc.intensite_alea IS ''Intensité de l''''aléa (ex : faible, moyen, fort, très fort)'';
	COMMENT ON COLUMN s2_2a_amc.id_bdt IS ''Identifiant du bâtiment issu de la BD TOPO (hérité de l''''id_bdt de la table c_occupation_sol.oc1)'';
	COMMENT ON COLUMN s2_2a_amc.nb_logts_ind IS ''Nombre total de logements individuels dans le bâtiment'';
	COMMENT ON COLUMN s2_2a_amc.nb_appts IS ''Nombre total d''''appartements dans le bâtiment'';
	COMMENT ON COLUMN s2_2a_amc.id_logt IS ''Identifiant du logement (hérité de l''''id de la table r_cerema_acb.logements_*)'';
	COMMENT ON COLUMN s2_2a_amc.type_logt IS ''Type général du logement, indépendamment de l''''étage (MAISON ou APPARTEMENT)'';
	COMMENT ON COLUMN s2_2a_amc.niv_logt IS ''Niveau du logement d''''habitation (REZ-DE-CHAUSSEE ou ETAGE)'';
	COMMENT ON COLUMN s2_2a_amc.typo_acb IS ''Typologie du logement d''''habitation (INDIVIDUEL SANS ETAGE, INDIVIDUEL AVEC ETAGE, COLLECTIF ou AUTRE)'';
	COMMENT ON COLUMN s2_2a_amc.surf_polygon_tot IS ''Surface totale du polygone représentant le bâtiment (en m²)'';
	COMMENT ON COLUMN s2_2a_amc.surf_polygon_alea IS ''Surface de polygone du bâtiment exposée à un aléa d''''intensité donnée (en m²)'';
	COMMENT ON COLUMN s2_2a_amc.surf_rdc_rect_tot IS ''Surface de rez-de-chaussée totale rectifiée à l''''aide de la BD TOPO (en m²)'';
	COMMENT ON COLUMN s2_2a_amc.surf_rdc_rect_alea IS ''Surface de rez-de-chaussée rectifiée exposée à un aléa d''''intensité donnée (en m²) après application de la proportion (surf_polygon_alea / surf_polygon_tot)'';
	COMMENT ON COLUMN s2_2a_amc.sous_sol IS ''Présence d''''un sous-sol dans le bâtiment (oui / non)'';
	COMMENT ON COLUMN s2_2a_amc.surf_ssol_tot_bat IS ''Surface de sous-sol totale pour le bâtiment et la typologie de logement considérée (en m²)'';
	COMMENT ON COLUMN s2_2a_amc.surf_ssol_rap_logt IS ''Surface de sous-sol rattachée au logement (en m²)'';
	COMMENT ON COLUMN s2_2a_amc.surf_ssol_alea IS ''Surface de sous-sol rattachée au logement exposée à un aléa d''''intensité donnée (en m²) après application de la proportion (surf_polygon_alea / surf_polygon_tot)'';
	COMMENT ON COLUMN s2_2a_amc.cout_min_dmg_bati IS ''Montant minimum des dommages à la structure (bâti)'';
	COMMENT ON COLUMN s2_2a_amc.cout_max_dmg_bati IS ''Montant maximum des dommages à la structure (bâti)'';
	COMMENT ON COLUMN s2_2a_amc.cout_min_dmg_mob IS ''Montant minimum des dommages au mobilier'';
	COMMENT ON COLUMN s2_2a_amc.cout_max_dmg_mob IS ''Montant maximum des dommages au mobilier'';
	COMMENT ON COLUMN s2_2a_amc.cout_min_dmg_ssol IS ''Montant minimum des dommages au sous-sol'';
	COMMENT ON COLUMN s2_2a_amc.cout_max_dmg_ssol IS ''Montant maximum des dommages au sous-sol'';
	COMMENT ON COLUMN s2_2a_amc.cout_min_dmg_tot IS ''Montant minimum total des dommages au logement'';
	COMMENT ON COLUMN s2_2a_amc.cout_max_dmg_tot IS ''Montant maximum total des dommages au logement'';
	COMMENT ON COLUMN s2_2a_amc.date_actu_cout_dmg IS ''Date d''''actualisation des fonctions de dommages utilisées'';
	COMMENT ON COLUMN s2_2a_amc.sce_donnee IS ''Données sources utilisées (référentiels + millésimes)'';
	COMMENT ON COLUMN s2_2a_amc.moda_calc IS ''Nom de la fonction postgis telle que stockée dans la BDD'';
	COMMENT ON COLUMN s2_2a_amc.date_calc IS ''Date de création de l''''indicateur'';
	COMMENT ON COLUMN s2_2a_amc.geom IS ''Description géographique de l''''entité (bâtiments inondables)'';
	COMMENT ON COLUMN s2_2a_amc.geomloc IS ''Centroïde du logement'';
	';
	EXECUTE (com);
	RAISE NOTICE 'Commentaires ajoutés à la table s2_2a_amc';
	
	RAISE NOTICE '====== FIN TRAITEMENT ======';
	RAISE NOTICE '[INFO] La table s2_2a_amc a été initialisée dans le schéma p_indicateurs';
	RAISE NOTICE '';

END;
$procedure$
