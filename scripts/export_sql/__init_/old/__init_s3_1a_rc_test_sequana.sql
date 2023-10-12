CREATE OR REPLACE PROCEDURE public.__init_s3_1a_rc_test_sequana()
 LANGUAGE plpgsql
AS $procedure$

-- Procédure SQL d'initialisation de la table s3_1a_rc_sequana_seine_brevon (représentation cartographique des occupants en zone inondable pour le territoire Sequana / secteurs Seine et Brevon) dans le schéma p_rep_carto
-- Copyright Cerema / GT AgiRisk
-- Auteur du script : Sébastien

-- Commande d'appel à cette procédure : CALL public.__init_s3_1a_rc_test_sequana();

DECLARE
	com text; -- variable d'exécution des commentaires
	ind text; -- variable d'exécution des index

BEGIN

	SET search_path TO p_rep_carto, public;
	
    RAISE NOTICE '';
    RAISE NOTICE '====== RAPPORT ======';
    RAISE NOTICE 'Initialisation de la table de représentation cartographique de l''indicateur S3/1a (occupants en zone inondable) pour le territoire Sequana / secteurs Seine et Brevon';
	
	RAISE NOTICE 'Création de la structure de table attributaire s3_1a_rc_sequana_seine_brevon';
	EXECUTE 'DROP TABLE IF EXISTS s3_1a_rc_sequana_seine_brevon CASCADE';
	EXECUTE 'CREATE TABLE s3_1a_rc_sequana_seine_brevon (
		id serial primary key,
		territoire varchar(200),
		type_alea varchar(50),
		code_occurrence varchar(200),
		type_result varchar(200),
		id_geom varchar(200),
		nom_id_geom varchar(200),
		loc_zx varchar(30),

		pop1_in double precision DEFAULT 0,
		pop1_out double precision DEFAULT 0,

		pop2_haut_in double precision DEFAULT 0,
		pop2_bas_in double precision DEFAULT 0,
		pop2_haut_out double precision DEFAULT 0,
		pop2_bas_out double precision DEFAULT 0,

		pop6_haut_in double precision DEFAULT 0,
		pop6_bas_in double precision DEFAULT 0,
		pop6_haut_out double precision DEFAULT 0,
		pop6_bas_out double precision DEFAULT 0,

		pct1_in integer GENERATED ALWAYS AS (ROUND((pop1_in :: numeric / (pop1_in + pop1_out + 0.001) * 100)::numeric,0)) STORED, -- on rajoute + 0.001 pour éviter les divisions à 0
		pct1_out integer GENERATED ALWAYS AS (100 - (pop1_in :: numeric / (pop1_in + pop1_out + 0.001) * 100)) STORED,
		total1 double precision GENERATED ALWAYS AS (pop1_in + pop1_out) STORED,

		pct2_haut_in integer GENERATED ALWAYS AS (ROUND((pop2_haut_in :: numeric / (pop2_haut_in + pop2_haut_out + 0.001) * 100)::numeric,0)) STORED, -- on rajoute + 0.001 pour éviter les divisions à 0
		pct2_bas_in integer GENERATED ALWAYS AS (ROUND((pop2_bas_in :: numeric / (pop2_bas_in + pop2_bas_out + 0.001) * 100)::numeric,0)) STORED,
		pct2_haut_out integer GENERATED ALWAYS AS (100 - (pop2_haut_in :: numeric / (pop2_haut_in + pop2_haut_out + 0.001) * 100)) STORED,
		pct2_bas_out integer GENERATED ALWAYS AS (100 - (pop2_bas_in :: numeric / (pop2_bas_in + pop2_bas_out + 0.001) * 100)) STORED,
		total2_haut double precision GENERATED ALWAYS AS (pop2_haut_in + pop2_haut_out) STORED,
		total2_bas double precision GENERATED ALWAYS AS (pop2_bas_in + pop2_bas_out) STORED,

		pct6_haut_in integer GENERATED ALWAYS AS (ROUND((pop6_haut_in :: numeric / (pop6_haut_in + pop6_haut_out + 0.001) * 100)::numeric,0)) STORED, -- on rajoute + 0.001 pour éviter les divisions à 0
		pct6_bas_in integer GENERATED ALWAYS AS (ROUND((pop6_bas_in :: numeric / (pop6_bas_in + pop6_bas_out + 0.001) * 100)::numeric,0)) STORED,
		pct6_haut_out integer GENERATED ALWAYS AS (100 - (pop6_haut_in :: numeric / (pop6_haut_in + pop6_haut_out + 0.001) * 100)) STORED,
		pct6_bas_out integer GENERATED ALWAYS AS (100 - (pop6_bas_in :: numeric / (pop6_bas_in + pop6_bas_out + 0.001) * 100)) STORED,
		total6_haut double precision GENERATED ALWAYS AS (pop6_haut_in + pop6_haut_out) STORED,
		total6_bas double precision GENERATED ALWAYS AS (pop6_bas_in + pop6_bas_out) STORED,

		date_calcul date,
		geom geometry (MultiPolygon,2154)
	)';
	RAISE NOTICE 'Création de la table s3_1a_rc_sequana_seine_brevon effectuée';
	
	com := '
	COMMENT ON TABLE s3_1a_rc_sequana_seine_brevon IS ''Représentation cartographique des occupants en zone inondable (Zx)'';
	COMMENT ON COLUMN s3_1a_rc_sequana_seine_brevon.id IS ''Identifiant unique non nul de type serial'';
	COMMENT ON COLUMN s3_1a_rc_sequana_seine_brevon.territoire IS ''Nom du territoire d''''étude'';
	COMMENT ON COLUMN s3_1a_rc_sequana_seine_brevon.type_alea IS ''Type d''''aléa considéré (ex : débordement de cours d''''eau, submersion marine, ruissellement)'';
	COMMENT ON COLUMN s3_1a_rc_sequana_seine_brevon.code_occurrence IS ''Code de la période de retour (ex : QRef, Q100, Q10, Xynthia_2100, Q_freq, Q_moy, Q_extr, Qref_plus50)'';
	COMMENT ON COLUMN s3_1a_rc_sequana_seine_brevon.type_result IS ''Type d''''affichage carto : hexagones selon nb hectare, limites administratives, etc.'';
	COMMENT ON COLUMN s3_1a_rc_sequana_seine_brevon.id_geom IS ''Code de la géométrie de la représentation cartographique'';
	COMMENT ON COLUMN s3_1a_rc_sequana_seine_brevon.nom_id_geom IS ''Nom de la géométrie (IRIS, Commune, EPCI) de la représentation cartographique'';
	COMMENT ON COLUMN s3_1a_rc_sequana_seine_brevon.loc_zx IS ''Pour le niveau d''''agrégation ''''Bâtiments IRIS'''', indique si l''''entité intersecte ("In") ou non ("Out") la zone inondable (Zx), "indéterminé" pour les niveaux d''''agrégation ''''Hexag_*ha'''' et entités administratives'';

	COMMENT ON COLUMN s3_1a_rc_sequana_seine_brevon.pop1_in IS ''Habitants en ZI dans la géométrie'';
	COMMENT ON COLUMN s3_1a_rc_sequana_seine_brevon.pop1_out IS ''Habitants hors ZI dans la géométrie'';

	COMMENT ON COLUMN s3_1a_rc_sequana_seine_brevon.pop2_haut_in IS ''Employés (seuil haut) en ZI dans la géométrie'';
	COMMENT ON COLUMN s3_1a_rc_sequana_seine_brevon.pop2_bas_in IS ''Employés (seuil bas) en ZI dans la géométrie'';
	COMMENT ON COLUMN s3_1a_rc_sequana_seine_brevon.pop2_haut_out IS ''Employés (seuil haut) hors ZI dans la géométrie'';
	COMMENT ON COLUMN s3_1a_rc_sequana_seine_brevon.pop2_bas_out IS ''Employés (seuil bas) hors ZI dans la géométrie'';

	COMMENT ON COLUMN s3_1a_rc_sequana_seine_brevon.pop6_haut_in IS ''Occupants (seuil haut) en ZI dans la géométrie'';
	COMMENT ON COLUMN s3_1a_rc_sequana_seine_brevon.pop6_bas_in IS ''Occupants (seuil bas) en ZI dans la géométrie'';
	COMMENT ON COLUMN s3_1a_rc_sequana_seine_brevon.pop6_haut_out IS ''Occupants (seuil haut) hors ZI dans la géométrie'';
	COMMENT ON COLUMN s3_1a_rc_sequana_seine_brevon.pop6_bas_out IS ''Occupants (seuil bas) hors ZI dans la géométrie'';

	COMMENT ON COLUMN s3_1a_rc_sequana_seine_brevon.pct1_in IS ''Pourcentage d''''habitants en ZI dans la géométrie'';
	COMMENT ON COLUMN s3_1a_rc_sequana_seine_brevon.pct1_out IS ''Pourcentage d''''habitants hors ZI dans la géométrie'';
	COMMENT ON COLUMN s3_1a_rc_sequana_seine_brevon.total1 IS ''Total habitants en ET hors ZI dans la géométrie'';

	COMMENT ON COLUMN s3_1a_rc_sequana_seine_brevon.pct2_haut_in IS ''Pourcentage d''''employés (seuil haut) en ZI dans la géométrie'';
	COMMENT ON COLUMN s3_1a_rc_sequana_seine_brevon.pct2_bas_in IS ''Pourcentage d''''employés (seuil bas) en ZI dans la géométrie'';
	COMMENT ON COLUMN s3_1a_rc_sequana_seine_brevon.pct2_haut_out IS ''Pourcentage d''''employés (seuil haut) hors ZI dans la géométrie'';
	COMMENT ON COLUMN s3_1a_rc_sequana_seine_brevon.pct2_bas_out IS ''Pourcentage d''''employés (seuil bas) hors ZI dans la géométrie'';
	COMMENT ON COLUMN s3_1a_rc_sequana_seine_brevon.total2_haut IS ''Total employés (seuil haut) en ET hors ZI dans la géométrie'';
	COMMENT ON COLUMN s3_1a_rc_sequana_seine_brevon.total2_bas IS ''Total employés (seuil bas) en ET hors ZI dans la géométrie'';

	COMMENT ON COLUMN s3_1a_rc_sequana_seine_brevon.pct6_haut_in IS ''Pourcentage de la population (seuil haut) en ZI dans la géométrie'';
	COMMENT ON COLUMN s3_1a_rc_sequana_seine_brevon.pct6_bas_in IS ''Pourcentage de la population (seuil bas) en ZI dans la géométrie'';
	COMMENT ON COLUMN s3_1a_rc_sequana_seine_brevon.pct6_haut_out IS ''Pourcentage de la population (seuil haut) hors ZI dans la géométrie'';
	COMMENT ON COLUMN s3_1a_rc_sequana_seine_brevon.pct6_bas_out IS ''Pourcentage de la population (seuil bas) hors ZI dans la géométrie'';
	COMMENT ON COLUMN s3_1a_rc_sequana_seine_brevon.total6_haut IS ''Total population (seuil haut) en ET hors ZI dans la géométrie'';
	COMMENT ON COLUMN s3_1a_rc_sequana_seine_brevon.total6_bas IS ''Total population (seuil bas) en ET hors ZI dans la géométrie'';

	COMMENT ON COLUMN s3_1a_rc_sequana_seine_brevon.date_calcul IS ''Date de création de l''''indicateur brut'';
	COMMENT ON COLUMN s3_1a_rc_sequana_seine_brevon.geom IS ''Description géographique de l''''entité'';
	';
	EXECUTE (com);
	RAISE NOTICE 'Commentaires ajoutés à la table s3_1a_rc_sequana_seine_brevon';
	
	ind := '
	CREATE INDEX ON s3_1a_rc_sequana_seine_brevon USING gist(geom);
	CREATE INDEX ON s3_1a_rc_sequana_seine_brevon USING btree(id);
	CREATE INDEX ON s3_1a_rc_sequana_seine_brevon USING btree(territoire);
	CREATE INDEX ON s3_1a_rc_sequana_seine_brevon USING btree(type_alea);
	CREATE INDEX ON s3_1a_rc_sequana_seine_brevon USING btree(code_occurrence);
	CREATE INDEX ON s3_1a_rc_sequana_seine_brevon USING btree(type_result);
	CREATE INDEX ON s3_1a_rc_sequana_seine_brevon USING btree(id_geom);
	CREATE INDEX ON s3_1a_rc_sequana_seine_brevon USING btree(nom_id_geom);
	CREATE INDEX ON s3_1a_rc_sequana_seine_brevon USING btree(loc_zx);

	CREATE INDEX ON s3_1a_rc_sequana_seine_brevon USING btree(pop1_in);
	CREATE INDEX ON s3_1a_rc_sequana_seine_brevon USING btree(pop1_in);

	CREATE INDEX ON s3_1a_rc_sequana_seine_brevon USING btree(pop2_haut_in);
	CREATE INDEX ON s3_1a_rc_sequana_seine_brevon USING btree(pop2_bas_in);
	CREATE INDEX ON s3_1a_rc_sequana_seine_brevon USING btree(pop2_haut_out);
	CREATE INDEX ON s3_1a_rc_sequana_seine_brevon USING btree(pop2_bas_out);

	CREATE INDEX ON s3_1a_rc_sequana_seine_brevon USING btree(pop6_haut_in);
	CREATE INDEX ON s3_1a_rc_sequana_seine_brevon USING btree(pop6_bas_in);
	CREATE INDEX ON s3_1a_rc_sequana_seine_brevon USING btree(pop6_haut_out);
	CREATE INDEX ON s3_1a_rc_sequana_seine_brevon USING btree(pop6_bas_out);

	CREATE INDEX ON s3_1a_rc_sequana_seine_brevon USING btree(pct1_in);
	CREATE INDEX ON s3_1a_rc_sequana_seine_brevon USING btree(pct1_out);
	CREATE INDEX ON s3_1a_rc_sequana_seine_brevon USING btree(total1);

	CREATE INDEX ON s3_1a_rc_sequana_seine_brevon USING btree(pct2_haut_in);
	CREATE INDEX ON s3_1a_rc_sequana_seine_brevon USING btree(pct2_bas_in);
	CREATE INDEX ON s3_1a_rc_sequana_seine_brevon USING btree(pct2_haut_out);
	CREATE INDEX ON s3_1a_rc_sequana_seine_brevon USING btree(pct2_bas_out);
	CREATE INDEX ON s3_1a_rc_sequana_seine_brevon USING btree(total2_haut);
	CREATE INDEX ON s3_1a_rc_sequana_seine_brevon USING btree(total2_bas);

	CREATE INDEX ON s3_1a_rc_sequana_seine_brevon USING btree(pct6_haut_in);
	CREATE INDEX ON s3_1a_rc_sequana_seine_brevon USING btree(pct6_bas_in);
	CREATE INDEX ON s3_1a_rc_sequana_seine_brevon USING btree(pct6_haut_out);
	CREATE INDEX ON s3_1a_rc_sequana_seine_brevon USING btree(pct6_bas_out);
	CREATE INDEX ON s3_1a_rc_sequana_seine_brevon USING btree(total6_haut);
	CREATE INDEX ON s3_1a_rc_sequana_seine_brevon USING btree(total6_bas);

	CREATE INDEX ON s3_1a_rc_sequana_seine_brevon USING btree(date_calcul);
	';
	EXECUTE (ind);
	RAISE NOTICE 'Index créés sur la table s3_1a_rc_sequana_seine_brevon';
	
	RAISE NOTICE '====== FIN TRAITEMENT ======';
	RAISE NOTICE '[INFO] La table s3_1a_rc_sequana_seine_brevon a été initialisée dans le schéma p_rep_carto';
	RAISE NOTICE '';

END;
$procedure$
