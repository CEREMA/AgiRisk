SET client_encoding = 'UTF8';

CREATE OR REPLACE PROCEDURE public.__init_s3_1a_rc()
 LANGUAGE plpgsql
AS $procedure$

-- Procédure SQL d'initialisation de la table s3_1a_rc (représentation cartographique des occupants en zone inondable) dans le schéma p_rep_carto
-- © Cerema / GT AgiRisk
-- Dernière mise à jour du script le 18/07/2023 par Sébastien

-- Commande d'appel à cette procédure :
-- CALL public.__init_s3_1a_rc();

DECLARE
	com text; -- variable d'exécution des commentaires

BEGIN

	SET search_path TO p_rep_carto, public;

	RAISE NOTICE '';
	RAISE NOTICE '====== RAPPORT ======';
	RAISE NOTICE 'Initialisation de la table de représentation cartographique de l''indicateur S3/1a (occupants en zone inondable)';

	RAISE NOTICE 'Création de la structure de table attributaire s3_1a_rc';
	EXECUTE 'DROP TABLE IF EXISTS s3_1a_rc CASCADE';
	EXECUTE 'CREATE TABLE s3_1a_rc (
		id serial PRIMARY KEY,
		territoire varchar(200),
		type_alea varchar(200),
		code_occurrence varchar(200),
		type_result varchar(200),
		id_geom varchar(200),
		nom_id_geom varchar(200),
		loc_zx varchar(30),
		
		pop1_in double precision DEFAULT 0,
		pop1_out double precision DEFAULT 0,
		
		pop2_bas_in double precision DEFAULT 0,
		pop2_haut_in double precision DEFAULT 0,
		pop2_bas_out double precision DEFAULT 0,
		pop2_haut_out double precision DEFAULT 0,
		
		pop3_in double precision DEFAULT 0,
		pop3_out double precision DEFAULT 0,
		
		pop4_in double precision DEFAULT 0,
		pop4_out double precision DEFAULT 0,
		
		pop5_in double precision DEFAULT 0,
		pop5_out double precision DEFAULT 0,
		
		pop6_bas_in double precision DEFAULT 0,
		pop6_haut_in double precision DEFAULT 0,
		pop6_bas_out double precision DEFAULT 0,
		pop6_haut_out double precision DEFAULT 0,
		
		pct1_in integer GENERATED ALWAYS AS (ROUND((pop1_in :: numeric / (pop1_in + pop1_out + 0.001) * 100)::numeric,0)) STORED, -- on rajoute + 0.001 pour éviter les divisions à 0
		pct1_out integer GENERATED ALWAYS AS (100 - (pop1_in :: numeric / (pop1_in + pop1_out + 0.001) * 100)) STORED,
		total1 double precision GENERATED ALWAYS AS (pop1_in + pop1_out) STORED,
		
		pct2_bas_in integer GENERATED ALWAYS AS (ROUND((pop2_bas_in :: numeric / (pop2_bas_in + pop2_bas_out + 0.001) * 100)::numeric,0)) STORED,
		pct2_haut_in integer GENERATED ALWAYS AS (ROUND((pop2_haut_in :: numeric / (pop2_haut_in + pop2_haut_out + 0.001) * 100)::numeric,0)) STORED, -- on rajoute + 0.001 pour éviter les divisions à 0
		pct2_bas_out integer GENERATED ALWAYS AS (100 - (pop2_bas_in :: numeric / (pop2_bas_in + pop2_bas_out + 0.001) * 100)) STORED,
		pct2_haut_out integer GENERATED ALWAYS AS (100 - (pop2_haut_in :: numeric / (pop2_haut_in + pop2_haut_out + 0.001) * 100)) STORED,
		total2_bas double precision GENERATED ALWAYS AS (pop2_bas_in + pop2_bas_out) STORED,
		total2_haut double precision GENERATED ALWAYS AS (pop2_haut_in + pop2_haut_out) STORED,
		
		pct3_in integer GENERATED ALWAYS AS (ROUND((pop3_in :: numeric / (pop3_in + pop3_out + 0.001) * 100)::numeric,0)) STORED, -- on rajoute + 0.001 pour éviter les divisions à 0
		pct3_out integer GENERATED ALWAYS AS (100 - (pop3_in :: numeric / (pop3_in + pop3_out + 0.001) * 100)) STORED,
		total3 double precision GENERATED ALWAYS AS (pop3_in + pop3_out) STORED,
		
		pct4_in integer GENERATED ALWAYS AS (ROUND((pop4_in :: numeric / (pop4_in + pop4_out + 0.001) * 100)::numeric,0)) STORED, -- on rajoute + 0.001 pour éviter les divisions à 0
		pct4_out integer GENERATED ALWAYS AS (100 - (pop4_in :: numeric / (pop4_in + pop4_out + 0.001) * 100)) STORED,
		total4 double precision GENERATED ALWAYS AS (pop4_in + pop4_out) STORED,
		
		pct5_in integer GENERATED ALWAYS AS (ROUND((pop5_in :: numeric / (pop5_in + pop5_out + 0.001) * 100)::numeric,0)) STORED, -- on rajoute + 0.001 pour éviter les divisions à 0
		pct5_out integer GENERATED ALWAYS AS (100 - (pop5_in :: numeric / (pop5_in + pop5_out + 0.001) * 100)) STORED,
		total5 double precision GENERATED ALWAYS AS (pop5_in + pop5_out) STORED,
		
		pct6_bas_in integer GENERATED ALWAYS AS (ROUND((pop6_bas_in :: numeric / (pop6_bas_in + pop6_bas_out + 0.001) * 100)::numeric,0)) STORED,
		pct6_haut_in integer GENERATED ALWAYS AS (ROUND((pop6_haut_in :: numeric / (pop6_haut_in + pop6_haut_out + 0.001) * 100)::numeric,0)) STORED, -- on rajoute + 0.001 pour éviter les divisions à 0
		pct6_bas_out integer GENERATED ALWAYS AS (100 - (pop6_bas_in :: numeric / (pop6_bas_in + pop6_bas_out + 0.001) * 100)) STORED,
		pct6_haut_out integer GENERATED ALWAYS AS (100 - (pop6_haut_in :: numeric / (pop6_haut_in + pop6_haut_out + 0.001) * 100)) STORED,
		total6_bas double precision GENERATED ALWAYS AS (pop6_bas_in + pop6_bas_out) STORED,
		total6_haut double precision GENERATED ALWAYS AS (pop6_haut_in + pop6_haut_out) STORED,
		
		valid_result integer,
		date_calc date,
		geom geometry
	)';
	RAISE NOTICE 'Création de la table s3_1a_rc effectuée';

	com := '
	COMMENT ON TABLE s3_1a_rc IS ''Représentation cartographique des occupants en zone inondable (Zx)'';
	COMMENT ON COLUMN s3_1a_rc.id IS ''Identifiant unique non nul de type serial (clé primaire)'';
	COMMENT ON COLUMN s3_1a_rc.territoire IS ''Nom du territoire d''''étude'';
	COMMENT ON COLUMN s3_1a_rc.type_alea IS ''Type d''''aléa considéré (ex : débordement de cours d''''eau, submersion marine, ruissellement)'';
	COMMENT ON COLUMN s3_1a_rc.code_occurrence IS ''Code de la période de retour (ex : QRef, Q100, Q10, Xynthia_2100, Q_freq, Q_moy, Q_extr, Qref_plus50)'';
	COMMENT ON COLUMN s3_1a_rc.type_result IS ''Type d''''affichage carto : hexagones selon nb hectare, limites administratives, etc.'';
	COMMENT ON COLUMN s3_1a_rc.id_geom IS ''Code de la géométrie de la représentation cartographique'';
	COMMENT ON COLUMN s3_1a_rc.nom_id_geom IS ''Nom de la géométrie (IRIS, Commune, EPCI) de la représentation cartographique'';
	COMMENT ON COLUMN s3_1a_rc.loc_zx IS ''Pour le niveau d''''agrégation ''''Bâtiments IRIS'''', indique si l''''entité intersecte ("In") ou non ("Out") la zone inondable (Zx), "indéterminé" pour les niveaux d''''agrégation ''''Hexag_*ha'''' et entités administratives'';
	
	COMMENT ON COLUMN s3_1a_rc.pop1_in IS ''Habitants en ZI dans la géométrie'';
	COMMENT ON COLUMN s3_1a_rc.pop1_out IS ''Habitants hors ZI dans la géométrie'';
	
	COMMENT ON COLUMN s3_1a_rc.pop2_bas_in IS ''Employés (seuil bas) en ZI dans la géométrie'';
	COMMENT ON COLUMN s3_1a_rc.pop2_haut_in IS ''Employés (seuil haut) en ZI dans la géométrie'';
	COMMENT ON COLUMN s3_1a_rc.pop2_bas_out IS ''Employés (seuil bas) hors ZI dans la géométrie'';
	COMMENT ON COLUMN s3_1a_rc.pop2_haut_out IS ''Employés (seuil haut) hors ZI dans la géométrie'';
	
	COMMENT ON COLUMN s3_1a_rc.pop3_in IS ''Population sensible en ZI dans la géométrie'';
	COMMENT ON COLUMN s3_1a_rc.pop3_out IS ''Population sensible hors ZI dans la géométrie'';
	
	COMMENT ON COLUMN s3_1a_rc.pop4_in IS ''Concentration de personnes en ZI dans la géométrie'';
	COMMENT ON COLUMN s3_1a_rc.pop4_out IS ''Concentration de personnes hors ZI dans la géométrie'';
	
	COMMENT ON COLUMN s3_1a_rc.pop5_in IS ''Population saisonnière en ZI dans la géométrie'';
	COMMENT ON COLUMN s3_1a_rc.pop5_out IS ''Population saisonnière hors ZI dans la géométrie'';
	
	COMMENT ON COLUMN s3_1a_rc.pop6_bas_in IS ''Population (seuil bas) en ZI dans la géométrie'';
	COMMENT ON COLUMN s3_1a_rc.pop6_haut_in IS ''Population (seuil haut) en ZI dans la géométrie'';
	COMMENT ON COLUMN s3_1a_rc.pop6_bas_out IS ''Population (seuil bas) hors ZI dans la géométrie'';
	COMMENT ON COLUMN s3_1a_rc.pop6_haut_out IS ''Population (seuil haut) hors ZI dans la géométrie'';
	
	COMMENT ON COLUMN s3_1a_rc.pct1_in IS ''Pourcentage d''''habitants en ZI dans la géométrie'';
	COMMENT ON COLUMN s3_1a_rc.pct1_out IS ''Pourcentage d''''habitants hors ZI dans la géométrie'';
	COMMENT ON COLUMN s3_1a_rc.total1 IS ''Total habitants en ET hors ZI dans la géométrie'';
	
	COMMENT ON COLUMN s3_1a_rc.pct2_bas_in IS ''Pourcentage d''''employés (seuil bas) en ZI dans la géométrie'';
	COMMENT ON COLUMN s3_1a_rc.pct2_haut_in IS ''Pourcentage d''''employés (seuil haut) en ZI dans la géométrie'';
	COMMENT ON COLUMN s3_1a_rc.pct2_bas_out IS ''Pourcentage d''''employés (seuil bas) hors ZI dans la géométrie'';
	COMMENT ON COLUMN s3_1a_rc.pct2_haut_out IS ''Pourcentage d''''employés (seuil haut) hors ZI dans la géométrie'';
	COMMENT ON COLUMN s3_1a_rc.total2_bas IS ''Total employés (seuil bas) en ET hors ZI dans la géométrie'';
	COMMENT ON COLUMN s3_1a_rc.total2_haut IS ''Total employés (seuil haut) en ET hors ZI dans la géométrie'';
	
	COMMENT ON COLUMN s3_1a_rc.pct3_in IS ''Pourcentage de population sensible en ZI dans la géométrie'';
	COMMENT ON COLUMN s3_1a_rc.pct3_out IS ''Pourcentage de population sensible hors ZI dans la géométrie'';
	COMMENT ON COLUMN s3_1a_rc.total3 IS ''Total population sensible en ET hors ZI dans la géométrie'';
	
	COMMENT ON COLUMN s3_1a_rc.pct4_in IS ''Pourcentage de population rassemblée en ZI dans la géométrie'';
	COMMENT ON COLUMN s3_1a_rc.pct4_out IS ''Pourcentage de population rassemblée hors ZI dans la géométrie'';
	COMMENT ON COLUMN s3_1a_rc.total4 IS ''Total population rassemblée en ET hors ZI dans la géométrie'';
	
	COMMENT ON COLUMN s3_1a_rc.pct5_in IS ''Pourcentage de résidents saisonniers en ZI dans la géométrie'';
	COMMENT ON COLUMN s3_1a_rc.pct5_out IS ''Pourcentage de résidents saisonniers hors ZI dans la géométrie'';
	COMMENT ON COLUMN s3_1a_rc.total5 IS ''Total population saisonnière en ET hors ZI dans la géométrie'';
	
	COMMENT ON COLUMN s3_1a_rc.pct6_bas_in IS ''Pourcentage d''''occupants (seuil bas) en ZI dans la géométrie'';
	COMMENT ON COLUMN s3_1a_rc.pct6_haut_in IS ''Pourcentage d''''occupants (seuil haut) en ZI dans la géométrie'';
	COMMENT ON COLUMN s3_1a_rc.pct6_bas_out IS ''Pourcentage d''''occupants (seuil bas) hors ZI dans la géométrie'';
	COMMENT ON COLUMN s3_1a_rc.pct6_haut_out IS ''Pourcentage d''''occupants (seuil haut) hors ZI dans la géométrie'';
	COMMENT ON COLUMN s3_1a_rc.total6_bas IS ''Total occupants (seuil bas) en ET hors ZI dans la géométrie'';
	COMMENT ON COLUMN s3_1a_rc.total6_haut IS ''Total occupants (seuil haut) en ET hors ZI dans la géométrie'';
	
	COMMENT ON COLUMN s3_1a_rc.valid_result IS ''Validité du résultat (1 : calcul correct sur l''''ensemble du périmètre de calcul / 0 : résultat incomplet)'';
	COMMENT ON COLUMN s3_1a_rc.date_calc IS ''Date de création de l''''indicateur brut'';
	COMMENT ON COLUMN s3_1a_rc.geom IS ''Description géographique de l''''entité'';
	';
	EXECUTE (com);
	RAISE NOTICE 'Commentaires ajoutés à la table s3_1a_rc';

	RAISE NOTICE '====== FIN TRAITEMENT ======';
	RAISE NOTICE '[INFO] La table s3_1a_rc a été initialisée dans le schéma p_rep_carto';
	RAISE NOTICE '';

END;
$procedure$
