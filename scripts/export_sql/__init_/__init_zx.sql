SET client_encoding = 'UTF8';

CREATE OR REPLACE PROCEDURE public.__init_zx()
 LANGUAGE plpgsql
AS $procedure$

-- Procédure SQL d'initialisation de la table zx dans le schéma c_phenomenes
-- © Cerema / GT AgiRisk
-- Dernière mise à jour du script le 26/08/2023 par Sébastien

-- Commande d'appel à cette procédure :
-- CALL public.__init_zx();

DECLARE
	com text; -- variable d'exécution des commentaires

BEGIN

	SET search_path TO c_phenomenes, public;

	RAISE NOTICE '';
	RAISE NOTICE '====== RAPPORT ======';
	RAISE NOTICE 'Initialisation de la variable Zx (enveloppes des zones inondables)';

	RAISE NOTICE 'Création de la structure de table attributaire zx';
	EXECUTE 'DROP TABLE IF EXISTS zx CASCADE';
	EXECUTE 'CREATE TABLE zx (
		id serial PRIMARY KEY,
		territoire varchar(200),
		type_alea varchar(200),
		occurrence integer,
		code_occurrence varchar(200),
		description_alea varchar(254),
		moda_calc text,
		date_calc text,
		geom geometry(multipolygon, 2154)
	)';
	RAISE NOTICE 'Création de la table zx effectuée';

	com := '
	COMMENT ON TABLE zx IS ''Enveloppes des zones inondables'';
	COMMENT ON COLUMN zx.id IS ''Identifiant unique non nul de type serial (clé primaire)'';
	COMMENT ON COLUMN zx.territoire IS ''Nom du territoire d''''étude'';
	COMMENT ON COLUMN zx.type_alea IS ''Type d''''aléa considéré (ex : débordement de cours d''''eau, submersion marine, ruissellement)'';
	COMMENT ON COLUMN zx.occurrence IS ''Période de retour considérée (en années)'';
	COMMENT ON COLUMN zx.code_occurrence IS ''Code de la période de retour (ex : QRef, Q100, Q10, Xynthia_2100, Q_freq, Q_moy, Q_extr, Qref_plus50)'';
	COMMENT ON COLUMN zx.description_alea IS ''Description de la source de l''''aléa (ex : PPRi de ..., Etude de modélisation ...)'';
	COMMENT ON COLUMN zx.moda_calc IS ''Nom de la fonction postgis telle que stockée dans la BDD'';
	COMMENT ON COLUMN zx.date_calc IS ''Date de création de la variable'';
	COMMENT ON COLUMN zx.geom IS ''Description géographique de l''''entité (zone inondable)'';
	';
	EXECUTE (com);
	RAISE NOTICE 'Commentaires ajoutés à la table zx';

	RAISE NOTICE '====== FIN TRAITEMENT ======';
	RAISE NOTICE '[INFO] La table zx a été initialisée dans le schéma c_phenomenes';
	RAISE NOTICE '';

END;
$procedure$
