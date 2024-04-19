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

CREATE OR REPLACE PROCEDURE public.__init_s1_2b()
 LANGUAGE plpgsql
AS $procedure$

-- Procédure SQL d'initialisation de la table s1_2b (personnes occupant des locaux fortement inondables) dans le schéma p_indicateurs
-- © Cerema / GT AgiRisk
-- Dernière mise à jour du script le 26/08/2023 par Sébastien

-- Commande d'appel à cette procédure :
-- CALL public.__init_s1_2b();

DECLARE
	com text; -- variable d'exécution des commentaires

BEGIN

	SET search_path TO p_indicateurs, public;

	RAISE NOTICE '';
	RAISE NOTICE '====== RAPPORT ======';
	RAISE NOTICE 'Initialisation de l''indicateur S1/2b (personnes occupant des locaux fortement inondables)';

	RAISE NOTICE 'Création de la structure de table attributaire s1_2b';
	EXECUTE 'DROP TABLE IF EXISTS s1_2b CASCADE';
	EXECUTE 'CREATE TABLE s1_2b (
		id serial PRIMARY KEY,
		territoire varchar(200),
		id_epci varchar(9),
		nom_epci varchar(200),
		id_commune varchar(5),
		nom_commune varchar(200),
		id_iris varchar(9),
		nom_iris varchar(200),
		id_bdt varchar(50),
		loc_zq varchar(50),
		type_alea varchar(200),
		code_occurrence varchar(200),
		pop6_rdc float DEFAULT 0,
		sce_donnee text,
		moda_calc text,
		date_calc date,
		geom geometry(MultiPolygon,2154),
		geomloc geometry(POINT,2154)
	)';
	RAISE NOTICE 'Création de la table s1_2b effectuée';

	com := '
	COMMENT ON TABLE s1_2b IS ''Couche des occupants en rez-de-chaussée de bâtiment'';
	COMMENT ON COLUMN s1_2b.id IS ''Identifiant unique non nul de type serial (clé primaire)'';
	COMMENT ON COLUMN s1_2b.territoire IS ''Nom du territoire d''''étude'';
	COMMENT ON COLUMN s1_2b.id_epci IS ''Numéro SIREN de l''''EPCI'';
	COMMENT ON COLUMN s1_2b.nom_epci IS ''Nom de l''''EPCI'';
	COMMENT ON COLUMN s1_2b.id_commune IS ''Code INSEE de la commune'';
	COMMENT ON COLUMN s1_2b.nom_commune IS ''Nom de la commune'';
	COMMENT ON COLUMN s1_2b.id_iris IS ''Code de l''''IRIS GE (maille de calcul élémentaire)'';
	COMMENT ON COLUMN s1_2b.nom_iris IS ''Nom de l''''IRIS GE (maille de calcul élémentaire)'';
	COMMENT ON COLUMN s1_2a.id_bdt IS ''Identifiant d''''origine de la couche des bâtiments issu de la BDTOPO'';
	COMMENT ON COLUMN s1_2b.loc_zq IS ''Indique si le bâtiment intersecte ("in") ou non ("out") une zone d''''aléa de niveaux fort à très fort'';
	COMMENT ON COLUMN s1_2b.type_alea IS ''Type d''''aléa considéré (ex : débordement de cours d''''eau, submersion marine, ruissellement)'';
	COMMENT ON COLUMN s1_2b.code_occurrence IS ''Code de la période de retour (ex : QRef, Q100, Q10, Xynthia_2100, Q_freq, Q_moy, Q_extr, Qref_plus50)'';
	COMMENT ON COLUMN s1_2b.pop6_rdc IS ''Nombre d''''occupants en rez-de-chaussée du bâtiment'';
	COMMENT ON COLUMN s1_2a.sce_donnee IS ''Données sources utilisées (référentiels + millésimes)'';
	COMMENT ON COLUMN s1_2a.moda_calc IS ''Nom de la fonction postgis telle que stockée dans la BDD'';
	COMMENT ON COLUMN s1_2a.date_calc IS ''Date de création de l''''indicateur'';
	COMMENT ON COLUMN s1_2b.geom IS ''Description géographique de l''''entité (zones à urbaniser inondables)'';
	COMMENT ON COLUMN s1_2b.geomloc IS ''Centroïde de la géométrie'';
	';
	EXECUTE (com);
	RAISE NOTICE 'Commentaires ajoutés à la table s1_2b';

	RAISE NOTICE '====== FIN TRAITEMENT ======';
	RAISE NOTICE '[INFO] La table s1_2b a été initialisée dans le schéma p_indicateurs';
	RAISE NOTICE '';

END;
$procedure$
