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

CREATE OR REPLACE PROCEDURE public.__init_zq()
 LANGUAGE plpgsql
AS $procedure$

-- Procédure SQL d'initialisation de la table zq (zones d'aléa) dans le schéma c_phenomenes
-- © Cerema / GT AgiRisk
-- Dernière mise à jour du script le 26/08/2023 par Sébastien

-- Commande d'appel à cette procédure :
-- CALL public.__init_zq();

DECLARE
	com text; -- variable d'exécution des commentaires

BEGIN

	SET search_path TO c_phenomenes, public;

	RAISE NOTICE '';
	RAISE NOTICE '====== RAPPORT ======';
	RAISE NOTICE 'Initialisation de la variable Zq (zones d''aléa)';

	RAISE NOTICE 'Création de la structure de table attributaire zq';
	EXECUTE 'DROP TABLE IF EXISTS zq CASCADE';
	EXECUTE 'CREATE TABLE zq (
		id serial PRIMARY KEY,
		territoire varchar(200),
		type_alea varchar(200),
		occurrence integer,
		code_occurrence varchar(200),
		description_alea varchar(254),
		intensite_alea varchar(50),
		moda_calc text,
		date_calc text,
		geom geometry(multipolygon, 2154)
	)';
	RAISE NOTICE 'Création de la table zq effectuée';

	com := '
	COMMENT ON TABLE zq IS ''Zonages des intensités d''''aléa'';
	COMMENT ON COLUMN zq.id IS ''Identifiant unique non nul de type serial (clé primaire)'';
	COMMENT ON COLUMN zq.territoire IS ''Nom du territoire d''''étude'';
	COMMENT ON COLUMN zq.type_alea IS ''Type d''''aléa considéré : débordement de cours d''''eau, submersion marine, ruissellement'';
	COMMENT ON COLUMN zq.occurrence IS ''Période de retour considérée (en années)'';
	COMMENT ON COLUMN zq.code_occurrence IS ''Code de la période de retour (ex : QRef, Q100, Q10, Xynthia_2100, Q_freq, Q_moy, Q_extr, Qref_plus50)'';
	COMMENT ON COLUMN zq.description_alea IS ''Description de la source de l''''aléa (ex : PPRi de ..., Etude de modélisation ...)'';
	COMMENT ON COLUMN zq.intensite_alea IS ''Intensité (niveau) de l''''aléa (ex : faible, moyen, fort, très fort)'';
	COMMENT ON COLUMN zq.moda_calc IS ''Nom de la fonction postgis telle que stockée dans la BDD'';
	COMMENT ON COLUMN zq.date_calc IS ''Date de création de la variable'';
	COMMENT ON COLUMN zq.geom IS ''Description géographique de l''''entité (zone d''''aléa)'';
	';
	EXECUTE (com);
	RAISE NOTICE 'Commentaires ajoutés à la table zq';
	
	RAISE NOTICE '====== FIN TRAITEMENT ======';
	RAISE NOTICE '[INFO] La table zq a été initialisée dans le schéma c_phenomenes';
	RAISE NOTICE '';

END;
$procedure$
