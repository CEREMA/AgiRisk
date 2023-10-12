SET client_encoding = 'UTF8';

CREATE OR REPLACE FUNCTION public.__var_oc11(nom_ter text, an_bdtopo text)
 RETURNS void
 LANGUAGE plpgsql
AS $function$

-- Fonction SQL d'incrémentation de la table oc11 (établissements publics) dans le schéma c_occupation_sol
-- © Cerema / GT AgiRisk (auteure principale du script : Anaïs)
-- Dernière mise à jour du script le 25/08/2023 par Sébastien (test avec succès sur Longuyon le 24/08/2023)

-- Paramètres d'entrée :
-- nom_ter = nom du territoire d'étude tel que renseigné dans le champ `territoire` de la table c_general.territoires
-- an_bdtopo = millésime (année au format AAAA) de la BD TOPO®

-- Exemple d'appel à cette fonction :
-- SELECT public.__var_oc11('TRI Verdun', '2022');

-- La présente fonction crée la variable Oc11, correspondant aux établissements publics présents sur le territoire d'étude.

DECLARE
	c integer; -- un compteur des lignes modifiées pour logging
	heure1 varchar; -- heure de début du traitement
	heure2 varchar; -- heure de fin du traitement

BEGIN
	heure1 = clock_timestamp();

	--************************************************************************
	-- Définition des schémas de travail
	--************************************************************************
	SET SEARCH_PATH TO public, c_phenomenes, c_occupation_sol, r_ign_bdtopo;

	RAISE NOTICE '';
	RAISE NOTICE '====== RAPPORT ======';
	RAISE NOTICE 'Calcul de la variable Oc11 (établissements publics) sur le territoire "%"', nom_ter;
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
	-- Vérification de l'absence du territoire renseigné dans la table c_occupation_sol.oc11
	--************************************************************************
	IF EXISTS (
		SELECT *
		FROM c_occupation_sol.oc11
		WHERE territoire = ''||nom_ter||''
	)
	THEN
		RAISE EXCEPTION 'Il existe déjà des enregistrements pour le territoire "%" dans la table c_occupation_sol.oc11. 
		Pour les supprimer, lancer la requête suivante : 
		DELETE FROM c_occupation_sol.oc11 WHERE territoire = ''%'';', nom_ter, REPLACE(nom_ter,'''','''''');
	END IF;

	--************************************************************************
	-- Calcul Oc11 (récupération des ERP renseignés dans la BD TOPO® uniquement dans la présente modalité de calcul)
	--************************************************************************
	RAISE NOTICE '';
	RAISE NOTICE '[INFO] Les établissements publics n''ont pas encore été importés pour le territoire "%" dans la table c_occupation_sol.oc11. 
			Import en cours...', nom_ter;
		EXECUTE 'INSERT INTO c_occupation_sol.oc11 (
				territoire,
				id_iris,
				nom_iris,
				id_sce,
				type_etab,
				cap_acc,
				cap_heberg,
				categorie,
				libelle,
				sce_donnee,
				url,
				moda_calc,
				date_calc,
				geom,
				geomloc
			)
			SELECT
				'''||REPLACE(nom_ter,'''','''''')||''',
				zt.id_iris,
				zt.libelle,
				erp.id,
				''ERP'',
				CASE
					WHEN erp.cap_acc IS NULL THEN 0
					ELSE erp.cap_acc
				END,
				CASE
					WHEN erp.cap_heberg IS NULL THEN 0
					ELSE erp.cap_heberg
				END,
				erp.categorie,
				erp.libelle,
				''BD TOPO IGN '||an_bdtopo||''',
				''https://geoservices.ign.fr/bdtopo'',
				''__var_oc11'',
				current_date,
				ST_Multi(ST_Simplify(ST_CollectionExtract(ST_ForceCollection(ST_MakeValid(ST_Buffer(erp.geom,10))),3),0)),
				erp.geom
			FROM erp_'||an_bdtopo||' AS erp, zt
			WHERE __util_to_snake_case(zt.territoire) = '''||__util_to_snake_case(nom_ter)||'''
			AND ST_Intersects(erp.geom, zt.geom)';

	--************************************************************************
	-- Récupération du nombre d'entités ajoutées
	--************************************************************************
	GET DIAGNOSTICS c = row_count;

	RAISE NOTICE '			Import terminé';

	--************************************************************************
	-- Création de la vue matérialisée sur le territoire
	--************************************************************************
	RAISE NOTICE '';
	RAISE NOTICE 'Création de la vue matérialisée %', 'c_occupation_sol.oc11_'||__util_to_snake_case(nom_ter);
	EXECUTE '
		DROP MATERIALIZED VIEW IF EXISTS c_occupation_sol.oc11_'||__util_to_snake_case(nom_ter)||' CASCADE;
		CREATE MATERIALIZED VIEW c_occupation_sol.oc11_'||__util_to_snake_case(nom_ter)||' AS
		SELECT *
		FROM c_occupation_sol.oc11
		WHERE __util_to_snake_case(territoire) = '''||__util_to_snake_case(nom_ter)||'''
		ORDER BY nom_iris';

	-- Création des index sur la vue matérialisée
	RAISE NOTICE 'Création des index sur la vue matérialisée';

	EXECUTE 'CREATE UNIQUE INDEX ON c_occupation_sol.oc11_'||__util_to_snake_case(nom_ter)||' (id)';

	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc11_'||__util_to_snake_case(nom_ter)||' USING gist(geom)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc11_'||__util_to_snake_case(nom_ter)||' USING gist(geomloc)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc11_'||__util_to_snake_case(nom_ter)||' USING btree(id)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc11_'||__util_to_snake_case(nom_ter)||' USING btree(territoire)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc11_'||__util_to_snake_case(nom_ter)||' USING btree(id_iris)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc11_'||__util_to_snake_case(nom_ter)||' USING btree(nom_iris)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc11_'||__util_to_snake_case(nom_ter)||' USING btree(id_sce)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc11_'||__util_to_snake_case(nom_ter)||' USING btree(type_etab)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc11_'||__util_to_snake_case(nom_ter)||' USING btree(cap_acc)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc11_'||__util_to_snake_case(nom_ter)||' USING btree(cap_heberg)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc11_'||__util_to_snake_case(nom_ter)||' USING btree(categorie)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc11_'||__util_to_snake_case(nom_ter)||' USING btree(libelle)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc11_'||__util_to_snake_case(nom_ter)||' USING btree(sce_donnee)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc11_'||__util_to_snake_case(nom_ter)||' USING btree(url)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc11_'||__util_to_snake_case(nom_ter)||' USING btree(moda_calc)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc11_'||__util_to_snake_case(nom_ter)||' USING btree(date_calc)';
	RAISE NOTICE 'Index créés sur la vue matérialisée';

	--************************************************************************
	-- Conclusion
	--************************************************************************
	RAISE NOTICE '';
	RAISE NOTICE '====== FIN TRAITEMENT ======';
	RAISE NOTICE '[INFO] La table oc11 (zones en voie d''urbanisation) a été mise à jour dans le schéma c_occupation_sol pour le territoire "%"', nom_ter;
	RAISE NOTICE '';
	RAISE NOTICE '====== RÉSULTATS ======';
	IF c > 1
		THEN RAISE NOTICE '% enregistrements insérés au total dans la table c_occupation_sol.oc11 pour le territoire "%"', c, nom_ter;
		ELSE RAISE NOTICE '% enregistrement inséré dans la table c_occupation_sol.oc11 pour le territoire "%"', c, nom_ter;
	END IF;
	RAISE NOTICE '';
	heure2 = clock_timestamp();
	RAISE NOTICE 'Fin du traitement : %', heure2;
	RAISE NOTICE 'Durée du traitement : %', CAST(heure2 as time)-CAST(heure1 as time);
	RAISE NOTICE '';

END;
$function$
