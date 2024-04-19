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

CREATE OR REPLACE PROCEDURE public.__init_s3_1f_rc()
 LANGUAGE plpgsql
AS $procedure$

-- Procédure SQL d'initialisation de la table s3_1f_rc (représentation cartographique des parcelles agricoles en zone inondable) dans le schéma p_rep_carto
-- © Cerema / GT Agirisk
-- Dernière mise à jour du script le 18/07/2023 par Sébastien

-- Commande d'appel à cette procédure :
-- CALL public.__init_s3_1f_rc();

DECLARE
	com text; -- variable d'exécution des commentaires

BEGIN

	SET search_path TO p_rep_carto, public;

	RAISE NOTICE '';
	RAISE NOTICE '====== RAPPORT ======';
	RAISE NOTICE 'Initialisation de la table de représentation cartographique de l''indicateur S3/1a (parcelles agricoles en zone inondable)';

	RAISE NOTICE 'Création de la structure de table attributaire s3_1f_rc';
	EXECUTE 'DROP TABLE IF EXISTS s3_1f_rc CASCADE';
	EXECUTE 'CREATE TABLE s3_1f_rc (
		id serial PRIMARY KEY,
		territoire varchar(200),
		type_alea varchar(200),
		code_occurrence varchar(200),
		type_result varchar(200),
		id_geom varchar(200),
		nom_id_geom varchar(200),
		code_rpg varchar(5),
		loc_zx varchar(30),
		surf_in double precision DEFAULT 0,
		surf_out double precision DEFAULT 0,
		pct_surf_in integer GENERATED ALWAYS AS (ROUND((surf_in :: numeric / (surf_in + surf_out + 0.001) * 100)::numeric,0)) STORED, -- on rajoute + 0.001 pour éviter les divisions à 0
		pct_surf_out integer GENERATED ALWAYS AS (100 - (surf_in :: numeric / (surf_in + surf_out + 0.001) * 100)) STORED,
		total_surf double precision GENERATED ALWAYS AS (surf_in + surf_out) STORED,
		valid_result integer,
		date_calc date,
		geom geometry
	)';
	RAISE NOTICE 'Création de la table s3_1f_rc effectuée';

	com := '
	COMMENT ON TABLE s3_1f_rc IS ''Représentation cartographique des parcelles agricoles en zone inondable (Zx)'';
	COMMENT ON COLUMN s3_1f_rc.id IS ''Identifiant unique non nul de type serial (clé primaire)'';
	COMMENT ON COLUMN s3_1f_rc.territoire IS ''Nom du territoire d''''étude'';
	COMMENT ON COLUMN s3_1f_rc.type_alea IS ''Type d''''aléa considéré (ex : débordement de cours d''''eau, submersion marine, ruissellement)'';
	COMMENT ON COLUMN s3_1f_rc.code_occurrence IS ''Code de la période de retour (ex : QRef, Q100, Q10, Xynthia_2100, Q_freq, Q_moy, Q_extr, Qref_plus50)'';
	COMMENT ON COLUMN s3_1f_rc.type_result IS ''Type d''''affichage carto : parcelles agricoles, limites administratives, etc.'';
	COMMENT ON COLUMN s3_1f_rc.id_geom IS ''Code de la géométrie de la représentation cartographique'';
	COMMENT ON COLUMN s3_1f_rc.nom_id_geom IS ''Nom de la géométrie (IRIS, Commune, EPCI) de la représentation cartographique'';
	COMMENT ON COLUMN s3_1f_rc.code_rpg IS ''Code du groupe de culture de la parcelle'';
	COMMENT ON COLUMN s3_1f_rc.loc_zx IS ''Indique si la parcelle agricole est à l''''intérieure ("In") ou non ("Out") la zone inondable (Zx)'';
	COMMENT ON COLUMN s3_1f_rc.surf_in IS ''Surface en ZI'';
	COMMENT ON COLUMN s3_1f_rc.surf_out IS ''Surface hors ZI'';
	COMMENT ON COLUMN s3_1f_rc.pct_surf_in IS ''Pourcentage de la surface en ZI'';
	COMMENT ON COLUMN s3_1f_rc.pct_surf_out IS ''Pourcentage de surface hors ZI'';
	COMMENT ON COLUMN s3_1f_rc.total_surf IS ''Total surface en ET hors ZI dans la géométrie'';
	COMMENT ON COLUMN s1_2a_rc.valid_result IS ''Validité du résultat (1 : calcul correct sur l''''ensemble du périmètre de calcul / 0 : résultat incomplet)'';
	COMMENT ON COLUMN s3_1f_rc.date_calc IS ''Date de création de l''''indicateur brut'';
	COMMENT ON COLUMN s3_1f_rc.geom IS ''Description géographique de l''''entité'';
	';
	EXECUTE (com);
	RAISE NOTICE 'Commentaires ajoutés à la table s3_1f_rc';

	RAISE NOTICE '====== FIN TRAITEMENT ======';
	RAISE NOTICE '[INFO] La table s3_1f_rc a été initialisée dans le schéma p_rep_carto';
	RAISE NOTICE '';

END;
$procedure$
