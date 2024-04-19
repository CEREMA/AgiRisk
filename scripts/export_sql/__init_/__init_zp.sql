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

CREATE OR REPLACE PROCEDURE public.__init_zp()
 LANGUAGE plpgsql
AS $procedure$

-- Procédure SQL d'initialisation de la table zp (probabilités d'occurrence de crue selon la saison) dans le schéma c_phenomenes
-- © Cerema / GT AgiRisk (auteur du script : Sébastien, sur une idée originale de Christophe)
-- Dernière mise à jour du script le 26/08/2023 par Sébastien

-- Commande d'appel à cette procédure :
-- CALL public.__init_zp();

DECLARE
	com text; -- variable d'exécution des commentaires

BEGIN

	SET search_path TO c_phenomenes, public;

	RAISE NOTICE '';
	RAISE NOTICE '====== RAPPORT ======';
	RAISE NOTICE 'Initialisation de la variable Zp (probabilités d''occurrence de crue selon la saison)';

	RAISE NOTICE 'Création de la structure de table attributaire zp';
	EXECUTE 'DROP TABLE IF EXISTS zp CASCADE';
	EXECUTE 'CREATE TABLE zp (
		id serial PRIMARY KEY,
		territoire varchar(200),
		type_alea varchar(200),
		occurrence integer,
		code_occurrence varchar(200),
		description_alea varchar(254),
		proba_prin float,
		proba_ete float,
		proba_aut float,
		proba_hiv float,
		sce_donnee text,
		moda_calc text,
		date_calc date
	)';
	RAISE NOTICE 'Création de la table zp effectuée';

	com := '
	COMMENT ON TABLE zp IS ''Probabilités d''''occurrence de crue selon la saison'';
	COMMENT ON COLUMN zp.id IS ''Identifiant unique non nul de type serial (clé primaire)'';
	COMMENT ON COLUMN zp.territoire IS ''Nom du territoire d''''étude'';
	COMMENT ON COLUMN zp.type_alea IS ''Type d''''aléa considéré : débordement de cours d''''eau, submersion marine, ruissellement'';
	COMMENT ON COLUMN zp.occurrence IS ''Période de retour considérée (en années)'';
	COMMENT ON COLUMN zp.code_occurrence IS ''Code de la période de retour (ex : QRef, Q100, Q10, Xynthia_2100, Q_freq, Q_moy, Q_extr, Qref_plus50)'';
	COMMENT ON COLUMN zp.description_alea IS ''Description de la source de l''''aléa (ex : PPRi de ..., Etude de modélisation ...)'';
	COMMENT ON COLUMN zp.proba_prin IS ''Probabilité printemps'';
	COMMENT ON COLUMN zp.proba_ete IS ''Probabilité été'';
	COMMENT ON COLUMN zp.proba_aut IS ''Probabilité automne'';
	COMMENT ON COLUMN zp.proba_hiv IS ''Probabilité hiver'';
	COMMENT ON COLUMN zp.sce_donnee IS ''Source de la donnée'';
	COMMENT ON COLUMN zp.moda_calc IS ''Nom de la fonction postgis telle que stockée dans la BDD'';
	COMMENT ON COLUMN zp.date_calc IS ''Date de création de la variable'';
	';
	EXECUTE (com);
	RAISE NOTICE 'Commentaires ajoutés à la table zp';

	RAISE NOTICE '====== FIN TRAITEMENT ======';
	RAISE NOTICE '[INFO] La table zp a été initialisée dans le schéma c_phenomenes';
	RAISE NOTICE '';

END;
$procedure$
