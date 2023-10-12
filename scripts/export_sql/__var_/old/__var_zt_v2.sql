CREATE OR REPLACE FUNCTION public.__var_zt_v2(nom_ter text, an_bdtopo text, an_iris text, an_topage text)
 RETURNS void
 LANGUAGE plpgsql
AS $function$

-- Fonction SQL d'incrémentation de la table zt (périmètres de calcul élémentaires : contours IRIS GE intersectant le périmètre d'étude) dans le schéma c_phenomenes
-- © Cerema / GT AgiRisk
-- Dernière mise à jour du script le 31/03/2023 par Sébastien

-- Paramètres d'entrée :
-- nom_ter = nom du territoire d'étude tel que renseigné dans le champ `territoire` de la table c_general.territoires
-- an_bdtopo = millésime (année au format AAAA) de la BD TOPO®
-- an_iris = millésime (année au format AAAA) de la table des IRIS Grande Échelle
-- an_bdtopage = millésime (année au format AAAA) de la BD TOPAGE® (qui remplace la BD CARTHAGE® depuis 2020)

-- Exemple d'appel à cette fonction : SELECT public.__var_zt('TRI Verdun', '2022', '2022', '2019');

DECLARE
	c integer; -- un compteur des lignes modifiées pour logging
	heure1 varchar; -- heure de début du traitement
	heure2 varchar; -- heure de fin du traitement
	nindexzt varchar; -- liste des index zt
	att varchar; -- liste des attributs de la table zt
	typ varchar; -- liste des types d'attributs de la table zt

