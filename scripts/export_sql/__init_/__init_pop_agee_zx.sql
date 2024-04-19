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

CREATE OR REPLACE PROCEDURE public.__init_pop_agee_zx()
 LANGUAGE plpgsql
AS $procedure$

-- Procédure SQL d'initialisation de la table pop_agee_zx (habitants âgés de plus de 65 ans en zone inondable) dans le schéma p_indicateurs
-- © Cerema / GT AgiRisk (auteur du script : Sébastien)
-- Dernières mises à jour du script le 24/04/2023 par Lucie et le 26/08/2023 par Sébastien

-- Commande d'appel à cette procédure :
-- CALL public.__init_pop_agee_zx();

DECLARE
	com text; -- variable d'exécution des commentaires

BEGIN

	SET search_path TO p_indicateurs, public;

	RAISE NOTICE '';
	RAISE NOTICE '====== RAPPORT ======';
	RAISE NOTICE 'Initialisation de l''indicateur pop_agee_zx (habitants âgés de plus de 65 ans en zone inondable)';

	RAISE NOTICE 'Création de la structure de table attributaire pop_agee_zx';
	EXECUTE 'DROP TABLE IF EXISTS pop_agee_zx CASCADE';
	EXECUTE 'CREATE TABLE pop_agee_zx (
		id serial PRIMARY KEY,
		territoire varchar(200),
		id_epci varchar(9),
		nom_epci varchar(200),
		id_commune varchar(5),
		nom_commune varchar(200),
		id_iris varchar(9),
		nom_iris varchar(200),
		id_bdt varchar(50),
		loc_zx varchar(30),
		type_alea varchar(200),
		code_occurrence varchar(200),
		pop1_agee float DEFAULT 0,
		sce_donnee text,
		moda_calc text,
		date_calc date,
		geom geometry(MultiPolygon,2154),
		geomloc geometry(POINT,2154)
	)';
	RAISE NOTICE 'Création de la table pop_agee_zx effectuée';

	com := '
	COMMENT ON TABLE pop_agee_zx IS ''Couche des habitants âgés de plus de 65 ans en zone inondable (Zx)'';
	COMMENT ON COLUMN pop_agee_zx.id IS ''Identifiant unique non nul de type serial (clé primaire)'';
	COMMENT ON COLUMN pop_agee_zx.territoire IS ''Nom du territoire d''''étude'';
	COMMENT ON COLUMN pop_agee_zx.id_epci IS ''Numéro SIREN de l''''EPCI'';
	COMMENT ON COLUMN pop_agee_zx.nom_epci IS ''Nom de l''''EPCI'';
	COMMENT ON COLUMN pop_agee_zx.id_commune IS ''Code INSEE de la commune'';
	COMMENT ON COLUMN pop_agee_zx.nom_commune IS ''Nom de la commune'';
	COMMENT ON COLUMN pop_agee_zx.id_iris IS ''Code de l''''IRIS GE (maille de calcul élémentaire)'';
	COMMENT ON COLUMN pop_agee_zx.nom_iris IS ''Nom de l''''IRIS GE (maille de calcul élémentaire)'';
	COMMENT ON COLUMN pop_agee_zx.id_bdt IS ''Identifiant du bâtiment issu de la BDTOPO'';
	COMMENT ON COLUMN pop_agee_zx.loc_zx IS ''Indique si le bâtiment intersecte ("In") ou non ("Out") la zone inondable (Zx)'';
	COMMENT ON COLUMN pop_agee_zx.type_alea IS ''Type d''''aléa considéré (ex : débordement de cours d''''eau, submersion marine, ruissellement)'';
	COMMENT ON COLUMN pop_agee_zx.code_occurrence IS ''Code de la période de retour (ex : QRef, Q100, Q10, Xynthia_2100, Q_freq, Q_moy, Q_extr, Qref_plus50)'';
	COMMENT ON COLUMN pop_agee_zx.pop1_agee IS ''Nombre de résidents permanents âgés de plus de 65 ans dans le bâtiment'';
	COMMENT ON COLUMN pop_agee_zx.sce_donnee IS ''Données sources utilisées (référentiels + millésimes)'';
	COMMENT ON COLUMN pop_agee_zx.moda_calc IS ''Nom de la fonction postgis telle que stockée dans la BDD'';
	COMMENT ON COLUMN pop_agee_zx.date_calc IS ''Date de création de l''''indicateur'';
	COMMENT ON COLUMN pop_agee_zx.geom IS ''Description géographique de l''''entité (bâtiments)'';
	COMMENT ON COLUMN pop_agee_zx.geomloc IS ''Centroïde de la géométrie'';
	';
	EXECUTE (com);
	RAISE NOTICE 'Commentaires ajoutés à la table pop_agee_zx';

	RAISE NOTICE '====== FIN TRAITEMENT ======';
	RAISE NOTICE '[INFO] La table pop_agee_zx a été initialisée dans le schéma p_indicateurs';
	RAISE NOTICE '';

END;
$procedure$
