SET client_encoding = 'UTF8';

CREATE OR REPLACE PROCEDURE public.__init_zv()
 LANGUAGE plpgsql
AS $procedure$

-- Procédure SQL d'initialisation de la table zq (zones d'aléa) dans le schéma c_phenomenes
-- © Cerema / GT AgiRisk
-- Dernière mise à jour du script le 18/07/2023 par Sébastien

-- Commande d'appel à cette procédure : CALL public.__init_zv();

DECLARE
	com text; -- variable d'exécution des commentaires

BEGIN

	SET search_path TO c_phenomenes, public;

	RAISE NOTICE '';
	RAISE NOTICE '====== RAPPORT ======';
	RAISE NOTICE 'Initialisation de la variable Zv (Vitesse)';

	RAISE NOTICE 'Création de la structure de table attributaire zv';
	EXECUTE 'DROP TABLE IF EXISTS zv CASCADE';
		
	EXECUTE 'CREATE TABLE IF NOT EXISTS c_phenomenes.zv
	(
		id serial PRIMARY KEY,		
		nompt2 character varying(4),
		vitesse_maxi double precision,
		type_alea character varying,
		modele_hydro_ref character varying,
		occurrence integer,
		territoire character varying,
		code_occurrence character varying,
		geom geometry(Point,2154)
	)';
	RAISE NOTICE 'Création de la table zv effectuée';
	
	com := '
	COMMENT ON TABLE c_phenomenes.zv IS ''Classes de vitesses d''''écoulement'';
	COMMENT ON COLUMN c_phenomenes.zv.id IS ''Clé primaire'';
	COMMENT ON COLUMN c_phenomenes.zv.nompt2 IS ''Nom du point (hérité du champ nompt2 de la table fournie par le SDEA)'';
	COMMENT ON COLUMN c_phenomenes.zv.vitesse_maxi IS ''Vitesse d''''écoulement maximum en m/s (hérité du champ c_vitesse de la table fournie par le SDEA)'';
	COMMENT ON COLUMN c_phenomenes.zv.type_alea IS ''Type d''''aléa considéré : débordement de cours d''''eau, submersion marine'';
	COMMENT ON COLUMN c_phenomenes.zv.modele_hydro_ref IS ''Modèle hydraulique utilisé (référence de l''''étude)'';
	COMMENT ON COLUMN c_phenomenes.zv.occurrence IS ''Période de retour considérée (en années)'';
	COMMENT ON COLUMN c_phenomenes.zv.territoire IS ''Nom du territoire d''''étude'';
	COMMENT ON COLUMN c_phenomenes.zv.code_occurrence IS ''Code de la période de retour (ex : QRef, Q100, Q10, Xynthia_2100, Q_freq, Q_moy, Q_extr, Qref_plus50)'';
	';
	EXECUTE (com);

	RAISE NOTICE 'Commentaires ajoutés à la table zv';
	
    RAISE NOTICE '====== FIN TRAITEMENT ======';
	RAISE NOTICE '[INFO] La table zv a été initialisée dans le schéma c_phenomenes';
    RAISE NOTICE '';

END;
$procedure$
