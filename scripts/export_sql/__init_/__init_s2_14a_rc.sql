SET client_encoding = 'UTF8';

CREATE OR REPLACE PROCEDURE public.__init_s2_14a_rc()
 LANGUAGE plpgsql
AS $procedure$

-- Procédure SQL d'initialisation de la table s2_14a_rc (représentation cartographique des zones AU en zone inondable) dans le schéma p_rep_carto
-- © Cerema / GT AgiRisk
-- Dernière mise à jour du script le 18/07/2023 par Sébastien

-- Commande d'appel à cette procédure :
-- CALL public.__init_s2_14a_rc();

DECLARE
	com text; -- variable d'exécution des commentaires

BEGIN

	SET search_path TO p_rep_carto, public;

	RAISE NOTICE '';
	RAISE NOTICE '====== RAPPORT ======';
	RAISE NOTICE 'Initialisation de la table de représentation cartographique de l''indicateur s2/14a (zones AU en zone inondable)';

	RAISE NOTICE 'Création de la structure de table attributaire s2_14a_rc';
	EXECUTE 'DROP TABLE IF EXISTS s2_14a_rc CASCADE';
	EXECUTE 'CREATE TABLE s2_14a_rc (
		id serial PRIMARY KEY,
		territoire varchar(200),
		type_alea varchar(200),
		code_occurrence varchar(200),
		type_result varchar(200),
		id_geom varchar(200),
		nom_id_geom varchar(200),
		loc_zx varchar(30),
		surf_au_in double precision DEFAULT 0,
		surf_au_out double precision DEFAULT 0,
		pct_surf_au_in integer GENERATED ALWAYS AS (ROUND((surf_au_in :: numeric / (surf_au_in + surf_au_out + 0.001) * 100)::numeric,0)) STORED, -- on rajoute + 0.001 pour éviter les divisions à 0
		pct_surf_au_out integer GENERATED ALWAYS AS (100 - (surf_au_in :: numeric / (surf_au_in + surf_au_out + 0.001) * 100)) STORED,
		total_surf_au double precision GENERATED ALWAYS AS (surf_au_in + surf_au_out) STORED,
		valid_result integer,
		date_calc date,
		geom geometry
	)';
	RAISE NOTICE 'Création de la table s2_14a_rc effectuée';

	com := '
	COMMENT ON TABLE s2_14a_rc IS ''Représentation cartographique des zones AU en zone inondable (Zx)'';
	COMMENT ON COLUMN s2_14a_rc.id IS ''Identifiant unique non nul de type serial (clé primaire)'';
	COMMENT ON COLUMN s2_14a_rc.territoire IS ''Nom du territoire d''''étude'';
	COMMENT ON COLUMN s2_14a_rc.type_alea IS ''Type d''''aléa considéré (ex : débordement de cours d''''eau, submersion marine, ruissellement)'';
	COMMENT ON COLUMN s2_14a_rc.code_occurrence IS ''Code de la période de retour (ex : QRef, Q100, Q10, Xynthia_2100, Q_freq, Q_moy, Q_extr, Qref_plus50)'';
	COMMENT ON COLUMN s2_14a_rc.type_result IS ''Type d''''affichage carto : hexagones selon nb hectare, limites administratives, etc.'';
	COMMENT ON COLUMN s2_14a_rc.id_geom IS ''Code de la géométrie de la représentation cartographique'';
	COMMENT ON COLUMN s2_14a_rc.nom_id_geom IS ''Nom de la géométrie (IRIS, Commune, EPCI) de la représentation cartographique'';
	COMMENT ON COLUMN s2_14a_rc.loc_zx IS ''Pour le niveau d''''agrégation ''''Bâtiments IRIS'''', indique si l''''entité intersecte ("In") ou non ("Out") la zone inondable (Zx), "indéterminé" pour les niveaux d''''agrégation ''''Hexag_*ha'''' et entités administratives'';
	COMMENT ON COLUMN s2_14a_rc.surf_au_in IS ''Surface en zone AU inondable dans la géométrie'';
	COMMENT ON COLUMN s2_14a_rc.surf_au_out IS ''Surface en zone AU non inondable dans la géométrie'';
	COMMENT ON COLUMN s2_14a_rc.pct_surf_au_in IS ''Pourcentage de zone AU en ZI dans la géométrie'';
	COMMENT ON COLUMN s2_14a_rc.pct_surf_au_out IS ''Pourcentage de zone AU hors ZI dans la géométrie'';
	COMMENT ON COLUMN s2_14a_rc.total_surf_au IS ''Total surface de zone AU en ET hors ZI dans la géométrie'';
	COMMENT ON COLUMN s2_14a_rc.valid_result IS ''Validité du résultat (1 : calcul correct sur l''''ensemble du périmètre de calcul / 0 : résultat incomplet)'';
	COMMENT ON COLUMN s2_14a_rc.date_calc IS ''Date de création de l''''indicateur brut'';
	COMMENT ON COLUMN s2_14a_rc.geom IS ''Description géographique de l''''entité'';
	';
	EXECUTE (com);
	RAISE NOTICE 'Commentaires ajoutés à la table s2_14a_rc';

	RAISE NOTICE '====== FIN TRAITEMENT ======';
	RAISE NOTICE '[INFO] La table s2_14a_rc a été initialisée dans le schéma p_rep_carto';
	RAISE NOTICE '';

END;
$procedure$
