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

CREATE OR REPLACE PROCEDURE public.__init_zt_avec_tables_association()
 LANGUAGE plpgsql
AS $procedure$

-- Procédure SQL d'initialisation de la table zt (périmètres de calcul élémentaires : contours IRIS GE® intersectant le périmètre d'étude) dans le schéma c_phenomenes
-- © Cerema / GT AgiRisk
-- Dernière mise à jour du script le 26/08/2023 par Sébastien

-- Commande d'appel à cette procédure :
-- CALL public.__init_zt_avec_tables_association();

DECLARE
	com text; -- variable d'exécution des commentaires

BEGIN

	SET search_path TO c_phenomenes, public;

	RAISE NOTICE '';
	RAISE NOTICE '====== RAPPORT ======';
	RAISE NOTICE 'Initialisation de Zt (périmètres de calcul élémentaires)';

	RAISE NOTICE 'Création de la structure de table attributaire zt';
	EXECUTE 'DROP TABLE IF EXISTS c_phenomenes.zt CASCADE';
	EXECUTE 'CREATE TABLE c_phenomenes.zt (
		id serial PRIMARY KEY,
		territoire varchar(200),
		id_iris varchar(9),
		libelle varchar(200),
		id_commune varchar(5),
		id_epci varchar(9),
		id_dpt varchar(3),
		id_region varchar(2),
		sce_donnee text,
		moda_calc text,
		date_calc date,
		geom geometry(MultiPolygon,2154)
	)';
	RAISE NOTICE 'Création de la table zt effectuée';

	com := '
	COMMENT ON TABLE zt IS ''Couche des périmètres de calcul élémentaires : contours IRIS GE intersectant le périmètre d''''étude'';
	COMMENT ON COLUMN zt.id IS ''Identifiant unique non nul de type serial (clé primaire)'';
	COMMENT ON COLUMN zt.territoire IS ''Nom du territoire d''''étude'';
	COMMENT ON COLUMN zt.id_iris IS ''Code de l''''IRIS GE (maille de calcul élémentaire)'';
	COMMENT ON COLUMN zt.libelle IS ''Nom de l''''IRIS GE (maille de calcul élémentaire)'';
	COMMENT ON COLUMN zt.id_commune IS ''Code commune'';
	COMMENT ON COLUMN zt.id_epci IS ''Code EPCI'';
	COMMENT ON COLUMN zt.id_dpt IS ''Code département'';
	COMMENT ON COLUMN zt.id_region IS ''Code région'';
	COMMENT ON COLUMN zt.sce_donnee IS ''Données sources utilisées (référentiels + millésimes)'';
	COMMENT ON COLUMN zt.moda_calc IS ''Nom de la fonction postgis telle que stockée dans la BDD'';
	COMMENT ON COLUMN zt.date_calc IS ''Date de création de la variable'';
	COMMENT ON COLUMN zt.geom IS ''Description géographique de l''''entité (contour IRIS GE)'';
	';
	EXECUTE (com);
	RAISE NOTICE 'Commentaires ajoutés à la table zt';

	RAISE NOTICE 'Création de la table d''association zt_bh (bassins hydrographiques)';
	EXECUTE 'DROP TABLE IF EXISTS c_phenomenes.zt_bh CASCADE';
	EXECUTE 'CREATE TABLE c_phenomenes.zt_bh (
		id_zt integer,
		id_bh integer,
		FOREIGN KEY (id_zt) REFERENCES c_phenomenes.zt (id) ON DELETE CASCADE,
		FOREIGN KEY (id_bh) REFERENCES r_sandre_bdtopage.bassin_hydrographique_2019 (id) ON DELETE CASCADE,
		PRIMARY KEY (id_zt, id_bh)
	)';
	RAISE NOTICE 'Création de la table d''association zt_bh effectuée';

	RAISE NOTICE 'Création de la table d''association zt_mbv (macro-bassins versants)';
	EXECUTE 'DROP TABLE IF EXISTS c_phenomenes.zt_mbv CASCADE';
	EXECUTE 'CREATE TABLE c_phenomenes.zt_mbv (
		id_zt integer,
		id_mbv integer,
		FOREIGN KEY (id_zt) REFERENCES c_phenomenes.zt (id) ON DELETE CASCADE,
		FOREIGN KEY (id_mbv) REFERENCES r_sandre_bdcarthage.sous_secteur_hydro_2016 (id) ON DELETE CASCADE,
		PRIMARY KEY (id_zt, id_mbv)
	)';
	RAISE NOTICE 'Création de la table d''association zt_mbv effectuée';

	RAISE NOTICE 'Création de la table d''association zt_bv (bassins versants topographiques)';
	EXECUTE 'DROP TABLE IF EXISTS c_phenomenes.zt_bv CASCADE';
	EXECUTE 'CREATE TABLE c_phenomenes.zt_bv (
		id_zt integer,
		id_bv integer,
		FOREIGN KEY (id_zt) REFERENCES c_phenomenes.zt (id) ON DELETE CASCADE,
		FOREIGN KEY (id_bv) REFERENCES r_sandre_bdtopage.bassin_versant_topographique_2019 (id) ON DELETE CASCADE,
		PRIMARY KEY (id_zt, id_bv)
	)';
	RAISE NOTICE 'Création de la table d''association zt_bv effectuée';

	RAISE NOTICE 'Création de la table d''association zt_bve (bassins versants élémentaires)';
	EXECUTE 'DROP TABLE IF EXISTS c_phenomenes.zt_bve CASCADE';
	EXECUTE 'CREATE TABLE c_phenomenes.zt_bve (
		id_zt integer,
		id_bve integer,
		FOREIGN KEY (id_zt) REFERENCES c_phenomenes.zt (id) ON DELETE CASCADE,
		FOREIGN KEY (id_bve) REFERENCES public.bassins_versants_elementaires (id) ON DELETE CASCADE,
		PRIMARY KEY (id_zt, id_bve)
	)';
	RAISE NOTICE 'Création de la table d''association zt_bve effectuée';

	RAISE NOTICE '====== FIN TRAITEMENT ======';
	RAISE NOTICE '[INFO] La table zt et les tables d''association zt_bh, zt_mbv, zt_bv et zt_bve ont été initialisées dans le schéma c_phenomenes';
	RAISE NOTICE '';

END;
$procedure$
