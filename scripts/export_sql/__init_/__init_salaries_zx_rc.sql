SET client_encoding = 'UTF8';

CREATE OR REPLACE PROCEDURE public.__init_salaries_zx_rc()
 LANGUAGE plpgsql
AS $procedure$

-- Procédure SQL d'initialisation de la table salaries_zx_rc (représentation cartographique des salariés en zone inondable) dans le schéma p_rep_carto
-- © Cerema / GT AgiRisk (auteur du script : Sébastien)
-- Dernière mise à jour du script le 26/08/2023 par Sébastien

-- Commande d'appel à cette procédure :
-- CALL public.__init_salaries_zx_rc();

DECLARE
	com text; -- variable d'exécution des commentaires

BEGIN

	SET search_path TO p_rep_carto, public;
	
	RAISE NOTICE '';
	RAISE NOTICE '====== RAPPORT ======';
	RAISE NOTICE 'Initialisation de la table de représentation cartographique de l''indicateur salaries_zx (salariés en zone inondable)';
	
	RAISE NOTICE 'Création de la structure de table attributaire salaries_zx_rc';
	EXECUTE 'DROP TABLE IF EXISTS salaries_zx_rc CASCADE';
	EXECUTE 'CREATE TABLE salaries_zx_rc (
		id serial PRIMARY KEY,
		territoire varchar(200),
		type_alea varchar(200),
		code_occurrence varchar(200),
		type_result varchar(200),
		id_geom varchar(200),
		nom_id_geom varchar(200),
		loc_zx varchar(30),
		pop2_bas_in double precision DEFAULT 0,
		pop2_haut_in double precision DEFAULT 0,
		pop2_bas_out double precision DEFAULT 0,
		pop2_haut_out double precision DEFAULT 0,
		pct_pop2_bas_in integer GENERATED ALWAYS AS (ROUND((pop2_bas_in :: numeric / (pop2_bas_in + pop2_bas_out + 0.001) * 100)::numeric,0)) STORED, -- on rajoute + 0.001 pour éviter les divisions à 0
		pct_pop2_haut_in integer GENERATED ALWAYS AS (ROUND((pop2_haut_in :: numeric / (pop2_haut_in + pop2_haut_out + 0.001) * 100)::numeric,0)) STORED,
		pct_pop2_bas_out integer GENERATED ALWAYS AS (100 - (pop2_bas_in :: numeric / (pop2_bas_in + pop2_bas_out + 0.001) * 100)) STORED,
		pct_pop2_haut_out integer GENERATED ALWAYS AS (100 - (pop2_haut_in :: numeric / (pop2_haut_in + pop2_haut_out + 0.001) * 100)) STORED,
		total_bas double precision GENERATED ALWAYS AS (pop2_bas_in + pop2_bas_out) STORED,
		total_haut double precision GENERATED ALWAYS AS (pop2_haut_in + pop2_haut_out) STORED,
		valid_result integer,
		date_calc date,
		geom geometry(MultiPolygon,2154)
	)';
	RAISE NOTICE 'Création de la table salaries_zx_rc effectuée';
	
	com := '
	COMMENT ON TABLE salaries_zx_rc IS ''Représentation cartographique des occupants en zone inondable (Zx)'';
	COMMENT ON COLUMN salaries_zx_rc.id IS ''Identifiant unique non nul de type serial (clé primaire)'';
	COMMENT ON COLUMN salaries_zx_rc.territoire IS ''Nom du territoire d''''étude'';
	COMMENT ON COLUMN salaries_zx_rc.type_alea IS ''Type d''''aléa considéré (ex : débordement de cours d''''eau, submersion marine, ruissellement)'';
	COMMENT ON COLUMN salaries_zx_rc.code_occurrence IS ''Code de la période de retour (ex : QRef, Q100, Q10, Xynthia_2100, Q_freq, Q_moy, Q_extr, Qref_plus50)'';
	COMMENT ON COLUMN salaries_zx_rc.type_result IS ''Type d''''affichage carto : hexagones selon nb hectare, limites administratives, etc.'';
	COMMENT ON COLUMN salaries_zx_rc.id_geom IS ''Code de la géométrie de la représentation cartographique'';
	COMMENT ON COLUMN salaries_zx_rc.nom_id_geom IS ''Nom de la géométrie (IRIS, Commune, EPCI) de la représentation cartographique'';
	COMMENT ON COLUMN salaries_zx_rc.loc_zx IS ''Pour le niveau d''''agrégation ''''Bâtiments IRIS'''', indique si l''''entité intersecte ("In") ou non ("Out") la zone inondable (Zx), "indéterminé" pour les niveaux d''''agrégation ''''Hexag_*ha'''' et entités administratives'';
	COMMENT ON COLUMN salaries_zx_rc.pop2_bas_in IS ''Nombre de salariés, seuil bas, en ZI dans la géométrie'';
	COMMENT ON COLUMN salaries_zx_rc.pop2_haut_in IS ''Nombre de salariés, seuil haut, en ZI dans la géométrie'';
	COMMENT ON COLUMN salaries_zx_rc.pop2_bas_out IS ''Nombre de salariés, seuil bas, hors ZI dans la géométrie'';
	COMMENT ON COLUMN salaries_zx_rc.pop2_haut_out IS ''Nombre de salariés, seuil haut, hors ZI dans la géométrie'';
	COMMENT ON COLUMN salaries_zx_rc.pct_pop2_bas_in IS ''Pourcentage de salariés, seuil bas, en ZI dans la géométrie'';
	COMMENT ON COLUMN salaries_zx_rc.pct_pop2_haut_in IS ''Pourcentage de salariés, seuil haut, en ZI dans la géométrie'';
	COMMENT ON COLUMN salaries_zx_rc.pct_pop2_bas_out IS ''Pourcentage de salariés, seuil bas, hors ZI dans la géométrie'';
	COMMENT ON COLUMN salaries_zx_rc.pct_pop2_haut_out IS ''Pourcentage de salariés, seuil haut, hors ZI dans la géométrie'';
	COMMENT ON COLUMN salaries_zx_rc.total_bas IS ''Total salariés, seuil bas, en ET hors ZI dans la géométrie'';
	COMMENT ON COLUMN salaries_zx_rc.total_haut IS ''Total salariés, seuil haut, en ET hors ZI dans la géométrie'';
	COMMENT ON COLUMN pop_agee_zx_rc.valid_result IS ''Validité du résultat (1 : calcul correct sur l''''ensemble du périmètre de calcul / 0 : résultat incomplet)'';
	COMMENT ON COLUMN salaries_zx_rc.date_calc IS ''Date de création de l''''indicateur brut'';
	COMMENT ON COLUMN salaries_zx_rc.geom IS ''Description géographique de l''''entité'';
	';
	EXECUTE (com);
	RAISE NOTICE 'Commentaires ajoutés à la table salaries_zx_rc';
	
	RAISE NOTICE '====== FIN TRAITEMENT ======';
	RAISE NOTICE '[INFO] La table salaries_zx_rc a été initialisée dans le schéma p_rep_carto';
	RAISE NOTICE '';

END;
$procedure$
