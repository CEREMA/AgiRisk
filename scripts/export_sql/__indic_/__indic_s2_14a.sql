SET client_encoding = 'UTF8';

CREATE OR REPLACE FUNCTION public.__indic_s2_14a(nom_ter text, typ_alea text, code_occ text, an_bdtopo text)
 RETURNS void
 LANGUAGE plpgsql
AS $function$

-- Fonction SQL d'incrémentation de la table p_indicateurs.s2_14a "Surfaces à urbaniser inondables"
-- © Cerema / GT AgiRisk (auteurs principaux du script : Anaïs, Lucie, Sébastien)
-- Dernières mises à jour du script le 18/04/2023 par Lucie et le 25/08/2023 par Sébastien (test avec succès sur Longuyon le 24/08/2023)

-- Paramètres d'entrée :
-- nom_ter = nom du territoire d'étude tel que renseigné dans le champ `territoire` de la table c_general.territoires (ex : Jura, Scot de Tours, TRI Noirmoutier SJDM, TRI Verdun, Vienne Clain, Zorn)
-- typ_alea : type d'aléa considéré (ex : débordement de cours d'eau, submersion marine)
-- code_occ : occurrence de crue telle que renseignée dans le champ `code_occurrence` de la table c_phenomenes.zx (ex : Q20, Q100, Q1000, QRef, Qref Xynthia, Qref Xynthia 2100)
-- an_bdtopo = millésime (année au format AAAA) de la BD TOPO®

-- Exemple d'appel à cette fonction :
-- SELECT public.__indic_s2_14a('Jura', 'débordement de cours d''eau', 'QRef', '2022');

/* La présente fonction calcule les surfaces de zones A Urbaniser (AU) susceptibles d'être exposées à une crue.
Son exécution nécessite d'avoir calculé au préalable les variables Oc0 (zones en voie d'urbanisation) et Zx (enveloppes des zones inondables) sur le territoire renseigné.

Propositions d'évolution du script à mettre en oeuvre :
-- Proposition 1 : intégrer une commande permettant de télécharger les données de la BD TOPO® directement depuis la plateforme https://geoservices.ign.fr de l'IGN, via les flux WFS dédiés.
-- Proposition 2 : ajouter en entrée de la fonction, une clause sur le type d'aléa (ex : débordement de cours d'eau, érosion - recul du trait de cote, remontée de nappe, ruissellement, submersion marine), car il est possible par exemple d'avoir une 'QRef' pour deux types d'aléa différents sur le même territoire.
-- Proposition 3 : à l'étape de contrôle de l'existence ou non du territoire et de l'occurrence de crue dans la table s2_14a, intégrer une commande permettant de comparer aussi les dates de calcul.
-- Proposition 4 : ajouter une étape préalable ("0" cachée) visant à attribuer la valeur "0" à tous les champs relatifs aux surfaces et proportions de zones AU, pour tous les contours IRIS GE intersectant le territoire d'étude, sans pour autant récupérer la géométrie de ces contours IRIS GE ou celle des zones AU non inondables. Cela permettra, au moment de l'affichage des résultats, d'avoir les IRIS / communes / EPCI / etc. ne comprenant aucune zone AU inondable, en plus des IRIS / communes / EPCI / etc. comprenant des zones AU inondables (la valeur "0" étant un résultat à part entière à prendre en compte de l'évaluation de la vulnérabilité des territoires face aux risques d'inondation). Il est proposé d'ajouter cette commande au niveau du calcul de l'indicateur, et non dès la variable. En effet, au stade de l'identification des zones AU sur le territoire (constitution de la variable Oc0), on ne peut pas savoir si les portions de territoire sans zone AU dans le GPU, sont effectivement sans zone AU, ou si la donnée n'a pas encore importée.
-- Proposition 5 : ajouter une condition de type ST_Within() ou ST_Contains() pour réaliser les calculs de surfaces/proportions sur un périmètre supérieur si, et seulement si, ce périmètre est intégralement inclus dans le périmètre du territoire d'étude considéré (à défaut, établir une comparaison des surfaces entre les différents périmètres de calcul).
-- Proposition 6 : il pourrait être intéressant d'améliorer la précision des résultats de l'indicateur en croisant les zones à urbaniser directement avec la variable Zh (classes de hauteur d'eau pour les différentes occurrences de crue étudiées). En effet, on pourrait imaginer une adaptation des prescriptions en fonction de la hauteur d'eau au sein des zones AU (ex : inconstructibilité totale dans les zones d'aléa fort, constructions sur pilotis possibles dans les zones d'aléa les plus faibles).
-- Proposition 7 : intégrer une commande en fin de traitement permettant de trier les enregistrements de la table s2_14a par ordre croissant des noms de territoire, de commune et d'occurrence de crue (la commande "SELECT * FROM p_indicateurs.s2_14a ORDER BY territoire, nom_commune, code_occurrence" fonctionnant parfaitement dans le logiciel de gestion de base de données, mais pas dans le présent script). */

