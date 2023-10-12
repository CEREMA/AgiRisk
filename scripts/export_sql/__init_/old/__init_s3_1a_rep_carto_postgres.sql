CREATE OR REPLACE PROCEDURE public.__init_s3_1a_rep_carto_postgres()
 LANGUAGE plpgsql
AS $procedure$

-- Script d'initialisation de la table s3_1a dans le schéma p_indicateurs

DECLARE

BEGIN

    RAISE NOTICE '';
    RAISE NOTICE '====== RAPPORT ======';
    RAISE NOTICE 'Initialisation de la table de représentation cartographique de l''indicateur S3/1a (population en zone inondable)';
	
	RAISE NOTICE 'Création de la structure de table attributaire s3_1a_rep_carto';
	EXECUTE 'DROP TABLE IF EXISTS p_indicateurs.s3_1a_rep_carto CASCADE';
	EXECUTE 'CREATE TABLE p_indicateurs.s3_1a_rep_carto (
		id serial primary key,
		territoire varchar(200),
		type_alea varchar (50),
		code_occurrence varchar(200),
		type_result varchar(200),
		id_geom varchar(200),
		pop_s3_1a float,
		geom geometry (MultiPolygon,2154)
		)';

	RAISE NOTICE 'Création de la table s3_1a_rep_carto effectuée';

	COMMENT ON TABLE p_indicateurs.s3_1a_rep_carto IS 'Couche des occupants en zone inondable (zx)';
	COMMENT ON COLUMN p_indicateurs.s3_1a_rep_carto.id IS 'Identifiant unique non nul de type serial';
	COMMENT ON COLUMN p_indicateurs.s3_1a_rep_carto.territoire IS 'Nom du territoire d''''étude';
	COMMENT ON COLUMN p_indicateurs.s3_1a_rep_carto.type_alea IS 'Type d''''aléa considéré : débordement de cours d''''eau, submersion marine, ruissellement';
	COMMENT ON COLUMN p_indicateurs.s3_1a_rep_carto.code_occurrence IS 'Code de la période de retour (ex : QRef, Q100, Q10, Xynthia_2100, Q_freq, Q_moy, Q_extr, Qref_plus50)';
	COMMENT ON COLUMN p_indicateurs.s3_1a_rep_carto.type_result IS 'Type d''affichage carto : hexagones selon nb hectare, limites administratives, etc.';
	COMMENT ON COLUMN p_indicateurs.s3_1a_rep_carto.id_geom IS 'Code de la géométrie de la représentation carto';
	COMMENT ON COLUMN p_indicateurs.s3_1a_rep_carto.pop_s3_1a IS 'Population en ZI dans la géométrie';
	COMMENT ON COLUMN p_indicateurs.s3_1a_rep_carto.geom IS 'Description géographique de l''''entité';

	RAISE NOTICE 'Commentaires ajoutés à la table s3_1a_rep_carto';
/*
	CREATE INDEX ON p_indicateurs.s3_1a_rep_carto USING gist(geom);
	CREATE INDEX ON p_indicateurs.s3_1a_rep_carto USING btree(id);
	CREATE INDEX ON p_indicateurs.s3_1a_rep_carto USING btree(territoire);
	CREATE INDEX ON p_indicateurs.s3_1a_rep_carto USING btree(type_alea);
	CREATE INDEX ON p_indicateurs.s3_1a_rep_carto USING btree(code_occurrence);
	CREATE INDEX ON p_indicateurs.s3_1a_rep_carto USING btree(type_result);
	CREATE INDEX ON p_indicateurs.s3_1a_rep_carto USING btree(pop_s3_1a);
	CREATE INDEX ON p_indicateurs.s3_1a_rep_carto USING btree(geom);
	
	RAISE NOTICE 'Index créés sur la table s3_1a_rep_carto';
*/
	RAISE NOTICE '====== FIN TRAITEMENT ======';
	RAISE NOTICE '[INFO] La table s3_1a_rep_carto a été initialisée dans le schéma p_indicateurs';
	RAISE NOTICE '';

END;
$procedure$
;
