CREATE OR REPLACE PROCEDURE public.__init_s2_14a_old()
 LANGUAGE plpgsql
AS $procedure$

-- Script d'initialisation de la table s2_14a dans le sch�ma p_indicateurs

DECLARE

BEGIN

    RAISE NOTICE '';
    RAISE NOTICE '====== RAPPORT ======';
    RAISE NOTICE 'Initialisation de l''indicateur S2/14a (surfaces � urbaniser inondables)';
   
    RAISE NOTICE 'Cr�ation de la structure de table attributaire s2_14a';
    DROP TABLE IF EXISTS p_indicateurs.s2_14a CASCADE;
    CREATE TABLE p_indicateurs.s2_14a (
        id serial primary key,
        territoire varchar(200),
        id_epci varchar(9),
        nom_epci varchar(200),
        id_commune varchar(5),
        nom_commune varchar(200),
        id_iris varchar(9),
        nom_iris varchar(200),
        code_occurrence varchar(200),
        type_alea varchar (50),
        surf_au_inond_iris_ha float,
        surf_au_inond_com_ha float,
        surf_au_inond_epci_ha float,
        surf_au_tot_iris_ha float,
        surf_au_tot_com_ha float,
        surf_au_tot_epci_ha float,
        pct_au_inond_au_tot_iris float,
        pct_au_inond_au_tot_com float,
        pct_au_inond_au_tot_epci float,
        date_calcul date,
        modalite_calcul varchar(50),
        geom geometry (MultiPolygon,2154)
    );
    RAISE NOTICE 'Cr�ation de la table s2_14a effectu�e';
   
    COMMENT ON TABLE p_indicateurs.s2_14a IS 'Couche des zones � urbaniser inondables';
    COMMENT ON COLUMN p_indicateurs.s2_14a.id IS 'Identifiant unique non nul de type serial';
    COMMENT ON COLUMN p_indicateurs.s2_14a.territoire IS 'Nom du territoire d''�tude';
    COMMENT ON COLUMN p_indicateurs.s2_14a.id_epci IS 'Num�ro SIREN de l''EPCI';
    COMMENT ON COLUMN p_indicateurs.s2_14a.nom_epci IS 'Nom de l''EPCI';
    COMMENT ON COLUMN p_indicateurs.s2_14a.id_commune IS 'Code INSEE de la commune';
    COMMENT ON COLUMN p_indicateurs.s2_14a.nom_commune IS 'Nom de la commune';
    COMMENT ON COLUMN p_indicateurs.s2_14a.id_iris IS 'Code de l''IRIS GE (maille de calcul �l�mentaire)';
    COMMENT ON COLUMN p_indicateurs.s2_14a.nom_iris IS 'Nom de l''IRIS GE (maille de calcul �l�mentaire)';
    COMMENT ON COLUMN p_indicateurs.s2_14a.code_occurrence IS 'Code de la p�riode de retour (ex : QRef, Q100, Q10, Xynthia_2100, Q_freq, Q_moy, Q_extr, Qref_plus50)';
    COMMENT ON COLUMN p_indicateurs.s2_14a.type_alea IS 'Type d''al�a consid�r� : d�bordement de cours d''eau, submersion marine, ruissellement';
    COMMENT ON COLUMN p_indicateurs.s2_14a.surf_au_inond_iris_ha IS 'Surface de zones � urbaniser inondables au sein de chaque p�rim�tre IRIS (en hectares)';
    COMMENT ON COLUMN p_indicateurs.s2_14a.surf_au_inond_com_ha IS 'Surface de zones � urbaniser inondables au sein de chaque commune (en hectares)';
    COMMENT ON COLUMN p_indicateurs.s2_14a.surf_au_inond_epci_ha IS 'Surface de zones � urbaniser inondables au sein de chaque EPCI (en hectares)';
    COMMENT ON COLUMN p_indicateurs.s2_14a.surf_au_tot_iris_ha IS 'Surface totale de zones � urbaniser au sein de chaque p�rim�tre IRIS (en hectares)';
    COMMENT ON COLUMN p_indicateurs.s2_14a.surf_au_tot_com_ha IS 'Surface totale de zones � urbaniser au sein de chaque commune (en hectares)';
    COMMENT ON COLUMN p_indicateurs.s2_14a.surf_au_tot_epci_ha IS 'Surface totale de zones � urbaniser au sein de chaque EPCI (en hectares)';
    COMMENT ON COLUMN p_indicateurs.s2_14a.pct_au_inond_au_tot_iris IS 'Pourcentage de zones � urbaniser inondables par rapport � l''ensemble des zones � urbaniser au sein de chaque p�rim�tre IRIS';
    COMMENT ON COLUMN p_indicateurs.s2_14a.pct_au_inond_au_tot_com IS 'Pourcentage de zones � urbaniser inondables par rapport � l''ensemble des zones � urbaniser au sein de chaque commune';
    COMMENT ON COLUMN p_indicateurs.s2_14a.pct_au_inond_au_tot_epci IS 'Pourcentage de zones � urbaniser inondables par rapport � l''ensemble des zones � urbaniser au sein de chaque EPCI';
    COMMENT ON COLUMN p_indicateurs.s2_14a.date_calcul IS 'Date de cr�ation de l''indicateur';
    COMMENT ON COLUMN p_indicateurs.s2_14a.modalite_calcul IS 'Nom de la fonction postgis telle que stock�e dans la BDD';
    COMMENT ON COLUMN p_indicateurs.s2_14a.geom IS 'Description g�ographique de l''entit� (zones � urbaniser inondables)';
    RAISE NOTICE 'Commentaires ajout�s � la table s2_14a';

    CREATE INDEX ON p_indicateurs.s2_14a USING gist(geom);
    CREATE INDEX ON p_indicateurs.s2_14a USING btree(id);
    CREATE INDEX ON p_indicateurs.s2_14a USING btree(territoire);
    CREATE INDEX ON p_indicateurs.s2_14a USING btree(id_epci);
    CREATE INDEX ON p_indicateurs.s2_14a USING btree(nom_epci);
    CREATE INDEX ON p_indicateurs.s2_14a USING btree(id_commune);
    CREATE INDEX ON p_indicateurs.s2_14a USING btree(nom_commune);
    CREATE INDEX ON p_indicateurs.s2_14a USING btree(id_iris);
    CREATE INDEX ON p_indicateurs.s2_14a USING btree(nom_iris);
    CREATE INDEX ON p_indicateurs.s2_14a USING btree(code_occurrence);
    CREATE INDEX ON p_indicateurs.s2_14a USING btree(type_alea);
    CREATE INDEX ON p_indicateurs.s2_14a USING btree(surf_au_inond_iris_ha);
    CREATE INDEX ON p_indicateurs.s2_14a USING btree(surf_au_inond_com_ha);
    CREATE INDEX ON p_indicateurs.s2_14a USING btree(surf_au_inond_epci_ha);
    CREATE INDEX ON p_indicateurs.s2_14a USING btree(surf_au_tot_iris_ha);
    CREATE INDEX ON p_indicateurs.s2_14a USING btree(surf_au_tot_com_ha);
    CREATE INDEX ON p_indicateurs.s2_14a USING btree(surf_au_tot_epci_ha);
    CREATE INDEX ON p_indicateurs.s2_14a USING btree(pct_au_inond_au_tot_iris);
    CREATE INDEX ON p_indicateurs.s2_14a USING btree(pct_au_inond_au_tot_com);
    CREATE INDEX ON p_indicateurs.s2_14a USING btree(pct_au_inond_au_tot_epci);
    CREATE INDEX ON p_indicateurs.s2_14a USING btree(date_calcul);
    CREATE INDEX ON p_indicateurs.s2_14a USING btree(modalite_calcul);
    RAISE NOTICE 'Index cr��s sur la table s2_14a';

    RAISE NOTICE '====== FIN TRAITEMENT ======';
	RAISE NOTICE '[INFO] La table s2_14a a �t� initialis�e dans le sch�ma p_indicateurs';
    RAISE NOTICE '';

END;
$procedure$
;
