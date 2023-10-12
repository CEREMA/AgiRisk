CREATE OR REPLACE PROCEDURE public.__init_s2_2a()
 LANGUAGE plpgsql
AS $procedure$

-- Procédure SQL d'initialisation de la table s2_2a (montant des dommages aux logements) dans le schéma p_indicateurs
-- Copyright Cerema / GT AgiRisk
-- Auteur principal du script : Sébastien

-- Commande d'appel à cette procédure : CALL public.__init_s2_2a();

DECLARE
	com text; -- variable d'exécution des commentaires
	ind text; -- variable d'exécution des index

BEGIN

	SET search_path TO p_indicateurs, public;
	
    RAISE NOTICE '';
    RAISE NOTICE '====== RAPPORT ======';
    RAISE NOTICE 'Initialisation de l''indicateur S2/2a (montant des dommages aux logements)';
	
	RAISE NOTICE 'Création de la structure de table attributaire s2_2a';
	EXECUTE 'DROP TABLE IF EXISTS s2_2a CASCADE';
	EXECUTE 'CREATE TABLE s2_2a (
		id serial primary key,
		territoire varchar(200),
		id_epci varchar(30),
		nom_epci varchar(200),
		id_commune varchar(10),
		nom_commune varchar(200),
		id_iris varchar(30),
		nom_iris varchar(200),
		loc_zx varchar(30),
		type_alea varchar(50),
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
		date_calc date,
		moda_calc varchar(250),
		geom geometry(MultiPolygon,2154),
		geomloc geometry (POINT,2154)
	)';
	RAISE NOTICE 'Création de la table s2_2a effectuée';
	
	com := '
	COMMENT ON TABLE s2_2a IS ''Couche des logements et montants des dommages liés à l''''inondation'';
	COMMENT ON COLUMN s2_2a.id IS ''Identifiant unique non nul de type serial'';
	COMMENT ON COLUMN s2_2a.territoire IS ''Nom du territoire d''''étude'';
	COMMENT ON COLUMN s2_2a.id_epci IS ''Numéro SIREN de l''''EPCI'';
	COMMENT ON COLUMN s2_2a.nom_epci IS ''Nom de l''''EPCI'';
	COMMENT ON COLUMN s2_2a.id_commune IS ''Code INSEE de la commune'';
	COMMENT ON COLUMN s2_2a.nom_commune IS ''Nom de la commune'';
	COMMENT ON COLUMN s2_2a.id_iris IS ''Code de l''''IRIS GE (maille de calcul élémentaire)'';
	COMMENT ON COLUMN s2_2a.nom_iris IS ''Nom de l''''IRIS GE (maille de calcul élémentaire)'';
	COMMENT ON COLUMN s2_2a.loc_zx IS ''Indique si le bâtiment intersecte ("In") ou non ("Out") la zone inondable (plus exactement Zh ou Zq selon disponibilité de la donnée sur l''''aléa)'';
	COMMENT ON COLUMN s2_2a.type_alea IS ''Type d''''aléa considéré (ex : débordement de cours d''''eau, submersion marine, ruissellement)'';
	COMMENT ON COLUMN s2_2a.type_alea_fct_dmg IS ''Correspondance du type d''''aléa considéré dans les fonctions de dommages (fluvial ou marin)'';
	COMMENT ON COLUMN s2_2a.code_occurrence IS ''Code de la période de retour (ex : QRef, Q100, Q10, Xynthia_2100, Q_freq, Q_moy, Q_extr, Qref_plus50)'';
	COMMENT ON COLUMN s2_2a.duree_subm IS ''Durée de submersion (<48h ou >48h)'';
	COMMENT ON COLUMN s2_2a.h_eau_min IS ''Hauteur d''''eau minimum au droit du logement (en cm)'';
	COMMENT ON COLUMN s2_2a.h_eau_max IS ''Hauteur d''''eau maximum au droit du logement (en cm)'';
	COMMENT ON COLUMN s2_2a.intensite_alea IS ''Intensité de l''''aléa (ex : faible, moyen, fort, très fort)'';
	COMMENT ON COLUMN s2_2a.id_bdt IS ''Identifiant du bâtiment issu de la BD TOPO (hérité de l''''id_bdt de la table c_occupation_sol.oc1)'';
	COMMENT ON COLUMN s2_2a.nb_logts_ind IS ''Nombre total de logements individuels dans le bâtiment'';
	COMMENT ON COLUMN s2_2a.nb_appts IS ''Nombre total d''''appartements dans le bâtiment'';
	COMMENT ON COLUMN s2_2a.id_logt IS ''Identifiant du logement (hérité de l''''id de la table r_cerema_acb.logements_*)'';
	COMMENT ON COLUMN s2_2a.type_logt IS ''Type général du logement, indépendamment de l''''étage (MAISON ou APPARTEMENT)'';
	COMMENT ON COLUMN s2_2a.niv_logt IS ''Niveau du logement d''''habitation (REZ-DE-CHAUSSEE ou ETAGE)'';
	COMMENT ON COLUMN s2_2a.typo_acb IS ''Typologie du logement d''''habitation (INDIVIDUEL SANS ETAGE, INDIVIDUEL AVEC ETAGE, COLLECTIF ou AUTRE)'';
	COMMENT ON COLUMN s2_2a.surf_polygon_tot IS ''Surface totale du polygone représentant le bâtiment (en m²)'';
	COMMENT ON COLUMN s2_2a.surf_polygon_alea IS ''Surface de polygone du bâtiment exposée à un aléa d''''intensité donnée (en m²)'';
	COMMENT ON COLUMN s2_2a.surf_rdc_rect_tot IS ''Surface de rez-de-chaussée totale rectifiée à l''''aide de la BD TOPO (en m²)'';
	COMMENT ON COLUMN s2_2a.surf_rdc_rect_alea IS ''Surface de rez-de-chaussée rectifiée exposée à un aléa d''''intensité donnée (en m²) après application de la proportion (surf_polygon_alea / surf_polygon_tot)'';
	COMMENT ON COLUMN s2_2a.sous_sol IS ''Présence d''''un sous-sol dans le bâtiment (oui / non)'';
	COMMENT ON COLUMN s2_2a.surf_ssol_tot_bat IS ''Surface de sous-sol totale pour le bâtiment et la typologie de logement considérée (en m²)'';
	COMMENT ON COLUMN s2_2a.surf_ssol_rap_logt IS ''Surface de sous-sol rattachée au logement (en m²)'';
	COMMENT ON COLUMN s2_2a.surf_ssol_alea IS ''Surface de sous-sol rattachée au logement exposée à un aléa d''''intensité donnée (en m²) après application de la proportion (surf_polygon_alea / surf_polygon_tot)'';
	COMMENT ON COLUMN s2_2a.cout_min_dmg_bati IS ''Montant minimum des dommages à la structure (bâti)'';
	COMMENT ON COLUMN s2_2a.cout_max_dmg_bati IS ''Montant maximum des dommages à la structure (bâti)'';
	COMMENT ON COLUMN s2_2a.cout_min_dmg_mob IS ''Montant minimum des dommages au mobilier'';
	COMMENT ON COLUMN s2_2a.cout_max_dmg_mob IS ''Montant maximum des dommages au mobilier'';
	COMMENT ON COLUMN s2_2a.cout_min_dmg_ssol IS ''Montant minimum des dommages au sous-sol'';
	COMMENT ON COLUMN s2_2a.cout_max_dmg_ssol IS ''Montant maximum des dommages au sous-sol'';
	COMMENT ON COLUMN s2_2a.cout_min_dmg_tot IS ''Montant minimum total des dommages au logement'';
	COMMENT ON COLUMN s2_2a.cout_max_dmg_tot IS ''Montant maximum total des dommages au logement'';
	COMMENT ON COLUMN s2_2a.date_actu_cout_dmg IS ''Date d''''actualisation des fonctions de dommages'';
	COMMENT ON COLUMN s2_2a.date_calc IS ''Date de création de l''''indicateur'';
	COMMENT ON COLUMN s2_2a.moda_calc IS ''Nom de la fonction postgis telle que stockée dans la BDD'';
	COMMENT ON COLUMN s2_2a.geom IS ''Description géographique de l''''entité (bâtiments inondables)'';
	COMMENT ON COLUMN s2_2a.geomloc IS ''Centroïde du logement'';
	';
	EXECUTE (com);
	RAISE NOTICE 'Commentaires ajoutés à la table s2_2a';
	
	ind := '
	CREATE INDEX ON s2_2a USING gist(geom);
	CREATE INDEX ON s2_2a USING gist(geomloc);
	CREATE INDEX ON s2_2a USING btree(id);
	CREATE INDEX ON s2_2a USING btree(territoire);
	CREATE INDEX ON s2_2a USING btree(id_epci);
	CREATE INDEX ON s2_2a USING btree(nom_epci);
	CREATE INDEX ON s2_2a USING btree(id_commune);
	CREATE INDEX ON s2_2a USING btree(nom_commune);
	CREATE INDEX ON s2_2a USING btree(id_iris);
	CREATE INDEX ON s2_2a USING btree(nom_iris);
	CREATE INDEX ON s2_2a USING btree(loc_zx);
	CREATE INDEX ON s2_2a USING btree(type_alea);
	CREATE INDEX ON s2_2a USING btree(type_alea_fct_dmg);
	CREATE INDEX ON s2_2a USING btree(code_occurrence);
	CREATE INDEX ON s2_2a USING btree(duree_subm);
	CREATE INDEX ON s2_2a USING btree(h_eau_min);
	CREATE INDEX ON s2_2a USING btree(h_eau_max);
	CREATE INDEX ON s2_2a USING btree(intensite_alea);
	CREATE INDEX ON s2_2a USING btree(id_bdt);
	CREATE INDEX ON s2_2a USING btree(nb_logts_ind);
	CREATE INDEX ON s2_2a USING btree(nb_appts);
	CREATE INDEX ON s2_2a USING btree(id_logt);
	CREATE INDEX ON s2_2a USING btree(type_logt);
	CREATE INDEX ON s2_2a USING btree(niv_logt);
	CREATE INDEX ON s2_2a USING btree(typo_acb);
	CREATE INDEX ON s2_2a USING btree(surf_polygon_tot);
	CREATE INDEX ON s2_2a USING btree(surf_polygon_alea);
	CREATE INDEX ON s2_2a USING btree(surf_rdc_rect_tot);
	CREATE INDEX ON s2_2a USING btree(surf_rdc_rect_alea);
	CREATE INDEX ON s2_2a USING btree(sous_sol);
	CREATE INDEX ON s2_2a USING btree(surf_ssol_tot_bat);
	CREATE INDEX ON s2_2a USING btree(surf_ssol_rap_logt);
	CREATE INDEX ON s2_2a USING btree(surf_ssol_alea);
	CREATE INDEX ON s2_2a USING btree(cout_min_dmg_bati);
	CREATE INDEX ON s2_2a USING btree(cout_max_dmg_bati);
	CREATE INDEX ON s2_2a USING btree(cout_min_dmg_mob);
	CREATE INDEX ON s2_2a USING btree(cout_max_dmg_mob);
	CREATE INDEX ON s2_2a USING btree(cout_min_dmg_ssol);
	CREATE INDEX ON s2_2a USING btree(cout_max_dmg_ssol);
	CREATE INDEX ON s2_2a USING btree(cout_min_dmg_tot);
	CREATE INDEX ON s2_2a USING btree(cout_max_dmg_tot);
	CREATE INDEX ON s2_2a USING btree(date_actu_cout_dmg);
	CREATE INDEX ON s2_2a USING btree(date_calc);
	CREATE INDEX ON s2_2a USING btree(moda_calc);
	';
	EXECUTE (ind);
	RAISE NOTICE 'Index créés sur la table s2_2a';
	
	RAISE NOTICE '====== FIN TRAITEMENT ======';
	RAISE NOTICE '[INFO] La table s2_2a a été initialisée dans le schéma p_indicateurs';
	RAISE NOTICE '';

END;
$procedure$
