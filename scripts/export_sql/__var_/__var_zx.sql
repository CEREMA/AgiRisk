SET client_encoding = 'UTF8';

CREATE OR REPLACE FUNCTION public.__var_zx(nom_ter text, typ_alea text, code_occ text, desc_alea text)
 RETURNS void
 LANGUAGE plpgsql
AS $function$

-- Fonction SQL de constitution de la couche zx (enveloppes des zones inondables) à partir de la couche zq (zones d'intensité des aléas)
-- © Cerema / GT AgiRisk (auteurs du script : Thomas, Sébastien)
-- Dernière mise à jour du script le 24/08/2023 par Sébastien

-- Paramètres d'entrée :
-- nom_ter : nom du territoire d'étude tel que renseigné dans le champ `territoire` de la table c_general.territoires (ex : Jura, Scot de Tours, TRI Noirmoutier SJDM, TRI Verdun, Vienne Clain, Zorn)
-- typ_alea : type d'aléa considéré (ex : débordement de cours d'eau, submersion marine)
-- code_occ : période de retour considérée pour le type d'aléa choisi (ex : QRef, Q100, Q10)
-- desc_alea : description de la source de l'aléa (ex : PPRi de ..., Etude de modélisation ...)

-- Exemple d'appel à cette fonction :
-- SELECT public.__var_zx('Longuyon', 'débordement de cours d''eau', 'Q100', 'Modélisation Chiers BCEOM 2007');

DECLARE
	c integer; -- un compteur des lignes modifiées pour logging
	heure1 varchar; -- heure de début du traitement
	heure2 varchar; -- heure de fin du traitement

BEGIN
	heure1 = clock_timestamp();

	--************************************************************************
	-- Définition des schémas de travail
	--************************************************************************
	SET SEARCH_PATH TO public, c_phenomenes;

	RAISE NOTICE '';
	RAISE NOTICE '====== RAPPORT ======';
	RAISE NOTICE 'Calcul de la variable Zx (enveloppes des zones inondables) sur le territoire "%"', nom_ter;
	RAISE NOTICE 'Début du traitement : %', heure1;

	--************************************************************************
	-- Calcul Zx
	--************************************************************************
	EXECUTE 'DELETE FROM c_phenomenes.zx WHERE territoire = '''||REPLACE(nom_ter,'''','''''')||''' AND type_alea = '''||REPLACE(typ_alea,'''','''''')||''' AND code_occurrence = '''||REPLACE(code_occ,'''','''''')||''' AND description_alea = '''||REPLACE(desc_alea,'''','''''')||'''';
	EXECUTE 'INSERT INTO c_phenomenes.zx (
			territoire,
			type_alea,
			occurrence,
			code_occurrence,
			description_alea,
			moda_calc,
			date_calc,
			geom
		)
		SELECT
			territoire,
			type_alea,
			occurrence,
			code_occurrence,
			description_alea,
			''__var_zx'',
			current_date,
			st_multi(ST_Union(geom))
		FROM c_phenomenes.zq
		WHERE __util_to_snake_case(territoire) = '''||__util_to_snake_case(nom_ter)||'''
		GROUP BY territoire, type_alea, occurrence, code_occurrence, description_alea
	';

	--************************************************************************
	-- Récupère le nombre d'entités ajoutées
	--************************************************************************
	GET DIAGNOSTICS c = row_count;

	--************************************************************************
	-- Création de la vue matérialisée zx sur le territoire
	--************************************************************************
	RAISE NOTICE 'Création de la vue matérialisée zx sur le territoire';
	EXECUTE '
		DROP MATERIALIZED VIEW IF EXISTS c_phenomenes.zx_'||__util_to_snake_case(nom_ter)||' CASCADE;
		CREATE MATERIALIZED VIEW c_phenomenes.zx_'||__util_to_snake_case(nom_ter)||' AS
		SELECT *
		FROM c_phenomenes.zx
		WHERE __util_to_snake_case(territoire) = '''||__util_to_snake_case(nom_ter)||'''';

	-- Création des index sur la vue matérialisée
	RAISE NOTICE 'Création des index sur la vue matérialisée';

	EXECUTE 'CREATE UNIQUE INDEX ON c_phenomenes.zx_'||__util_to_snake_case(nom_ter)||' (id)';

	EXECUTE 'CREATE INDEX ON c_phenomenes.zx_'||__util_to_snake_case(nom_ter)||' USING gist(geom)';
	EXECUTE 'CREATE INDEX ON c_phenomenes.zx_'||__util_to_snake_case(nom_ter)||' USING btree(id)';
	EXECUTE 'CREATE INDEX ON c_phenomenes.zx_'||__util_to_snake_case(nom_ter)||' USING btree(territoire)';
	EXECUTE 'CREATE INDEX ON c_phenomenes.zx_'||__util_to_snake_case(nom_ter)||' USING btree(type_alea)';
	EXECUTE 'CREATE INDEX ON c_phenomenes.zx_'||__util_to_snake_case(nom_ter)||' USING btree(occurrence)';
	EXECUTE 'CREATE INDEX ON c_phenomenes.zx_'||__util_to_snake_case(nom_ter)||' USING btree(code_occurrence)';
	EXECUTE 'CREATE INDEX ON c_phenomenes.zx_'||__util_to_snake_case(nom_ter)||' USING btree(description_alea)';
	EXECUTE 'CREATE INDEX ON c_phenomenes.zx_'||__util_to_snake_case(nom_ter)||' USING btree(moda_calc)';
	EXECUTE 'CREATE INDEX ON c_phenomenes.zx_'||__util_to_snake_case(nom_ter)||' USING btree(date_calc)';
	RAISE NOTICE 'Index créés sur la vue matérialisée';

	--************************************************************************
	-- Conclusion
	--************************************************************************
	RAISE NOTICE '';
	RAISE NOTICE '====== FIN TRAITEMENT ======';
	RAISE NOTICE '[INFO] La table zx a été mise à jour dans le schéma c_phenomenes pour le territoire "%" et l''aléa "% - % - %"', nom_ter, typ_alea, code_occ, desc_alea;
	RAISE NOTICE '';
	RAISE NOTICE '====== RÉSULTATS ======';
   	IF c > 1
		THEN RAISE NOTICE '% enregistrements insérés au total dans la table c_occupation_sol.zx pour le territoire "%"', c, nom_ter;
		ELSE RAISE NOTICE '% enregistrement inséré dans la table c_occupation_sol.zx pour le territoire "%"', c, nom_ter;
	END IF;
	RAISE NOTICE '';
	RAISE NOTICE 'Création de la vue "%"', 'c_phenomenes.zx_'||__util_to_snake_case(nom_ter);
	heure2 = clock_timestamp();
	RAISE NOTICE 'Fin du traitement : %', heure2;
	RAISE NOTICE 'Durée du traitement : %', CAST(heure2 as time)-CAST(heure1 as time);
	RAISE NOTICE '';

END;
$function$
