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

CREATE OR REPLACE PROCEDURE public.__init_s3_1f()
 LANGUAGE plpgsql
AS $procedure$

-- Procédure SQL d'initialisation de la table s3_1f (surfaces agricoles en zone inondable) dans le schéma p_indicateurs
-- © Cerema / GT AgiRisk (auteures principales du script : Tiffany, Lucie)
-- Dernière mise à jour du script le 26/08/2023 par Sébastien

-- Commande d'appel à cette procédure :
-- CALL public.__init_s3_1f();

DECLARE
	com text; -- variable d'exécution des commentaires

BEGIN

	SET search_path TO p_indicateurs, public;
	
	RAISE NOTICE '';
	RAISE NOTICE '====== RAPPORT ======';
	RAISE NOTICE 'Initialisation de l''indicateur s3/1f (parcelles agricoles en zone inondable)';
	
	RAISE NOTICE 'Création de la structure de table attributaire s3_1f';
	EXECUTE 'DROP TABLE IF EXISTS s3_1f CASCADE';
	EXECUTE 'CREATE TABLE s3_1f (
		id serial PRIMARY KEY,
		territoire varchar(200),
		id_epci varchar(9),
		nom_epci varchar(200),
		id_commune varchar(5),
		nom_commune varchar(200),
		id_iris varchar(9),
		nom_iris varchar(200),
		id_oc7 int,
		code_rpg varchar(30),
		lib_culture varchar(50),
		loc_zx varchar(30),
		type_alea varchar(200),
		code_occurrence varchar(200),
		surf_parc numeric(15,2),
		sce_donnee text,
		moda_calc text,
		date_calc date,
		geom geometry(MultiPolygon,2154),
		geomloc geometry(POINT,2154)
		)';
	RAISE NOTICE 'Création de la table s3_1f effectuée';
	
	com := '
	COMMENT ON TABLE s3_1f IS ''Couche des occupants en zone inondable (Zx)'';
	COMMENT ON COLUMN s3_1f.id IS ''Identifiant unique non nul de type serial (clé primaire)'';
	COMMENT ON COLUMN s3_1f.territoire IS ''Nom du territoire d''''étude'';
	COMMENT ON COLUMN s3_1f.id_epci IS ''Numéro SIREN de l''''EPCI'';
	COMMENT ON COLUMN s3_1f.nom_epci IS ''Nom de l''''EPCI'';
	COMMENT ON COLUMN s3_1f.id_commune IS ''Code INSEE de la commune'';
	COMMENT ON COLUMN s3_1f.nom_commune IS ''Nom de la commune'';
	COMMENT ON COLUMN s3_1f.id_iris IS ''Code de l''''IRIS GE (maille de calcul élémentaire)'';
	COMMENT ON COLUMN s3_1f.nom_iris IS ''Nom de l''''IRIS GE (maille de calcul élémentaire)'';
	COMMENT ON COLUMN s3_1f.id_oc7 IS ''Identifiant présent dans oc7'';
	COMMENT ON COLUMN s3_1f.code_RPG IS ''Code de la culture selon le RPG'';
	COMMENT ON COLUMN s3_1f.lib_culture IS ''Libellé de la culture selon le RPG'';
	COMMENT ON COLUMN s3_1f.loc_zx IS ''Indique si la parcelle intersecte ("in") ou non ("out") la zone inondable (Zx)'';
	COMMENT ON COLUMN s3_1f.type_alea IS ''Type d''''aléa considéré (ex : débordement de cours d''''eau, submersion marine, ruissellement)'';
	COMMENT ON COLUMN s3_1f.code_occurrence IS ''Code de la période de retour (ex : QRef, Q100, Q10, Xynthia_2100, Q_freq, Q_moy, Q_extr, Qref_plus50)'';
	COMMENT ON COLUMN s3_1f.surf_parc IS ''Surface de la parcelle'';
	COMMENT ON COLUMN s3_1f.sce_donnee IS ''Données sources utilisées (référentiels + millésimes)'';
	COMMENT ON COLUMN s3_1f.date_calc IS ''Date de création de l''''indicateur'';
	COMMENT ON COLUMN s3_1f.moda_calc IS ''Nom de la fonction postgis telle que stockée dans la BDD'';
	COMMENT ON COLUMN s3_1f.geom IS ''Description géographique de l''''entité parcelle'';
	COMMENT ON COLUMN s3_1f.geomloc IS ''Centroïde de l''''entité parcelle'';
	';
	EXECUTE (com);
	RAISE NOTICE 'Commentaires ajoutés à la table s3_1f';
	
	RAISE NOTICE '====== FIN TRAITEMENT ======';
	RAISE NOTICE '[INFO] La table s3_1f a été initialisée dans le schéma p_indicateurs';
	RAISE NOTICE '';

END;
$procedure$
