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

CREATE OR REPLACE PROCEDURE public.__init_niv_zoom()
 LANGUAGE plpgsql
AS $procedure$

-- Procédure SQL d'initialisation de la table niv_zoom (niveaux de zoom à afficher selon chaque indicateur) dans le schéma r_ressources
-- © Cerema / GT AgiRisk (auteure du script : Lucie)
-- Dernière mise à jour du script le 31/03/2023 par Sébastien

-- Commande d'appel à cette procédure :
-- CALL public.__init_niv_zoom();

BEGIN

	SET search_path TO r_ressources, public;

	RAISE NOTICE '';
	RAISE NOTICE '====== RAPPORT ======';
	RAISE NOTICE 'Initialisation de la table de définition des niveaux de zoom à afficher selon chaque indicateur';

	RAISE NOTICE 'Création de la structure de table attributaire niv_zoom';
	EXECUTE 'DROP TABLE IF EXISTS niv_zoom CASCADE';
	EXECUTE 'CREATE TABLE niv_zoom (
		id serial PRIMARY KEY,
		code_indic varchar(50),
		niv_zoom integer DEFAULT 0,
		type_result varchar(50))';
	RAISE NOTICE 'Création de la table niv_zoom effectuée';

	RAISE NOTICE 'Insertion des données dans la table niv_zoom';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''s1_2a'', ''Entite'', 0);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''s1_2a'', ''Hexag_1ha'', 1);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''s1_2a'', ''Hexag_5ha'', 2);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''s1_2a'', ''Hexag_10ha'', 3);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''s1_2a'', ''Hexag_50ha'', 4);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''s1_2a'', ''Hexag_100ha'', 5);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''s1_2a'', ''IRIS'', 6);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''s1_2a'', ''Commune'', 7);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''s1_2a'', ''EPCI'', 8);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''s1_2b'', ''Entite'', 0);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''s1_2b'', ''Hexag_1ha'', 1);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''s1_2b'', ''Hexag_5ha'', 2);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''s1_2b'', ''Hexag_10ha'', 3);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''s1_2b'', ''Hexag_50ha'', 4);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''s1_2b'', ''Hexag_100ha'', 5);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''s1_2b'', ''IRIS'', 6);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''s1_2b'', ''Commune'', 7);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''s1_2b'', ''EPCI'', 8);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''s2_14a'', ''Entite'', 0);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''s2_14a'', ''Entite'', 1);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''s2_14a'', ''Entite'', 2);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''s2_14a'', ''Entite'', 3);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''s2_14a'', ''Entite'', 4);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''s2_14a'', ''Entite'', 5);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''s2_14a'', ''IRIS'', 6);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''s2_14a'', ''Commune'', 7);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''s2_14a'', ''EPCI'', 8);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''s2_2a_amc'', ''Entite'', 0);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''s2_2a_amc'', ''Hexag_1ha'', 1);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''s2_2a_amc'', ''Hexag_5ha'', 2);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''s2_2a_amc'', ''Hexag_10ha'', 3);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''s2_2a_amc'', ''Hexag_50ha'', 4);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''s2_2a_amc'', ''Hexag_100ha'', 5);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''s2_2a_amc'', ''IRIS'', 6);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''s2_2a_amc'', ''Commune'', 7);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''s2_2a_amc'', ''EPCI'', 8);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''s2_6a'', ''Entite'', 0);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''s2_6a'', ''Entite'', 1);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''s2_6a'', ''Entite'', 2);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''s2_6a'', ''Entite'', 3);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''s2_6a'', ''Entite'', 4);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''s2_6a'', ''Entite'', 5);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''s2_6a'', ''IRIS'', 6);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''s2_6a'', ''Commune'', 7);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''s2_6a'', ''EPCI'', 8);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''s2_7a'', ''Entite'', 0);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''s2_7a'', ''Hexag_1ha'', 1);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''s2_7a'', ''Hexag_5ha'', 2);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''s2_7a'', ''Hexag_10ha'', 3);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''s2_7a'', ''Hexag_50ha'', 4);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''s2_7a'', ''Hexag_100ha'', 5);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''s2_7a'', ''IRIS'', 6);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''s2_7a'', ''Commune'', 7);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''s2_7a'', ''EPCI'', 8);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''s3_1a'', ''Entite'', 0);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''s3_1a'', ''Hexag_1ha'', 1);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''s3_1a'', ''Hexag_5ha'', 2);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''s3_1a'', ''Hexag_10ha'', 3);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''s3_1a'', ''Hexag_50ha'', 4);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''s3_1a'', ''Hexag_100ha'', 5);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''s3_1a'', ''IRIS'', 6);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''s3_1a'', ''Commune'', 7);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''s3_1a'', ''EPCI'', 8);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''s3_1f'', ''Entite'', 0);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''s3_1f'', ''Entite'', 1);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''s3_1f'', ''Entite'', 2);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''s3_1f'', ''Entite'', 3);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''s3_1f'', ''Entite'', 4);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''s3_1f'', ''Entite'', 5);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''s3_1f'', ''IRIS'', 6);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''s3_1f'', ''Commune'', 7);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''s3_1f'', ''EPCI'', 8);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''s3_2b'', ''Entite'', 0);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''s3_2b'', ''Hexag_1ha'', 1);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''s3_2b'', ''Hexag_5ha'', 2);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''s3_2b'', ''Hexag_10ha'', 3);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''s3_2b'', ''Hexag_50ha'', 4);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''s3_2b'', ''Hexag_100ha'', 5);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''s3_2b'', ''IRIS'', 6);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''s3_2b'', ''Commune'', 7);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''s3_2b'', ''EPCI'', 8);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''logt_zx'', ''Entite'', 0);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''logt_zx'', ''Hexag_1ha'', 1);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''logt_zx'', ''Hexag_5ha'', 2);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''logt_zx'', ''Hexag_10ha'', 3);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''logt_zx'', ''Hexag_50ha'', 4);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''logt_zx'', ''Hexag_100ha'', 5);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''logt_zx'', ''IRIS'', 6);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''logt_zx'', ''Commune'', 7);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''logt_zx'', ''EPCI'', 8);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''pop_agee_zx'', ''Entite'', 0);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''pop_agee_zx'', ''Hexag_1ha'', 1);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''pop_agee_zx'', ''Hexag_5ha'', 2);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''pop_agee_zx'', ''Hexag_10ha'', 3);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''pop_agee_zx'', ''Hexag_50ha'', 4);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''pop_agee_zx'', ''Hexag_100ha'', 5);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''pop_agee_zx'', ''IRIS'', 6);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''pop_agee_zx'', ''Commune'', 7);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''pop_agee_zx'', ''EPCI'', 8);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''salaries_zx'', ''Entite'', 0);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''salaries_zx'', ''Hexag_1ha'', 1);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''salaries_zx'', ''Hexag_5ha'', 2);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''salaries_zx'', ''Hexag_10ha'', 3);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''salaries_zx'', ''Hexag_50ha'', 4);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''salaries_zx'', ''Hexag_100ha'', 5);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''salaries_zx'', ''IRIS'', 6);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''salaries_zx'', ''Commune'', 7);';
	EXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''salaries_zx'', ''EPCI'', 8);';

	RAISE NOTICE '====== FIN TRAITEMENT ======';
	RAISE NOTICE '[INFO] La table niv_zoom a été initialisée dans le schéma r_ressources';
	RAISE NOTICE '';

END;
$procedure$
