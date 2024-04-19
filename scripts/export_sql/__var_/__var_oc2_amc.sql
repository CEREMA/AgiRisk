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

CREATE OR REPLACE FUNCTION public.__var_oc2_amc(nom_ter text, an_ff text, an_fch_acb text, an_bdtopo text)
 RETURNS void
 LANGUAGE plpgsql
AS $function$

-- Modalité de calcul d'Oc2 basée sur les fichiers AMC produits par le Cerema Méditerranée

-- Fonction SQL d'incrémentation du champ attributaire booléen oc2 (logements) dans la table c_occupation_sol.oc1 + alimentation de la table oc2_amc dans le schéma c_occupation_sol 
-- © Cerema / GT AgiRisk (auteurs du script : Lucie, Sébastien)
-- Dernières mises à jour du script le 12/04/2023 par Lucie et le 27/08/2023 par Sébastien (test avec succès sur Longuyon le 24/08/2023)

-- Paramètres d'entrée :
-- nom_ter = nom du territoire d'étude tel que renseigné dans le champ `territoire` de la table c_general.territoires
-- an_ff = millésime (année au format AAAA) des Fichiers Fonciers (FF)
-- an_fch_acb : millésime (année au format AAAA) des fichiers "logements" et "sous-sols" produits par le Cerema Méditerranée pour l'Analyse Coûts-Bénéfices (ACB) des projets de prévention des inondations (détail de la méthode dans cet article : https://www.cerema.fr/fr/actualites/cerema-ameliore-son-fichier-analyse-cout-benefice-projets)
-- an_bdtopo = millésime (année au format AAAA) de la BD TOPO®

-- Exemple d'appel à cette fonction :
-- SELECT public.__var_oc2_amc('Jura', '2021', '2021', '2022');

DECLARE
	c_nb_logts integer; -- un compteur des lignes modifiées pour logging
	c_ssol_ind integer; -- un compteur des lignes modifiées pour logging
	c_ssol_col integer; -- un compteur des lignes modifiées pour logging
	c_oc2_true integer; -- un compteur des lignes modifiées pour logging
	c_oc2_false integer; -- un compteur des lignes modifiées pour logging
	heure1 varchar; -- heure de début du traitement
	heure2 varchar; -- heure intermédiaire
	heure3 varchar; -- heure intermédiaire
	heure4 varchar; -- heure intermédiaire
	heure5 varchar; -- heure intermédiaire
	heure6 varchar; -- heure intermédiaire
	heure7 varchar; -- heure intermédiaire
	heure8 varchar; -- heure intermédiaire
	heure9 varchar; -- heure intermédiaire
	heure10 varchar; -- heure intermédiaire
	heure11 varchar; -- heure intermédiaire
	heure12 varchar; -- heure intermédiaire
	heure13 varchar; -- heure de fin du traitement

