CREATE OR REPLACE PROCEDURE public.__init_s2_2a_rep_carto_postgres()
 LANGUAGE plpgsql
AS $procedure$

-- Script d'initialisation de la table s2_2a dans le sch�ma p_indicateurs

DECLARE

BEGIN

    RAISE NOTICE '';
    RAISE NOTICE '====== RAPPORT ======';
    RAISE NOTICE 'Initialisation de la table de repr�sentation cartographique de l''indicateur S2/2a (montant des dommages aux logements)';
	
	RAISE NOTICE 'Cr�ation de la structure de table attributaire s2_2a_rep_carto';
	EXECUTE 'DROP TABLE IF EXISTS p_indicateurs.s2_2a_rep_carto CASCADE';
	EXECUTE 'CREATE TABLE p_indicateurs.s2_2a_rep_carto (
		id serial primary key,
		territoire varchar(200),
		type_alea varchar (50),
		code_occurrence varchar(200),
		type_result varchar(200),
		id_geom varchar(200),
		typo_acb varchar(21),
		cout_dmg_s2_2a float,
		geom geometry (MultiPolygon,2154)
		)';

	RAISE NOTICE 'Cr�ation de la table s2_2a_rep_carto effectu�e';

	COMMENT ON TABLE p_indicateurs.s2_2a_rep_carto IS 'Couche des occupants en zone inondable (zx)';
	COMMENT ON COLUMN p_indicateurs.s2_2a_rep_carto.id IS 'Identifiant unique non nul de type serial';
	COMMENT ON COLUMN p_indicateurs.s2_2a_rep_carto.territoire IS 'Nom du territoire d''''�tude';
	COMMENT ON COLUMN p_indicateurs.s2_2a_rep_carto.type_alea IS 'Type d''''al�a consid�r� : d�bordement de cours d''''eau, submersion marine, ruissellement';
	COMMENT ON COLUMN p_indicateurs.s2_2a_rep_carto.code_occurrence IS 'Code de la p�riode de retour (ex : QRef, Q100, Q10, Xynthia_2100, Q_freq, Q_moy, Q_extr, Qref_plus50)';
	COMMENT ON COLUMN p_indicateurs.s2_2a_rep_carto.type_result IS 'Type d''affichage carto : hexagones selon nb hectare, limites administratives, etc.';
	COMMENT ON COLUMN p_indicateurs.s2_2a_rep_carto.id_geom IS 'Code de la g�om�trie de la repr�sentation carto';
	COMMENT ON COLUMN p_indicateurs.s2_2a_rep_carto.typo_acb IS 'Typologie de logement';
	COMMENT ON COLUMN p_indicateurs.s2_2a_rep_carto.cout_dmg_s2_2a IS 'Co�t de dommages global dans la g�om�trie';
	COMMENT ON COLUMN p_indicateurs.s2_2a_rep_carto.geom IS 'Description g�ographique de l''''entit�';

	RAISE NOTICE 'Commentaires ajout�s � la table s2_2a_rep_carto';
/*
	CREATE INDEX ON p_indicateurs.s2_2a_rep_carto USING gist(geom);
	CREATE INDEX ON p_indicateurs.s2_2a_rep_carto USING btree(id);
	CREATE INDEX ON p_indicateurs.s2_2a_rep_carto USING btree(territoire);
	CREATE INDEX ON p_indicateurs.s2_2a_rep_carto USING btree(type_alea);
	CREATE INDEX ON p_indicateurs.s2_2a_rep_carto USING btree(code_occurrence);
	CREATE INDEX ON p_indicateurs.s2_2a_rep_carto USING btree(type_result);
	CREATE INDEX ON p_indicateurs.s2_2a_rep_carto USING btree(typo_acb);
	CREATE INDEX ON p_indicateurs.s2_2a_rep_carto USING btree(cout_dmg_s2_2a);
	CREATE INDEX ON p_indicateurs.s2_2a_rep_carto USING btree(geom);
	
	RAISE NOTICE 'Index cr��s sur la table s2_2a_rep_carto';
*/
	RAISE NOTICE '====== FIN TRAITEMENT ======';
	RAISE NOTICE '[INFO] La table s2_2a_rep_carto a �t� initialis�e dans le sch�ma p_indicateurs';
	RAISE NOTICE '';

END;
$procedure$
;
