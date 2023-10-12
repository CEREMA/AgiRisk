SET client_encoding = 'UTF8';

CREATE OR REPLACE PROCEDURE public.__init_db()
 LANGUAGE plpgsql
AS $procedure$

-- Procédure SQL d'initialisation de toute la base de données
-- © Cerema / GT AgiRisk
-- Dernière mise à jour du script le 26/08/2023 par Sébastien  puis le 26/09/2023 par Aurélien

-- Commande d'appel à cette procédure :
-- CALL public.__init_db();

DECLARE
	heure1 varchar; -- heure de début du traitement
	heure2 varchar; -- heure de fin du traitement

BEGIN
	heure1 = current_timestamp;

	RAISE NOTICE '';
	RAISE NOTICE '====== INITIALISATION DE LA BASE DE DONNÉES ======';
	RAISE NOTICE 'Début du traitement : %', heure1;
	RAISE NOTICE '';

	--************************************************************************
	-- Activation des extensions nécessaires au fonctionnement d'AgiRisk
	--************************************************************************
--	CREATE EXTENSION IF NOT EXISTS postgis;
--	CREATE EXTENSION IF NOT EXISTS unaccent;

--	RAISE NOTICE 'Activation des extensions nécessaires au fonctionnement d''AgiRisk effectuée';

	--************************************************************************
	-- Initialisation de la table des styles dans le schéma public
	--************************************************************************
--	CALL public.__init_layer_styles();

	--************************************************************************
	-- Commande pour éviter d'avoir une erreur postgis lors de l'utilisation du plugin AgiRisk
	--************************************************************************
--	GRANT SELECT ON TABLE public.layer_styles TO user_agirisk;

	--************************************************************************
	-- Appel de toutes les variables (hors tables d'aléa)
	--************************************************************************
	-- Variables Phénomènes
--	CALL public.__init_zt();

	-- Variables Occupation du sol
	CALL public.__init_oc0();
	CALL public.__init_oc1();
	CALL public.__init_oc2_amc();
--	CALL public.__init_oc2_ref();
	CALL public.__init_oc3();
	CALL public.__init_oc5();
	CALL public.__init_oc7();
	CALL public.__init_oc11();

	RAISE NOTICE 'Création des structures des tables attributaires des variables effectuée';

	--************************************************************************
	-- Appel de tous les indicateurs et de toutes leurs représentations cartographiques
	--************************************************************************
	-- Indicateurs associés à l'objectif 1 de la SNGRI (sécurité des personnes)
	CALL public.__init_s1_2a();
	CALL public.__init_s1_2a_rc();
	CALL public.__init_s1_2b();
	CALL public.__init_s1_2b_rc();

	-- Indicateurs associés à l'objectif 2 de la SNGRI (réduction du coût des dommages)
	CALL public.__init_s2_2a_amc();
	CALL public.__init_s2_2a_amc_rc();
	CALL public.__init_s2_6a();
	CALL public.__init_s2_6a_rc();
	CALL public.__init_s2_14a();
	CALL public.__init_s2_14a_rc();

	-- Indicateurs associés à l'objectif 3 de la SNGRI (retour rapide à la normale)
	CALL public.__init_s3_1a();
	CALL public.__init_s3_1a_rc();
	CALL public.__init_s3_1f();
	CALL public.__init_s3_1f_rc();
	CALL public.__init_s3_2b();
	CALL public.__init_s3_2b_rc();

	-- Autres indicateurs
	CALL public.__init_logt_zx();
	CALL public.__init_logt_zx_rc();
	CALL public.__init_pop_agee_zx();
	CALL public.__init_pop_agee_zx_rc();
	CALL public.__init_salaries_zx();
	CALL public.__init_salaries_zx_rc();

	RAISE NOTICE 'Création des structures des tables attributaires des indicateurs et de leur représentation cartographique effectuée';

	--************************************************************************
	-- Conclusion
	--************************************************************************
	RAISE NOTICE '';
	RAISE NOTICE '====== FIN TRAITEMENT ======';
	RAISE NOTICE '[INFO] La base de données a été initialisée';
	RAISE NOTICE '';
   	heure2 = clock_timestamp();
	RAISE NOTICE 'Fin du traitement : %', heure2;
	RAISE NOTICE 'Durée du traitement : %', CAST(heure2 as time)-CAST(heure1 as time);
	RAISE NOTICE '';

END;
$procedure$
