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

CREATE OR REPLACE PROCEDURE public.__init_logt_zx()
 LANGUAGE plpgsql
AS $procedure$

-- Procédure SQL d'initialisation de la table logt_zx (nombre de logements en zone inondable) dans le schéma p_indicateurs
-- © Cerema / GT AgiRisk
-- Dernière mise à jour du script le 26/08/2023 par Sébastien

-- Commande d'appel à cette procédure :
-- CALL public.__init_logt_zx();

DECLARE
	com text; -- variable d'exécution des commentaires

BEGIN

	SET search_path TO p_indicateurs, public;
	
	RAISE NOTICE '';
	RAISE NOTICE '====== RAPPORT ======';
	RAISE NOTICE 'Initialisation de l''indicateur logt_zx (occupants en zone inondable)';

	RAISE NOTICE 'Création de la structure de table attributaire logt_zx';

	EXECUTE 'DROP TABLE IF EXISTS logt_zx CASCADE';
	EXECUTE 'CREATE TABLE logt_zx (
		id serial PRIMARY KEY,
		territoire varchar(200),
		id_epci varchar(9),
		nom_epci varchar(200),
		id_commune varchar(5),
		nom_commune varchar(200),
		id_iris varchar(9),
		nom_iris varchar(200),
		id_bdt varchar(50),
		nb_logts integer DEFAULT 0,
		loc_zx varchar(30),
		type_alea varchar(200),
		code_occurrence varchar(200),
		sce_donnee text,
		moda_calc text,
		date_calc date,
		geom geometry(MultiPolygon,2154),
		geomloc geometry(POINT,2154)
	)';
	RAISE NOTICE 'Création de la table logt_zx effectuée';

	com := '
	COMMENT ON TABLE logt_zx IS ''Couche des occupants en zone inondable (Zx)'';
	COMMENT ON COLUMN logt_zx.id IS ''Identifiant unique non nul de type serial (clé primaire)'';
	COMMENT ON COLUMN logt_zx.territoire IS ''Nom du territoire d''''étude'';
	COMMENT ON COLUMN logt_zx.id_epci IS ''Numéro SIREN de l''''EPCI'';
	COMMENT ON COLUMN logt_zx.nom_epci IS ''Nom de l''''EPCI'';
	COMMENT ON COLUMN logt_zx.id_commune IS ''Code INSEE de la commune'';
	COMMENT ON COLUMN logt_zx.nom_commune IS ''Nom de la commune'';
	COMMENT ON COLUMN logt_zx.id_iris IS ''Code de l''''IRIS GE (maille de calcul élémentaire)'';
	COMMENT ON COLUMN logt_zx.nom_iris IS ''Nom de l''''IRIS GE (maille de calcul élémentaire)'';
	COMMENT ON COLUMN logt_zx.id_bdt IS ''Identifiant d''''origine de la couche des bâtiments issu de la BDTOPO'';
	COMMENT ON COLUMN logt_zx.nb_logts IS ''Nombre de logements dans le bâtiment'';
	COMMENT ON COLUMN logt_zx.loc_zx IS ''Indique si le bâtiment intersecte ("in") ou non ("out") la zone inondable (Zx)'';
	COMMENT ON COLUMN logt_zx.type_alea IS ''Type d''''aléa considéré (ex : débordement de cours d''''eau, submersion marine, ruissellement)'';
	COMMENT ON COLUMN logt_zx.code_occurrence IS ''Code de la période de retour (ex : QRef, Q100, Q10, Xynthia_2100, Q_freq, Q_moy, Q_extr, Qref_plus50)'';
	COMMENT ON COLUMN logt_zx.sce_donnee IS ''Données sources utilisées (référentiels + millésimes)'';
	COMMENT ON COLUMN logt_zx.moda_calc IS ''Nom de la fonction postgis telle que stockée dans la BDD'';
	COMMENT ON COLUMN logt_zx.date_calc IS ''Date de création de l''''indicateur'';
	COMMENT ON COLUMN logt_zx.geom IS ''Description géographique de l''''entité (bâtiments)'';
	COMMENT ON COLUMN logt_zx.geomloc IS ''Centroïde de la géométrie'';
	';
	EXECUTE (com);
	RAISE NOTICE 'Commentaires ajoutés à la table logt_zx';

	RAISE NOTICE '====== FIN TRAITEMENT ======';
	RAISE NOTICE '[INFO] La table logt_zx a été initialisée dans le schéma p_indicateurs';
	RAISE NOTICE '';

END;
$procedure$
