CREATE OR REPLACE PROCEDURE public.__init_s2_14a_simpl(seuil_max integer, buf_max double precision, pas_buf double precision)
 LANGUAGE plpgsql
AS $procedure$

-- Script d'initialisation de la table s2_14a dans le schéma p_indicateurs

DECLARE

s integer; -- variable qui prend la valeur de seuil entre 0 et '||seuil_max||'
b double precision; -- variable qui prend la valeur du buffer entre 0 et '||buf_max||'
com text ; -- variable d'exécution des commentaires
ind text ; -- variable d'exécution des index

BEGIN

	-- seuil_max = valeur du seuil de zoom max (0..n avec un pas de 1)
	-- buf_max = valeur du buffer max
	-- pas_buf = valeur du pas entre chaque valeur de buffer

    RAISE NOTICE '';
    RAISE NOTICE '====== RAPPORT ======';
    RAISE NOTICE 'Initialisation de l''indicateur S2/14a (surfaces à urbaniser inondables)';
	
	EXECUTE 'DROP TABLE IF EXISTS buffer CASCADE';
	EXECUTE 'CREATE TEMP TABLE buffer AS
	SELECT
		generate_series(0,'||seuil_max||')::integer as num_seuil,
		generate_series(0,'||buf_max||','||pas_buf||')::double precision as buf';
	
	FOR s, b IN SELECT * FROM buffer
	
		LOOP
   
		RAISE NOTICE 'Création de la structure de table attributaire %', 's2_14a_' || s;
		EXECUTE 'DROP TABLE IF EXISTS p_indicateurs.s2_14a_'||s||' CASCADE';
		EXECUTE 'CREATE TABLE p_indicateurs.s2_14a_'||s||' (
			id serial primary key,
			territoire varchar(200),
			id_epci varchar(9),
			nom_epci varchar(200),
			id_commune varchar(5),
			nom_commune varchar(200),
			id_iris varchar(9),
			nom_iris varchar(200),
			num_seuil integer DEFAULT '||s||',
			buffer double precision DEFAULT '||b||',
			loc_zx varchar(10),
			code_occurrence varchar(200),
			type_alea varchar (50),
			surf_au_inond_iris_ha float DEFAULT 0,
			surf_au_inond_com_ha float DEFAULT 0,
			surf_au_inond_epci_ha float DEFAULT 0,
			surf_au_tot_iris_ha float DEFAULT 0,
			surf_au_tot_com_ha float DEFAULT 0,
			surf_au_tot_epci_ha float DEFAULT 0,
			pct_au_inond_au_tot_iris float DEFAULT 0,
			pct_au_inond_au_tot_com float DEFAULT 0,
			pct_au_inond_au_tot_epci float DEFAULT 0,
			date_calcul date,
			modalite_calcul varchar(50),
			geom geometry (MultiPolygon,2154)
			)';
		RAISE NOTICE 'Création de la table % effectuée', 's2_14a_' || s;
		
		com := '

		COMMENT ON TABLE p_indicateurs.s2_14a_'||s||' IS ''Couche des zones à urbaniser inondables'';
		COMMENT ON COLUMN p_indicateurs.s2_14a_'||s||'.id IS ''Identifiant unique non nul de type serial'';
		COMMENT ON COLUMN p_indicateurs.s2_14a_'||s||'.territoire IS ''Nom du territoire d''''étude'';
		COMMENT ON COLUMN p_indicateurs.s2_14a_'||s||'.id_epci IS ''Numéro SIREN de l''''EPCI'';
		COMMENT ON COLUMN p_indicateurs.s2_14a_'||s||'.nom_epci IS ''Nom de l''''EPCI'';
		COMMENT ON COLUMN p_indicateurs.s2_14a_'||s||'.id_commune IS ''Code INSEE de la commune'';
		COMMENT ON COLUMN p_indicateurs.s2_14a_'||s||'.nom_commune IS ''Nom de la commune'';
		COMMENT ON COLUMN p_indicateurs.s2_14a_'||s||'.id_iris IS ''Code de l''''IRIS GE (maille de calcul élémentaire)'';
		COMMENT ON COLUMN p_indicateurs.s2_14a_'||s||'.nom_iris IS ''Nom de l''''IRIS GE (maille de calcul élémentaire)'';
		COMMENT ON COLUMN p_indicateurs.s2_14a_'||s||'.num_seuil IS ''Numéro de seuil pour la simplifiction des géométries'';
		COMMENT ON COLUMN p_indicateurs.s2_14a_'||s||'.loc_zx IS ''Indique si le bout de zone Au est à l''''intérieur ou à l''''extérieur de la zone inondable zx'';
		COMMENT ON COLUMN p_indicateurs.s2_14a_'||s||'.code_occurrence IS ''Code de la période de retour (ex : QRef, Q100, Q10, Xynthia_2100, Q_freq, Q_moy, Q_extr, Qref_plus50)'';
		COMMENT ON COLUMN p_indicateurs.s2_14a_'||s||'.type_alea IS ''Type d''''aléa considéré : débordement de cours d''''eau, submersion marine, ruissellement'';
		COMMENT ON COLUMN p_indicateurs.s2_14a_'||s||'.surf_au_inond_iris_ha IS ''Surface de zones à urbaniser inondables au sein de chaque périmètre IRIS (en hectares)'';
		COMMENT ON COLUMN p_indicateurs.s2_14a_'||s||'.surf_au_inond_com_ha IS ''Surface de zones à urbaniser inondables au sein de chaque commune (en hectares)'';
		COMMENT ON COLUMN p_indicateurs.s2_14a_'||s||'.surf_au_inond_epci_ha IS ''Surface de zones à urbaniser inondables au sein de chaque EPCI (en hectares)'';
		COMMENT ON COLUMN p_indicateurs.s2_14a_'||s||'.surf_au_tot_iris_ha IS ''Surface totale de zones à urbaniser au sein de chaque périmètre IRIS (en hectares)'';
		COMMENT ON COLUMN p_indicateurs.s2_14a_'||s||'.surf_au_tot_com_ha IS ''Surface totale de zones à urbaniser au sein de chaque commune (en hectares)'';
		COMMENT ON COLUMN p_indicateurs.s2_14a_'||s||'.surf_au_tot_epci_ha IS ''Surface totale de zones à urbaniser au sein de chaque EPCI (en hectares)'';
		COMMENT ON COLUMN p_indicateurs.s2_14a_'||s||'.pct_au_inond_au_tot_iris IS ''Pourcentage de zones à urbaniser inondables par rapport à l''''ensemble des zones à urbaniser au sein de chaque périmètre IRIS'';
		COMMENT ON COLUMN p_indicateurs.s2_14a_'||s||'.pct_au_inond_au_tot_com IS ''Pourcentage de zones à urbaniser inondables par rapport à l''''ensemble des zones à urbaniser au sein de chaque commune'';
		COMMENT ON COLUMN p_indicateurs.s2_14a_'||s||'.pct_au_inond_au_tot_epci IS ''Pourcentage de zones à urbaniser inondables par rapport à l''''ensemble des zones à urbaniser au sein de chaque EPCI'';
		COMMENT ON COLUMN p_indicateurs.s2_14a_'||s||'.date_calcul IS ''Date de création de l''''indicateur'';
		COMMENT ON COLUMN p_indicateurs.s2_14a_'||s||'.modalite_calcul IS ''Nom de la fonction postgis telle que stockée dans la BDD'';
		COMMENT ON COLUMN p_indicateurs.s2_14a_'||s||'.geom IS ''Description géographique de l''''entité (zones à urbaniser inondables)'';
		';
		
		EXECUTE (com);
		
		RAISE NOTICE 'Commentaires ajoutés à la table %', 's2_14a_' || s;

		ind := '

		CREATE INDEX ON p_indicateurs.s2_14a_'||s||' USING gist(geom);
		CREATE INDEX ON p_indicateurs.s2_14a_'||s||' USING btree(id);
		CREATE INDEX ON p_indicateurs.s2_14a_'||s||' USING btree(territoire);
		CREATE INDEX ON p_indicateurs.s2_14a_'||s||' USING btree(id_epci);
		CREATE INDEX ON p_indicateurs.s2_14a_'||s||' USING btree(nom_epci);
		CREATE INDEX ON p_indicateurs.s2_14a_'||s||' USING btree(id_commune);
		CREATE INDEX ON p_indicateurs.s2_14a_'||s||' USING btree(nom_commune);
		CREATE INDEX ON p_indicateurs.s2_14a_'||s||' USING btree(id_iris);
		CREATE INDEX ON p_indicateurs.s2_14a_'||s||' USING btree(nom_iris);
		CREATE INDEX ON p_indicateurs.s2_14a_'||s||' USING btree(num_seuil);
		CREATE INDEX ON p_indicateurs.s2_14a_'||s||' USING btree(loc_zx);
		CREATE INDEX ON p_indicateurs.s2_14a_'||s||' USING btree(code_occurrence);
		CREATE INDEX ON p_indicateurs.s2_14a_'||s||' USING btree(type_alea);
		CREATE INDEX ON p_indicateurs.s2_14a_'||s||' USING btree(surf_au_inond_iris_ha);
		CREATE INDEX ON p_indicateurs.s2_14a_'||s||' USING btree(surf_au_inond_com_ha);
		CREATE INDEX ON p_indicateurs.s2_14a_'||s||' USING btree(surf_au_inond_epci_ha);
		CREATE INDEX ON p_indicateurs.s2_14a_'||s||' USING btree(surf_au_tot_iris_ha);
		CREATE INDEX ON p_indicateurs.s2_14a_'||s||' USING btree(surf_au_tot_com_ha);
		CREATE INDEX ON p_indicateurs.s2_14a_'||s||' USING btree(surf_au_tot_epci_ha);
		CREATE INDEX ON p_indicateurs.s2_14a_'||s||' USING btree(pct_au_inond_au_tot_iris);
		CREATE INDEX ON p_indicateurs.s2_14a_'||s||' USING btree(pct_au_inond_au_tot_com);
		CREATE INDEX ON p_indicateurs.s2_14a_'||s||' USING btree(pct_au_inond_au_tot_epci);
		CREATE INDEX ON p_indicateurs.s2_14a_'||s||' USING btree(date_calcul);
		CREATE INDEX ON p_indicateurs.s2_14a_'||s||' USING btree(modalite_calcul);
		';
		
		EXECUTE (ind);
		
		RAISE NOTICE 'Index créés sur la table %', 's2_14a_' || s;

		RAISE NOTICE '====== FIN TRAITEMENT ======';
		RAISE NOTICE '[INFO] La table % a été initialisée dans le schéma p_indicateurs', 's2_14a_' || s;
		RAISE NOTICE '';
		
		END LOOP;

END;
$procedure$
;