CREATE OR REPLACE PROCEDURE public.__init_s3_1a_rc_postgres()
 LANGUAGE plpgsql
AS $procedure$

-- Script d'initialisation de la table s3_1a_rc dans le schéma p_rep_carto

BEGIN

	SET search_path TO p_rep_carto, public;

    RAISE NOTICE '';
    RAISE NOTICE '====== RAPPORT ======';
    RAISE NOTICE 'Initialisation de la table de représentation cartographique de l''indicateur S3/1a (population en zone inondable)';
	
	RAISE NOTICE 'Création de la structure de table attributaire s3_1a_rc';
	
	EXECUTE 'DROP TABLE IF EXISTS s3_1a_rc CASCADE';
	EXECUTE 'CREATE TABLE s3_1a_rc (
		id serial primary key,
		territoire varchar(200),
		type_alea varchar (50),
		code_occurrence varchar(200),
		type_result varchar(200),
		id_geom varchar(200),
		pop6_haut_in double precision DEFAULT 0,
		pop6_bas_in double precision DEFAULT 0,
		pop6_haut_out double precision DEFAULT 0,
		pop6_bas_out double precision DEFAULT 0,
		pct_haut_in integer GENERATED ALWAYS AS (ROUND((pop6_haut_in :: numeric / (pop6_haut_in + pop6_haut_out + 0.001) * 100)::numeric,0)) STORED, -- on rajoute + 0.001 pour éviter les divisions à 0
		pct_bas_in integer GENERATED ALWAYS AS (ROUND((pop6_bas_in :: numeric / (pop6_bas_in + pop6_bas_out + 0.001) * 100)::numeric,0)) STORED,
		pct_haut_out integer GENERATED ALWAYS AS (100 - (pop6_haut_in :: numeric / (pop6_haut_in + pop6_haut_out + 0.001) * 100)) STORED,
		pct_bas_out integer GENERATED ALWAYS AS (100 - (pop6_bas_in :: numeric / (pop6_bas_in + pop6_bas_out + 0.001) * 100)) STORED,
		total_haut double precision GENERATED ALWAYS AS (pop6_haut_in + pop6_haut_out) STORED,
		total_bas double precision GENERATED ALWAYS AS (pop6_bas_in + pop6_bas_out) STORED,
		geom geometry (MultiPolygon,2154)
		)';

	RAISE NOTICE 'Création de la table s3_1a_rc effectuée';

	COMMENT ON TABLE s3_1a_rc IS 'Couche des occupants en zone inondable (zx)';
	COMMENT ON COLUMN s3_1a_rc.id IS 'Identifiant unique non nul de type serial';
	COMMENT ON COLUMN s3_1a_rc.territoire IS 'Nom du territoire d''''étude';
	COMMENT ON COLUMN s3_1a_rc.type_alea IS 'Type d''''aléa considéré : débordement de cours d''''eau, submersion marine, ruissellement';
	COMMENT ON COLUMN s3_1a_rc.code_occurrence IS 'Code de la période de retour (ex : QRef, Q100, Q10, Xynthia_2100, Q_freq, Q_moy, Q_extr, Qref_plus50)';
	COMMENT ON COLUMN s3_1a_rc.type_result IS 'Type d''affichage carto : hexagones selon nb hectare, limites administratives, etc.';
	COMMENT ON COLUMN s3_1a_rc.id_geom IS 'Code de la géométrie de la représentation carto';
	COMMENT ON COLUMN s3_1a_rc.pop6_haut_in IS 'Population (seuil haut) en ZI dans la géométrie';
	COMMENT ON COLUMN s3_1a_rc.pop6_bas_in IS 'Population (seuil bas) en ZI dans la géométrie';
	COMMENT ON COLUMN s3_1a_rc.pop6_haut_out IS 'Population (seuil haut) hors ZI dans la géométrie';
	COMMENT ON COLUMN s3_1a_rc.pop6_bas_out IS 'Population (seuil bas) hors ZI dans la géométrie';
	COMMENT ON COLUMN s3_1a_rc.pct_haut_in IS 'Pourcentage de la population (seuil haut) en ZI dans la géométrie';
	COMMENT ON COLUMN s3_1a_rc.pct_bas_in IS 'Pourcentage de la population (seuil bas) en ZI dans la géométrie';
	COMMENT ON COLUMN s3_1a_rc.pct_haut_out IS 'Pourcentage de la population (seuil haut) hors ZI dans la géométrie';
	COMMENT ON COLUMN s3_1a_rc.pct_bas_out IS 'Pourcentage de la population (seuil bas) hors ZI dans la géométrie';
	COMMENT ON COLUMN s3_1a_rc.total_haut IS 'Total population (seuil haut) en ET hors ZI dans la géométrie';
	COMMENT ON COLUMN s3_1a_rc.total_bas IS 'Total population (seuil bas) en ET hors ZI dans la géométrie';
	COMMENT ON COLUMN s3_1a_rc.geom IS 'Description géographique de l''''entité';

	RAISE NOTICE 'Commentaires ajoutés à la table s3_1a_rc';

	CREATE INDEX ON s3_1a_rc USING gist(geom);
	CREATE INDEX ON s3_1a_rc USING btree(id);
	CREATE INDEX ON s3_1a_rc USING btree(territoire);
	CREATE INDEX ON s3_1a_rc USING btree(type_alea);
	CREATE INDEX ON s3_1a_rc USING btree(code_occurrence);
	CREATE INDEX ON s3_1a_rc USING btree(type_result);
	CREATE INDEX ON s3_1a_rc USING btree(id_geom);
	
	RAISE NOTICE 'Index créés sur la table s3_1a_rc';

	RAISE NOTICE '====== FIN TRAITEMENT ======';
	RAISE NOTICE '[INFO] La table s3_1a_rc a été initialisée dans le schéma p_rep_carto';
	RAISE NOTICE '';

END;
$procedure$
;
