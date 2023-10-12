SET client_encoding = 'UTF8';

CREATE OR REPLACE FUNCTION public.__var_oc7(nom_ter text, an_bdtopo text, an_rpg text)
 RETURNS void
 LANGUAGE plpgsql
AS $function$

-- Fonction SQL d'incrémentation de la table oc7 (parcelles agricoles) dans le schéma c_occupation_sol
-- © Cerema / GT AgiRisk (auteure principale du script : Tiffany)
-- Dernière mise à jour du script le 25/08/2023 par Sébastien (test avec succès sur Longuyon le 24/08/2023)

-- Paramètres d'entrée :
-- nom_ter = nom du territoire d'étude tel que renseigné dans le champ `territoire` de la table c_general.territoires
-- an_bdtopo = millésime (année au format AAAA) de la BD TOPO®
-- an_rpg : millésime (année au format AAAA) du RPG (Registre Parcellaire Graphique)

-- Exemple d'appel à cette fonction :
-- SELECT public.__var_oc7('Jura', '2022', '2021');

/* Cette fonction crée la variable Oc7, correspondant aux zones agricoles présentes sur le teritoire d'étude.
Oc7 permettant de calculer ensuite le coût des dommages à l'agriculture, il est nécessaire d'avoir le type de culture.

Évolution envisagée :
-- Vérification de la pertinence de l'intégration des données de l'INAO
-- Meilleure gestion des recouvrements des polygones du RPG */

DECLARE
	c1 integer; -- un compteur des lignes modifiées pour logging
	c2 integer; -- un compteur des lignes modifiées pour logging
	heure1 varchar; -- heure de début du traitement
	heure2 varchar; -- heure de fin du traitement

