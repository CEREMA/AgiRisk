CREATE OR REPLACE FUNCTION public.__var_oc3(nom_ter text, an_lien text, an_bdtopo text, an_siren text)
 RETURNS void
 LANGUAGE plpgsql
AS $function$

DECLARE 
	c integer;
	heure varchar;

BEGIN

-- nom_ter = nom du territoire test
-- an_siren = millésime des points SIRENE V3 récupéré depuis le site https://public.opendatasoft.com/explore/dataset/economicref-france-sirene-v3/
-- an_adresse = millésime base adresse premium
-- an_bdtopo = millésime de la BDTOPO®

	SET SEARCH_PATH TO public, c_general, c_phenomenes, c_occupation_sol, r_ign_bdtopo, r_insee_sirene, r_ign_adresse_premium;

	-- On apparie les points geosiren avec les bâtiments de la BDTOPO en 2 temps :
	-- - lien entre les points geosiren et les points adresse
	-- - lien avec les bâtiments avec la base adresse premium, couche bati-adresse

	heure = current_timestamp;
	RAISE NOTICE 'début traitement "%"', heure;
	RAISE NOTICE '======	RAPPORT		======';
	
	-- Test de l'existence du territoire dans la table des territoires
	IF NOT EXISTS (
		SELECT *
		FROM territoires t 
		WHERE territoire = nom_ter
	)
	THEN
		RAISE EXCEPTION 'Il n''y a pas de territoire "%" dans la table c_general.territoires. Fin de l''exécution.', nom_ter;
	END IF;
	--************************************************************************
	--partie 0 : sélection des points geosiren dans le périmètre du territoire
	--************************************************************************
	RAISE NOTICE '======	DEBUT PARTIE 0		======';
	RAISE NOTICE '--1. création de la couche de points geosiren sur le territoire';
	EXECUTE 'DROP TABLE IF EXISTS geosiren_terr';
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
		WHERE territoire = '''||nom_ter||'''';
		
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
		53 : 10 000 salariés et plus
		*/
	EXECUTE 'CREATE INDEX ON geosiren_terr USING btree(siret)';
	EXECUTE 'CREATE INDEX ON geosiren_terr USING gist(geom)';
	--EXECUTE 'CREATE INDEX ON geosiren_terr USING gist(adresse_sirene gist_trgm_ops(siglen=2000))';	

	RAISE NOTICE '--2. création de la couche des bâtiments sur le territoire';		
	--batiments sur territoire (au minimum 25m2)
	EXECUTE 'DROP TABLE IF EXISTS bat_terr';
	EXECUTE 'CREATE TEMP TABLE bat_terr AS
		SELECT 
			a.id,a.geom
		FROM batiment_'||an_bdtopo||' a
		JOIN territoires b
		ON ST_Intersects(a.geom,b.geom)
		WHERE ST_area(a.geom)>25 AND territoire = '''||nom_ter||'''';
		
	EXECUTE 'CREATE INDEX ON bat_terr using gist(geom)';
	EXECUTE 'CREATE INDEX ON bat_terr using btree(id)';

	RAISE NOTICE '--3. création de la couche adresse sur le territoire';		
	EXECUTE 'DROP TABLE IF EXISTS adresse_terr';
	EXECUTE 'CREATE TEMP TABLE adresse_terr AS
		WITH temp as
		(SELECT 
			CASE
				WHEN nom_1 like ''R %'' THEN replace(nom_1,''R '',''RUE '')
				WHEN nom_1 like ''RTE %'' THEN replace(nom_1,''RTE '',''ROUTE '')
				WHEN nom_1 like ''ALL %'' THEN replace(nom_1,''ALL '',''ALLEE '')
				WHEN nom_1 like ''CHE %'' THEN replace(nom_1,''CHE '',''CHEMIN '')
				WHEN nom_1 like ''AV %'' THEN replace(nom_1,''AV '',''AVENUE '')
				WHEN nom_1 like ''IMP %'' THEN replace(nom_1,''IMP '',''IMPASSE '')
				WHEN nom_1 like ''PL %'' THEN replace(nom_1,''PL '',''PLACE '')
				WHEN nom_1 like ''BD %'' THEN replace(nom_1,''BD '',''BOULEVARD '')
				WHEN nom_1 like ''PTR %'' THEN replace(nom_1,''PTR '',''PETITE RUE '')
				WHEN nom_1 like ''LOT %'' THEN replace(nom_1,''LOT '',''LOTISSEMENT '')
				WHEN nom_1 like ''FONT %'' THEN replace(nom_1,''FONT '',''FONTAINE '')
				WHEN nom_1 like ''RPT %'' THEN replace(nom_1,''RPT '',''ROND POINT '')
				WHEN nom_1 like ''DOM %'' THEN replace(nom_1,''DOM '',''DOMAINE '')
				WHEN nom_1 like ''HAM %'' THEN replace(nom_1,''HAM '',''HAMEAU '')
				WHEN nom_1 like ''SQ %'' THEN replace(nom_1,''SQ '',''SQUARE '')
				WHEN nom_1 like ''RES %'' THEN replace(nom_1,''RES '',''RESIDENCE '')
				WHEN nom_1 like ''VOI %'' THEN replace(nom_1,''VOI '',''VOIE '')
				WHEN nom_1 like ''RLE %'' THEN replace(nom_1,''RLE '',''RUELLE '')
				WHEN nom_1 like ''ZA %'' THEN replace(nom_1,''ZA '',''ZONE ARTISANALE '')
				WHEN nom_1 like ''PAS %'' THEN replace(nom_1,''PAS '',''PASSAGE '')
				WHEN nom_1 like ''RPE %'' THEN replace(nom_1,''RPE '',''RAMPE '')
				WHEN nom_1 like ''SEN %'' THEN replace(nom_1,''SEN '',''SENTIER '') 
				WHEN nom_1 like ''BRG %'' THEN replace(nom_1,''BRG '',''BOURG '')
				WHEN nom_1 like ''VEN %'' THEN replace(nom_1,''VEN '',''VENELLE '')
				WHEN nom_1 like ''QU %'' THEN replace(nom_1,''QU '',''QUAI '')
				WHEN nom_1 like ''TRA %'' THEN replace(nom_1,''TRA '',''TRAVERSE '')
				WHEN nom_1 like ''CRS %'' THEN replace(nom_1,''CRS '',''COURS '')
				WHEN nom_1 like ''FRM %'' THEN replace(nom_1,''FRM '',''FERME '')
				WHEN nom_1 like ''GR %'' THEN replace(nom_1,''GR '',''GRANDE RUE '')
				WHEN nom_1 like ''VC %'' THEN replace(nom_1,''VC '',''VOIE COMMUNALE '')
				else nom_1
			END as adresse_ban,
			id,numero as numero_ban,rep,code_post,code_insee,geom		
		 FROM adresse_'||an_bdtopo||'
		)
		SELECT 
			a.id,a.code_post,c.nom,numero_ban,adresse_ban,a.geom
		FROM temp a
		JOIN territoires b
		ON ST_Intersects(a.geom,b.geom)
		JOIN commune_'||an_bdtopo||' c
		ON a.code_insee=c.insee_com
		WHERE territoire = '''||nom_ter||'''';
		
	EXECUTE 'CREATE INDEX ON adresse_terr using gist(geom)';

	RAISE NOTICE '--4. création de la couche du lien bati-adresse sur le territoire';		
	EXECUTE 'DROP TABLE IF EXISTS lien_adresse_terr';
	EXECUTE 'CREATE TEMP TABLE lien_adresse_terr AS
		SELECT DISTINCT
			a.id_bat,a.id_adr,a.the_geom as geom
		FROM lien_adresse_bati_'||an_lien||' a
		JOIN territoires b
		ON ST_Intersects(a.the_geom,b.geom)
		WHERE territoire = '''||nom_ter||'''';
		
	EXECUTE 'CREATE INDEX ON lien_adresse_terr using gist(geom)';
	EXECUTE 'CREATE INDEX ON lien_adresse_terr using btree(id_adr)';

			
	RAISE NOTICE '======	FIN PARTIE 0	======';
	
	--**********************************************************		
	--    Rapprochement points adresse et points geosiren
	--**********************************************************
	
	RAISE NOTICE '--1. Cas 1 : les points geosirene et BAN sont identiques (tolérence de 1m)';
	
	EXECUTE 'DROP TABLE IF EXISTS buffer_sirene_1m'; --création couche buffer autour des points sirene buffer = 1m
	EXECUTE 'CREATE TEMP TABLE buffer_sirene_1m AS
		SELECT 
			siret, etablissementsiege, trancheeffectifsetablissement, trancheeffectifsetablissementtriable,
			activiteprincipaleetablissement, etatadministratifetablissement,numero_sirene,adresse_sirene,
			ST_Buffer(geom,1)::geometry(Polygon,2154) as geom
		FROM geosiren_terr';

	EXECUTE 'CREATE INDEX ON buffer_sirene_1m using gist(geom)';

	EXECUTE 'DROP TABLE IF EXISTS ban_buffer_1m CASCADE';--création couche des points adresses qui sont à moins de 1m des points geosirene
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

	EXECUTE 'DROP TABLE IF EXISTS match_cas1 CASCADE';--cas 1 : points geosirene et ban superposés (moins de 1m)
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

	RAISE NOTICE '--2. Cas 2 : les points geosirene et BAN sont distincts (distance > 1m)';

	EXECUTE 'DROP TABLE IF EXISTS buffer_sirene'; --création couche buffer autour des points sirene buffer = 100m
	EXECUTE 'CREATE TEMP TABLE buffer_sirene AS
		SELECT 
			siret, etablissementsiege, trancheeffectifsetablissement, trancheeffectifsetablissementtriable,
			activiteprincipaleetablissement, etatadministratifetablissement,numero_sirene,adresse_sirene,
			ST_Buffer(geom,100)::geometry(Polygon,2154) as geom
		FROM geosiren_terr
		WHERE siret NOT IN (SELECT siret FROM match_cas1)';

	EXECUTE 'CREATE INDEX ON buffer_sirene using gist(geom)';

	EXECUTE 'DROP TABLE IF EXISTS ban_buffer CASCADE';--création couche des points adresses qui sont à moins de 100m (tampon ci-dessus) des points geosirene
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
				WHEN numero_ban is null AND numero_sirene is not null THEN numero_sirene
				WHEN numero_sirene is null AND numero_ban is not null THEN numero_ban
				WHEN numero_sirene is null AND numero_ban is null THEN 0
				ELSE abs(numero_ban-numero_sirene)
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
			
	RAISE NOTICE '--3. Union des 2 tables cas1 (points geosirene et ban identiques) et cas 2 (distincts)';	

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
	--   Croisement des batiments avec les points geosiren
	--**********************************************************
	RAISE NOTICE '--4. création table temporaire oc3';	
	EXECUTE 'DROP TABLE IF EXISTS oc3_temp';
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
	EXECUTE 'UPDATE oc3_temp a SET numero_sirene=(SELECT numero_sirene FROM pt_union b WHERE a.siret=b.siret LIMIT 1)';
	
	EXECUTE 'ALTER TABLE oc3_temp ADD COLUMN adresse_sirene varchar';
	EXECUTE 'UPDATE oc3_temp a SET adresse_sirene=(SELECT adresse_sirene FROM pt_union b WHERE a.siret=b.siret LIMIT 1)';
	
	RAISE NOTICE '--5. Ajout des colonnes nb_etab, nb_bat, surf_bat_siret (surf_bat/nb_etab), employes_haut_siret (tranche_haut/nb_bat), employes_bas_siret (tranche_bas/nb_bat) ';
	EXECUTE 'DROP TABLE IF EXISTS tempd'; --on compte le nombre de bâtiments pour chaque établissement
	EXECUTE 'CREATE TEMP TABLE tempd AS
			SELECT 
				siret,count(*) as nb_bat
			FROM oc3_temp
			GROUP BY siret';	

	EXECUTE 'CREATE INDEX ON tempd USING btree(siret)';	

	EXECUTE 'DROP TABLE IF EXISTS tempe'; --on compte le nombre de bâtiments pour chaque établissement
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
	
	EXECUTE 'UPDATE oc3_temp a SET surf_bat=(SELECT St_Area(geom) FROM bat_terr b WHERE a.id_bat=b.id)';
	EXECUTE 'UPDATE oc3_temp a SET nb_bat=(SELECT nb_bat FROM tempd b WHERE a.siret=b.siret)';
	EXECUTE 'UPDATE oc3_temp a SET nb_etab=(SELECT nb_etab FROM tempe b WHERE a.id_bat=b.id_bat)';
	EXECUTE 'UPDATE oc3_temp SET territoire='''||nom_ter||'''';
	EXECUTE 'UPDATE oc3_temp SET surf_bat_etab = surf_bat/nb_etab';
	EXECUTE 'UPDATE oc3_temp a SET employes_haut_etab = (SELECT 
		CASE 
			WHEN trancheeffectifsetablissementtriable=-1 OR trancheeffectifsetablissementtriable IS NULL THEN 0
			WHEN trancheeffectifsetablissementtriable=0 THEN 1.0/nb_bat
			WHEN trancheeffectifsetablissementtriable=1 THEN 2.0/nb_bat
			WHEN trancheeffectifsetablissementtriable=2 THEN 5.0/nb_bat
			WHEN trancheeffectifsetablissementtriable=3 THEN 9.0/nb_bat
			WHEN trancheeffectifsetablissementtriable=11 THEN 19.0/nb_bat
			WHEN trancheeffectifsetablissementtriable=12 THEN 49.0/nb_bat
			WHEN trancheeffectifsetablissementtriable=21 THEN 99.0/nb_bat
			WHEN trancheeffectifsetablissementtriable=22 THEN 199.0/nb_bat
			WHEN trancheeffectifsetablissementtriable=31 THEN 249.0/nb_bat
			WHEN trancheeffectifsetablissementtriable=32 THEN 499.0/nb_bat
			WHEN trancheeffectifsetablissementtriable=41 THEN 999.0/nb_bat
			WHEN trancheeffectifsetablissementtriable=42 THEN 1999.0/nb_bat
			WHEN trancheeffectifsetablissementtriable=51 THEN 4999.0/nb_bat
			WHEN trancheeffectifsetablissementtriable=52 THEN 9999.0/nb_bat
			WHEN trancheeffectifsetablissementtriable=53 THEN 20000.0/nb_bat			
		END
		FROM geosiren_terr b WHERE a.siret=b.siret)';	
	EXECUTE 'UPDATE oc3_temp a SET employes_bas_etab = (SELECT 
		CASE 
			WHEN trancheeffectifsetablissementtriable=-1 OR trancheeffectifsetablissementtriable IS NULL THEN 0
			WHEN trancheeffectifsetablissementtriable=0 THEN 1.0/nb_bat
			WHEN trancheeffectifsetablissementtriable=1 THEN 1.0/nb_bat
			WHEN trancheeffectifsetablissementtriable=2 THEN 3.0/nb_bat
			WHEN trancheeffectifsetablissementtriable=3 THEN 6.0/nb_bat
			WHEN trancheeffectifsetablissementtriable=11 THEN 10.0/nb_bat
			WHEN trancheeffectifsetablissementtriable=12 THEN 20.0/nb_bat
			WHEN trancheeffectifsetablissementtriable=21 THEN 50.0/nb_bat
			WHEN trancheeffectifsetablissementtriable=22 THEN 100.0/nb_bat
			WHEN trancheeffectifsetablissementtriable=31 THEN 200.0/nb_bat
			WHEN trancheeffectifsetablissementtriable=32 THEN 250.0/nb_bat
			WHEN trancheeffectifsetablissementtriable=41 THEN 500.0/nb_bat
			WHEN trancheeffectifsetablissementtriable=42 THEN 1000.0/nb_bat
			WHEN trancheeffectifsetablissementtriable=51 THEN 2000.0/nb_bat
			WHEN trancheeffectifsetablissementtriable=52 THEN 5000.0/nb_bat
			WHEN trancheeffectifsetablissementtriable=53 THEN 10000.0/nb_bat			
		END
		FROM geosiren_terr b WHERE a.siret=b.siret)';	
		
	--**********************************************************		
	--   Création table oc3 (schéma c_occupation_sol)
	--**********************************************************		
	RAISE NOTICE '-- 6. Création ou mise à jour de la table oc3';	
	
	-- Test de l'existence de la table oc3
	IF NOT EXISTS (
		SELECT *
		FROM information_schema.tables
		WHERE table_name='oc3' AND table_schema='c_occupation_sol'
	)
	THEN 
		CREATE TABLE c_occupation_sol.oc3 AS
		SELECT 
			siret, id_bat, id_adr, similarity, dif_numero, numero_ban, adresse_ban, 
			numero_sirene, adresse_sirene, territoire, surf_bat, nb_bat, nb_etab, 
			surf_bat_etab, employes_haut_etab, employes_bas_etab 
		FROM oc3_temp;
		ALTER TABLE c_occupation_sol.oc3 ADD COLUMN id serial;
		ALTER TABLE c_occupation_sol.oc3 ADD CONSTRAINT c_occupation_sol_oc3_pkey primary key (id);
	ELSE
		DELETE FROM c_occupation_sol.oc3 WHERE territoire=''||nom_ter||''; --suppression des lignes sur le territoire en cours pour éviter les doublons
		INSERT INTO c_occupation_sol.oc3 (
			SELECT 
				siret, id_bat, id_adr, similarity, dif_numero, numero_ban, adresse_ban, 
				numero_sirene, adresse_sirene, territoire, surf_bat, nb_bat, nb_etab, 
				surf_bat_etab, employes_haut_etab, employes_bas_etab
			FROM oc3_temp);		
	END IF;		

	create index on c_occupation_sol.oc3 using btree(id_bat);
	create index on c_occupation_sol.oc3 using btree(territoire);
	
	RAISE NOTICE '-- 7. Création des vues matérialisées oc3 par territoire';	
		
    EXECUTE 
		'DROP MATERIALIZED VIEW IF EXISTS c_occupation_sol.oc3_' || __util_to_snake_case(nom_ter) || ';
        CREATE MATERIALIZED VIEW c_occupation_sol.oc3_' || __util_to_snake_case(nom_ter) || ' AS
        SELECT *
        FROM c_occupation_sol.oc3
        WHERE territoire = ''' || nom_ter || '''
		';
		
	EXECUTE 'CREATE UNIQUE INDEX
	ON c_occupation_sol.oc3_' || __util_to_snake_case(nom_ter) || ' (id)';

	RAISE NOTICE '-- 8. Mise à jour de la table oc1 des champs oc3, pop2_haut et pop2_bas';	
		
    EXECUTE 'WITH tempa AS
	(
		SELECT
			territoire,
			id_bat,
			sum(employes_haut_etab) as sum_haut,
			sum(employes_bas_etab) as sum_bas,
		FROM c_occupation_sol.oc3
		GROUP BY territoire, id_bat
	)
	UPDATE c_occupation_sol.oc1
	SET pop2_haut = tempa.sum_haut, pop2_bas = tempa.sum_bas
	FROM tempa
	WHERE oc1.id_bdt = tempa.id_bat AND oc1.territoire = tempa.territoire
	';

    -- EXECUTE 'UPDATE c_occupation_sol.oc1 a SET pop2_bas=(SELECT sum(employes_bas_etab) FROM c_occupation_sol.oc3 b WHERE a.id_bdt=b.id_bat AND a.territoire=b.territoire GROUP BY b.id_bat)';
	
	EXECUTE 'UPDATE c_occupation_sol.oc1
	SET oc3 = true
	FROM c_occupation_sol.oc3
	WHERE oc1.territoire = oc3.territoire
		AND oc1.id_bdt = oc3.id_bat
		';

	RAISE NOTICE '-- 9. Mise à jour de la vue matérialisée oc1 territoire' ;

	EXECUTE 'REFRESH MATERIALIZED VIEW c_occupation_sol.oc1_'  || __util_to_snake_case(nom_ter) || '';
				
	RAISE NOTICE '======	FIN TRAITEMENT	======';
	RAISE NOTICE '[INFO] La table oc3 (entreprises rattachées aux bâtiments de la BDTOPO) a été mise à jour sur le territoire de "%".', nom_ter;

END;
$function$
;

SELECT public.__var_oc3('Jura','2022','2022','2022');