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

CREATE OR REPLACE FUNCTION public.__var_pop5(nom_ter text, an_ff text)
 RETURNS void
 LANGUAGE plpgsql
AS $function$

-- Fonction SQL d'incrémentation du champ pop5 (population saisonnière) dans la table c_occupation_sol.oc1
-- © Cerema / GT AgiRisk
-- Dernière mise à jour du script le 21/09/2023 par Christophe puis le 26/09/2023 par Aurélien
-- 		Changelog : 
-- 		Sélection des variables utiles aux calculs uniquement (exemple : avant : 124 colonnes dans local, maintenant 7 colonnes)
--		Supression des conditions inutiles
-- 		Rajout d'index
--		Changement dans le calcul de la correction de 'RP' dans local
--		

-- Paramètres d'entrée :
-- nom_ter = nom du territoire d'étude tel que renseigné dans le champ `territoire` de la table c_general.territoires
-- an_ff = millésime (année au format AAAA) des Fichiers Fonciers (FF)

-- Exemple d'appel à cette fonction :
-- SELECT public.__var_pop5('Jura', '2021');

DECLARE
	c integer; -- un compteur des lignes modifiées pour logging
	heure1 varchar; -- heure de début du traitement
	heure2 varchar; -- heure de fin du traitement

BEGIN
	heure1 = clock_timestamp();

	--************************************************************************
	-- Définition des schémas de travail
	--************************************************************************
	SET SEARCH_PATH TO c_occupation_sol, c_general, c_phenomenes, r_ign_bdtopo, r_insee_pop, public;

	RAISE NOTICE '';
	RAISE NOTICE '====== RAPPORT ======';
	RAISE NOTICE 'Calcul de la variable Pop5 (population saisonnière) sur le territoire "%"', nom_ter;
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
		SELECT loc.idlocal, loc.stoth, loc.idprocpte, loc.proba_rprs, loc.locprop, loc.logh, loc.idtup
		FROM r_fichiersfonciers.local_'||an_ff||' AS loc
		JOIN territoires AS ter
		ON ST_Intersects(loc.geom,ter.geom)
		WHERE __util_to_snake_case(ter.territoire) = '''||__util_to_snake_case(nom_ter)||'''';

	EXECUTE 'CREATE INDEX ON local USING btree(idlocal)';
	EXECUTE 'CREATE INDEX ON local USING btree(idtup)';
	EXECUTE 'CREATE INDEX ON local USING btree(stoth)';
	EXECUTE 'CREATE INDEX ON local USING btree(idprocpte)';
	EXECUTE 'CREATE INDEX ON local USING btree(proba_rprs)';
	EXECUTE 'CREATE INDEX ON local USING btree(locprop)';
	EXECUTE 'CREATE INDEX ON local USING btree(logh)';

	-- Constitution d'une table tup temporaire
	EXECUTE 'DROP TABLE IF EXISTS tup CASCADE;
		CREATE TEMP TABLE tup AS
		SELECT tup.idtup
		FROM r_fichiersfonciers.tup_'||an_ff||' AS tup
		JOIN territoires AS ter
		ON ST_Intersects(tup.geom,ter.geom)
		WHERE __util_to_snake_case(ter.territoire) = '''||__util_to_snake_case(nom_ter)||'''';

	EXECUTE 'CREATE INDEX ON tup USING btree(idtup)';

	EXECUTE 'ALTER TABLE local
		DROP COLUMN IF EXISTS rs_corr,
		ADD COLUMN rs_corr varchar(20)';

	EXECUTE '
		WITH loc AS
		(
			SELECT idlocal, proba_rprs, locprop, stoth,
			MAX(stoth) OVER (PARTITION BY idprocpte) as stothmax
			FROM local
		),
		rs_correct AS
		(
			SELECT idlocal,
				CASE
					WHEN proba_rprs = ''RP'' AND (locprop <> ''1'' OR (locprop = ''1'' AND stoth < stothmax)) THEN ''RS''  -- ''RS'' changée en ''RP''
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
		SELECT tup.idtup,

			-- liste des idlocal par parcelle TUP
			ARRAY_AGG(loc.idlocal)::varchar[] AS idlocal_l,

			-- surface d''habitation totale par parcelle TUP
			COALESCE((SUM(loc.stoth) FILTER (WHERE loc.logh = ''t'')),0)::numeric AS s_logh,

			-- surface totale des locaux de type RS ou vacants par parcelle TUP                      -- cm: pourquoi logements vacants ? dans pop1, il y a une condition sur la vacance mais pas ici.
			COALESCE((SUM(loc.stoth) FILTER (WHERE loc.rs_corr = ''RS'')),0)::numeric AS s_rs

		FROM tup AS tup
		JOIN local AS loc
		ON loc.idtup = tup.idtup
		GROUP BY tup.idtup';

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
	-- 2. Ventilation nombre de RS et surfaces développées de RS entre les bâtiments de chaque TUP
	--************************************************************************
	-- On affecte à chaque bâtiment de logement le pourcentage en nombre et en surface développée de locaux inoccupés de sa parcelle TUP
	-- 2.1. Création d'une copie d'Oc1 pour ne pas avoir trop de champs inutiles (= champs utiles uniquement pour les calculs) dans la table d'origine Oc1

	EXECUTE 'DROP TABLE IF EXISTS temp_oc1 CASCADE;
		CREATE TEMP TABLE temp_oc1 (LIKE oc1 INCLUDING constraints INCLUDING indexes)';
	EXECUTE '
		INSERT INTO temp_oc1
		SELECT id, idtup, oc2, nb_etages_corr, geom
		FROM oc1
		WHERE __util_to_snake_case(territoire) = '''||__util_to_snake_case(nom_ter)||'''';

	-- 2.2. Mise à jour des champs de pourcentage locaux 'RS' dans la table temporaire temp_oc1
	EXECUTE 'ALTER TABLE temp_oc1
		DROP COLUMN IF EXISTS pct_s_rs,
		ADD COLUMN pct_s_rs double precision DEFAULT 0';

	EXECUTE '
		UPDATE temp_oc1
		SET pct_s_rs = tup.pct_s_rs
		FROM tup_local AS tup
		WHERE temp_oc1.oc2 IS TRUE AND temp_oc1.idtup = tup.idtup';

 	EXECUTE 'COMMENT ON COLUMN temp_oc1.pct_s_rs IS ''Pourcentage en surface développée de locaux de type "résidence secondaire" ou "vacants" dans la parcelle TUP du bâtiment''';
	EXECUTE 'CREATE INDEX ON temp_oc1 USING btree(pct_s_rs)';

	--************************************************************************
	-- 3. Calcul de la surface développée totale (sedvtot) des bâtiments
	--************************************************************************
	EXECUTE 'ALTER TABLE temp_oc1
		DROP COLUMN IF EXISTS sdevtot,
		DROP COLUMN IF EXISTS sdevrs,
		ADD COLUMN sdevtot double precision DEFAULT 0,
		ADD COLUMN sdevrs double precision DEFAULT 0';

	EXECUTE '
		UPDATE temp_oc1
		SET sdevtot = ST_Area(geom) * nb_etages_corr
		WHERE oc2 IS TRUE';

	--************************************************************************
	-- 4. Calcul de la surface développée des résidences secondaires (RS)
	--************************************************************************
	EXECUTE '
		UPDATE temp_oc1
		SET sdevrs = pct_s_rs * sdevtot
		WHERE oc2 IS TRUE';

	EXECUTE 'COMMENT ON COLUMN temp_oc1.sdevtot IS ''Surface développée totale du bâtiment (emprise au sol * nombre de niveaux à l''''intérieur du bâtiment)''';
	EXECUTE 'COMMENT ON COLUMN temp_oc1.sdevrs IS ''Surface développée des locaux de type "résidence secondaire" à l''''intérieur du bâtiment''';
	EXECUTE 'CREATE INDEX ON temp_oc1 USING btree(sdevtot)';
	EXECUTE 'CREATE INDEX ON temp_oc1 USING btree(sdevrs)';

	--************************************************************************
	-- 5. Calcul de la population de résidents secondaires à l'intérieur des bâtiments
	--************************************************************************
	-- 5.1. Ajout de champs dans la couche temporaire temp_oc1
	EXECUTE 'ALTER TABLE temp_oc1
		DROP COLUMN IF EXISTS pop_rs,
		ADD COLUMN pop_rs double precision DEFAULT 0';

	-- 5.2. Affectation du nombre d'habitants par bâtiment
	-- Avec les clés de répartition calculées à partir de la surface des RS, et en considérant un coefficient d'occupation du logement d'1 personne pour 20m²
	EXECUTE '
		WITH tempb AS
		-- requête qui permet de calculer la population par bâtiment (calcul de proportionnalité en considérant 1 personne pour 20m²)
		(
			SELECT temp_oc1.id,
			round(temp_oc1.sdevrs::numeric / 20, 2)::double precision AS pop_rs
			FROM temp_oc1
		)
		-- requête de mise à jour de la couche du bâti
		UPDATE temp_oc1
		SET pop_rs = tempb.pop_rs
		FROM tempb
		WHERE temp_oc1.id = tempb.id			
			AND oc2 IS TRUE';

	EXECUTE 'CREATE INDEX ON temp_oc1 USING btree(pop_rs)';
	
	EXECUTE 'COMMENT ON COLUMN temp_oc1.pop_rs IS ''Estimation du nombre de résidents secondaires à l''''intérieur du bâtiment (calculé en retirant de la surface développée totale du bâtiment le pourcentage en surface développée de locaux inoccupés sur la TUP)''';

/*	--************************************************************************
	-- 6. Calcul de la capacité touristique (donnée nationale Atout France "hébergements classés" mais non exhaustive)
	--************************************************************************
	-- On ne prend pas en compte les campings, villages vacances et aires des gens du voyage
	EXECUTE '
		WITH tmp AS 
		(
			SELECT heb_tour.id_heb AS id_heb, heb_tour.capacite_da::double precision, t.oc1_id, t.dist
			FROM r_atoutfrance.heberg_touris_classes AS heb_tour
			CROSS JOIN LATERAL
		-- requête qui permet de récupérer la distance la plus proche entre le ponctuel des hébergements classés et la table temporaire oc1 des bâtis
		(
			SELECT oc1.id AS oc1_id, st_distance(oc1.geom, heb_tour.geom) AS dist
			FROM c_occupation_sol.oc1
			--filtre sur un rayon de 50m
			WHERE ST_Dwithin(oc1.geom, heb_tour.geom,50)
			ORDER BY heb_tour.geom <-> oc1.geom
			LIMIT 1) AS t
			WHERE heb_tour.typologie_e like ''HÔTEL'' or heb_tour.typologie_e like ''RÉSIDENCE DE TOURISME''
		),
		
		-- requête qui permet de créer un identifiant partitionné par identifiant bâti de la distance la plus petite à la plus grande
			
			tmp1 AS 
		(
			SELECT t.*, ROW_NUMBER() OVER (PARTITION BY t.oc1_id ORDER BY t.dist ) AS rn
			FROM tmp AS t
		),
		
		-- requête qui permet d''aggréger les données de résidences de tourisme sous forme de listes
			
			tmp2 AS
		(
			SELECT oc1_id, capacite_da AS heb_cap
			--array_agg(capacite_da) AS heb_cap,
			--sum(capacite_da::numeric) AS heb_cap_sum
			FROM tmp1
			GROUP BY tmp1.oc1_id, heb_cap
		)
		
		-- requête qui permet de mettre à jour la capacité touristique de la table oc1
			UPDATE c_occupation_sol.oc1 AS bati
			SET capacite_touristique = tmp2.heb_cap
			FROM tmp2, tmp1
			WHERE tmp2.oc1_id = bati.id
				AND tmp1.oc1_id = bati.id
				AND tmp1.rn = 1';
*/
	--************************************************************************
	-- 7. Prise en compte des campings, villages vacances et aires des gens du voyage
	--************************************************************************
	--> TO-DO

	--************************************************************************
	-- 8. Mise à jour de la couche d'origine Oc1 (en sommant les différentes capacités et populations décrivant Pop5)
	--************************************************************************
	EXECUTE '
		UPDATE c_occupation_sol.oc1
		SET capacite_touristique =
			CASE
			WHEN capacite_touristique IS NULL THEN 0
			ELSE capacite_touristique
		END';

	EXECUTE '
		UPDATE oc1
		SET pop5 = temp_oc1.pop_rs + oc1.capacite_touristique
		FROM temp_oc1
		WHERE oc1.id = temp_oc1.id';

	--************************************************************************
	-- Récupère le nombre d'entités modifiées
	--************************************************************************
	GET DIAGNOSTICS c = row_count;

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
	RAISE NOTICE '[INFO] Le champ pop5 a été mis à jour dans la table des bâtiments oc1 sur le territoire "%"', nom_ter;
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
