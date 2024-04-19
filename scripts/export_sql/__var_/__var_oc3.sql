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

CREATE OR REPLACE FUNCTION public.__var_oc3(nom_ter text, an_lien text, an_bdtopo text, an_siren text)
 RETURNS void
 LANGUAGE plpgsql
AS $function$

-- Fonction SQL d'incrémentation du champ attributaire booléen oc3 (activités) et des champs pop2_haut et pop2_bas (employés) dans la table c_occupation_sol.oc1
-- © Cerema / GT AgiRisk (auteur principal du script : Aurélien)
-- Dernière mise à jour du script le 27/08/2023 par Sébastien (test avec succès sur Longuyon le 24/08/2023)  puis le 26/09/2023 par Aurélien

-- Paramètres d'entrée :
-- nom_ter = nom du territoire d'étude tel que renseigné dans le champ `territoire` de la table c_general.territoires
-- an_lien = millésime (année au format AAAA) de la base ADRESSE PREMIUM
-- an_bdtopo = millésime (année au format AAAA) de la BD TOPO®
-- an_siren = millésime (année au format AAAA) des points SIRENE V3 récupérés depuis le site https://public.opendatasoft.com/explore/dataset/economicref-france-sirene-v3/

-- Exemple d'appel à cette fonction :
-- SELECT public.__var_oc3('Jura', '2022', '2022', '2022');

DECLARE
	c integer; -- un compteur des lignes modifiées pour logging
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
	heure13 varchar; -- heure intermédiaire
	heure14 varchar; -- heure intermédiaire
	heure15 varchar; -- heure intermédiaire
	heure16 varchar; -- heure de fin du traitement