BEGIN
	heure1 = clock_timestamp();

	--************************************************************************
	-- Définition des schémas de travail
	--************************************************************************
	SET SEARCH_PATH TO c_general, c_phenomenes, c_occupation_sol, r_ign_bdtopo, public;

	RAISE NOTICE '';
	RAISE NOTICE '====== RAPPORT ======';
	RAISE NOTICE 'Calcul de la variable Oc2 (logements) selon la méthode utilisant les fichiers AMC sur le territoire "%"', nom_ter;
	RAISE NOTICE 'Début du traitement : %', heure1;
	RAISE NOTICE '';

	--************************************************************************
	-- Vérification de l'existence du territoire renseigné dans la table c_general.territoires
	--************************************************************************
	IF NOT EXISTS (
		SELECT *
		FROM c_general.territoires
		WHERE territoire = ''||nom_ter||''
	)
	THEN
		RAISE EXCEPTION 'Il n''y a pas de territoire "%" dans la table c_general.territoires. Fin de l''exécution', nom_ter;
	END IF;

	--************************************************************************
	-- Vérification de l'absence du territoire renseigné dans la table c_occupation_sol.oc2_amc
	--************************************************************************
	IF EXISTS (
		SELECT *
		FROM c_occupation_sol.oc2_amc
		WHERE territoire = ''||nom_ter||''
	)
	THEN
		RAISE EXCEPTION 'Il existe déjà des enregistrements pour le territoire "%" dans la table c_occupation_sol.oc2_amc. 
		Pour les supprimer, lancer la requête suivante : 
		DELETE FROM c_occupation_sol.oc2_amc WHERE territoire = ''%'';', nom_ter, REPLACE(nom_ter,'''','''''');
	END IF;

	--************************************************************************
	-- Mise à jour de la table c_occupation_sol.oc2_amc correspondant aux logements et sous-sols issus des fichiers ACB qui intersectent les bâtiments de la BD TOPO®
	--************************************************************************
	RAISE NOTICE 'Mise à jour de la table c_occupation_sol.oc2_amc';
	EXECUTE 'INSERT INTO c_occupation_sol.oc2_amc(
			territoire,
			id_bdt,
			nb_logts_ind,
			nb_appts,
			id_logt,
			type_logt,
			niv_logt,
			typo_acb,
			surf_polygon_tot,
			surf_rdc_rect_tot,
			sous_sol,
			surf_ssol_tot_bat,
			surf_ssol_rap_logt,
			sce_donnee,
			moda_calc,
			date_calc,
			geom,
			geomloc
		)
		SELECT DISTINCT
			oc1.territoire AS territoire,
			oc1.id_bdt AS id_bdt,
			0 AS nb_logts_ind,
			0 AS nb_appts,
			logts_acb.id AS id_logt,
			logts_acb.type_logt AS type_logt,
			''NON PRECISE'' AS niv_logt,
			logts_acb.typo_acb AS typo_acb,
			ROUND(CAST(ST_Area(oc1.geom) AS numeric),2) AS surf_polygon_tot,
			logts_acb.surf_rect AS surf_rdc_rect_tot,
			false AS sous_sol,
			0 AS surf_ssol_tot_bat,
			0 AS surf_ssol_rap_logt,
			''Fichiers AMC '||an_fch_acb||' (données foncières retraitées par le Cerema)'' AS sce_donnee,
			''__var_oc2_amc'' AS moda_calc,
			current_date AS date_calc,
			oc1.geom AS geom,
			logts_acb.geom AS geomloc
		FROM c_occupation_sol.oc1 AS oc1, r_cerema_acb.logements_'||an_fch_acb||' AS logts_acb
		WHERE __util_to_snake_case(oc1.territoire) = '''||__util_to_snake_case(nom_ter)||''' -- attention, certains points peuvent être situés en dehors des polygones (TO-DO : méthode à optimiser)
			AND ST_Within(logts_acb.geom, oc1.geom)';

	GET DIAGNOSTICS c_nb_logts = row_count;

	heure2 = clock_timestamp();
	RAISE NOTICE 'Durée de l''étape de mise à jour de la table oc2_amc : %', CAST(heure2 as time)-CAST(heure1 as time);

	--************************************************************************
	-- Calcul du nombre total de logements individuels dans le bâtiment
	--************************************************************************
	RAISE NOTICE '';
	RAISE NOTICE 'Calcul du nombre total de logements individuels et d''appartements dans le bâtiment';

	EXECUTE 'DROP TABLE IF EXISTS nb_logts_ind_temp CASCADE';
	EXECUTE 'CREATE TEMP TABLE nb_logts_ind_temp AS
		SELECT id_bdt AS id_bdt_temp, COUNT(id_logt) AS nb_logts_ind_temp
		FROM c_occupation_sol.oc2_amc
		WHERE __util_to_snake_case(territoire) = '''||__util_to_snake_case(nom_ter)||''' AND type_logt = ''MAISON'' 
		GROUP BY id_bdt_temp';
	EXECUTE 'CREATE INDEX ON nb_logts_ind_temp USING btree(id_bdt_temp)';
	EXECUTE '
		UPDATE c_occupation_sol.oc2_amc
		SET nb_logts_ind = nb_logts_ind_temp.nb_logts_ind_temp
		FROM nb_logts_ind_temp
		WHERE id_bdt = nb_logts_ind_temp.id_bdt_temp';

	--************************************************************************
	-- Calcul du nombre total d'appartements dans le bâtiment
	--************************************************************************
	EXECUTE 'DROP TABLE IF EXISTS nb_appts_temp CASCADE';
	EXECUTE 'CREATE TEMP TABLE nb_appts_temp AS
		SELECT id_bdt AS id_bdt_temp, COUNT(id_logt) AS nb_appts_temp
		FROM c_occupation_sol.oc2_amc
		WHERE __util_to_snake_case(territoire) = '''||__util_to_snake_case(nom_ter)||''' AND type_logt = ''APPARTEMENT'' 
		GROUP BY id_bdt_temp';
	EXECUTE 'CREATE INDEX ON nb_appts_temp USING btree(id_bdt_temp)';
	EXECUTE '
		UPDATE c_occupation_sol.oc2_amc
		SET nb_appts = nb_appts_temp.nb_appts_temp
		FROM nb_appts_temp
		WHERE id_bdt = nb_appts_temp.id_bdt_temp';

	heure3 = clock_timestamp();
	RAISE NOTICE 'Durée de l''étape de calcul du nombre total de logements individuels et d''appartements dans le bâtiment : %', CAST(heure3 as time)-CAST(heure2 as time);

	--************************************************************************
	-- Précision sur la localisation (niveau) du logement dans le bâtiment
	--************************************************************************
	RAISE NOTICE '';
	RAISE NOTICE 'Mise à jour du champ niv_logt de la table c_occupation_sol.oc2_amc'; -- Update oc2_amc.niv_logt

	EXECUTE '
		UPDATE c_occupation_sol.oc2_amc
		SET niv_logt = (
			CASE
				WHEN typo_acb LIKE ''INDIVIDUEL%'' OR typo_acb = ''COLLECTIF'' THEN ''REZ-DE-CHAUSSEE''
				WHEN typo_acb = ''AUTRE'' THEN ''ETAGE''
				ELSE niv_logt
		END)';

	heure4 = clock_timestamp();
	RAISE NOTICE 'Durée de l''étape de mise à jour du champ oc2_amc.niv_logt : %', CAST(heure4 as time)-CAST(heure3 as time);

	--************************************************************************
	-- Identification des logements possédant un sous-sol à partir du fichier produit par le Cerema Méditerranée
	--************************************************************************
	RAISE NOTICE '';
	RAISE NOTICE 'Identification des logements possédant un sous-sol';

	-- Sous-sols individuels
	EXECUTE '
		UPDATE c_occupation_sol.oc2_amc
		SET sous_sol = true,
			surf_ssol_tot_bat = ssol.surf_ssol,
			surf_ssol_rap_logt = ssol.surf_ssol / nb_logts_ind
		FROM r_cerema_acb.sous_sols_'||an_fch_acb||' AS ssol
		WHERE __util_to_snake_case(c_occupation_sol.oc2_amc.territoire) = '''||__util_to_snake_case(nom_ter)||'''		
			AND c_occupation_sol.oc2_amc.nb_logts_ind > 0
			AND c_occupation_sol.oc2_amc.type_logt = ''MAISON''
			AND ssol.typo_acb = ''INDIVIDUEL''
			AND ST_Intersects(ssol.geom, oc2_amc.geomloc)';

	GET DIAGNOSTICS c_ssol_ind = row_count;

	-- Sous-sols collectifs
	EXECUTE '
		UPDATE c_occupation_sol.oc2_amc
		SET sous_sol = true,
			surf_ssol_tot_bat = ssol.surf_ssol,
			surf_ssol_rap_logt = ssol.surf_ssol / nb_appts
		FROM r_cerema_acb.sous_sols_'||an_fch_acb||' AS ssol
		WHERE __util_to_snake_case(c_occupation_sol.oc2_amc.territoire) = '''||__util_to_snake_case(nom_ter)||'''
			AND c_occupation_sol.oc2_amc.nb_appts > 0			
			AND c_occupation_sol.oc2_amc.type_logt = ''APPARTEMENT''
			AND ssol.typo_acb = ''COLLECTIF''
			AND ST_Intersects(ssol.geom, oc2_amc.geomloc)';

	GET DIAGNOSTICS c_ssol_col = row_count;

	RAISE NOTICE 'Table c_occupation_sol.oc2_amc mise à jour';

	heure5 = clock_timestamp();
	RAISE NOTICE 'Durée de l''étape d''identification des logements possédant un sous-sol : %', CAST(heure5 as time)-CAST(heure4 as time);

	--************************************************************************
	-- Création de la vue matérialisée oc2_amc sur le territoire
	--************************************************************************
	RAISE NOTICE '';
	RAISE NOTICE 'Création de la vue matérialisée %', 'c_occupation_sol.oc2_amc_'||__util_to_snake_case(nom_ter);
	EXECUTE '
		DROP MATERIALIZED VIEW IF EXISTS c_occupation_sol.oc2_amc_'||__util_to_snake_case(nom_ter)||' CASCADE;
		CREATE MATERIALIZED VIEW c_occupation_sol.oc2_amc_'||__util_to_snake_case(nom_ter)||' AS
		SELECT *
		FROM c_occupation_sol.oc2_amc
		WHERE __util_to_snake_case(territoire) = '''||__util_to_snake_case(nom_ter)||'''';

	RAISE NOTICE 'Vue matérialisée créée';
	heure6 = clock_timestamp();
	RAISE NOTICE 'Durée de l''étape de création de la vue matérialisée : %', CAST(heure6 as time)-CAST(heure5 as time);

	-- Création des index sur la vue matérialisée
	RAISE NOTICE 'Création des index sur la vue matérialisée';

	EXECUTE 'CREATE UNIQUE INDEX ON c_occupation_sol.oc2_amc_'||__util_to_snake_case(nom_ter)||' (id)';

	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc2_amc_'||__util_to_snake_case(nom_ter)||' USING gist(geom)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc2_amc_'||__util_to_snake_case(nom_ter)||' USING gist(geomloc)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc2_amc_'||__util_to_snake_case(nom_ter)||' USING btree(id)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc2_amc_'||__util_to_snake_case(nom_ter)||' USING btree(territoire)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc2_amc_'||__util_to_snake_case(nom_ter)||' USING btree(id_bdt)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc2_amc_'||__util_to_snake_case(nom_ter)||' USING btree(nb_logts_ind)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc2_amc_'||__util_to_snake_case(nom_ter)||' USING btree(nb_appts)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc2_amc_'||__util_to_snake_case(nom_ter)||' USING btree(id_logt)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc2_amc_'||__util_to_snake_case(nom_ter)||' USING btree(type_logt)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc2_amc_'||__util_to_snake_case(nom_ter)||' USING btree(niv_logt)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc2_amc_'||__util_to_snake_case(nom_ter)||' USING btree(typo_acb)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc2_amc_'||__util_to_snake_case(nom_ter)||' USING btree(surf_polygon_tot)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc2_amc_'||__util_to_snake_case(nom_ter)||' USING btree(surf_rdc_rect_tot)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc2_amc_'||__util_to_snake_case(nom_ter)||' USING btree(sous_sol)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc2_amc_'||__util_to_snake_case(nom_ter)||' USING btree(surf_ssol_tot_bat)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc2_amc_'||__util_to_snake_case(nom_ter)||' USING btree(surf_ssol_rap_logt)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc2_amc_'||__util_to_snake_case(nom_ter)||' USING btree(sce_donnee)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc2_amc_'||__util_to_snake_case(nom_ter)||' USING btree(moda_calc)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc2_amc_'||__util_to_snake_case(nom_ter)||' USING btree(date_calc)';

	RAISE NOTICE 'Index créés sur la vue matérialisée';
	heure7 = clock_timestamp();
	RAISE NOTICE 'Durée de l''étape de création des index sur la vue matérialisée : %', CAST(heure7 as time)-CAST(heure6 as time);

	heure8 = clock_timestamp();
	RAISE NOTICE 'Durée de l''étape de création de la vue matérialisée : %', CAST(heure8 as time)-CAST(heure7 as time);

	--************************************************************************
	-- Requêtes mettant à jour le champ booléen oc2 de la table oc1 avec les informations de la table oc2_amc
	--************************************************************************
	RAISE NOTICE '';
	RAISE NOTICE 'Mise à jour du champ oc2 de la table c_occupation_sol.oc1 ...';
		EXECUTE '
			UPDATE c_occupation_sol.oc1
			SET oc2 = ''true''
			FROM c_occupation_sol.oc2_amc
			WHERE __util_to_snake_case(oc1.territoire) = '''||__util_to_snake_case(nom_ter)||'''
				AND oc1.id_bdt = oc2_amc.id_bdt';

		GET DIAGNOSTICS c_oc2_true = row_count;

		EXECUTE '
			UPDATE c_occupation_sol.oc1
			SET oc2 = ''false''
			WHERE __util_to_snake_case(territoire) = '''||__util_to_snake_case(nom_ter)||'''
				AND id_bdt NOT IN
			(
				SELECT id_bdt
				FROM oc1
				WHERE __util_to_snake_case(territoire) = '''||__util_to_snake_case(nom_ter)||'''
					AND oc2 = ''true''
			)';

		GET DIAGNOSTICS c_oc2_false = row_count;

	RAISE NOTICE 'Mise à jour du champ oc2 de la table c_occupation_sol.oc1 effectuée';

	heure9 = clock_timestamp();
	RAISE NOTICE 'Durée des requêtes mettant à jour le champ booléen oc2 de la table oc1 : %', CAST(heure9 as time)-CAST(heure8 as time);

	--************************************************************************
	-- Requête mettant à jour le champ nb_logts_corr de la table oc1
	--************************************************************************
	RAISE NOTICE '';
	RAISE NOTICE 'Mise à jour du champ nb_logts_corr de la table c_occupation_sol.oc1 ...';
	EXECUTE '
		UPDATE c_occupation_sol.oc1
		SET nb_logts_corr =
			CASE
				WHEN nb_logts_bdt IS NULL AND oc2 = ''false'' THEN 0
				WHEN nb_logts_bdt IS NULL AND oc2 = ''true'' THEN oc2_amc.nb_logts_ind + oc2_amc.nb_appts
				WHEN nb_logts_bdt <> oc2_amc.nb_logts_ind + oc2_amc.nb_appts THEN oc2_amc.nb_logts_ind + oc2_amc.nb_appts
				ELSE nb_logts_bdt
			END
		FROM c_occupation_sol.oc2_amc
		WHERE __util_to_snake_case(oc1.territoire) = '''||__util_to_snake_case(nom_ter)||'''
			AND oc1.id_bdt = oc2_amc.id_bdt';
		
	RAISE NOTICE 'Mise à jour du champ nb_logts_corr de la table c_occupation_sol.oc1 effectuée';

	heure10 = clock_timestamp();
	RAISE NOTICE 'Durée de la requête de mise à jour du champ nb_logts_corr de la table oc1 : %', CAST(heure10 as time)-CAST(heure9 as time);

	--************************************************************************
	-- Mise à jour de la vue matérialisée oc1 sur le territoire
	--************************************************************************
	RAISE NOTICE '';
	RAISE NOTICE 'Création de la vue matérialisée %', 'c_occupation_sol.oc1_'||__util_to_snake_case(nom_ter);
	EXECUTE '
		DROP MATERIALIZED VIEW IF EXISTS c_occupation_sol.oc1_'||__util_to_snake_case(nom_ter)||' CASCADE;
		CREATE MATERIALIZED VIEW c_occupation_sol.oc1_'||__util_to_snake_case(nom_ter)||' AS
		SELECT *
		FROM c_occupation_sol.oc1
		WHERE __util_to_snake_case(territoire) = '''||__util_to_snake_case(nom_ter)||'''
		ORDER BY nom_iris';

	RAISE NOTICE 'Vue matérialisée créée';
	heure11 = clock_timestamp();
	RAISE NOTICE 'Durée de l''étape de création de la vue matérialisée : %', CAST(heure11 as time)-CAST(heure10 as time);

	-- Création des index sur la vue matérialisée
	RAISE NOTICE 'Création des index sur la vue matérialisée';

	EXECUTE 'CREATE UNIQUE INDEX ON c_occupation_sol.oc1_'||__util_to_snake_case(nom_ter)||' (id)';

	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc1_'||__util_to_snake_case(nom_ter)||' USING gist(geom)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc1_'||__util_to_snake_case(nom_ter)||' USING gist(geomloc)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc1_'||__util_to_snake_case(nom_ter)||' USING btree(id)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc1_'||__util_to_snake_case(nom_ter)||' USING btree(territoire)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc1_'||__util_to_snake_case(nom_ter)||' USING btree(id_iris)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc1_'||__util_to_snake_case(nom_ter)||' USING btree(nom_iris)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc1_'||__util_to_snake_case(nom_ter)||' USING btree(id_bdt)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc1_'||__util_to_snake_case(nom_ter)||' USING btree(nature)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc1_'||__util_to_snake_case(nom_ter)||' USING btree(usage1)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc1_'||__util_to_snake_case(nom_ter)||' USING btree(usage2)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc1_'||__util_to_snake_case(nom_ter)||' USING btree(leger)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc1_'||__util_to_snake_case(nom_ter)||' USING btree(etat)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc1_'||__util_to_snake_case(nom_ter)||' USING btree(hauteur_bdt)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc1_'||__util_to_snake_case(nom_ter)||' USING btree(hauteur_corr)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc1_'||__util_to_snake_case(nom_ter)||' USING btree(nb_logts_bdt)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc1_'||__util_to_snake_case(nom_ter)||' USING btree(nb_logts_corr)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc1_'||__util_to_snake_case(nom_ter)||' USING btree(nb_etages_bdt)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc1_'||__util_to_snake_case(nom_ter)||' USING btree(nb_etages_corr)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc1_'||__util_to_snake_case(nom_ter)||' USING btree(plainpied)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc1_'||__util_to_snake_case(nom_ter)||' USING btree(idtup)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc1_'||__util_to_snake_case(nom_ter)||' USING btree(tlocdomin_ff)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc1_'||__util_to_snake_case(nom_ter)||' USING btree(oc2)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc1_'||__util_to_snake_case(nom_ter)||' USING btree(oc3)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc1_'||__util_to_snake_case(nom_ter)||' USING btree(pop1)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc1_'||__util_to_snake_case(nom_ter)||' USING btree(pop1_agee)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc1_'||__util_to_snake_case(nom_ter)||' USING btree(pop2_bas)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc1_'||__util_to_snake_case(nom_ter)||' USING btree(pop2_haut)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc1_'||__util_to_snake_case(nom_ter)||' USING btree(pop3)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc1_'||__util_to_snake_case(nom_ter)||' USING btree(pop4)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc1_'||__util_to_snake_case(nom_ter)||' USING btree(pop5)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc1_'||__util_to_snake_case(nom_ter)||' USING btree(pop6_bas)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc1_'||__util_to_snake_case(nom_ter)||' USING btree(pop6_haut)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc1_'||__util_to_snake_case(nom_ter)||' USING btree(capacite_touristique)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc1_'||__util_to_snake_case(nom_ter)||' USING btree(sce_donnee)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc1_'||__util_to_snake_case(nom_ter)||' USING btree(moda_calc)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc1_'||__util_to_snake_case(nom_ter)||' USING btree(date_calc)';

	RAISE NOTICE 'Index créés sur la vue matérialisée';
	heure12 = clock_timestamp();
	RAISE NOTICE 'Durée de l''étape de création des index sur la vue matérialisée : %', CAST(heure12 as time)-CAST(heure11 as time);

	--************************************************************************
	-- Conclusion
	--************************************************************************
	RAISE NOTICE '';
	RAISE NOTICE '====== FIN TRAITEMENT ======';
	RAISE NOTICE '[INFO] Le champ oc2 (logements) a été mis à jour et indexé dans la couche oc1 (bâtiments) sur le territoire "%"', nom_ter;
	RAISE NOTICE '';
	RAISE NOTICE '====== RÉSULTATS ======';
	IF c_nb_logts > 1
		THEN RAISE NOTICE '% logements insérés au total dans la table c_occupation_sol.oc2_amc pour le territoire "%"', c_nb_logts, nom_ter;
		ELSE RAISE NOTICE '% logement inséré dans la table c_occupation_sol.oc2_amc pour le territoire "%"', c_nb_logts, nom_ter;
	END IF;
	IF c_ssol_ind+c_ssol_col > 1
		THEN RAISE NOTICE '% sous-sols identifiés au total sur le territoire "%"', c_ssol_ind+c_ssol_col, nom_ter;
		ELSE RAISE NOTICE '% sous-sol identifié sur le territoire "%"', c_ssol_ind+c_ssol_col, nom_ter;
	END IF;
	IF c_oc2_true+c_oc2_false > 1
		THEN RAISE NOTICE '% enregistrements mis à jour dans la table c_occupation_sol.oc1 pour le territoire "%"', c_oc2_true+c_oc2_false, nom_ter;
		ELSE RAISE NOTICE '% enregistrement mis à jour dans la table c_occupation_sol.oc1 pour le territoire "%"', c_oc2_true+c_oc2_false, nom_ter;
	END IF;
	RAISE NOTICE '';
	heure13 = clock_timestamp();
	RAISE NOTICE 'Fin du traitement : %', heure13;
	RAISE NOTICE 'Durée du traitement : %', CAST(heure13 as time)-CAST(heure1 as time);
	RAISE NOTICE '';

END;
$function$