BEGIN
	heure1 = clock_timestamp();

	--************************************************************************
	-- Définition des schémas de travail
	--************************************************************************
	SET search_path TO public, c_phenomenes, c_occupation_sol, r_ign_bdtopo, r_ign_rpg;

	RAISE NOTICE '';
	RAISE NOTICE '====== RAPPORT ======';
	RAISE NOTICE 'Calcul de la variable Oc7 (parcelles agricoles) sur le territoire "%"', nom_ter;
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
	-- Vérification de l'existence du territoire renseigné dans la table c_phenomenes.zt
	--************************************************************************
	IF NOT EXISTS (
		SELECT *
		FROM c_phenomenes.zt
		WHERE territoire = ''||nom_ter||''
	)
	THEN
		RAISE EXCEPTION 'Il n''y a pas de territoire "%" dans la table c_phenomenes.zt. Fin de l''exécution', nom_ter;
	END IF;

	--************************************************************************
	-- Vérification de l'absence du territoire renseigné dans la table c_occupation_sol.oc7
	--************************************************************************
	IF EXISTS (
		SELECT *
		FROM c_occupation_sol.oc7
		WHERE territoire = ''||nom_ter||''
	)
	THEN
		RAISE EXCEPTION 'Il existe déjà des enregistrements pour le territoire "%" dans la table c_occupation_sol.oc7. 
		Pour les supprimer, lancer la requête suivante : 
		DELETE FROM c_occupation_sol.oc7 WHERE territoire = ''%'';', nom_ter, REPLACE(nom_ter,'''','''''');
	END IF;

	--************************************************************************
	-- 1. Ajout des données RPG dans oc7 avec modification de la colonne ID en integer
	--************************************************************************
	RAISE NOTICE '';
	RAISE NOTICE '[INFO] Les données du RPG n''ont pas encore été importées pour le territoire "%" dans la table c_occupation_sol.oc7. 
			Import en cours...', nom_ter;

	-- 1.a. Création d'un index sur geom (anciennement the_geom, terme lié à la méthode d'import, corrigé le 10/01/2023) de parcelles_graphiques_'||an_rpg||'
	EXECUTE 'DROP INDEX IF EXISTS parcelles_graphiques_'||an_rpg||'_geom_gist';
	EXECUTE 'CREATE INDEX parcelles_graphiques_'||an_rpg||'_geom_gist ON r_ign_rpg.parcelles_graphiques_'||an_rpg||' USING gist(geom)';

	-- 1.b. Intégration des données RPG dans la couche oc7
	EXECUTE 'INSERT INTO c_occupation_sol.oc7 (
			territoire,
			id_iris,
			nom_iris,
			id_parc,
			code_rpg,
			lib_culture,
			sce_donnee,
			url_rpg,
			url_bdtopo,
			moda_calc,
			date_calc,
			geom,
			geomloc
		)
		SELECT DISTINCT
			'''||REPLACE(nom_ter,'''','''''')||''',
			zt.id_iris,
			zt.libelle,
			rpg.id_parcel::integer,
			rpg.code_group,
			rpg.code_cultu,
			''RPG IGN '||an_rpg||''',
			''https://geoservices.ign.fr/rpg#telechargement'' as url_rpg,
			''https://geoservices.ign.fr/telechargement'' as url_bdtopo,
			''__var_oc7'',
			current_date,
			rpg.geom,
			rpg.geomloc
		FROM r_ign_rpg.parcelles_graphiques_'||an_rpg||' AS rpg
		JOIN zt
		ON __util_to_snake_case(zt.territoire) = '''||__util_to_snake_case(nom_ter)||'''
		AND ST_Intersects(rpg.geomloc, zt.geom)';

	--************************************************************************
	-- Récupération du nombre d'entités ajoutées
	--************************************************************************
	GET DIAGNOSTICS c1 = row_count;

	RAISE NOTICE '[INFO] Les données du RPG ont été intégrées dans oc7 pour le territoire "%"', nom_ter;

	--************************************************************************
	-- 2. Ajout des données BD TOPO dans oc7
	--************************************************************************
	RAISE NOTICE '';
	RAISE NOTICE '[INFO] Traitement de la BD TOPO sur le territoire "%"', nom_ter;

	-- 2.a. Création d'un index sur geom de la couche zone de végétation de la BD TOPO®
	EXECUTE 'DROP INDEX IF EXISTS zone_de_vegetation_'||an_bdtopo||'geom_gist';
	EXECUTE 'CREATE INDEX zone_de_vegetation_'||an_bdtopo||'geom_gist ON zone_de_vegetation_'||an_bdtopo||' USING gist(geom)';

	-- 2.b. Récupération des vignes dans la couche zone de végétation de la BD TOPO®
	RAISE NOTICE '[Traitement intermédiaire] Récupération des vignes dans la BD TOPO pour le territoire "%"', nom_ter;
	EXECUTE 'DROP TABLE IF EXISTS vigne_bdtopo'||an_bdtopo||' CASCADE';
	EXECUTE 'CREATE TEMP TABLE vigne_bdtopo'||an_bdtopo||' AS
		SELECT
			'''||REPLACE(nom_ter,'''','''''')||''' AS territoire,
			zt.id_iris AS id_iris,
			zt.libelle AS nom_iris,
			RIGHT(vigne.id,9)::integer AS id_parc,
			vigne.geom,
			vigne.geomloc
		FROM r_ign_bdtopo.zone_de_vegetation_'||an_bdtopo||' AS vigne
		JOIN zt
		ON __util_to_snake_case(zt.territoire) = '''||__util_to_snake_case(nom_ter)||'''
		AND ST_Intersects(vigne.geomloc, zt.geom)
		WHERE nature = ''Vigne''';

	RAISE NOTICE '[Traitement intermédiaire] Les vignes ont été extraites de la BD TOPO pour le territoire "%"', nom_ter;

	-- 2.c. Gestion des superpositions entre les vignes issues de la BD TOPO® et les parcelles du RPG
	RAISE NOTICE '[Traitement intermédiaire] Croisement du RPG et des vignes de la BD TOPO, gestion des superpositions';

	-- 2.c.1. Création d'une table provisoire qui intersecte le RPG et les vignes de la BD TOPO®
	RAISE NOTICE '[Traitement intermédiaire] Intersection les parcelles du RPG et des vignes de la BD TOPO';
	EXECUTE 'DROP TABLE IF EXISTS intersect_rpg_bdtopo CASCADE';
	EXECUTE 'CREATE TEMP TABLE intersect_rpg_bdtopo AS
		SELECT 
			vigne_bdtopo'||an_bdtopo||'.id_parc,
			ST_Multi(ST_CollectionExtract(ST_ForceCollection(ST_MakeValid(ST_Union(r_ign_rpg.parcelles_graphiques_'||an_rpg||'.geom))),3))::geometry(MultiPolygon,2154) AS geom
		FROM vigne_bdtopo'||an_bdtopo||'
		JOIN r_ign_rpg.parcelles_graphiques_'||an_rpg||'
		ON ST_Intersects(vigne_bdtopo'||an_bdtopo||'.geom,r_ign_rpg.parcelles_graphiques_'||an_rpg||'.geom)
		GROUP BY vigne_bdtopo'||an_bdtopo||'.id_parc';

	RAISE NOTICE '[Traitement intermédiaire] Parcelles du RPG et des vignes de la BD TOPO intersectées';

	-- 2.c.2. Création de la table de vignes de la BD TOPO® hors du RPG
	RAISE NOTICE '[Traitement intermédiaire] Récupération des vignes de la BD TOPO hors du RPG';
	EXECUTE 'DROP TABLE IF EXISTS diff_rpg_bdtopo_'||an_bdtopo||' CASCADE';
	EXECUTE 'CREATE TEMP TABLE diff_rpg_bdtopo_'||an_bdtopo||' AS
		SELECT
			vigne_bdtopo'||an_bdtopo||'.territoire,
			vigne_bdtopo'||an_bdtopo||'.id_iris,
			vigne_bdtopo'||an_bdtopo||'.nom_iris,
			vigne_bdtopo'||an_bdtopo||'.id_parc,
			ST_Multi(ST_CollectionExtract(ST_ForceCollection(ST_MakeValid(ST_Difference(vigne_bdtopo'||an_bdtopo||'.geom,coalesce(intersect_rpg_bdtopo.geom,''srid=2154;GEOMETRYCOLLECTION EMPTY''::geometry)))),3))as geom
			FROM vigne_bdtopo'||an_bdtopo||'
			LEFT JOIN intersect_rpg_bdtopo
			ON vigne_bdtopo'||an_bdtopo||'.id_parc = intersect_rpg_bdtopo.id_parc';

	RAISE NOTICE '[Traitement intermédiaire] Les vignes hors du RPG ont bien été récupérées';

	-- 2.d. Mise en forme de la table finale pour l'intégrer dans oc7
	RAISE NOTICE '[INFO] Intégration des données retraitées la BD TOPO dans oc7 pour le territoire "%"', nom_ter;

	-- Création d'un index sur le champs géométrie de la couche
	EXECUTE 'DROP INDEX IF EXISTS diff_rpg_bdtopo_'||an_bdtopo||'_geom_gist';
	EXECUTE 'CREATE INDEX diff_rpg_bdtopo_'||an_bdtopo||'_geom_gist ON diff_rpg_bdtopo_'||an_bdtopo||' USING gist(geom)';

	-- Création d'un centroïde geomloc dans la couche
	EXECUTE 'ALTER TABLE diff_rpg_bdtopo_'||an_bdtopo||'
		DROP COLUMN IF EXISTS geomloc,
		ADD COLUMN geomloc geometry(POINT,2154)';
	EXECUTE 'UPDATE diff_rpg_bdtopo_'||an_bdtopo||'
		SET geomloc = ST_Centroid(geom)';

	-- Création d'un index sur geomloc de parcelles_graphiques_'||an_rpg||'
	EXECUTE 'CREATE INDEX diff_rpg_bdtopo_'||an_bdtopo||'_geomloc_gist ON diff_rpg_bdtopo_'||an_bdtopo||' USING gist(geomloc)';

	-- 2.e. Intégration de la table créée dans oc7
	EXECUTE 'INSERT INTO c_occupation_sol.oc7 (
			territoire,
			id_iris,
			nom_iris,
			id_parc,
			code_rpg,
			lib_culture,
			sce_donnee,
			url_rpg,
			url_bdtopo,
			moda_calc,
			date_calc,
			geom,
			geomloc
		)
		SELECT DISTINCT
			'''||REPLACE(nom_ter,'''','''''')||''',
			id_iris,
			nom_iris,
			id_parc,
			''21'',
			''VRC'',
			''BD TOPO IGN '||an_bdtopo||''',
			''https://geoservices.ign.fr/rpg#telechargement'' as url_rpg,
			''https://geoservices.ign.fr/telechargement'' as url_bdtopo,
			''__var_oc7'',
			current_date,
			ST_Multi(diff.geom),
			diff.geomloc
	FROM diff_rpg_bdtopo_'||an_bdtopo||' AS diff';

	--************************************************************************
	-- Récupération du nombre d'entités ajoutées
	--************************************************************************
	GET DIAGNOSTICS c2 = row_count;

	RAISE NOTICE '[INFO] Les données retraitées de la BD TOPO ont été intégrées dans oc7 pour le territoire "%"', nom_ter;

	--************************************************************************
	-- Création de la vue matérialisée oc7 sur le territoire
	--************************************************************************
	RAISE NOTICE '';
	RAISE NOTICE 'Création de la vue matérialisée %', 'c_occupation_sol.oc7_'||__util_to_snake_case(nom_ter);
	EXECUTE '
		DROP MATERIALIZED VIEW IF EXISTS c_occupation_sol.oc7_'||__util_to_snake_case(nom_ter)||' CASCADE;
		CREATE MATERIALIZED VIEW c_occupation_sol.oc7_'||__util_to_snake_case(nom_ter)||' AS
		SELECT *
		FROM c_occupation_sol.oc7
		WHERE __util_to_snake_case(territoire) = '''||__util_to_snake_case(nom_ter)||'''
		ORDER BY nom_iris';

	-- Création des index sur la vue matérialisée
	RAISE NOTICE 'Création des index sur la vue matérialisée';

	EXECUTE 'CREATE UNIQUE INDEX ON c_occupation_sol.oc7_'||__util_to_snake_case(nom_ter)||' (id)';

	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc7_'||__util_to_snake_case(nom_ter)||' USING gist(geom)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc7_'||__util_to_snake_case(nom_ter)||' USING gist(geomloc)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc7_'||__util_to_snake_case(nom_ter)||' USING btree(id)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc7_'||__util_to_snake_case(nom_ter)||' USING btree(territoire)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc7_'||__util_to_snake_case(nom_ter)||' USING btree(id_iris)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc7_'||__util_to_snake_case(nom_ter)||' USING btree(nom_iris)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc7_'||__util_to_snake_case(nom_ter)||' USING btree(id_parc)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc7_'||__util_to_snake_case(nom_ter)||' USING btree(code_rpg)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc7_'||__util_to_snake_case(nom_ter)||' USING btree(lib_culture)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc7_'||__util_to_snake_case(nom_ter)||' USING btree(sce_donnee)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc7_'||__util_to_snake_case(nom_ter)||' USING btree(url_rpg)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc7_'||__util_to_snake_case(nom_ter)||' USING btree(url_bdtopo)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc7_'||__util_to_snake_case(nom_ter)||' USING btree(moda_calc)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc7_'||__util_to_snake_case(nom_ter)||' USING btree(date_calc)';
	RAISE NOTICE 'Index créés sur la vue matérialisée';

	--************************************************************************
	-- Conclusion
	--************************************************************************
	RAISE NOTICE '';
	RAISE NOTICE '====== FIN TRAITEMENT ======';
	RAISE NOTICE '[INFO] La table oc7 (parcelles agricoles) a été mise à jour dans le schéma c_occupation_sol pour le territoire "%"', nom_ter;
	RAISE NOTICE '';
	RAISE NOTICE '====== RÉSULTATS ======';
	IF c1+c2 > 1
		THEN RAISE NOTICE '% enregistrements insérés au total dans la table c_occupation_sol.oc7 pour le territoire "%"', c1+c2, nom_ter;
		ELSE RAISE NOTICE '% enregistrement inséré dans la table c_occupation_sol.oc7 pour le territoire "%"', c1+c2, nom_ter;
	END IF;
	RAISE NOTICE '';
	heure2 = clock_timestamp();
	RAISE NOTICE 'Fin du traitement : %', heure2;
	RAISE NOTICE 'Durée du traitement : %', CAST(heure2 as time)-CAST(heure1 as time);
	RAISE NOTICE '';

END;
$function$
