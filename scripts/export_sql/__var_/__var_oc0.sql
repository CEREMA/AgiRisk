SET client_encoding = 'UTF8';

CREATE OR REPLACE FUNCTION public.__var_oc0(nom_ter text, an_gpu text)
 RETURNS void
 LANGUAGE plpgsql
AS $function$

-- Fonction SQL d'incrémentation de la table oc0 (zones en voie d'urbanisation) dans le schéma c_occupation_sol
-- © Cerema / GT AgiRisk (auteurs principaux du script : Anaïs, Sébastien)
-- Dernière mise à jour du script le 25/08/2023 par Sébastien (test avec succès sur Longuyon le 24/08/2023)

-- Paramètres d'entrée :
-- nom_ter : nom du territoire d'étude tel que renseigné dans le champ `territoire` de la table c_general.territoires (ex : Jura, Scot de Tours, TRI Noirmoutier SJDM, TRI Verdun, Vienne Clain, Zorn)
-- an_gpu : millésime (année au format AAAA) des données du Géoportail de l'Urbanisme (GPU) (ex : 2022)

-- Exemple d'appel à cette fonction :
-- SELECT public.__var_oc0('TRI Verdun', '2022');

-- La présente fonction crée la variable Oc0, correspondant aux zones A Urbaniser (AU) présentes sur le territoire d'étude.
-- Point de vigilance : dans cette méthode de calcul, seules les zones de type AUc ou AUs existantes dans la table "zone_urba" du GPU sont récupérées. Les données des cartes communales (secteurs ouverts à la construction dans la table "secteur_cc" dans le GPU) ne sont pas utilisées.

