--***************************************************************************
--        Fonction de la base de données du projet AgiRisk
--        begin                : 2022-04-06
--        copyright            : (C) 2023 by Cerema
--        email                : agirisk@cerema.fr
--***************************************************************************/

--/***************************************************************************
--*                                                                         *
--*   Ce programme est un logiciel libre, distribué selon les termes de la  *
--*   licence CeCILL v2.1 disponible à l'adresse suivante :                 *
--*   http://www.cecill.info/licences/Licence_CeCILL_V2.1-fr.html           *
--*   ou toute autre version ultérieure.                                    *
--*                                                                         *
--/***************************************************************************/

SET client_encoding = 'UTF8';

CREATE OR REPLACE PROCEDURE public.__init_zh()
 LANGUAGE plpgsql
AS $procedure$

-- Procédure SQL d'initialisation de la table zq (zones d'aléa) dans le schéma c_phenomenes
-- © Cerema / GT AgiRisk
-- Dernière mise à jour du script le 18/07/2023 par Sébastien

-- Commande d'appel à cette procédure : CALL public.__init_zh();

DECLARE
	com text; -- variable d'exécution des commentaires

BEGIN

	SET search_path TO c_phenomenes, public;

	RAISE NOTICE '';
	RAISE NOTICE '====== RAPPORT ======';
	RAISE NOTICE 'Initialisation de la variable Zh (zones de hauteur d''eau)';

	RAISE NOTICE 'Création de la structure de table attributaire zh';
	EXECUTE 'DROP TABLE IF EXISTS zh CASCADE';
		
	EXECUTE 'CREATE TABLE IF NOT EXISTS c_phenomenes.zh
	(
		id serial PRIMARY KEY,
		h_eau_min double precision,
		h_eau_max double precision,
		territoire character varying,
		code_occurrence character varying,
		occurrence integer,
		type_alea character varying,
		description_alea character varying,
		sce_donnee character varying,
		mnsle_ref character varying,
		mnt_ref character varying,
		geom geometry(MultiPolygon,2154)
	)';
	RAISE NOTICE 'Création de la table zh effectuée';
	
	com := '
	COMMENT ON TABLE c_phenomenes.zh IS ''Classes de hauteur d''''eau'';
	COMMENT ON COLUMN c_phenomenes.zh.id IS ''Clé primaire'';
	COMMENT ON COLUMN c_phenomenes.zh.geom IS ''Géométrie corrigée pour ce qui concerne le TRI de Verdun'';
	COMMENT ON COLUMN c_phenomenes.zh.h_eau_min	IS ''Hauteur d''''eau minimum (en cm)'';
	COMMENT ON COLUMN c_phenomenes.zh.h_eau_max	IS ''Hauteur d''''eau maximum (en cm)'';
	COMMENT ON COLUMN c_phenomenes.zh.territoire IS ''Nom du territoire d''''étude'';
	COMMENT ON COLUMN c_phenomenes.zh.code_occurrence IS ''Code de la période de retour (ex : QRef, Q100, Q10, Xynthia_2100, Q_freq, Q_moy, Q_extr, Qref_plus50)'';
	COMMENT ON COLUMN c_phenomenes.zh.occurrence IS ''Période de retour considérée (en années)'';
	COMMENT ON COLUMN c_phenomenes.zh.type_alea	IS ''Type d''''aléa considéré (ex : débordement de cours d''''eau, submersion marine, ruissellement)'';
	COMMENT ON COLUMN c_phenomenes.zh.description_alea IS ''Description de la source de l''''aléa (ex : PPRi de ..., Etude de modélisation ...)'';
	COMMENT ON COLUMN c_phenomenes.zh.sce_donnee IS ''Source de la donnée'';
	COMMENT ON COLUMN c_phenomenes.zh.mnsle_ref	IS ''MNSLE utilisé pour calculer les hauteurs d''''eau à partir du modèle numérique de terrain (MNT)'';
	COMMENT ON COLUMN c_phenomenes.zh.mnt_ref IS ''MNT utilisé pour calculer les hauteurs d''''eau à partir du modèle numérique de surface libre en eau (MNSLE)'';
	';
	EXECUTE (com);

	RAISE NOTICE 'Commentaires ajoutés à la table zh';
	
    RAISE NOTICE '====== FIN TRAITEMENT ======';
	RAISE NOTICE '[INFO] La table zh a été initialisée dans le schéma c_phenomenes';
    RAISE NOTICE '';

END;
$procedure$
