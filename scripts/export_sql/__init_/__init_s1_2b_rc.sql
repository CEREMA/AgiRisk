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

CREATE OR REPLACE PROCEDURE public.__init_s1_2b_rc()
 LANGUAGE plpgsql
AS $procedure$

-- Procédure SQL d'initialisation de la table s1_2b_rc (représentation cartographique des personnes occupant des locaux fortement inondables) dans le schéma p_rep_carto
-- © Cerema / GT AgiRisk
-- Dernière mise à jour du script le 18/07/2023 par Sébastien

-- Commande d'appel à cette procédure :
-- CALL public.__init_s1_2b_rc();

DECLARE
	com text; -- variable d'exécution des commentaires

BEGIN

	SET search_path TO p_rep_carto, public;

	RAISE NOTICE '';
	RAISE NOTICE '====== RAPPORT ======';
	RAISE NOTICE 'Initialisation de la table de représentation cartographique de l''indicateur S1/2b (personnes occupant des locaux fortement inondables)';

	RAISE NOTICE 'Création de la structure de table attributaire s1_2b_rc';
	EXECUTE 'DROP TABLE IF EXISTS s1_2b_rc CASCADE';
	EXECUTE 'CREATE TABLE s1_2b_rc (
		id serial PRIMARY KEY,
		territoire varchar(200),
		type_alea varchar(200),
		code_occurrence varchar(200),
		type_result varchar(200),
		id_geom varchar(200),
		nom_id_geom varchar(200),
		loc_zq varchar(50),
		pop6_rdc_in_fort_tresfort double precision DEFAULT 0,
		pop6_rdc_in_fai_moyen double precision DEFAULT 0,
		pop6_rdc_out_zq double precision DEFAULT 0,
		pct_rdc_in_fort_tresfort integer GENERATED ALWAYS AS (ROUND((pop6_rdc_in_fort_tresfort :: numeric / (pop6_rdc_in_fort_tresfort + pop6_rdc_in_fai_moyen + pop6_rdc_out_zq + 0.001) * 100)::numeric,0)) STORED, -- on rajoute + 0.001 pour éviter les divisions à 0
		pct_rdc_in_fai_moyen integer GENERATED ALWAYS AS (ROUND((pop6_rdc_in_fai_moyen :: numeric / (pop6_rdc_in_fort_tresfort + pop6_rdc_in_fai_moyen + pop6_rdc_out_zq + 0.001) * 100)::numeric,0)) STORED,
		pct_rdc_out_zq integer GENERATED ALWAYS AS (ROUND((pop6_rdc_out_zq :: numeric / (pop6_rdc_in_fort_tresfort + pop6_rdc_in_fai_moyen + pop6_rdc_out_zq + 0.001) * 100)::numeric,0)) STORED,
		total_rdc double precision GENERATED ALWAYS AS (pop6_rdc_in_fort_tresfort + pop6_rdc_in_fai_moyen + pop6_rdc_out_zq) STORED,
		valid_result integer,
		date_calc date,
		geom geometry
	)';
	RAISE NOTICE 'Création de la table s1_2b_rc effectuée';

	com := '
	COMMENT ON TABLE s1_2b_rc IS ''Représentation cartographique des occupants de locaux fortement inondables'';
	COMMENT ON COLUMN s1_2b_rc.id IS ''Identifiant unique non nul de type serial (clé primaire)'';
	COMMENT ON COLUMN s1_2b_rc.territoire IS ''Nom du territoire d''''étude'';
	COMMENT ON COLUMN s1_2b_rc.type_alea IS ''Type d''''aléa considéré (ex : débordement de cours d''''eau, submersion marine, ruissellement)'';
	COMMENT ON COLUMN s1_2b_rc.code_occurrence IS ''Code de la période de retour (ex : QRef, Q100, Q10, Xynthia_2100, Q_freq, Q_moy, Q_extr, Qref_plus50)'';
	COMMENT ON COLUMN s1_2b_rc.type_result IS ''Type d''''affichage carto : hexagones selon nb hectare, limites administratives, etc.'';
	COMMENT ON COLUMN s1_2b_rc.id_geom IS ''Code de la géométrie de la représentation carto'';
	COMMENT ON COLUMN s1_2b_rc.nom_id_geom IS ''Nom de la géométrie (commune, Iris, EPCI) de la représentation carto'';
	COMMENT ON COLUMN s1_2a_rc.loc_zq IS ''Pour le niveau d''''agrégation ''''Bâtiments IRIS'''', indique si l''''entité intersecte ("In faible", "In moyen", "In fort", "In très fort") ou non ("Out") la zone inondable (Zq), "indéterminé" pour les niveaux d''''agrégation ''''Hexag_*ha'''' et entités administratives'';
	COMMENT ON COLUMN s1_2b_rc.pop6_rdc_in_fort_tresfort IS ''Population en rez-de-chaussée en zone d''''aléa de niveaux fort à très fort dans la géométrie'';
	COMMENT ON COLUMN s1_2b_rc.pop6_rdc_in_fai_moyen IS ''Population en rez-de-chaussée en zone d''''aléa de niveaux faible à moyen dans la géométrie'';
	COMMENT ON COLUMN s1_2b_rc.pop6_rdc_out_zq IS ''Population en rez-de-chaussée hors zone inondable dans la géométrie'';
	COMMENT ON COLUMN s1_2b_rc.pct_rdc_in_fort_tresfort IS ''Pourcentage de la population en rez-de-chaussée en zone d''''aléa de niveaux fort à très fort dans la géométrie'';
	COMMENT ON COLUMN s1_2b_rc.pct_rdc_in_fai_moyen IS ''Pourcentage de la population en rez-de-chaussée en zone d''''aléa de niveaux faible à moyen dans la géométrie'';
	COMMENT ON COLUMN s1_2b_rc.pct_rdc_out_zq IS ''Pourcentage de la population en rez-de-chaussée hors zone inondable dans la géométrie'';
	COMMENT ON COLUMN s1_2b_rc.total_rdc IS ''Total population en rez-de-chaussée en ET hors zone inondable dans la géométrie'';
	COMMENT ON COLUMN s1_2b_rc.valid_result IS ''Validité du résultat (1 : calcul correct sur l''''ensemble du périmètre de calcul / 0 : résultat incomplet)'';
	COMMENT ON COLUMN s1_2b_rc.date_calc IS ''Date de création de l''''indicateur brut'';
	COMMENT ON COLUMN s1_2b_rc.geom IS ''Description géographique de l''''entité'';
	';
	EXECUTE (com);
	RAISE NOTICE 'Commentaires ajoutés à la table s1_2b_rc';

	RAISE NOTICE '====== FIN TRAITEMENT ======';
	RAISE NOTICE '[INFO] La table s1_2b_rc a été initialisée dans le schéma p_rep_carto';
	RAISE NOTICE '';

END;
$procedure$
