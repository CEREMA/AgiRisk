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

CREATE OR REPLACE FUNCTION public.__var_oc5(nom_ter text, an_bdtopo text, an_osm text)
 RETURNS void
 LANGUAGE plpgsql
AS $function$

-- Fonction SQL d'incrémentation de la table oc5 (campings) dans le schéma c_occupation_sol
-- © Cerema / GT AgiRisk (auteures principales du script : Anaïs, Gaëlle)
-- Dernière mise à jour du script le 24/08/2023 par Sébastien

-- Paramètres d'entrée :
-- nom_ter = nom du territoire d'étude tel que renseigné dans le champ `territoire` de la table c_general.territoires
-- an_bdtopo = millésime (année au format AAAA) de la BD TOPO®
-- an_osm = millésime (année au format AAAA) des données OSM

-- Exemple d'appel à cette fonction :
-- SELECT public.__var_oc5('Jura', '2022');

DECLARE
	c integer; -- un compteur des lignes modifiées pour logging
	heure1 varchar; -- heure de début du traitement
	heure2 varchar; -- heure de fin du traitement

BEGIN
	heure1 = clock_timestamp();

	--************************************************************************
	-- Définition des schémas de travail
	--************************************************************************
	SET SEARCH_PATH TO public, c_phenomenes, c_occupation_sol, r_ign_bdtopo, r_osm;

	RAISE NOTICE '';
	RAISE NOTICE '====== RAPPORT ======';
	RAISE NOTICE 'Calcul de la variable oc5 (campings) sur le territoire "%"', nom_ter;
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
	-- Vérification de l'absence du territoire renseigné dans la table c_occupation_sol.oc5
	--************************************************************************
	IF EXISTS (
		SELECT *
		FROM c_occupation_sol.oc5
		WHERE territoire = ''||nom_ter||''
	)
	THEN
		RAISE EXCEPTION 'Il existe déjà des enregistrements pour le territoire "%" dans la table c_occupation_sol.oc5. 
		Pour les supprimer, lancer la requête suivante : 
		DELETE FROM c_occupation_sol.oc5 WHERE territoire = ''%'';', nom_ter, REPLACE(nom_ter,'''','''''');
	END IF;

	--************************************************************************
	-- Création de la table des campings et aires des gens du voyage à partir de la BD TOPO® et de la table des territoires
	--************************************************************************
	EXECUTE 'DROP TABLE IF EXISTS c_occupation_sol.s_camping_agv CASCADE';
	EXECUTE 'CREATE TABLE c_occupation_sol.s_camping_agv AS
		SELECT zai.id as id_bdt, zai.geom, zai.toponyme, zai.nature, zt.territoire
		FROM r_ign_bdtopo.zone_d_activite_ou_d_interet_'||an_bdtopo||' AS zai, c_general.territoires AS zt
		WHERE __util_to_snake_case(zt.territoire) = '''||__util_to_snake_case(nom_ter)||'''
			AND (zai.nature = ''Camping'' OR zai.nature = ''Aire d''''accueil des gens du voyage'')
			AND ST_Intersects(zai.geom, zt.geom)';

	EXECUTE 'CREATE INDEX ON c_occupation_sol.s_camping_agv USING gist(geom)';

	--************************************************************************
	-- Ajout des champs nécessaires à la table temporaire
	--************************************************************************
	EXECUTE 'ALTER TABLE c_occupation_sol.s_camping_agv
		ADD COLUMN capacite_accueil integer';
	EXECUTE 'ALTER TABLE c_occupation_sol.s_camping_agv
		ADD COLUMN contact_tel varchar(20)';
	EXECUTE 'ALTER TABLE c_occupation_sol.s_camping_agv
		ADD COLUMN contact_mail varchar(100)';
	EXECUTE 'ALTER TABLE c_occupation_sol.s_camping_agv
		ADD COLUMN website varchar(200)';
	EXECUTE 'ALTER TABLE c_occupation_sol.s_camping_agv
		ADD COLUMN sce_donnee varchar(30)';
	EXECUTE 'ALTER TABLE c_occupation_sol.s_camping_agv
		ADD COLUMN full_id varchar(30)';

	--************************************************************************
	-- Modification de la source de donnée (= BD TOPO®)
	--************************************************************************
	EXECUTE 'UPDATE c_occupation_sol.s_camping_agv
		SET sce_donnee = ''BD TOPO IGN '||an_bdtopo||'''';

	--************************************************************************
	-- Création du géolocalisant sur la table pour faciliter l'intersection avec la table OSM des campings surfaciques
	--************************************************************************
	EXECUTE 'SELECT public.__util_create_geomloc(''c_occupation_sol'', ''s_camping_agv'', ''geom'')';

	--************************************************************************
	-- Requête temporaire pour récupérer la géométrie de la table surfacique osm (camp_site) et l'affecter à la BD TOPO®
	--************************************************************************
	-- Affectation lorsque la surface du petit carré de la BD TOPO® est inférieure à 30m²
	-- (objectif : si la BDTtopo = petit carré, prise en compte de la géométrie d'OSM)

	EXECUTE '
		WITH tempa AS (
			SELECT camp.id_bdt, osm_camp.full_id, osm_camp.capacity, osm_camp.name, osm_camp.geom
			FROM c_occupation_sol.s_camping_agv AS camp, r_osm.tourism_camp_site_s'||an_osm||' AS osm_camp
			WHERE ST_Area(camp.geom) <= 30 AND ST_Within(camp.geom, osm_camp.geom)
		)

		-- Récupération de la géométrie OSM et mise à jour du champ dans la table temporaire des campings
		UPDATE c_occupation_sol.s_camping_agv AS camp
		SET geom = tempa.geom, full_id = tempa.full_id, sce_donnee=''OSM'' -- ajout de la source ici (CM le 18/8/23)
		FROM tempa
		WHERE camp.id_bdt=tempa.id_bdt ;

		-- Mise à jour de la table temporaire avec la source de données de la géométrie -> fait ci-dessus
		--	UPDATE c_occupation_sol.s_camping_agv AS camp
		--	SET sce_donnee=''OSM''
		--	FROM s_camping_agv
		--	WHERE camp.full_id IS NOT NULL';

	--************************************************************************
	-- Intersection entre la table osm surfacique et la table s_camping_agv (geomloc) de la BD TOPO® pour récupérer les capacités d'accueil sur la BD TOPO®
	--************************************************************************
	EXECUTE '
		WITH tempb AS (
			SELECT camp.id_bdt, osm_camp.full_id, osm_camp.capacity, osm_camp.phone, osm_camp.email, osm_camp.website
			FROM c_occupation_sol.s_camping_agv AS camp, r_osm.tourism_camp_site_s'||an_osm||' AS osm_camp
			WHERE ST_Intersects(camp.geomloc, osm_camp.geom)
		)

		-- Mise à jour des géométries et du champ capacite d''accueil
		UPDATE c_occupation_sol.s_camping_agv AS camp
		SET capacite_accueil = cast(tempb.capacity as int), contact_tel=tempb.phone, contact_mail=tempb.email, website=tempb.website, full_id=tempb.full_id
		FROM tempb
		WHERE camp.id_bdt = tempb.id_bdt;

		-- Mise à jour de la table temporaire avec la capacité d''accueil avec une capacité d''accueil pour les campings en fonction de sa surface (ratio)
		UPDATE c_occupation_sol.s_camping_agv AS camp
		SET capacite_accueil = ST_Area(camp.geom)/50
		WHERE (camp.capacite_accueil IS NULL AND camp.nature=''Camping'')';

	-- TODO : ajouter un champ sur l'origine de la capacité : OSM ou extrapolé
	
	--************************************************************************
	-- Alimentation de la table Oc5
	--************************************************************************
	EXECUTE 'INSERT INTO c_occupation_sol.oc5 (
			territoire,
			id_bdt,
			nature,
			nom,
			cap_acc,
			contact_tel,
			contact_mail,
			website,
			sce_donnee,
			moda_calc,
			date_calc,
			geom
		)
		SELECT DISTINCT
			camp.territoire,
			camp.id_bdt,
			camp.nature,
			camp.toponyme,
			camp.capacite_accueil,
			camp.contact_tel,
			camp.contact_mail,
			camp.website,
			camp.sce_donnee,
			''__var_oc5'',
			current_date,
			camp.geom
	FROM c_occupation_sol.s_camping_agv AS camp';

	--************************************************************************
	-- Récupération du nombre d'entités ajoutées
	--************************************************************************
	GET DIAGNOSTICS c = row_count;

	--************************************************************************
	-- Création de la vue matérialisée oc5 sur le territoire
	--************************************************************************
	RAISE NOTICE '';
	RAISE NOTICE 'Création de la vue matérialisée %', 'c_occupation_sol.oc5_'||__util_to_snake_case(nom_ter);
	EXECUTE '
		DROP MATERIALIZED VIEW IF EXISTS c_occupation_sol.oc5_'||__util_to_snake_case(nom_ter)||' CASCADE;
		CREATE MATERIALIZED VIEW c_occupation_sol.oc5_'||__util_to_snake_case(nom_ter)||' AS
		SELECT *
		FROM c_occupation_sol.oc5
		WHERE __util_to_snake_case(territoire) = '''||__util_to_snake_case(nom_ter)||'''';

	-- Création des index sur la vue matérialisée
	RAISE NOTICE 'Création des index sur la vue matérialisée';

	EXECUTE 'CREATE UNIQUE INDEX ON c_occupation_sol.oc5_'||__util_to_snake_case(nom_ter)||' (id)';

	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc5_'||__util_to_snake_case(nom_ter)||' USING gist(geom)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc5_'||__util_to_snake_case(nom_ter)||' USING btree(id)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc5_'||__util_to_snake_case(nom_ter)||' USING btree(territoire)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc5_'||__util_to_snake_case(nom_ter)||' USING btree(id_bdt)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc5_'||__util_to_snake_case(nom_ter)||' USING btree(nature)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc5_'||__util_to_snake_case(nom_ter)||' USING btree(nom)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc5_'||__util_to_snake_case(nom_ter)||' USING btree(cap_acc)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc5_'||__util_to_snake_case(nom_ter)||' USING btree(contact_tel)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc5_'||__util_to_snake_case(nom_ter)||' USING btree(contact_mail)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc5_'||__util_to_snake_case(nom_ter)||' USING btree(website)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc5_'||__util_to_snake_case(nom_ter)||' USING btree(sce_donnee)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc5_'||__util_to_snake_case(nom_ter)||' USING btree(moda_calc)';
	EXECUTE 'CREATE INDEX ON c_occupation_sol.oc5_'||__util_to_snake_case(nom_ter)||' USING btree(date_calc)';
	RAISE NOTICE 'Index créés sur la vue matérialisée';

	--************************************************************************
	-- Conclusion
	--************************************************************************
	RAISE NOTICE '';
	RAISE NOTICE '====== FIN TRAITEMENT ======';
	RAISE NOTICE '[INFO] La table oc5 (campings) a été mise à jour dans le schéma c_occupation_sol pour le territoire "%"', nom_ter;
	RAISE NOTICE '';
	RAISE NOTICE '====== RÉSULTATS ======';
	IF c > 1
		THEN RAISE NOTICE '% enregistrements insérés au total dans la table c_occupation_sol.oc5 pour le territoire "%"', c, nom_ter;
		ELSE RAISE NOTICE '% enregistrement inséré dans la table c_occupation_sol.oc5 pour le territoire "%"', c, nom_ter;
	END IF;
	RAISE NOTICE '';
	heure2 = clock_timestamp();
	RAISE NOTICE 'Fin du traitement : %', heure2;
	RAISE NOTICE 'Durée du traitement : %', CAST(heure2 as time)-CAST(heure1 as time);
	RAISE NOTICE '';

END;
$function$
