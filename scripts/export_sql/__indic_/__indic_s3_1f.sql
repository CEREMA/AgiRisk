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

CREATE OR REPLACE FUNCTION public.__indic_s3_1f(nom_ter text, typ_alea text, code_occ text, an_bdtopo text)
 RETURNS void
 LANGUAGE plpgsql
AS $function$

-- Fonction SQL d'incrémentation de la table p_indicateurs.s3_1f "Cultures en zone inondable"
-- © Cerema / GT AgiRisk (auteure principale du script : Tiffany, remasterisé par Lucie)
-- Dernières mises à jour du script le 18/04/2023 par Lucie et le 25/08/2023 par Sébastien (test avec succès sur Longuyon le 24/08/2023)

-- Paramètres d'entrée :
-- nom_ter = nom du territoire d'étude tel que renseigné dans le champ `territoire` de la table c_general.territoires
-- typ_alea : type d'aléa considéré (ex : débordement de cours d'eau, submersion marine)
-- code_occ : période de retour considérée pour le type d'aléa choisi (ex : QRef, Q100, Q10)
-- an_bdtopo = millésime (année au format AAAA) de la BD TOPO®

-- Exemple d'appel à cette fonction :
-- SELECT public.__indic_s3_1f('Jura', 'débordement de cours d''eau', 'QRef', '2022');

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
	RAISE NOTICE 'Calcul de l''indicateur s3/1f (cultures en zone inondable) sur le territoire "%" pour l''aléa "% - %"', nom_ter, typ_alea, code_occ;
	RAISE NOTICE '[NOTA] Calcul basé sur les variables oc7 et zx disponibles dans la base de données';
	RAISE NOTICE 'Début du traitement : %', heure1;

	--************************************************************************
	-- Vérification de l'existence du territoire renseigné dans la table des territoires (c_general.territoires)
	--************************************************************************
	 IF NOT EXISTS(
		SELECT *
		FROM c_general.territoires
		WHERE territoire = ''||nom_ter||''
	)
	THEN
		RAISE EXCEPTION 'Il n''y a pas de territoire "%" dans la table c_general.territoires. Fin de l''exécution', nom_ter;
	END IF;

	--************************************************************************
	-- Vérification de l'absence de données pour le territoire, le type d'aléa et l'occurrence de crue renseignés dans la table p_indicateurs.s3_1a
	--************************************************************************
	IF EXISTS (
		SELECT *
		FROM p_indicateurs.s3_1f
		WHERE territoire = ''||nom_ter||''
			AND type_alea = ''||typ_alea||''
			AND code_occurrence = ''||code_occ||''
	)
	THEN
		RAISE EXCEPTION 'Il existe déjà des enregistrements pour le territoire "%" avec l''aléa "% - %" dans la table p_indicateurs.s3_1f. 
		Pour les supprimer, lancer la requête suivante : 
		DELETE FROM p_indicateurs.s3_1f WHERE territoire = ''%'' AND type_alea = ''%'' AND code_occurrence = ''%'';', nom_ter, typ_alea, code_occ, REPLACE(nom_ter,'''',''''''), REPLACE(typ_alea,'''',''''''), REPLACE(code_occ,'''','''''');
	END IF;
	
	--************************************************************************
	-- A) Croisement des parcelles agricoles avec la zone inondable (zx) sur le territoire d'étude
	--************************************************************************
	RAISE NOTICE '';
	RAISE NOTICE 'Récupération des géométries et affectation des noms de périmètres de calcul';
	RAISE NOTICE 'Etape 1a : récupération des parcelles agricoles inondables sur le territoire "%" pour l''aléa "% - %"', nom_ter, typ_alea, code_occ;
  
	EXECUTE 'INSERT INTO p_indicateurs.s3_1f(
			territoire,
			id_iris,
			nom_iris,
			id_oc7,
			code_rpg,
			lib_culture,
			loc_zx,
			type_alea,
			code_occurrence,
			sce_donnee,
			moda_calc,
			date_calc,
			geom
		)
		SELECT DISTINCT
			oc7.territoire,
			oc7.id_iris,
			oc7.nom_iris,
			oc7.id,
			oc7.code_rpg,
			oc7.lib_culture,
			''In'',
			zx.type_alea,
			zx.code_occurrence,
			oc7.sce_donnee,
			''__indic_s3_1f''::varchar(50) AS moda_calc,
			current_date AS date_calc,
			CASE
				WHEN st_within(oc7.geom,zx.geom) THEN st_multi(st_collectionextract(st_forcecollection(st_makevalid(oc7.geom)),3))
				ELSE st_multi(st_collectionextract(st_forcecollection(st_makevalid(st_intersection(oc7.geom,zx.geom))),3))
			END::geometry(MultiPolygon,2154) AS geom
		FROM oc7
		JOIN zx
		ON oc7.geom && zx.geom
		WHERE st_intersects(oc7.geom, zx.geom)
			AND __util_to_snake_case(oc7.territoire) = ''' ||__util_to_snake_case(nom_ter) || '''
			AND __util_to_snake_case(zx.territoire) IN (''' ||__util_to_snake_case(nom_ter) || ''')
			AND __util_to_snake_case(zx.code_occurrence) IN (''' ||__util_to_snake_case(code_occ) || ''')
			AND __util_to_snake_case(zx.type_alea) IN (''' ||__util_to_snake_case(typ_alea) || ''')';

	RAISE NOTICE 'Etape 1a terminée : les parcelles en zone inondable ont bien été récupérées sur le territoire "%" pour l''aléa "% - %"', nom_ter, typ_alea, code_occ;
	RAISE NOTICE '';
	RAISE NOTICE 'Etape 1b : récupération des parcelles qui se trouvent en dehors de la zone zx sur le territoire "%" pour l''aléa "% - %"', nom_ter, typ_alea, code_occ;
	RAISE NOTICE 'Création de la table union_zx (union des objets de zx par identifiant oc7)';	

	RAISE NOTICE 'Sous-division des objets de zx pour diminuer les temps de traitement';

	PERFORM public.__util_subdivide('zx','zx','geom');

	EXECUTE 'DROP TABLE IF EXISTS union_zx CASCADE';
	EXECUTE 'CREATE TEMP TABLE union_zx AS
		SELECT oc7.id, st_multi(st_collectionextract(st_forcecollection(st_makevalid(st_union(zx.geom))),3))::geometry(MultiPolygon,2154) as geom
		FROM oc7
		JOIN l_subdivide_zx zx
		ON st_intersects(zx.geom,oc7.geom)
		WHERE __util_to_snake_case(oc7.territoire) = '''||__util_to_snake_case(nom_ter)||'''
			AND __util_to_snake_case(zx.territoire) IN (''' ||__util_to_snake_case(nom_ter) || ''')
			AND __util_to_snake_case(zx.code_occurrence) IN (''' ||__util_to_snake_case(code_occ) || ''')
			AND __util_to_snake_case(zx.type_alea) IN (''' ||__util_to_snake_case(typ_alea) || ''')
		GROUP BY oc7.id
		';

	EXECUTE 'CREATE INDEX ON union_zx USING gist(geom)';
	EXECUTE 'CREATE INDEX ON union_zx USING btree(id)';

	RAISE NOTICE 'Création de la table union_zx terminée';
	RAISE NOTICE 'Insertion des parcelles qui se trouvent en dehors de la zone zx';

	EXECUTE 'INSERT INTO p_indicateurs.s3_1f(
			territoire,
			id_iris,
			nom_iris,
			id_oc7,
			code_rpg,
			lib_culture,
			loc_zx,
			type_alea,
			code_occurrence,
			sce_donnee,
			moda_calc,
			date_calc,
			geom
		)
		SELECT DISTINCT
			oc7.territoire,
			oc7.id_iris,
			oc7.nom_iris,
			oc7.id,
			oc7.code_rpg,
			oc7.lib_culture,
			''Out'',
			'''||REPLACE(typ_alea,'''','''''')||''' as alea,
			'''||REPLACE(code_occ,'''','''''')||''' as occ,
			oc7.sce_donnee,
			''__indic_s3_1f''::varchar(50) AS moda_calc,
			current_date AS date_calc,
			st_multi(st_collectionextract(st_forcecollection(st_makevalid(st_difference(oc7.geom,coalesce(t.geom,''srid=2154;GEOMETRYCOLLECTION EMPTY''::geometry)))),3)) as newgeom
		FROM oc7
		LEFT JOIN union_zx t
		ON oc7.id = t.id
		WHERE __util_to_snake_case(oc7.territoire) = ''' ||__util_to_snake_case(nom_ter) || '''';

	RAISE NOTICE 'Etape 1b terminée : les parcelles hors zone inondable ont bien été récupérées ';
	RAISE NOTICE '';
	
	RAISE NOTICE 'Etape 1c : mise à jour des centroïdes des parcelles découpées par la zone inondable';
	EXECUTE 'UPDATE p_indicateurs.s3_1f
		SET geomloc = st_centroid(geom)';

	RAISE NOTICE 'Etape 1c terminée : le centroïde des parcelles découpées a été mis à jour';
	RAISE NOTICE '';

	RAISE NOTICE 'Etape 1d : calcul des surfaces (ha) des parcelles découpées par la zone inondable';
	EXECUTE 'UPDATE p_indicateurs.s3_1f
		SET surf_parc = (st_Area(geom))/10000';
			
	RAISE NOTICE 'Etape 1d terminée : la surface des parcelles (ha) découpées a été mise à jour';

	--************************************************************************
	-- Récupération du nombre d'entités ajoutées
	--************************************************************************
	EXECUTE '
		SELECT count(*)
		FROM s3_1f
		WHERE __util_to_snake_case(territoire) = '''||__util_to_snake_case(nom_ter)||'''
			AND __util_to_snake_case(type_alea) = '''||__util_to_snake_case(typ_alea)||'''
			AND __util_to_snake_case(code_occurrence) = '''||__util_to_snake_case(code_occ)||'''
			AND loc_zx = ''In'''
	INTO c_in; -- nombre total de parcelles agricoles inondables insérées dans la table
	
	EXECUTE '
		SELECT count(*)
		FROM s3_1f
		WHERE __util_to_snake_case(territoire) = '''||__util_to_snake_case(nom_ter)||'''
			AND __util_to_snake_case(type_alea) = '''||__util_to_snake_case(typ_alea)||'''
			AND __util_to_snake_case(code_occurrence) = '''||__util_to_snake_case(code_occ)||'''
			AND loc_zx = ''Out'''
	INTO c_out; -- nombre total de parcelles agricoles non inondables insérées dans la table

	--************************************************************************
	-- B) Attribution des codes et des noms de périmètres
	--************************************************************************
	RAISE NOTICE '';
	RAISE NOTICE 'Etape 2 : attribution des codes et des noms de périmètres';

	-- 2a. Attribution des codes INSEE et noms de communes
		EXECUTE '
			UPDATE p_indicateurs.s3_1f
			SET id_commune = com.insee_com, nom_commune = com.nom
			FROM c_phenomenes.zt, commune_'||an_bdtopo||' AS com
			WHERE __util_to_snake_case(s3_1f.territoire) = '''||__util_to_snake_case(nom_ter)||'''
				AND __util_to_snake_case(s3_1f.type_alea) = '''||__util_to_snake_case(typ_alea)||'''
				AND __util_to_snake_case(s3_1f.code_occurrence) = '''||__util_to_snake_case(code_occ)||'''
				AND __util_to_snake_case(zt.territoire) = '''||__util_to_snake_case(nom_ter)||'''
				AND s3_1f.id_iris = zt.id_iris
				AND zt.id_commune = com.insee_com';

	-- 2b. Attribution des codes et noms EPCI
		EXECUTE '
			UPDATE p_indicateurs.s3_1f
			SET id_epci = epci.code_siren, nom_epci = epci.nom
			FROM c_phenomenes.zt, epci_'||an_bdtopo||' AS epci
			WHERE __util_to_snake_case(s3_1f.territoire) = '''||__util_to_snake_case(nom_ter)||'''
				AND __util_to_snake_case(s3_1f.type_alea) = '''||__util_to_snake_case(typ_alea)||'''
				AND __util_to_snake_case(s3_1f.code_occurrence) = '''||__util_to_snake_case(code_occ)||'''
				AND __util_to_snake_case(zt.territoire) = '''||__util_to_snake_case(nom_ter)||'''
				AND s3_1f.id_iris = zt.id_iris
				AND zt.id_epci = epci.code_siren';

	--************************************************************************
	-- Conclusion
	--************************************************************************
	RAISE NOTICE '';
	RAISE NOTICE '====== FIN TRAITEMENT ======';
	RAISE NOTICE '[INFO] La table s3_1f (cultures en zone inondable) a été mise à jour dans le schéma p_indicateurs pour le territoire "%" et l''aléa "% - %"', nom_ter, typ_alea, code_occ;
	RAISE NOTICE '';
	RAISE NOTICE '====== RÉSULTATS ======';

	IF c_in+c_out > 1
		THEN RAISE NOTICE '% enregistrements insérés au total dans la table p_indicateurs.s3_1f pour le territoire "%" et l''aléa "% - %"', c_in+c_out, nom_ter, typ_alea, code_occ;
		ELSE RAISE NOTICE '% enregistrement inséré dans la table p_indicateurs.s3_1f pour le territoire "%" et l''aléa "% - %"', c_in+c_out, nom_ter, typ_alea, code_occ;
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