BEGIN
	heure1 = clock_timestamp();

	--************************************************************************
	-- Définition des schémas de travail
	--************************************************************************
	SET SEARCH_PATH TO public, c_phenomenes, r_sandre_bdtopage, r_ign_irisge, r_ign_bdtopo;

    RAISE NOTICE '';
    RAISE NOTICE '====== RAPPORT ======';
    RAISE NOTICE 'Calcul de la variable Zt (périmètres de calcul élémentaires) sur le territoire "%"', nom_ter;
    RAISE NOTICE 'Début du traitement : %', heure1;

    --************************************************************************
    -- Vérification de l'existence du territoire dans la table c_general.territoires
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
	-- Vérification de l'absence du territoire renseigné dans la table c_phenomenes.zt
    --************************************************************************
	IF EXISTS (
		SELECT *
		FROM c_phenomenes.zt
		WHERE territoire = ''||nom_ter||''
	)
	THEN
		RAISE EXCEPTION 'Il existe déjà des enregistrements pour le territoire "%" dans la table c_phenomenes.zt. 
		Pour les supprimer, lancer la requête suivante : 
		DELETE FROM c_phenomenes.zt WHERE territoire = ''%'';', nom_ter, REPLACE(nom_ter,'''','''''');
	END IF;

	--************************************************************************
	-- Correction des géométries dans la couche c_general.territoires pour éviter les erreurs bloquantes
    --************************************************************************
	RAISE NOTICE 'Correction des géométries dans la couche c_general.territoires pour éviter les erreurs bloquantes';
	EXECUTE 'UPDATE c_general.territoires
	SET geom = ST_Multi(ST_Simplify(ST_CollectionExtract(ST_ForceCollection(ST_MakeValid(geom)),3),0))
	WHERE __util_to_snake_case(territoire) = '''||__util_to_snake_case(nom_ter)||'''';

	--************************************************************************
	-- Calcul Zt pour le territoire renseigné
	--************************************************************************
	RAISE NOTICE '[INFO] Les contours IRIS GE n''ont pas encore été importés pour le territoire "%" dans la table c_phenomenes.zt. 
			Import en cours...', nom_ter;
	EXECUTE '
		WITH administratif AS (
			SELECT
				'''||REPLACE(nom_ter,'''','''''')||''' AS territoire,
				iris.code_iris AS id_iris,
				CASE
					WHEN iris.nom_com = iris.nom_iris THEN iris.nom_com
					ELSE iris.nom_com || '' - '' || iris.nom_iris
				END AS libelle,
				iris.insee_com AS id_commune,
				commune.siren_epci AS id_epci,
				commune.insee_dep AS id_dpt,
				commune.insee_reg AS id_region,
				''IRIS GE IGN '||an_iris||', BD TOPO IGN '||an_bdtopo||''' AS sce_donnee,
				''__var_zt'' AS moda_calc,
				current_date AS date_calc,
				iris.geom AS geom
			FROM irisge_'||an_iris||' iris, commune_'||an_bdtopo||' commune, c_general.territoires ter
			WHERE iris.insee_com = commune.insee_com
				AND __util_to_snake_case(ter.territoire) = '''||__util_to_snake_case(nom_ter)||'''
				AND iris.geom && ter.geom
				AND ST_Intersects(ST_Buffer(iris.geom, -1), ter.geom)				
		)
		INSERT INTO zt(territoire, id_iris, libelle, id_commune, id_epci, id_dpt, id_region, sce_donnee, moda_calc, date_calc, geom)
		SELECT *
		FROM administratif';

	--************************************************************************
	-- Récupère le nombre d'entités ajoutées
	--************************************************************************
	GET DIAGNOSTICS c = row_count;

	--************************************************************************
	-- Ajout dans la table d'association avec la table zt_bh (bassins hydrographiques)
	--************************************************************************
	RAISE NOTICE 'Ajout dans la table d''association avec la table zt_bh (bassins hydrographiques)';
	EXECUTE '
		INSERT INTO c_phenomenes.zt_bh
		SELECT zt.id, bh.id
		FROM zt, bassin_hydrographique_'||an_topage||' bh
		WHERE ST_Intersects(zt.geom, bh.geom)
		AND __util_to_snake_case(zt.territoire) = '''||__util_to_snake_case(nom_ter)||'''';

	--************************************************************************
	-- Ajout dans la table d'association avec la table zt_bv (bassins versants topographiques)
	--************************************************************************
	RAISE NOTICE 'Ajout dans la table d''association avec la table zt_bv (bassins versants topographiques)';
	EXECUTE '
		INSERT INTO c_phenomenes.zt_bv (id_zt, id_bv)
		SELECT zt.id, bv.id
		FROM zt, bassin_versant_topographique_'||an_topage||' bv
		WHERE ST_Intersects(zt.geom, bv.geom)
		AND __util_to_snake_case(zt.territoire) = '''||__util_to_snake_case(nom_ter)||'''';

	--************************************************************************
	-- Ajout dans la table d'association avec la table zt_bve (bassins versants élémentaires)
	--************************************************************************
	RAISE NOTICE 'Ajout dans la table d''association avec la table zt_bve (bassins versants élémentaires)';
	EXECUTE '
		INSERT INTO c_phenomenes.zt_bve (id_zt, id_bve)
		SELECT zt.id, bve.id
		FROM zt, test_bvzorn_bassin_versant_elementaire bve
		WHERE ST_Intersects(zt.geom, bve.geom)
		AND __util_to_snake_case(zt.territoire) = '''||__util_to_snake_case(nom_ter)||'''';

	--************************************************************************
	-- Ajout dans la table d'association avec la table zt_mbv (macro-bassins versants)
	--************************************************************************
	RAISE NOTICE 'Ajout dans la table d''association avec la table zt_mbv (macro-bassins versants)';
	EXECUTE '
		INSERT INTO c_phenomenes.zt_mbv (id_zt, id_mbv)
		SELECT zt.id, mbv.id
		FROM zt, r_sandre_bdtopage.sous_secteur_hydro_2016 mbv
		WHERE ST_Intersects(zt.geom, mbv.geom)
		AND __util_to_snake_case(zt.territoire) = '''||__util_to_snake_case(nom_ter)||'''';

	--************************************************************************
	-- Création de la vue matérialisée zt sur le territoire
	--************************************************************************
	EXECUTE '
		DROP MATERIALIZED VIEW IF EXISTS c_phenomenes.zt_'||__util_to_snake_case(nom_ter)||';
		CREATE MATERIALIZED VIEW c_phenomenes.zt_'||__util_to_snake_case(nom_ter)||' AS
		SELECT *
		FROM c_phenomenes.zt
		WHERE __util_to_snake_case(zt.territoire) = '''||__util_to_snake_case(nom_ter)||'''';

	-- Création des index sur la vue matérialisée
	EXECUTE 'CREATE INDEX ON c_phenomenes.zt_'||__util_to_snake_case(nom_ter)||' USING gist(geom)';
	EXECUTE 'CREATE INDEX ON c_phenomenes.zt_'||__util_to_snake_case(nom_ter)||' USING btree(id)';
	EXECUTE 'CREATE INDEX ON c_phenomenes.zt_'||__util_to_snake_case(nom_ter)||' USING btree(territoire)';
	EXECUTE 'CREATE INDEX ON c_phenomenes.zt_'||__util_to_snake_case(nom_ter)||' USING btree(id_iris)';
	EXECUTE 'CREATE INDEX ON c_phenomenes.zt_'||__util_to_snake_case(nom_ter)||' USING btree(libelle)';
	EXECUTE 'CREATE INDEX ON c_phenomenes.zt_'||__util_to_snake_case(nom_ter)||' USING btree(id_commune)';
	EXECUTE 'CREATE INDEX ON c_phenomenes.zt_'||__util_to_snake_case(nom_ter)||' USING btree(id_dpt)';
	EXECUTE 'CREATE INDEX ON c_phenomenes.zt_'||__util_to_snake_case(nom_ter)||' USING btree(id_region)';

    --************************************************************************
    -- Regénération de l'ensemble des index sur la table zt
    --************************************************************************
   	-- Pour cela, on crée une table temporaire qui récupère tous les attributs de la table zt
   	EXECUTE 'DROP TABLE IF EXISTS attname CASCADE;
	CREATE TEMP TABLE attname
	AS SELECT pg_attribute.attname, pg_type.typname
	FROM pg_class
	JOIN pg_attribute ON pg_class.relname=''zt'' AND pg_attribute.attrelid=pg_class.oid AND attnum > 0
	JOIN pg_type ON pg_type.oid=pg_attribute.atttypid';

	-- On récupère dans une variable nindexzt les noms de tous les index affectés aux champs de la table zt
	FOR att, typ IN SELECT attname, typname FROM attname
	LOOP
		EXECUTE 'SELECT indexname
			FROM pg_indexes
			WHERE
				schemaname = ''c_phenomenes''
				AND tablename = ''zt''
				AND substring(split_part(indexdef,''('',2), 1, char_length(split_part(indexdef,''('',2))-1) = '''||att||'''
			ORDER BY indexname'
		INTO nindexzt;
		IF nindexzt IS NOT NULL
			THEN
				EXECUTE 'DROP INDEX IF EXISTS '||nindexzt||'';
				IF typ = 'geometry'
					THEN EXECUTE 'CREATE INDEX ON c_phenomenes.zt USING gist('||att||')';
					ELSE EXECUTE 'CREATE INDEX ON c_phenomenes.zt USING btree('||att||')';
				END IF;
		END IF;
	END LOOP;

    --************************************************************************
    -- Conclusion
    --************************************************************************
    RAISE NOTICE '';
    RAISE NOTICE '====== FIN TRAITEMENT ======';
	RAISE NOTICE '[INFO] La table zt (périmètres de calcul élémentaires) a été mise à jour dans le schéma c_phenomenes pour le territoire de "%"', nom_ter;
    RAISE NOTICE '';
    RAISE NOTICE '====== RÉSULTATS ======';
    RAISE NOTICE '% entités ajoutées pour le territoire "%" dans la table c_phenomenes.zt', c, nom_ter;
    RAISE NOTICE 'Création de la vue "%"', 'c_phenomenes.zt_'||__util_to_snake_case(nom_ter);
   	heure2 = clock_timestamp();
	RAISE NOTICE 'Fin du traitement : %', heure2;
	RAISE NOTICE 'Durée du traitement : %', CAST(heure2 as time)-CAST(heure1 as time);
	RAISE NOTICE '';

END;
$function$