BEGIN
	heure1 = clock_timestamp();

	--************************************************************************
	-- Définition des schémas de travail
	--************************************************************************
	SET SEARCH_PATH TO public, c_general, c_phenomenes, c_occupation_sol, r_ign_bdtopo, r_insee_sirene, r_ban_plus;

	RAISE NOTICE '';
	RAISE NOTICE '====== RAPPORT ======';
	RAISE NOTICE 'Calcul de la variable Oc3 (bâtiments d''activité) sur le territoire "%"', nom_ter;
	RAISE NOTICE 'Début du traitement : %', heure1;

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
	-- Vérification de l'absence du territoire renseigné dans la table c_occupation_sol.oc3
	--************************************************************************
	IF EXISTS (
		SELECT *
		FROM c_occupation_sol.oc3
		WHERE territoire = ''||nom_ter||''
	)
	THEN
		RAISE EXCEPTION 'Il existe déjà des enregistrements pour le territoire "%" dans la table c_occupation_sol.oc3. 
		Pour les supprimer, lancer la requête suivante : 
		DELETE FROM c_occupation_sol.oc3 WHERE territoire = ''%'';', nom_ter, REPLACE(nom_ter,'''','''''');
	END IF;

	--************************************************************************
	-- Méthode de calcul Oc3
	--************************************************************************
	-- On apparie les points geosiren avec les bâtiments de la BDTOPO en 2 temps :
		-- lien entre les points geosiren et les points adresse ;
		-- lien avec les bâtiments avec la base adresse premium, couche bati-adresse.

	--************************************************************************
	-- PARTIE 1 : sélection des points geosiren dans le périmètre du territoire
	--************************************************************************
	RAISE NOTICE '';
	RAISE NOTICE '====== DÉBUT PARTIE 1 ======';
	RAISE NOTICE '-- 1a. Création de la couche de points geosiren sur le territoire';
	EXECUTE 'DROP TABLE IF EXISTS geosiren_terr CASCADE';
	EXECUTE 'CREATE TEMP TABLE geosiren_terr AS
		SELECT 
			siret, etablissementsiege, trancheeffectifsetablissement, trancheeffectifsetablissementtriable,
			activiteprincipaleetablissement, etatadministratifetablissement,
			numerovoieetablissement as numero_sirene,
			CASE 
				WHEN typevoieetablissement IS NULL THEN unaccent(lower(libellevoieetablissement))
				ELSE unaccent(lower(typevoieetablissement)||'' ''||lower(libellevoieetablissement))
			END::varchar as adresse_sirene,
			a.geom
		FROM sirene_v3_'||an_siren||' a
		JOIN territoires b
		ON ST_Intersects(a.geom,b.geom)
		WHERE __util_to_snake_case(territoire) = '''||__util_to_snake_case(nom_ter)||'''';

		/* trancheeffectifsetablissementtriable
		-1 : Unité non employeuse (pas de salarié au cours de l'année de référence et pas d'effectif au 31/12)
		0 : 0 salarié (n'ayant pas d'effectif au 31/12 mais ayant employé des salariés au cours de l'année de référence)
		1 : 1 ou 2 salariés
		2 : 3 à 5 salariés
		3 : 6 à 9 salariés
		11 : 10 à 19 salariés
		12 : 20 à 49 salariés
		21 : 50 à 99 salariés
		22 : 100 à 199 salariés
		31 : 200 à 249 salariés
		32 : 250 à 499 salariés
		41 : 500 à 999 salariés
		42 : 1 000 à 1 999 salariés
		51 : 2 000 à 4 999 salariés
		52 : 5 000 à 9 999 salariés
		53 : 10 000 salariés et plus */

	EXECUTE 'CREATE INDEX ON geosiren_terr USING btree(siret)';
	EXECUTE 'CREATE INDEX ON geosiren_terr USING gist(geom)';
	-- EXECUTE 'CREATE INDEX ON geosiren_terr USING gist(adresse_sirene gist_trgm_ops(siglen=2000))';	

	RAISE NOTICE '-- 1b. Création de la couche des bâtiments sur le territoire';
	-- Bâtiments sur territoire (au minimum 25m²)
	EXECUTE 'DROP TABLE IF EXISTS bat_terr CASCADE';
	EXECUTE 'CREATE TEMP TABLE bat_terr AS
		SELECT 
			a.id,a.geom
		FROM batiment_'||an_bdtopo||' a
		JOIN territoires b
		ON ST_Intersects(a.geom,b.geom)
		WHERE __util_to_snake_case(territoire) = '''||__util_to_snake_case(nom_ter)||'''
			AND ST_area(a.geom)>25';

	EXECUTE 'CREATE INDEX ON bat_terr using gist(geom)';
	EXECUTE 'CREATE INDEX ON bat_terr using btree(id)';

	heure2 = clock_timestamp();

	RAISE NOTICE '-- 1c. Création de la couche adresse sur le territoire';
	EXECUTE 'DROP TABLE IF EXISTS decode_adresse CASCADE';
	EXECUTE 'CREATE TEMP TABLE decode_adresse AS
		SELECT 
			nom_voie as adresse_ban,
			a.id_adr id,numero as numero_ban,rep,insee_com,a.geom		
		 FROM adresse_'||an_bdtopo||' a, territoires b
		 WHERE __util_to_snake_case(territoire) = '''||__util_to_snake_case(nom_ter)||'''
		 		AND a.insee_dep = any(b.insee_dep)';

	EXECUTE 'CREATE INDEX ON decode_adresse using gist(geom)';

	heure3 = clock_timestamp();
	RAISE NOTICE 'Durée de l''étape de création de la couche decode_adresse : %', CAST(heure3 as time)-CAST(heure2 as time);

	EXECUTE 'DROP TABLE IF EXISTS adresse_terr CASCADE';
	EXECUTE 'CREATE TEMP TABLE adresse_terr AS
		SELECT
			a.id,c.nom,numero_ban,adresse_ban,a.geom
		FROM decode_adresse a
		JOIN territoires b
		ON ST_Intersects(a.geom,b.geom)
		JOIN commune_'||an_bdtopo||' c
		ON a.insee_com=c.insee_com
		WHERE __util_to_snake_case(territoire) = '''||__util_to_snake_case(nom_ter)||'''';

	EXECUTE 'CREATE INDEX ON adresse_terr using gist(geom)';

	heure4 = clock_timestamp();
	RAISE NOTICE 'Durée de l''étape de création de la couche adresse_terr : %', CAST(heure4 as time)-CAST(heure3 as time);

	RAISE NOTICE '-- 1d. Création de la couche du lien bati-adresse sur le territoire';
	EXECUTE 'DROP TABLE IF EXISTS lien_adresse_terr CASCADE';
	EXECUTE 'CREATE TEMP TABLE lien_adresse_terr AS
		SELECT DISTINCT
			a.id_bat,a.id_adr,a.geom as geom
		FROM lien_adresse_bati_'||an_lien||' a
		JOIN territoires b
		ON ST_Intersects(a.geom,b.geom)
		WHERE __util_to_snake_case(territoire) = '''||__util_to_snake_case(nom_ter)||'''';

	EXECUTE 'CREATE INDEX ON lien_adresse_terr using gist(geom)';
	EXECUTE 'CREATE INDEX ON lien_adresse_terr using btree(id_adr)';

	heure5 = clock_timestamp();
	RAISE NOTICE 'Durée de l''étape de création de la couche du lien bati-adresse : %', CAST(heure5 as time)-CAST(heure4 as time);

	RAISE NOTICE 'Durée de la PARTIE 1 : %', CAST(heure5 as time)-CAST(heure1 as time);

	RAISE NOTICE '====== FIN PARTIE 1 ======';
	RAISE NOTICE '';

	--**********************************************************		
	-- PARTIE 2 : rapprochement points adresse et points geosiren
	--**********************************************************
	RAISE NOTICE '====== DÉBUT PARTIE 2 ======';
	-- Cas1 : les points geosirene et BAN sont identiques (tolérance de 1m)
	RAISE NOTICE '-- 2a. Cas1 : les points geosirene et BAN sont identiques (tolérance de 1m)';

	EXECUTE 'DROP TABLE IF EXISTS buffer_sirene_1m CASCADE'; -- création couche buffer autour des points sirene buffer = 1m
	EXECUTE 'CREATE TEMP TABLE buffer_sirene_1m AS
		SELECT 
			siret, etablissementsiege, trancheeffectifsetablissement, trancheeffectifsetablissementtriable,
			activiteprincipaleetablissement, etatadministratifetablissement,numero_sirene,adresse_sirene,
			ST_Buffer(geom,1)::geometry(Polygon,2154) as geom
		FROM geosiren_terr';

	EXECUTE 'CREATE INDEX ON buffer_sirene_1m using gist(geom)';

	EXECUTE 'DROP TABLE IF EXISTS ban_buffer_1m CASCADE'; -- création couche des points adresses qui sont à moins de 1m des points geosirene
	EXECUTE 'CREATE TEMP TABLE ban_buffer_1m AS
		SELECT 
			ban.id,s.siret,ban.geom,numero_ban,numero_sirene,
			ban.adresse_ban,s.adresse_sirene,
			ST_Distance(ban.geom,s.geom) as distance
		FROM adresse_terr as ban
		JOIN buffer_sirene_1m as s
		ON ST_Intersects(ban.geom,s.geom)';	

	EXECUTE 'CREATE INDEX ON ban_buffer_1m USING gist(geom)';
	EXECUTE 'CREATE INDEX ON ban_buffer_1m USING btree(siret)';
	EXECUTE 'CREATE INDEX ON ban_buffer_1m USING btree(distance)';

	EXECUTE 'DROP TABLE IF EXISTS match_cas1 CASCADE'; -- cas1 : points geosirene et ban superposés (moins de 1m)
	EXECUTE 'CREATE TEMP TABLE match_cas1 AS
		WITH temp AS
			(SELECT 
				siret,min(distance) as dist_min
			FROM ban_buffer_1m
			GROUP BY siret),
		temp2 AS
			(SELECT 
				id as id_ban,a.siret,numero_ban,numero_sirene,
				adresse_ban,adresse_sirene
			FROM ban_buffer_1m a,temp b
			WHERE a.siret=b.siret AND a.distance=b.dist_min)
		SELECT
			a.siret,id_ban,numero_ban,a.numero_sirene,
			adresse_ban,a.adresse_sirene,b.geom
		FROM temp2 a,geosiren_terr b
		WHERE a.siret=b.siret';

	EXECUTE 'CREATE INDEX ON match_cas1 USING gist(geom)';

	-- Cas2 : les points geosirene et BAN sont distincts (distance > 1m)
	RAISE NOTICE '-- 2b. Cas2 : les points geosirene et BAN sont distincts (distance > 1m)';

	EXECUTE 'DROP TABLE IF EXISTS buffer_sirene CASCADE'; -- création couche buffer autour des points sirene buffer = 100m
	EXECUTE 'CREATE TEMP TABLE buffer_sirene AS
		SELECT 
			siret, etablissementsiege, trancheeffectifsetablissement, trancheeffectifsetablissementtriable,
			activiteprincipaleetablissement, etatadministratifetablissement,numero_sirene,adresse_sirene,
			ST_Buffer(geom,100)::geometry(Polygon,2154) as geom
		FROM geosiren_terr
		WHERE siret NOT IN (SELECT siret FROM match_cas1)';

	EXECUTE 'CREATE INDEX ON buffer_sirene USING gist(geom)';

	EXECUTE 'DROP TABLE IF EXISTS ban_buffer CASCADE'; -- création couche des points adresses qui sont à moins de 100m (tampon ci-dessus) des points geosirene
	EXECUTE 'CREATE TEMP TABLE ban_buffer AS
		SELECT 
			ban.id,s.siret,ban.geom,numero_ban,numero_sirene,
			ban.adresse_ban,s.adresse_sirene
		FROM adresse_terr as ban
		JOIN buffer_sirene as s
		ON ST_Intersects(ban.geom,s.geom)';

	EXECUTE 'CREATE INDEX ON ban_buffer USING gist(geom)';

	EXECUTE 'DROP TABLE IF EXISTS temp1 CASCADE';
	EXECUTE 'CREATE TEMP TABLE temp1 AS
		SELECT 
			id,siret,adresse_sirene , adresse_ban, similarity(adresse_sirene, adresse_ban::varchar) as similarity,
			CASE 
				WHEN numero_ban is null AND numero_sirene is not null THEN cast(numero_sirene as integer)
				WHEN numero_sirene is null AND numero_ban is not null THEN numero_ban
				WHEN numero_sirene is null AND numero_ban is null THEN 0
				ELSE abs(numero_ban-cast(numero_sirene as integer))
			END::integer as dif_numero,numero_ban,numero_sirene,geom
		FROM ban_buffer';

	EXECUTE 'CREATE INDEX ON temp1 using btree(similarity)';
	EXECUTE 'CREATE INDEX ON temp1 using btree(siret)';
	EXECUTE 'CREATE INDEX ON temp1 using btree(dif_numero)';

	EXECUTE 'DROP TABLE IF EXISTS temp2 CASCADE';
	EXECUTE 'CREATE TEMP TABLE temp2 AS
		SELECT siret,max(similarity) as similarity
		FROM temp1
		GROUP BY siret
		HAVING max(similarity)>=0.7';

	EXECUTE 'CREATE INDEX ON temp2 using btree(similarity)';
	EXECUTE 'CREATE INDEX ON temp2 using btree(siret)';

	EXECUTE 'DROP TABLE IF EXISTS temp3 CASCADE';
	EXECUTE 'CREATE TEMP TABLE temp3 AS
		SELECT siret,min(dif_numero) as dif_numero
		FROM temp1
		GROUP BY siret';

	EXECUTE 'CREATE INDEX ON temp3 using btree(dif_numero)';
	EXECUTE 'CREATE INDEX ON temp3 using btree(siret)';

	EXECUTE 'DROP TABLE IF EXISTS temp4 CASCADE';
	EXECUTE 'CREATE TEMP TABLE temp4 AS
		SELECT a.siret,similarity,dif_numero 
		FROM temp2 a
		LEFT JOIN temp3 b
		ON a.siret=b.siret' ;

	EXECUTE 'CREATE INDEX ON temp4 using btree(siret)';
	EXECUTE 'CREATE INDEX ON temp4 using btree(similarity)';
	EXECUTE 'CREATE INDEX ON temp4 using btree(dif_numero)';

	EXECUTE 'DROP TABLE IF EXISTS ban_sirene_similarity CASCADE';
	EXECUTE 'CREATE TEMP TABLE ban_sirene_similarity as
		WITH temp AS
			(SELECT 
				a.siret,a.similarity,a.dif_numero,
				adresse_sirene,adresse_ban,id as id_ban,
				numero_sirene,numero_ban
			FROM temp4 a
			LEFT JOIN temp1 b
			ON a.siret=b.siret and a.similarity=b.similarity and a.dif_numero=b.dif_numero)
		SELECT 
			a.siret,similarity,dif_numero,
			a.adresse_sirene,adresse_ban,id_ban,
			a.numero_sirene,numero_ban,b.geom
		FROM temp a,geosiren_terr b
		WHERE a.siret=b.siret';

	EXECUTE 'CREATE INDEX ON ban_sirene_similarity using btree(siret)';

	--**********************************************************
	-- Union des 2 tables cas1 (points geosirene et ban identiques) et cas2 (distincts)
	--**********************************************************
	RAISE NOTICE '-- 2c. Union des 2 tables cas1 (points geosirene et ban identiques) et cas2 (distincts)';

	EXECUTE 'DROP TABLE IF EXISTS pt_union CASCADE';
	EXECUTE 'CREATE TEMP TABLE pt_union as
		SELECT siret,id_ban,numero_ban,numero_sirene,
			adresse_ban,adresse_sirene,
			2 as similarity,0 as dif_numero,geom
		FROM match_cas1
		UNION
		SELECT siret,id_ban,numero_ban,numero_sirene,
			adresse_ban,adresse_sirene,
			similarity,dif_numero,geom
		FROM ban_sirene_similarity';			

	EXECUTE 'CREATE INDEX ON pt_union using btree(siret)';
	EXECUTE 'CREATE INDEX ON pt_union using btree(id_ban)';

	--**********************************************************
	-- Croisement des bâtiments avec les points geosiren
	--**********************************************************
	RAISE NOTICE '-- 2d. Création table temporaire oc3';
	EXECUTE 'DROP TABLE IF EXISTS oc3_temp CASCADE';
	EXECUTE 'CREATE TEMP TABLE oc3_temp AS
		SELECT 
			siret,b.id_bat,b.id_adr,a.geom
		FROM pt_union a,lien_adresse_terr b
		WHERE a.id_ban=b.id_adr';
	EXECUTE 'CREATE INDEX ON oc3_temp using btree(siret)';

	EXECUTE 'ALTER TABLE oc3_temp ADD COLUMN similarity numeric';
	EXECUTE 'UPDATE oc3_temp a SET similarity=(SELECT similarity FROM pt_union b WHERE a.siret=b.siret LIMIT 1)';

	EXECUTE 'ALTER TABLE oc3_temp ADD COLUMN dif_numero numeric';
	EXECUTE 'UPDATE oc3_temp a SET dif_numero=(SELECT dif_numero FROM pt_union b WHERE a.siret=b.siret LIMIT 1)';

	EXECUTE 'ALTER TABLE oc3_temp ADD COLUMN numero_ban integer';
	EXECUTE 'UPDATE oc3_temp a SET numero_ban=(SELECT numero_ban FROM pt_union b WHERE a.siret=b.siret LIMIT 1)';

	EXECUTE 'ALTER TABLE oc3_temp ADD COLUMN adresse_ban varchar';
	EXECUTE 'UPDATE oc3_temp a SET adresse_ban=(SELECT adresse_ban FROM pt_union b WHERE a.siret=b.siret LIMIT 1)';

	EXECUTE 'ALTER TABLE oc3_temp ADD COLUMN numero_sirene integer';
	EXECUTE 'UPDATE oc3_temp a SET numero_sirene=(SELECT cast(numero_sirene as integer) FROM pt_union b WHERE a.siret=b.siret LIMIT 1)';

	EXECUTE 'ALTER TABLE oc3_temp ADD COLUMN adresse_sirene varchar';
	EXECUTE 'UPDATE oc3_temp a SET adresse_sirene=(SELECT adresse_sirene FROM pt_union b WHERE a.siret=b.siret LIMIT 1)';

	RAISE NOTICE '-- 2e. Ajout des colonnes nb_etab, nb_bat, surf_bat_siret (surf_bat/nb_etab), employes_haut_siret (tranche_haut/nb_bat), employes_bas_siret (tranche_bas/nb_bat) ';
	EXECUTE 'DROP TABLE IF EXISTS tempd CASCADE'; -- on compte le nombre de bâtiments pour chaque établissement
	EXECUTE 'CREATE TEMP TABLE tempd AS
			SELECT 
				siret,count(*) as nb_bat
			FROM oc3_temp
			GROUP BY siret';

	EXECUTE 'CREATE INDEX ON tempd USING btree(siret)';	

	EXECUTE 'DROP TABLE IF EXISTS tempe CASCADE'; -- on compte le nombre d'établissements pour chaque bâtiment
	EXECUTE 'CREATE TEMP TABLE tempe AS
			SELECT 
				id_bat,count(*) as nb_etab
			FROM oc3_temp
			GROUP BY id_bat';

	EXECUTE 'CREATE INDEX ON tempe USING btree(id_bat)';	

	EXECUTE 'ALTER TABLE oc3_temp ADD COLUMN territoire varchar';
	EXECUTE 'ALTER TABLE oc3_temp ADD COLUMN surf_bat integer';
	EXECUTE 'ALTER TABLE oc3_temp ADD COLUMN nb_bat integer';
	EXECUTE 'ALTER TABLE oc3_temp ADD COLUMN nb_etab integer';
	EXECUTE 'ALTER TABLE oc3_temp ADD COLUMN surf_bat_etab real';
	EXECUTE 'ALTER TABLE oc3_temp ADD COLUMN employes_haut_etab real';
	EXECUTE 'ALTER TABLE oc3_temp ADD COLUMN employes_bas_etab real';

	EXECUTE 'UPDATE oc3_temp a SET surf_bat = (SELECT St_Area(geom) FROM bat_terr b WHERE a.id_bat=b.id)';
	EXECUTE 'UPDATE oc3_temp a SET nb_bat = (SELECT nb_bat FROM tempd b WHERE a.siret=b.siret)';
	EXECUTE 'UPDATE oc3_temp a SET nb_etab = (SELECT nb_etab FROM tempe b WHERE a.id_bat=b.id_bat)';
	EXECUTE 'UPDATE oc3_temp SET territoire = '''||REPLACE(nom_ter,'''','''''')||'''';
	EXECUTE 'UPDATE oc3_temp SET surf_bat_etab = surf_bat/nb_etab';
	EXECUTE 'UPDATE oc3_temp a SET employes_haut_etab = (SELECT 
		CASE 
			WHEN trancheeffectifsetablissementtriable=''-1'' OR trancheeffectifsetablissementtriable IS NULL THEN 0
			WHEN trancheeffectifsetablissementtriable=''0'' THEN 1.0/nb_bat
			WHEN trancheeffectifsetablissementtriable=''1'' THEN 2.0/nb_bat
			WHEN trancheeffectifsetablissementtriable=''2'' THEN 5.0/nb_bat
			WHEN trancheeffectifsetablissementtriable=''3'' THEN 9.0/nb_bat
			WHEN trancheeffectifsetablissementtriable=''11'' THEN 19.0/nb_bat
			WHEN trancheeffectifsetablissementtriable=''12'' THEN 49.0/nb_bat
			WHEN trancheeffectifsetablissementtriable=''21'' THEN 99.0/nb_bat
			WHEN trancheeffectifsetablissementtriable=''22'' THEN 199.0/nb_bat
			WHEN trancheeffectifsetablissementtriable=''31'' THEN 249.0/nb_bat
			WHEN trancheeffectifsetablissementtriable=''32'' THEN 499.0/nb_bat
			WHEN trancheeffectifsetablissementtriable=''41'' THEN 999.0/nb_bat
			WHEN trancheeffectifsetablissementtriable=''42'' THEN 1999.0/nb_bat
			WHEN trancheeffectifsetablissementtriable=''51'' THEN 4999.0/nb_bat
			WHEN trancheeffectifsetablissementtriable=''52'' THEN 9999.0/nb_bat
			WHEN trancheeffectifsetablissementtriable=''53'' THEN 20000.0/nb_bat			
		END
		FROM geosiren_terr b WHERE a.siret=b.siret)';	
	EXECUTE 'UPDATE oc3_temp a SET employes_bas_etab = (SELECT 
		CASE 
			WHEN trancheeffectifsetablissementtriable=''-1'' OR trancheeffectifsetablissementtriable IS NULL THEN 0
			WHEN trancheeffectifsetablissementtriable=''0'' THEN 1.0/nb_bat
			WHEN trancheeffectifsetablissementtriable=''1'' THEN 1.0/nb_bat
			WHEN trancheeffectifsetablissementtriable=''2'' THEN 3.0/nb_bat
			WHEN trancheeffectifsetablissementtriable=''3'' THEN 6.0/nb_bat
			WHEN trancheeffectifsetablissementtriable=''11'' THEN 10.0/nb_bat
			WHEN trancheeffectifsetablissementtriable=''12'' THEN 20.0/nb_bat
			WHEN trancheeffectifsetablissementtriable=''21'' THEN 50.0/nb_bat
			WHEN trancheeffectifsetablissementtriable=''22'' THEN 100.0/nb_bat
			WHEN trancheeffectifsetablissementtriable=''31'' THEN 200.0/nb_bat
			WHEN trancheeffectifsetablissementtriable=''32'' THEN 250.0/nb_bat
			WHEN trancheeffectifsetablissementtriable=''41'' THEN 500.0/nb_bat
			WHEN trancheeffectifsetablissementtriable=''42'' THEN 1000.0/nb_bat
			WHEN trancheeffectifsetablissementtriable=''51'' THEN 2000.0/nb_bat
			WHEN trancheeffectifsetablissementtriable=''52'' THEN 5000.0/nb_bat
			WHEN trancheeffectifsetablissementtriable=''53'' THEN 10000.0/nb_bat			
		END
		FROM geosiren_terr b WHERE a.siret=b.siret)';

	heure6 = clock_timestamp();
	RAISE NOTICE 'Durée de la PARTIE 2 : %', CAST(heure6 as time)-CAST(heure5 as time);

	RAISE NOTICE '====== FIN PARTIE 2 ======';
	RAISE NOTICE '';

	--************************************************************************
	-- Mise à jour de la table oc3 dans le schéma c_occupation_sol
	--************************************************************************
	RAISE NOTICE 'Mise à jour de la table c_occupation_sol.oc3';
	EXECUTE 'INSERT INTO c_occupation_sol.oc3 (
			siret,
			id_bat,
			id_adr,
			similarity,
			dif_numero,
			numero_ban,
			adresse_ban, 
			numero_sirene,
			adresse_sirene,
			territoire,
			surf_bat,
			nb_bat,
			nb_etab,
			surf_bat_etab,
			employes_haut_etab,
			employes_bas_etab,
			sce_donnee,
			moda_calc,
			date_calc
			)
			SELECT
				siret,
				id_bat,
				id_adr,
				similarity,
				dif_numero,
				numero_ban,
				adresse_ban, 
				numero_sirene,
				adresse_sirene,
				territoire,
				surf_bat,
				nb_bat,
				nb_etab,
				surf_bat_etab,
				employes_haut_etab,
				employes_bas_etab,
				''Geosirene '||an_siren||''',
				''__var_oc3'',
				current_date
			FROM oc3_temp';

	heure7 = clock_timestamp();
	RAISE NOTICE 'Durée de l''étape de mise à jour de la table oc3 : %', CAST(heure7 as time)-CAST(heure6 as time);

	--************************************************************************
	-- Création de la vue matérialisée oc3 sur le territoire
	--************************************************************************
	RAISE NOTICE '';
	RAISE NOTICE 'Création de la vue matérialisée %', 'c_occupation_sol.oc3_'||__util_to_snake_case(nom_ter);
	EXECUTE '
		DROP MATERIALIZED VIEW IF EXISTS c_occupation_sol.oc3_'||__util_to_snake_case(nom_ter)||' CASCADE;
		CREATE MATERIALIZED VIEW c_occupation_sol.oc3_'||__util_to_snake_case(nom_ter)||' AS
		SELECT *
		FROM c_occupation_sol.oc3
		WHERE __util_to_snake_case(territoire) = '''||__util_to_snake_case(nom_ter)||'''';

	RAISE NOTICE 'Vue matérialisée créée';
	heure8 = clock_timestamp();
	RAISE NOTICE 'Durée de l''étape de création de la vue matérialisée : %', CAST(heure8 as time)-CAST(heure7 as time);

	-- Création des index sur la vue matérialisée
	RAISE NOTICE 'Création des index sur la vue matérialisée';

	EXECUTE 'CREATE UNIQUE INDEX ON c_occupation_sol.oc3_'||__util_to_snake_case(nom_ter)||' (id)';

	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc3_'||__util_to_snake_case(nom_ter)||' USING btree(id)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc3_'||__util_to_snake_case(nom_ter)||' USING btree(siret)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc3_'||__util_to_snake_case(nom_ter)||' USING btree(id_bat)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc3_'||__util_to_snake_case(nom_ter)||' USING btree(id_adr)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc3_'||__util_to_snake_case(nom_ter)||' USING btree(similarity)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc3_'||__util_to_snake_case(nom_ter)||' USING btree(dif_numero)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc3_'||__util_to_snake_case(nom_ter)||' USING btree(numero_ban)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc3_'||__util_to_snake_case(nom_ter)||' USING btree(adresse_ban)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc3_'||__util_to_snake_case(nom_ter)||' USING btree(numero_sirene)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc3_'||__util_to_snake_case(nom_ter)||' USING btree(adresse_sirene)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc3_'||__util_to_snake_case(nom_ter)||' USING btree(territoire)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc3_'||__util_to_snake_case(nom_ter)||' USING btree(surf_bat)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc3_'||__util_to_snake_case(nom_ter)||' USING btree(nb_bat)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc3_'||__util_to_snake_case(nom_ter)||' USING btree(nb_etab)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc3_'||__util_to_snake_case(nom_ter)||' USING btree(surf_bat_etab)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc3_'||__util_to_snake_case(nom_ter)||' USING btree(employes_haut_etab)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc3_'||__util_to_snake_case(nom_ter)||' USING btree(employes_bas_etab)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc3_'||__util_to_snake_case(nom_ter)||' USING btree(sce_donnee)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc3_'||__util_to_snake_case(nom_ter)||' USING btree(moda_calc)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc3_'||__util_to_snake_case(nom_ter)||' USING btree(date_calc)';

	RAISE NOTICE 'Index créés sur la vue matérialisée';
	heure9 = clock_timestamp();
	RAISE NOTICE 'Durée de l''étape de création des index sur la vue matérialisée : %', CAST(heure9 as time)-CAST(heure8 as time);

	--************************************************************************
	-- Requêtes mettant à jour le champ booléen oc3 ainsi que les champs pop2_bas et pop2_haut de la table oc1 avec les informations de la table oc3
	--************************************************************************
	RAISE NOTICE '';
	RAISE NOTICE 'Mise à jour dans la table oc1 des champs oc3, pop2_bas et pop2_haut';

	EXECUTE '
		WITH tempa AS
		(
			SELECT
				territoire,
				id_bat,
				sum(employes_haut_etab) as sum_haut,
				sum(employes_bas_etab) as sum_bas
			FROM c_occupation_sol.oc3
			GROUP BY territoire, id_bat
		)
		UPDATE c_occupation_sol.oc1
		SET pop2_haut = tempa.sum_haut, pop2_bas = tempa.sum_bas
		FROM tempa
		WHERE oc1.id_bdt = tempa.id_bat AND oc1.territoire = tempa.territoire
		';

	-- EXECUTE 'UPDATE c_occupation_sol.oc1 a SET pop2_bas=(SELECT sum(employes_bas_etab) FROM c_occupation_sol.oc3 b WHERE a.id_bdt=b.id_bat AND a.territoire=b.territoire GROUP BY b.id_bat)';
	
	EXECUTE '
		UPDATE c_occupation_sol.oc1
		SET oc3 = true
		FROM c_occupation_sol.oc3
		WHERE __util_to_snake_case(oc1.territoire) = '''||__util_to_snake_case(nom_ter)||'''
			AND __util_to_snake_case(oc3.territoire) = '''||__util_to_snake_case(nom_ter)||'''
			AND oc1.id_bdt = oc3.id_bat
		';
	
	--************************************************************************
	-- Récupère le nombre d'entités ajoutées
	--************************************************************************
	GET DIAGNOSTICS c = row_count;

	heure11 = clock_timestamp();
	RAISE NOTICE 'Durée totale des requêtes de mise à jour des champs oc3, pop2_bas et pop2_haut de la table oc1 : %', CAST(heure11 as time)-CAST(heure10 as time);

	heure12 = clock_timestamp();

	--************************************************************************
	-- Mise à jour de la vue matérialisée oc1 sur le territoire
	--************************************************************************
	RAISE NOTICE '';	
	RAISE NOTICE 'Mise à jour de la vue matérialisée oc1 sur le territoire';
	EXECUTE '
		DROP MATERIALIZED VIEW IF EXISTS c_occupation_sol.oc1_'||__util_to_snake_case(nom_ter)||' CASCADE;
		CREATE MATERIALIZED VIEW c_occupation_sol.oc1_'||__util_to_snake_case(nom_ter)||' AS
		SELECT *
		FROM c_occupation_sol.oc1
		WHERE __util_to_snake_case(territoire) = '''||__util_to_snake_case(nom_ter)||'''
		ORDER BY nom_iris';

	RAISE NOTICE 'Vue matérialisée créée';
	heure13 = clock_timestamp();
	RAISE NOTICE 'Durée de l''étape de création de la vue matérialisée : %', CAST(heure13 as time)-CAST(heure12 as time);

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
	heure14 = clock_timestamp();
	RAISE NOTICE 'Durée de l''étape de création des index sur la vue matérialisée : %', CAST(heure14 as time)-CAST(heure13 as time);

	--************************************************************************
	-- Conclusion
	--************************************************************************
	RAISE NOTICE '';
	RAISE NOTICE '====== FIN TRAITEMENT ======';
	RAISE NOTICE '[INFO] La table c_occupation_sol.oc3 (entreprises rattachées aux bâtiments de la BD TOPO), ainsi que les champs oc3, pop2_bas et pop2_haut de la table c_occupation_sol.oc1, ont été mis à jour sur le territoire "%"', nom_ter;
	RAISE NOTICE '';
	RAISE NOTICE '====== RÉSULTATS ======';
   	IF c > 1
		THEN RAISE NOTICE '% enregistrements mis à jour dans la table c_occupation_sol.oc3 pour le territoire "%"', c, nom_ter;
		ELSE RAISE NOTICE '% enregistrement mis à jour dans la table c_occupation_sol.oc3 pour le territoire "%"', c, nom_ter;
	END IF;
	RAISE NOTICE '';
	heure16 = clock_timestamp();
	RAISE NOTICE 'Fin du traitement : %', heure16;
	RAISE NOTICE 'Durée du traitement : %', CAST(heure16 as time)-CAST(heure1 as time);
	RAISE NOTICE '';

END;
$function$