-- TO-DO : Proposition d'évolution du script à mettre en oeuvre : intégrer une commande permettant de corriger les chevauchements partiels d'une même zone AU sur deux périmètres de calcul différents (les contours des IRIS GE, cohérents avec les contours communaux de la BD TOPO®, n'étant en effet pas superposables avec le plan parcellaire). Les tests montrent que la plupart des portions de zones AU mal géoréférencées n'intersectent pas la couche des zones inondables et sont donc occultées au moment du calcul de l'indicateur S2/14a, ce qui limite les erreurs. Ainsi, le traitement de cette proposition a été considérée comme non prioritaire pour les ANRN 2022.

DECLARE
	c integer; -- un compteur des lignes modifiées pour logging
	heure1 varchar; -- heure de début du traitement
	heure2 varchar; -- heure de fin du traitement

BEGIN
	heure1 = clock_timestamp();

	--************************************************************************
	-- Définition des schémas de travail
	--************************************************************************
	SET SEARCH_PATH TO public, c_phenomenes, c_occupation_sol, r_ign_gpu;

	RAISE NOTICE '';
	RAISE NOTICE '====== RAPPORT ======';
	RAISE NOTICE 'Calcul de la variable Oc0 (zones en voie d''urbanisation) sur le territoire "%"', nom_ter;
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
	-- Vérification de l'absence du territoire renseigné dans la table c_occupation_sol.oc0
	--************************************************************************
	IF EXISTS (
		SELECT *
		FROM c_occupation_sol.oc0
		WHERE territoire = ''||nom_ter||''
	)
	THEN
		RAISE EXCEPTION 'Il existe déjà des enregistrements pour le territoire "%" dans la table c_occupation_sol.oc0. 
		Pour les supprimer, lancer la requête suivante : 
		DELETE FROM c_occupation_sol.oc0 WHERE territoire = ''%'';', nom_ter, REPLACE(nom_ter,'''','''''');
	END IF;

	--************************************************************************
	-- Récupération des zones à urbaniser réglementées par un PLU ou PLUi disponible dans le Géoportail de l'Urbanisme
	--************************************************************************
	RAISE NOTICE '';
	RAISE NOTICE '[INFO] Les zones à urbaniser n''ont pas encore été importées pour le territoire "%" dans la table c_occupation_sol.oc0. 
			Import en cours...', nom_ter;
	EXECUTE 'INSERT INTO c_occupation_sol.oc0 (
			territoire,
			id_iris,
			nom_iris,
			type_zone_urba,
			sce_donnee,
			url_doc_urba,
			moda_calc,
			date_calc,
			geom
		)
		SELECT DISTINCT
			'''||REPLACE(nom_ter,'''','''''')||''',
			zt.id_iris,
			zt.libelle,
			''AU''::varchar(5),
			''GPU IGN '||an_gpu||''',
			''https://www.geoportail-urbanisme.gouv.fr/document/download-by-partition/'' || zonage_urbanisme.partition,
			''__var_oc0''::varchar(50),
			current_date,
			ST_Multi(ST_Simplify(ST_CollectionExtract(ST_ForceCollection(ST_MakeValid(ST_Intersection(zonage_urbanisme.geom, zt.geom))),3),0))
		FROM zonage_urbanisme_'||an_gpu||' zonage_urbanisme, c_phenomenes.zt
		WHERE zonage_urbanisme.typezone IS NOT NULL
			AND zonage_urbanisme.typezone LIKE ''%AU%''
			AND ST_Intersects(ST_Buffer(zonage_urbanisme.geom, -1), zt.geom)
			AND __util_to_snake_case(zt.territoire) = '''||__util_to_snake_case(nom_ter)||'''
		';

	--************************************************************************
	-- Récupère le nombre d'entités ajoutées
	--************************************************************************
	GET DIAGNOSTICS c = row_count;

	--************************************************************************
	-- Création de la vue matérialisée oc0 sur le territoire
	--************************************************************************
	RAISE NOTICE '';
	RAISE NOTICE 'Création de la vue %', 'c_occupation_sol.oc0_'||__util_to_snake_case(nom_ter);
	EXECUTE '
		DROP MATERIALIZED VIEW IF EXISTS c_occupation_sol.oc0_'||__util_to_snake_case(nom_ter)||' CASCADE;
		CREATE MATERIALIZED VIEW c_occupation_sol.oc0_'||__util_to_snake_case(nom_ter)||' AS
		SELECT *
		FROM c_occupation_sol.oc0
		WHERE __util_to_snake_case(territoire) = '''||__util_to_snake_case(nom_ter)||'''
		ORDER BY nom_iris';

	-- Création des index sur la vue matérialisée
	RAISE NOTICE 'Création des index sur la vue matérialisée';

	EXECUTE 'CREATE UNIQUE INDEX ON c_occupation_sol.oc0_'||__util_to_snake_case(nom_ter)||' (id)';

	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc0_'||__util_to_snake_case(nom_ter)||' USING gist(geom)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc0_'||__util_to_snake_case(nom_ter)||' USING btree(id)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc0_'||__util_to_snake_case(nom_ter)||' USING btree(territoire)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc0_'||__util_to_snake_case(nom_ter)||' USING btree(id_iris)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc0_'||__util_to_snake_case(nom_ter)||' USING btree(nom_iris)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc0_'||__util_to_snake_case(nom_ter)||' USING btree(type_zone_urba)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc0_'||__util_to_snake_case(nom_ter)||' USING btree(sce_donnee)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc0_'||__util_to_snake_case(nom_ter)||' USING btree(url_doc_urba)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc0_'||__util_to_snake_case(nom_ter)||' USING btree(moda_calc)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc0_'||__util_to_snake_case(nom_ter)||' USING btree(date_calc)';
	RAISE NOTICE 'Index créés sur la vue matérialisée';

	--************************************************************************
	-- Conclusion
	--************************************************************************
	RAISE NOTICE '';
	RAISE NOTICE '====== FIN TRAITEMENT ======';
	RAISE NOTICE '[INFO] La table oc0 (zones en voie d''urbanisation) a été mise à jour dans le schéma c_occupation_sol pour le territoire "%"', nom_ter;
	RAISE NOTICE '';
	RAISE NOTICE '====== RÉSULTATS ======';
	IF c > 1
		THEN RAISE NOTICE '% enregistrements insérés au total dans la table c_occupation_sol.oc0 pour le territoire "%"', c, nom_ter;
		ELSE RAISE NOTICE '% enregistrement inséré dans la table c_occupation_sol.oc0 pour le territoire "%"', c, nom_ter;
	END IF;
	RAISE NOTICE '';
	heure2 = clock_timestamp();
	RAISE NOTICE 'Fin du traitement : %', heure2;
	RAISE NOTICE 'Durée du traitement : %', CAST(heure2 as time)-CAST(heure1 as time);
	RAISE NOTICE '';

END;
$function$
