SET client_encoding = 'UTF8';

CREATE OR REPLACE PROCEDURE public.__init_s2_6a_rc()
 LANGUAGE plpgsql
AS $procedure$

-- Procédure SQL d'initialisation de la table s2_6a_rc (représentation cartographique des montants des dommages aux cultures agricoles) dans le schéma p_rep_carto
-- © Cerema / GT Agirisk
-- Dernière mise à jour du script le 25/07/2023 par Sébastien

-- Commande d'appel à cette procédure :
-- CALL public.__init_s2_6a_rc();

DECLARE
	com text; -- variable d'exécution des commentaires

BEGIN

	SET search_path TO p_rep_carto, public;

	RAISE NOTICE '';
	RAISE NOTICE '====== RAPPORT ======';
	RAISE NOTICE 'Initialisation de la table de représentation cartographique de l''indicateur S2_6a (montant des dommages agricoles en zone inondable)';

	RAISE NOTICE 'Création de la structure de table attributaire s2_6a_rc';
	EXECUTE 'DROP TABLE IF EXISTS s2_6a_rc CASCADE';
	EXECUTE 'CREATE TABLE s2_6a_rc (
		id serial PRIMARY KEY,
		territoire varchar(200),
		type_alea varchar(200),
		code_occurrence varchar(200),
		type_result varchar(200),
		id_geom varchar(200),
		nom_id_geom varchar(200),
		code_rpg varchar(5),
		surf double precision DEFAULT 0,
		cout_domm_prin float DEFAULT 0,
		cout_domm_ete float DEFAULT 0,
		cout_domm_aut float DEFAULT 0,
		cout_domm_hiv float DEFAULT 0,
		cout_domm_ann float DEFAULT 0,
		date_actu_cout_dmg varchar(4),
		valid_result integer,
		date_calc date,
		geom geometry
	)';
	RAISE NOTICE 'Création de la table s2_6a_rc effectuée';

	com := '
	COMMENT ON TABLE s2_6a_rc IS ''Représentation cartographique du montant des dommages aux cultures agricoles en zone inondable (Zx)'';
	COMMENT ON COLUMN s2_6a_rc.id IS ''Identifiant unique non nul de type serial (clé primaire)'';
	COMMENT ON COLUMN s2_6a_rc.territoire IS ''Nom du territoire d''''étude'';
	COMMENT ON COLUMN s2_6a_rc.type_alea IS ''Type d''''aléa considéré (ex : débordement de cours d''''eau, submersion marine, ruissellement)'';
	COMMENT ON COLUMN s2_6a_rc.code_occurrence IS ''Code de la période de retour (ex : QRef, Q100, Q10, Xynthia_2100, Q_freq, Q_moy, Q_extr, Qref_plus50)'';
	COMMENT ON COLUMN s2_6a_rc.type_result IS ''Type d''''affichage carto : parcelles agricoles, limites administratives, etc.'';
	COMMENT ON COLUMN s2_6a_rc.id_geom IS ''Code de la géométrie de la représentation cartographique'';
	COMMENT ON COLUMN s2_6a_rc.nom_id_geom IS ''Nom de la géométrie (IRIS, Commune, EPCI) de la représentation cartographique'';
	COMMENT ON COLUMN s2_6a_rc.code_rpg IS ''Code du groupe de culture de la parcelle'';
	COMMENT ON COLUMN s2_6a_rc.surf IS ''Surface en ZI'';
	COMMENT ON COLUMN s2_6a_rc.cout_domm_prin IS ''Coût des dommages agricoles au printemps'';
	COMMENT ON COLUMN s2_6a_rc.cout_domm_ete IS ''Coût des dommages agricoles en été'';
	COMMENT ON COLUMN s2_6a_rc.cout_domm_aut IS ''Coût des dommages agricoles en automne'';
	COMMENT ON COLUMN s2_6a_rc.cout_domm_hiv IS ''Coût des dommages agricoles en hiver'';
	COMMENT ON COLUMN s2_6a_rc.cout_domm_ann IS ''Coût des dommages agricoles annuel'';
	COMMENT ON COLUMN s2_6a_rc.date_actu_cout_dmg IS ''Date d''''actualisation des coûts de dommages'';
	COMMENT ON COLUMN s2_6a_rc.valid_result IS ''Validité du résultat (1 : calcul correct sur l''''ensemble du périmètre de calcul / 0 : résultat incomplet)'';
	COMMENT ON COLUMN s2_6a_rc.date_calc IS ''Date de création de l''''indicateur brut'';
	COMMENT ON COLUMN s2_6a_rc.geom IS ''Description géographique de l''''entité'';
	';
	EXECUTE (com);
	RAISE NOTICE 'Commentaires ajoutés à la table s2_6a_rc';

	RAISE NOTICE '====== FIN TRAITEMENT ======';
	RAISE NOTICE '[INFO] La table s2_6a_rc a été initialisée dans le schéma p_rep_carto';
	RAISE NOTICE '';

END;
$procedure$
