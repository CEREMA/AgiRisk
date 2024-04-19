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

CREATE OR REPLACE FUNCTION public.__var_pop1(nom_ter text, an_ff text, an_pop text)
 RETURNS void
 LANGUAGE plpgsql
AS $function$

-- Fonction SQL d'incrémentation du champ pop1 (nombre d'habitants) dans la table c_occupation_sol.oc1
-- © Cerema / GT AgiRisk
-- Dernière mise à jour du script le 25/08/2023 par Sébastien (test avec succès sur Longuyon le 24/08/2023)  puis le 26/09/2023 par Aurélien

-- Paramètres d'entrée :
-- nom_ter = nom du territoire d'étude tel que renseigné dans le champ `territoire` de la table c_general.territoires
-- an_ff = millésime (année au format AAAA) des Fichiers Fonciers (FF)
-- an_pop = millésime (année au format AAAA) de la couche population Insee

-- Exemple d'appel à cette fonction :
-- SELECT public.__var_pop1('Jura', '2021', '2015');

DECLARE
	c integer; -- un compteur des lignes modifiées pour logging
	heure1 varchar; -- heure de début du traitement
	heure2 varchar; -- heure de fin du traitement
	dep text; -- variable qui prend pour valeur chaque département concerné par le territoire d'étude (utilisée dans une boucle FOR)
	liste_dep text; -- variable qui liste tous les départements concernés par le territoire d'étude