DECLARE
	c_in integer; -- un compteur des lignes modifiées pour logging
	c_out integer; -- un compteur des lignes modifiées pour logging
	heure1 varchar; -- heure de début du traitement
	heure2 varchar; -- heure de fin du traitement
	
BEGIN
	heure1 = clock_timestamp();
	
	--************************************************************************
	-- Définition des schémas de travail
	--************************************************************************
	SET search_path TO p_indicateurs, c_general, c_phenomenes, c_occupation_sol, r_ign_bdtopo, public;

	RAISE NOTICE '';
	RAISE NOTICE '====== RAPPORT ======';
	RAISE NOTICE 'Calcul de l''indicateur S2/14a (surfaces à urbaniser inondables) sur le territoire "%" pour l''aléa "% - %"', nom_ter, typ_alea, code_occ;
	RAISE NOTICE '[NOTA] Calcul basé sur les variables Oc0 et Zx disponibles dans la base de données';
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
	-- Vérification de l'absence de données pour le territoire, le type d'aléa et l'occurrence de crue renseignés dans la table p_indicateurs.s2_14a
	--************************************************************************
	IF EXISTS (
		SELECT *
		FROM p_indicateurs.s2_14a
		WHERE territoire = ''||nom_ter||''
			AND type_alea = ''||typ_alea||''
			AND code_occurrence = ''||code_occ||''
	)
	THEN
		RAISE EXCEPTION 'Il existe déjà des enregistrements pour le territoire "%" avec l''aléa "% - %" dans la table p_indicateurs.s2_14a. 
		Pour les supprimer, lancer la requête suivante : 
		DELETE FROM p_indicateurs.s2_14a WHERE territoire = ''%'' AND type_alea = ''%'' AND code_occurrence = ''%'';', nom_ter, typ_alea, code_occ, REPLACE(nom_ter,'''',''''''), REPLACE(typ_alea,'''',''''''), REPLACE(code_occ,'''','''''');
	END IF;
	
	--************************************************************************
	-- 1. Découpage des zones AU (A Urbaniser) par les zones inondables (Zx) sur le territoire d'étude
	--************************************************************************
	RAISE NOTICE '';
	RAISE NOTICE 'Récupération des géométries et affectation des noms de périmètres de calcul';
	RAISE NOTICE 'Etape 1a : récupération des bouts de zones AU inondables sur le territoire "%" pour l''aléa "% - %"', nom_ter, typ_alea, code_occ;
  
	-- 1a. Insertion des bouts de zone AU qui sont entièrement compris dans la zone zx

	EXECUTE 'INSERT INTO p_indicateurs.s2_14a(
			territoire,
			id_iris,
			nom_iris,
			loc_zx,
			type_alea,
			code_occurrence,
			surf_au,
			sce_donnee,
			moda_calc,
			date_calc,
			geom
		)
		SELECT DISTINCT
			oc0.territoire AS territoire,
			oc0.id_iris AS id_iris,
			oc0.nom_iris AS nom_iris,
			''In''::varchar(10) as loc_zx,
			zx.type_alea AS type_alea,
			zx.code_occurrence AS code_occurrence,
			ROUND((ST_Area(ST_Multi(ST_Simplify(ST_CollectionExtract(ST_ForceCollection(ST_MakeValid(ST_Intersection(oc0.geom, zx.geom))),3),0))) / 10000)::numeric,2),
			oc0.sce_donnee,
			''__indic_s2_14a''::varchar(50) AS moda_calc,
			current_date AS date_calc,
			ST_Multi(ST_Simplify(ST_CollectionExtract(ST_ForceCollection(ST_MakeValid(ST_Intersection(oc0.geom, zx.geom))),3),0))
		FROM c_occupation_sol.oc0, c_phenomenes.zx
		WHERE ST_Intersects(oc0.geom, zx.geom)
			AND __util_to_snake_case(oc0.territoire) = ''' ||__util_to_snake_case(nom_ter) ||'''
			AND __util_to_snake_case(zx.type_alea) = ''' ||__util_to_snake_case(typ_alea) ||'''
			AND __util_to_snake_case(zx.code_occurrence) = ''' ||__util_to_snake_case(code_occ) ||'''
	';

	RAISE NOTICE 'Etape 1b : récupération des bouts de zones AU non inondables sur le territoire "%" pour l''aléa "% - %"', nom_ter, typ_alea, code_occ;

	-- 1b. Insertion des bouts de zone AU qui se trouvent en dehors de la zone zx
	
	-- Insertion des bouts de zone AU qui n''intersectent pas du tout la zone zx

	EXECUTE 'DROP TABLE IF EXISTS union_zx CASCADE';
	EXECUTE 'CREATE TEMP TABLE union_zx as
		SELECT oc0.id, ST_Multi(ST_Simplify(ST_CollectionExtract(ST_ForceCollection(ST_MakeValid(ST_Union(zx.geom))),3),0))::geometry(MultiPolygon,2154) as geom_union
		FROM c_occupation_sol.oc0
		JOIN c_phenomenes.zx
		ON ST_Intersects(zx.geom, oc0.geom)
		WHERE __util_to_snake_case(oc0.territoire) = ''' ||__util_to_snake_case(nom_ter) || '''
			AND __util_to_snake_case(zx.type_alea) = '''||__util_to_snake_case(typ_alea) ||'''
			AND __util_to_snake_case(zx.code_occurrence) = ''' ||__util_to_snake_case(code_occ) || '''
		GROUP BY oc0.id';

	EXECUTE 'CREATE INDEX union_zx_id_btree ON union_zx USING btree(id)';

	EXECUTE 'INSERT INTO p_indicateurs.s2_14a(
			territoire,
			id_iris,
			nom_iris,
			loc_zx,
			type_alea,
			code_occurrence,
			surf_au,
			sce_donnee,
			moda_calc,
			date_calc,
			geom
		)
		SELECT DISTINCT
			oc0.territoire AS territoire,
			oc0.id_iris AS id_iris,
			oc0.nom_iris AS nom_iris,
			''Out''::varchar(10) as loc_zx,
			'''||REPLACE(typ_alea,'''','''''')||''' as alea,
			'''||REPLACE(code_occ,'''','''''')||''' as occ,
			ROUND((ST_Area(oc0.geom) / 10000)::numeric,2),
			oc0.sce_donnee,
			''__indic_s2_14a''::varchar(50) AS moda_calc,
			current_date AS date_calc,
			oc0.geom
		FROM c_occupation_sol.oc0
		WHERE __util_to_snake_case(oc0.territoire) = ''' ||__util_to_snake_case(nom_ter) || '''
			AND oc0.id NOT IN (SELECT id FROM union_zx)
	';

	-- Insertion des bouts de zones AU qui chevauchent la zone zx mais qui ne sont pas dedans

	EXECUTE 'INSERT INTO p_indicateurs.s2_14a(
			territoire,
			id_iris,
			nom_iris,
			loc_zx,
			type_alea,
			code_occurrence,
			surf_au,
			sce_donnee,
			moda_calc,
			date_calc,
			geom
		)
		SELECT DISTINCT
			oc0.territoire AS territoire,
			oc0.id_iris AS id_iris,
			oc0.nom_iris AS nom_iris,
			''Out''::varchar(10) as loc_zx,
			'''||REPLACE(typ_alea,'''','''''')||''' as alea,
			'''||REPLACE(code_occ,'''','''''')||''' as occ,
			ROUND((ST_Area(ST_Multi(ST_Simplify(ST_CollectionExtract(ST_ForceCollection(ST_MakeValid(ST_Difference(oc0.geom,union_zx.geom_union))),3),0))) / 10000)::numeric,2),
			oc0.sce_donnee,
			''__indic_s2_14a''::varchar(50) AS moda_calc,
			current_date AS date_calc,
			ST_Multi(ST_Simplify(ST_CollectionExtract(ST_ForceCollection(ST_MakeValid(ST_Difference(oc0.geom,union_zx.geom_union))),3),0))
		FROM c_occupation_sol.oc0
		LEFT JOIN union_zx
		ON oc0.id = union_zx.id
		WHERE NOT ST_IsEmpty(ST_Difference(oc0.geom,union_zx.geom_union))
			AND __util_to_snake_case(oc0.territoire) = ''' ||__util_to_snake_case(nom_ter) || '''
	';

	--************************************************************************
	-- Récupération du nombre d'entités ajoutées
	--************************************************************************
	EXECUTE '
		SELECT count(*)
		FROM s2_14a
		WHERE __util_to_snake_case(territoire) = '''||__util_to_snake_case(nom_ter)||'''
			AND __util_to_snake_case(type_alea) = '''||__util_to_snake_case(typ_alea)||'''
			AND __util_to_snake_case(code_occurrence) = '''||__util_to_snake_case(code_occ)||'''
			AND loc_zx = ''In'''
	INTO c_in; -- nombre total de zones AU inondables insérées dans la table
	
	EXECUTE '
		SELECT count(*)
		FROM s2_14a
		WHERE __util_to_snake_case(territoire) = '''||__util_to_snake_case(nom_ter)||'''
			AND __util_to_snake_case(type_alea) = '''||__util_to_snake_case(typ_alea)||'''
			AND __util_to_snake_case(code_occurrence) = '''||__util_to_snake_case(code_occ)||'''
			AND loc_zx = ''Out'''
	INTO c_out; -- nombre total de zones AU non inondables insérées dans la table

	--************************************************************************
	-- 2. Attribution des codes et des noms de périmètres
	--************************************************************************
	RAISE NOTICE 'Etape 2 : attribution des codes et des noms de périmètres';

	-- 2a. Attribution des codes INSEE et noms de communes
		EXECUTE '
			UPDATE p_indicateurs.s2_14a
			SET id_commune = com.insee_com, nom_commune = com.nom
			FROM c_phenomenes.zt, commune_' || an_bdtopo || ' AS com
			WHERE __util_to_snake_case(s2_14a.territoire) = '''||__util_to_snake_case(nom_ter)||'''
				AND __util_to_snake_case(s2_14a.type_alea) = '''||__util_to_snake_case(typ_alea)||'''
				AND __util_to_snake_case(s2_14a.code_occurrence) = '''||__util_to_snake_case(code_occ)||'''
				AND __util_to_snake_case(zt.territoire) = '''||__util_to_snake_case(nom_ter)||'''
				AND s2_14a.id_iris = zt.id_iris
				AND zt.id_commune = com.insee_com';
			
	-- 2b. Attribution des codes et noms EPCI
		EXECUTE '
			UPDATE p_indicateurs.s2_14a
			SET id_epci = epci.code_siren, nom_epci = epci.nom
			FROM c_phenomenes.zt, epci_' || an_bdtopo || ' AS epci
			WHERE __util_to_snake_case(s2_14a.territoire) = '''||__util_to_snake_case(nom_ter)||'''
				AND __util_to_snake_case(s2_14a.type_alea) = '''||__util_to_snake_case(typ_alea)||'''
				AND __util_to_snake_case(s2_14a.code_occurrence) = '''||__util_to_snake_case(code_occ)||'''
				AND __util_to_snake_case(zt.territoire) = '''||__util_to_snake_case(nom_ter)||'''
				AND s2_14a.id_iris = zt.id_iris
				AND zt.id_epci = epci.code_siren';

	--************************************************************************
	-- Conclusion
	--************************************************************************
	RAISE NOTICE '';
	RAISE NOTICE '====== FIN TRAITEMENT ======';
	RAISE NOTICE '[INFO] La table s2_14a (surfaces à urbaniser inondables) a été mise à jour dans le schéma p_indicateurs pour le territoire "%" et l''aléa "% - %"', nom_ter, typ_alea, code_occ;
	RAISE NOTICE '';
	RAISE NOTICE '====== RÉSULTATS ======';

	IF c_in+c_out > 1
		THEN RAISE NOTICE '% enregistrements insérés au total dans la table p_indicateurs.s2_14a pour le territoire "%" et l''aléa "% - %"', c_in+c_out, nom_ter, typ_alea, code_occ;
		ELSE RAISE NOTICE '% enregistrement inséré dans la table p_indicateurs.s2_14a pour le territoire "%" et l''aléa "% - %"', c_in+c_out, nom_ter, typ_alea, code_occ;
	END IF;

	RAISE NOTICE 'dont :';
	
		IF c_in > 1
			THEN RAISE NOTICE '- % zones à urbaniser inondables', c_in;
			ELSE RAISE NOTICE '- % zone à urbaniser inondable', c_in;
		END IF;
	
		IF c_out > 1
			THEN RAISE NOTICE '- % zones à urbaniser non inondables', c_out;
			ELSE RAISE NOTICE '- % zone à urbaniser non inondable', c_out;
		END IF;

	RAISE NOTICE '';
	heure2 = clock_timestamp();
	RAISE NOTICE 'Fin du traitement : %', heure2;
	RAISE NOTICE 'Durée du traitement : %', CAST(heure2 as time)-CAST(heure1 as time);
	RAISE NOTICE '';

END;
$function$
