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

CREATE OR REPLACE PROCEDURE public.__init_oc3()
 LANGUAGE plpgsql
AS $procedure$

-- Procédure SQL d'initialisation de la table oc3 (activités) dans le schéma c_occupation_sol
-- © Cerema / GT AgiRisk
-- Dernières mises à jour du script le 12/04/2023 par Lucie et le 26/08/2023 par Sébastien

-- Commande d'appel à cette procédure :
-- CALL public.__init_oc3();

DECLARE
	com text; -- variable d'exécution des commentaires

BEGIN

	SET search_path TO c_occupation_sol, public;

	RAISE NOTICE '';
	RAISE NOTICE '====== RAPPORT ======';
	RAISE NOTICE 'Initialisation de la variable oc3 (activités)';

	RAISE NOTICE 'Création de la structure de table attributaire oc3';
	EXECUTE 'DROP TABLE IF EXISTS oc3 CASCADE';
	EXECUTE 'CREATE TABLE oc3 (
		id serial PRIMARY KEY,
		siret varchar(50),
		id_bat varchar(50),
		id_adr varchar(50),
		similarity double precision,
		dif_numero double precision,
		numero_ban integer,
		adresse_ban varchar(250), 
		numero_sirene integer,
		adresse_sirene varchar(250),
		territoire varchar(200),
		surf_bat integer,
		nb_bat integer,
		nb_etab integer, 
		surf_bat_etab double precision,
		employes_haut_etab double precision,
		employes_bas_etab double precision,
		sce_donnee text,
		moda_calc text,
		date_calc date
	)';
	RAISE NOTICE 'Création de la table oc3 effectuée';

	com := '
	COMMENT ON TABLE oc3 IS ''Couche des bâtiments de la BDTOPO croisés avec geosirene (activités)'';
	COMMENT ON COLUMN oc3.id IS ''Identifiant unique non nul de type serial (clé primaire)'';
	COMMENT ON COLUMN oc3.siret IS ''Identifiant siret de l''''activité'';
	COMMENT ON COLUMN oc3.id_bat IS ''Identifiant d''''origine de la couche des bâtiments issu de la BDTOPO'';
	COMMENT ON COLUMN oc3.id_adr IS ''Identifiant issu de la base de données ADRESSE PREMIUM'';
	COMMENT ON COLUMN oc3.similarity IS ''Score de similarité entre les libellés d''''adresse de la BAN et ceux de geosirene (distance de Levenshtein)'';
	COMMENT ON COLUMN oc3.dif_numero IS ''Reconstitution du numéro de rue : si le numero de rue issu de la BAN est nul, on prend celui de geosirene, et inversement. Si les deux numéros sont nuls, alors dif_numero = 0. Dans tous les autres cas, on prend la différence en valeur absolue des deux numéros.'';
	COMMENT ON COLUMN oc3.numero_ban IS ''Numéro de rue issu de l''''adresse BAN'';
	COMMENT ON COLUMN oc3.adresse_ban IS ''Adresse BAN'';
	COMMENT ON COLUMN oc3.numero_sirene IS ''Numéro de rue issu de l''''adresse geosirene'';
	COMMENT ON COLUMN oc3.adresse_sirene IS ''Adresse geosirene'';
	COMMENT ON COLUMN oc3.territoire IS ''Nom du territoire d''''étude'';
	COMMENT ON COLUMN oc3.surf_bat IS ''Emprise au sol du bâtiment BDTOPO'';
	COMMENT ON COLUMN oc3.nb_bat IS ''Nombre de bâtiments BDTOPO pour chaque établissement siret'';
	COMMENT ON COLUMN oc3.nb_etab IS ''Nombre d''''établissements siret pour chaque bâtiment BDTOPO'';
	COMMENT ON COLUMN oc3.surf_bat_etab IS ''Surface de l''''activité siret au sein du bâtiment BDTOPO (surf_bat/nb_etab)'';
	COMMENT ON COLUMN oc3.employes_haut_etab IS ''Borne haute du nombre d''''employés au sein du bâtiment d''''activités'';
	COMMENT ON COLUMN oc3.employes_bas_etab IS ''Borne basse du nombre d''''employés au sein du bâtiment d''''activités'';
	COMMENT ON COLUMN oc3.sce_donnee IS ''Données sources utilisées (référentiels + millésimes)'';
	COMMENT ON COLUMN oc3.moda_calc IS ''Nom de la fonction postgis telle que stockée dans la BDD'';
	COMMENT ON COLUMN oc3.date_calc IS ''Date de création de la variable'';
	';
	EXECUTE (com);
	RAISE NOTICE 'Commentaires ajoutés à la table oc3';

	RAISE NOTICE '====== FIN TRAITEMENT ======';
	RAISE NOTICE '[INFO] La table oc3 a été initialisée dans le schéma c_occupation_sol';
	RAISE NOTICE '';

END;
$procedure$
