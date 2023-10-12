SET client_encoding = 'UTF8';

CREATE OR REPLACE PROCEDURE public.__init_zf()
 LANGUAGE plpgsql
AS $procedure$

-- Procédure SQL d'initialisation de la table zq (zones d'aléa) dans le schéma c_phenomenes
-- © Cerema / GT AgiRisk
-- Dernière mise à jour du script le 18/07/2023 par Sébastien

-- Commande d'appel à cette procédure : CALL public.__init_zf();

DECLARE
	com text; -- variable d'exécution des commentaires

BEGIN

	SET search_path TO c_phenomenes, public;

	RAISE NOTICE '';
	RAISE NOTICE '====== RAPPORT ======';
	RAISE NOTICE 'Initialisation de la variable Zf (zones de hauteur d''eau)';

	RAISE NOTICE 'Création de la structure de table attributaire zf';
	EXECUTE 'DROP TABLE IF EXISTS zf CASCADE';
		
	EXECUTE 'CREATE TABLE IF NOT EXISTS c_phenomenes.zf
	(
		id serial PRIMARY KEY,		
		territoire character varying,
		occurrence integer,
		code_occurrence character varying,
		type_alea character varying,
		description_alea character varying,
		duree_subm character varying(4),
		geom geometry(MultiPolygon,2154)	
	)';
	RAISE NOTICE 'Création de la table zf effectuée';
	
	com := '
	COMMENT ON TABLE c_phenomenes.zf IS ''Durée de submersion'';
	COMMENT ON COLUMN c_phenomenes.zf.id IS ''Clé primaire'';
	COMMENT ON COLUMN c_phenomenes.zf.territoire IS ''Nom du territoire d''''étude'';
	COMMENT ON COLUMN c_phenomenes.zf.occurrence IS ''Période de retour considérée (en années)'';
	COMMENT ON COLUMN c_phenomenes.zf.code_occurrence IS ''Code de la période de retour (ex : QRef, Q100, Q10, Xynthia_2100, Q_freq, Q_moy, Q_extr, Qref_plus50)'';
	COMMENT ON COLUMN c_phenomenes.zf.type_alea	IS ''Type d''''aléa considéré : débordement de cours d''''eau, submersion marine'';
	COMMENT ON COLUMN c_phenomenes.zf.description_alea IS ''Description de la source de l''''aléa (ex : PPRi de ..., Etude de modélisation ...)'';
	COMMENT ON COLUMN c_phenomenes.zf.duree_subm IS ''Durée de submersion (en heures)'';
	';
	EXECUTE (com);

	RAISE NOTICE 'Commentaires ajoutés à la table zf';
	
    RAISE NOTICE '====== FIN TRAITEMENT ======';
	RAISE NOTICE '[INFO] La table zf a été initialisée dans le schéma c_phenomenes';
    RAISE NOTICE '';

END;
$procedure$