BEGIN
	heure1 = clock_timestamp();

	--************************************************************************
	-- Définition des schémas de travail
	--************************************************************************
	SET SEARCH_PATH TO c_occupation_sol, c_general, c_phenomenes, r_ign_bdtopo, r_insee_pop, public;

	RAISE NOTICE '';
	RAISE NOTICE '====== RAPPORT ======';
	RAISE NOTICE 'Calcul de la variable Pop1 (habitants) sur le territoire "%"', nom_ter;
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
	-- 1. Calcul de la surface développée des résidences secondaires (RS) par TUP
	--************************************************************************
	/* On calcule le pourcentage de locaux de type RS par TUP en nombre (pct_nb_rs) et en surface (pct_s_rs).
	On considère donc ici que la surface développée d'un local de type habitation = au champ stoth des FF.

	Avant toute chose, il est nécessaire de vérifier les conditions suivantes pour s'assurer qu'il s'agit bien d'une RS, car le champ proba_rprs des FF pas toujours fiable : SI locprop = '1' (la commune du local = la commune du propriétaire).
	Ne considérer que c'est une RS que s'il y a plusieurs locaux rattachés au compte propriétaire (si le propriétaire ne possède qu'un local d'habitation sur la commune et qu'il habite sur cette même commune, c'est forcément sa résidence principale !) et si le local considéré n'est pas celui de plus grande surface habitable. */

	-- Constitution d'une table local temporaire
	EXECUTE 'DROP TABLE IF EXISTS local CASCADE;
		CREATE TEMP TABLE local AS
		SELECT loc.*
		FROM r_fichiersfonciers.local_'||an_ff||' AS loc
		JOIN territoires AS ter
		ON ST_Intersects(loc.geom,ter.geom)
		WHERE __util_to_snake_case(ter.territoire) = '''||__util_to_snake_case(nom_ter)||'''';

	EXECUTE 'CREATE INDEX ON local USING btree(stoth)';
	EXECUTE 'CREATE INDEX ON local USING btree(idprocpte)';
	EXECUTE 'CREATE INDEX ON local USING btree(proba_rprs)';
	EXECUTE 'CREATE INDEX ON local USING btree(locprop)';

	-- Constitution d'une table tup temporaire
	EXECUTE 'DROP TABLE IF EXISTS tup CASCADE;
		CREATE TEMP TABLE tup AS
		SELECT tup.*
		FROM r_fichiersfonciers.tup_'||an_ff||' AS tup
		JOIN territoires AS ter
		ON ST_Intersects(tup.geomloc,ter.geom)
		WHERE __util_to_snake_case(ter.territoire) = '''||__util_to_snake_case(nom_ter)||'''';

	EXECUTE 'CREATE INDEX ON tup USING gist(geom)';
	EXECUTE 'CREATE INDEX ON tup USING gist(geomloc)';
	EXECUTE 'CREATE INDEX ON tup USING btree(idtup)';

	EXECUTE 'ALTER TABLE local
		DROP COLUMN IF EXISTS rs_corr,
		ADD COLUMN rs_corr varchar(20)';

	EXECUTE '
		WITH loc AS
		(
			SELECT *,
			MAX(stoth) OVER (PARTITION BY idprocpte) as stothmax
			FROM local
		),
		rs_correct AS
		(
			SELECT *,
				CASE
					WHEN proba_rprs = ''RP'' AND (locprop <> ''1'' OR (locprop = ''1'' AND stoth < stothmax)) THEN ''RS''
					ELSE proba_rprs
				END AS typheb
			FROM loc
		)
		UPDATE local
		SET rs_corr = rs_correct.typheb
		FROM rs_correct
		WHERE local.idlocal = rs_correct.idlocal';

	EXECUTE 'CREATE INDEX ON local USING btree(rs_corr)';

	-- Constitution d'une table tup_local temporaire à partir des tables créées précédemment
	EXECUTE 'DROP TABLE IF EXISTS tup_local CASCADE;
		CREATE TEMP TABLE tup_local AS
		SELECT tup.idtup, tup.geom,

			-- liste des idlocal par parcelle TUP
			ARRAY_AGG(loc.idlocal)::varchar[] AS idlocal_l,

			-- surface d''habitation totale par parcelle TUP
			COALESCE((SUM(loc.stoth) FILTER (WHERE loc.logh = ''t'')),0)::numeric AS s_logh,

			-- surface totale des locaux de type RS ou vacants par parcelle TUP
			COALESCE((SUM(loc.stoth) FILTER (WHERE loc.rs_corr = ''RS'' OR loc.ccthp = ''V'')),0)::numeric AS s_rs

		FROM tup AS tup
		JOIN local AS loc
		ON loc.idtup = tup.idtup
		GROUP BY tup.idtup, tup.geom';

	EXECUTE 'CREATE INDEX ON tup_local USING btree(s_logh)';
	EXECUTE 'CREATE INDEX ON tup_local USING btree(s_rs)';

	EXECUTE 'ALTER TABLE tup_local
		DROP COLUMN IF EXISTS pct_s_rs,
		ADD COLUMN pct_s_rs double precision DEFAULT 0';

	EXECUTE '
		UPDATE tup_local
		SET pct_s_rs = (s_rs::numeric / s_logh)
		WHERE s_logh > 0';

	EXECUTE 'CREATE INDEX ON tup_local USING btree(pct_s_rs)';

	--************************************************************************
	-- 2. Croisement des bâtiments BD TOPO® avec les TUP des FF
	--************************************************************************
	EXECUTE '
		UPDATE c_occupation_sol.oc1
		SET idtup = tup.idtup
		FROM tup
		WHERE __util_to_snake_case(oc1.territoire) = '''||__util_to_snake_case(nom_ter)||'''
			AND ST_Intersects(oc1.geomloc,tup.geom)';

	--************************************************************************
	-- 3. Ventilation nombre de RS et surfaces développées de RS entre les bâtiments de chaque TUP
	--************************************************************************
	-- 3.1. Calcul de la hauteur de chaque bâtiment oc1
	EXECUTE '
		UPDATE c_occupation_sol.oc1
		SET hauteur_corr =
		CASE
			WHEN (hauteur_bdt < 5 OR hauteur_bdt IS NULL) AND oc2 IS FALSE THEN 5
			WHEN (hauteur_bdt < 3 OR hauteur_bdt IS NULL) AND oc2 IS TRUE THEN 3
			ELSE hauteur_bdt
		END
		WHERE __util_to_snake_case(territoire) = '''||__util_to_snake_case(nom_ter)||'''';

	-- 3.2. Mise à jour du champ nb_etages_corr dans oc1 (car le champ nb_etages de la BD TOPO est mal renseigné)
	EXECUTE '
		UPDATE oc1
		SET nb_etages_corr =
		CASE
			WHEN nb_etages_bdt > 0 THEN nb_etages_bdt
			WHEN oc2 IS FALSE THEN ceil(hauteur_corr :: numeric / 5)
			WHEN oc2 IS TRUE THEN ceil(hauteur_corr :: numeric / 3)
			ELSE 1
		END
		WHERE __util_to_snake_case(territoire) = '''||__util_to_snake_case(nom_ter)||'''';

	-- 3.3. On affecte à chaque bâtiment de logement le pourcentage en nombre et en surface développée de locaux inoccupés de sa parcelle TUP
	-- 3.3.1. Création d'une copie d'Oc1 pour ne pas avoir trop de champs inutiles (= champs utiles uniquement pour les calculs) dans la table d'origine Oc1
	EXECUTE 'DROP TABLE IF EXISTS temp_oc1 CASCADE;
	CREATE TEMP TABLE temp_oc1 (LIKE oc1 INCLUDING constraints INCLUDING indexes)';
	EXECUTE 'INSERT INTO temp_oc1
		SELECT *
		FROM oc1
		WHERE __util_to_snake_case(territoire) = '''||__util_to_snake_case(nom_ter)||'''';

	-- 3.3.2. Mise à jour des champs de pourcentage locaux inoccupés dans la table temporaire temp_oc1
	EXECUTE 'ALTER TABLE temp_oc1
		DROP COLUMN IF EXISTS pct_s_rs,
		ADD COLUMN pct_s_rs double precision DEFAULT 0';

	EXECUTE 'CREATE INDEX ON temp_oc1 USING btree(pct_s_rs)';

	EXECUTE '
		UPDATE temp_oc1
		SET
		pct_s_rs = tup.pct_s_rs
		FROM tup_local as tup
		WHERE __util_to_snake_case(territoire) = '''||__util_to_snake_case(nom_ter)||'''
			AND temp_oc1.oc2 IS TRUE
			AND temp_oc1.idtup = tup.idtup';

	--************************************************************************
	-- 4. Calcul de la surface développée totale (sedvtot) des bâtiments
	--************************************************************************
	EXECUTE 'ALTER TABLE temp_oc1
		DROP COLUMN IF EXISTS sdevtot,
		DROP COLUMN IF EXISTS sdevrps,
		ADD COLUMN sdevtot double precision DEFAULT 0,
		ADD COLUMN sdevrps double precision DEFAULT 0';

	EXECUTE '
		UPDATE temp_oc1
		SET sdevtot = ST_Area(geom) * nb_etages_corr
		WHERE __util_to_snake_case(territoire) = '''||__util_to_snake_case(nom_ter)||'''
			AND oc2 IS TRUE';

	--************************************************************************
	-- 5. Calcul de la surface développée des résidences permanentes (RP)
	--************************************************************************
	EXECUTE '
		UPDATE temp_oc1
		SET
		sdevrps = sdevtot - (pct_s_rs * sdevtot)
		WHERE __util_to_snake_case(territoire) = '''||__util_to_snake_case(nom_ter)||'''
			AND oc2 IS TRUE
			 ';

	EXECUTE 'CREATE INDEX ON temp_oc1 USING btree(sdevtot)';
	EXECUTE 'CREATE INDEX ON temp_oc1 USING btree(sdevrps)';

	--************************************************************************
	-- 6. Calcul de la population permanente totale et âgée de plus de 65 ans à l'intérieur des bâtiments
	--************************************************************************
	-- 6.1. Ajout de champs dans la couche temporaire temp_oc1
	EXECUTE 'ALTER TABLE temp_oc1
		DROP COLUMN IF EXISTS id_popref,
		DROP COLUMN IF EXISTS nb_popref,
		DROP COLUMN IF EXISTS nb_popref_agee,
		DROP COLUMN IF EXISTS pop1_s,
		DROP COLUMN IF EXISTS pop1_s_agee,
		ADD COLUMN id_popref varchar(50),
		ADD COLUMN nb_popref double precision DEFAULT 0,
		ADD COLUMN nb_popref_agee double precision DEFAULT 0,
		ADD COLUMN pop1_s double precision DEFAULT 0,
		ADD COLUMN pop1_s_agee double precision DEFAULT 0';

	-- 6.2. Création d'une variable qui liste les départements concernés par le territoire
	EXECUTE 'DROP TABLE IF EXISTS departement CASCADE;
		CREATE TEMP TABLE departement AS
		SELECT DISTINCT id_dpt
		FROM zt
		WHERE __util_to_snake_case(territoire) = '''||__util_to_snake_case(nom_ter)||'''';

	EXECUTE 'DROP TABLE IF EXISTS liste CASCADE;
		CREATE TEMP TABLE liste (arr) AS VALUES (array[]::varchar[])';

	FOR dep IN SELECT * FROM departement
	LOOP
		EXECUTE'
		WITH tempa AS
		(
			SELECT array_append(arr, quote_literal('''||dep||''')) as arr
			FROM liste
		)
		UPDATE liste
		SET arr = tempa.arr
		FROM tempa';
	END LOOP;

	EXECUTE 'SELECT array_to_string(arr, '','')
	FROM liste'
	INTO liste_dep;

	-- 6.3. Croisement carroyage INSEE avec le centroïde des bâtiments
	-- !!! ATTENTION, TOUS LES BÂTIMENTS NE CROISENT PAS FORCÉMENT LE CARROYAGE DE L'INSEE !!!
	EXECUTE '
		UPDATE temp_oc1
		SET id_popref = i.idcar_200m, nb_popref = i.ind, nb_popref_agee = (i.ind_65_79 + i.ind_80p)
		FROM filosofi_'||an_pop||' as i
		WHERE insee_dep IN ('||liste_dep||')
			AND __util_to_snake_case(temp_oc1.territoire) = '''||__util_to_snake_case(nom_ter)||'''
			AND ST_Intersects(temp_oc1.geomloc, i.geom)';

	EXECUTE 'CREATE INDEX ON temp_oc1 USING btree(id_popref)';
	EXECUTE 'CREATE INDEX ON temp_oc1 USING btree(nb_popref)';
	EXECUTE 'CREATE INDEX ON temp_oc1 USING btree(nb_popref_agee)';

	-- 6.4. Affectation du nombre d'habitants par bâtiment
	-- Contrairement à ce qui aurait pu être fait précédemment, on ne cherche pas à tout prix à obtenir un Pop1 entier (suppression de la fonction ceil() qui permettait d'affecter l'entier supérieur le plus proche)
	EXECUTE '
		WITH tempa AS
		-- requête qui permet de sommer les clés de répartition de la population (en surface) par carreau pop
		(
			SELECT id_popref, sum(sdevrps) as sbatcars
			FROM temp_oc1
			WHERE __util_to_snake_case(territoire) = '''||__util_to_snake_case(nom_ter)||'''
			GROUP BY id_popref
			HAVING sum(sdevrps) > 0
		),
		tempb AS
		-- requête qui permet de calculer la population totale par bâtiment (calcul de proportionnalité)
		(
			SELECT temp_oc1.id,
			(temp_oc1.nb_popref * temp_oc1.sdevrps)::numeric / tempa.sbatcars as pop1_s
			FROM tempa
			JOIN temp_oc1
			ON tempa.id_popref = temp_oc1.id_popref
			WHERE __util_to_snake_case(temp_oc1.territoire) = '''||__util_to_snake_case(nom_ter)||'''
		)
		-- requête de mise à jour de la couche du bâti
		UPDATE temp_oc1
		SET pop1_s = round(tempb.pop1_s::numeric,2)
		FROM tempb
		WHERE temp_oc1.id = tempb.id
			AND __util_to_snake_case(temp_oc1.territoire) = '''||__util_to_snake_case(nom_ter)||'''
			AND oc2 IS TRUE';

	EXECUTE '
		WITH tempa AS
		-- requête qui permet de sommer les clés de répartition de la population (en surface) par carreau pop
		(
			SELECT id_popref, sum(sdevrps) as sbatcars
			FROM temp_oc1
			WHERE __util_to_snake_case(territoire) = '''||__util_to_snake_case(nom_ter)||'''
			GROUP BY id_popref
			HAVING sum(sdevrps) > 0
		),
		tempc AS
		-- requête qui permet de calculer la population âgée de plus de 65 ans par bâtiment (calcul de proportionnalité)
		(
			SELECT temp_oc1.id,
			(temp_oc1.nb_popref_agee * temp_oc1.sdevrps)::numeric / tempa.sbatcars as pop1_s_agee
			FROM tempa
			JOIN temp_oc1
			ON tempa.id_popref = temp_oc1.id_popref
			WHERE __util_to_snake_case(temp_oc1.territoire) = '''||__util_to_snake_case(nom_ter)||'''
		)
		-- requête de mise à jour de la couche du bâti
		UPDATE temp_oc1
		SET pop1_s_agee = round(tempc.pop1_s_agee::numeric,2)
		FROM tempc
		WHERE temp_oc1.id = tempc.id
			AND __util_to_snake_case(temp_oc1.territoire) = '''||__util_to_snake_case(nom_ter)||'''
			AND oc2 IS TRUE';

	EXECUTE 'CREATE INDEX ON temp_oc1 USING btree(pop1_s)';
	EXECUTE 'CREATE INDEX ON temp_oc1 USING btree(pop1_s_agee)';

	--************************************************************************
	-- 7. Mise à jour de la couche d'origine Oc1
	--************************************************************************
	EXECUTE '
		UPDATE oc1
		SET pop1 = temp_oc1.pop1_s, pop1_agee = temp_oc1.pop1_s_agee
		FROM temp_oc1
		WHERE oc1.id = temp_oc1.id';

	--************************************************************************
	-- Récupère le nombre d'entités modifiées
	--************************************************************************
	GET DIAGNOSTICS c = row_count;

	--************************************************************************
	-- 8. Mise à jour du champ plainpied de la couche Oc1
	--************************************************************************
	RAISE NOTICE '';
	RAISE NOTICE 'Mise à jour du champ plainpied de la couche des bâtiments (oc1)';
	EXECUTE '
		UPDATE oc1
		SET plainpied =
			CASE
				WHEN nb_etages_corr = 1 THEN true
				ELSE false
			END
		WHERE __util_to_snake_case(territoire) = '''||__util_to_snake_case(nom_ter)||'''';

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

	--************************************************************************
	-- Conclusion
	--************************************************************************
	RAISE NOTICE '';
	RAISE NOTICE '====== FIN TRAITEMENT ======';
	RAISE NOTICE '[INFO] Les champs pop1 et pop1_agee ont été mis à jour dans la table des bâtiments oc1 sur le territoire "%"', nom_ter;
	RAISE NOTICE '';
	RAISE NOTICE '====== RÉSULTATS ======';
   	IF c > 1
		THEN RAISE NOTICE '% enregistrements mis à jour dans la table c_occupation_sol.oc1 pour le territoire "%"', c, nom_ter;
		ELSE RAISE NOTICE '% enregistrement mis à jour dans la table c_occupation_sol.oc1 pour le territoire "%"', c, nom_ter;
	END IF;
	RAISE NOTICE '';
	heure2 = clock_timestamp();
	RAISE NOTICE 'Fin du traitement : %', heure2;
	RAISE NOTICE 'Durée du traitement : %', CAST(heure2 as time)-CAST(heure1 as time);
	RAISE NOTICE '';

END;
$function$
