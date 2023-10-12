CREATE OR REPLACE PROCEDURE public.__init_s2_2a_rc()
 LANGUAGE plpgsql
AS $procedure$

-- Procédure SQL d'initialisation de la table s2_2a_rc (représentation cartographique des montants des dommages aux logements) dans le schéma p_rep_carto
-- © Cerema / GT AgiRisk (auteur principal du script : Sébastien)
-- Dernière mise à jour du script le 02/04/2023 par Sébastien

-- Commande d'appel à cette procédure : CALL public.__init_s2_2a_rc();

DECLARE
	com text; -- variable d'exécution des commentaires
	ind text; -- variable d'exécution des index

BEGIN

	SET search_path TO p_rep_carto, public;

    RAISE NOTICE '';
    RAISE NOTICE '====== RAPPORT ======';
    RAISE NOTICE 'Initialisation de la table de représentation cartographique de l''indicateur S2/2a (montant des dommages aux logements)';

	RAISE NOTICE 'Création de la structure de table attributaire s2_2a_rc';
	EXECUTE 'DROP TABLE IF EXISTS s2_2a_rc CASCADE';
	EXECUTE 'CREATE TABLE s2_2a_rc (
		id serial PRIMARY KEY,
		territoire varchar(200),
		type_alea varchar(200),
		code_occurrence varchar(200),
		type_result varchar(200),
		id_geom varchar(200),
		nom_id_geom varchar(200),
		loc_zx varchar(30),
		typo_acb varchar(21),
		cout_min_dmg_tot float DEFAULT 0,
		cout_max_dmg_tot float DEFAULT 0,
		date_actu_cout_dmg varchar(4),
		valid_result integer,
		date_calc date,
		geom geometry
	)';
	RAISE NOTICE 'Création de la table s2_2a_rc effectuée';

	com := '
	COMMENT ON TABLE s2_2a_rc IS ''Représentation cartographique des montants des dommages aux logements'';
	COMMENT ON COLUMN s2_2a_rc.id IS ''Identifiant unique non nul de type serial (clé primaire)'';
	COMMENT ON COLUMN s2_2a_rc.territoire IS ''Nom du territoire d''''étude'';
	COMMENT ON COLUMN s2_2a_rc.type_alea IS ''Type d''''aléa considéré (ex : débordement de cours d''''eau, submersion marine, ruissellement)'';
	COMMENT ON COLUMN s2_2a_rc.code_occurrence IS ''Code de la période de retour (ex : QRef, Q100, Q10, Xynthia_2100, Q_freq, Q_moy, Q_extr, Qref_plus50)'';
	COMMENT ON COLUMN s2_2a_rc.type_result IS ''Type d''''affichage carto : hexagones selon nb hectare, limites administratives, etc.'';
	COMMENT ON COLUMN s2_2a_rc.id_geom IS ''Code de la géométrie de la représentation cartographique'';
	COMMENT ON COLUMN s2_2a_rc.nom_id_geom IS ''Nom de la géométrie (IRIS, Commune, EPCI) de la représentation cartographique'';
	COMMENT ON COLUMN s2_2a_rc.loc_zx IS ''Pour le niveau d''''agrégation ''''Bâtiments IRIS'''', indique si l''''entité intersecte ("In") ou non ("Out") la zone inondable, "indéterminé" pour les niveaux d''''agrégation ''''Hexag_*ha'''' et entités administratives'';
	COMMENT ON COLUMN s2_2a_rc.typo_acb IS ''Typologie de logement'';
	COMMENT ON COLUMN s2_2a_rc.cout_min_dmg_tot IS ''Coût global minimum des dommages dans la géométrie'';
	COMMENT ON COLUMN s2_2a_rc.cout_max_dmg_tot IS ''Coût global maximum des dommages dans la géométrie'';
	COMMENT ON COLUMN s2_2a_rc.date_actu_cout_dmg IS ''Date d''''actualisation des coûts de dommages'';
	COMMENT ON COLUMN s2_2a_rc.valid_result IS ''Validité du résultat (1 : calcul correct sur l''''ensemble du périmètre de calcul / 0 : résultat incomplet)'';
	COMMENT ON COLUMN s2_2a_rc.date_calc IS ''Date de création de l''''indicateur brut'';
	COMMENT ON COLUMN s2_2a_rc.geom IS ''Description géographique de l''''entité'';
	';
	EXECUTE (com);
	RAISE NOTICE 'Commentaires ajoutés à la table s2_2a_rc';

	ind := '
	CREATE INDEX ON s2_2a_rc USING gist(geom);
	CREATE INDEX ON s2_2a_rc USING btree(id);
	CREATE INDEX ON s2_2a_rc USING btree(territoire);
	CREATE INDEX ON s2_2a_rc USING btree(type_alea);
	CREATE INDEX ON s2_2a_rc USING btree(code_occurrence);
	CREATE INDEX ON s2_2a_rc USING btree(type_result);
	CREATE INDEX ON s2_2a_rc USING btree(id_geom);
	CREATE INDEX ON s2_2a_rc USING btree(nom_id_geom);
	CREATE INDEX ON s2_2a_rc USING btree(loc_zx);
	CREATE INDEX ON s2_2a_rc USING btree(typo_acb);
	CREATE INDEX ON s2_2a_rc USING btree(cout_min_dmg_tot);
	CREATE INDEX ON s2_2a_rc USING btree(cout_max_dmg_tot);
	CREATE INDEX ON s2_2a_rc USING btree(date_actu_cout_dmg);
	CREATE INDEX ON s2_2a_rc USING btree(valid_result);
	CREATE INDEX ON s2_2a_rc USING btree(date_calc);
	';
	EXECUTE (ind);
	RAISE NOTICE 'Index créés sur la table s2_2a_rc';

	RAISE NOTICE '====== FIN TRAITEMENT ======';
	RAISE NOTICE '[INFO] La table s2_2a_rc a été initialisée dans le schéma p_rep_carto';
	RAISE NOTICE '';

END;
$procedure$
