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

CREATE OR REPLACE FUNCTION public.__util_create_geomloc(nschema text, couche text, geom text)
 RETURNS void
 LANGUAGE plpgsql
AS $function$

-- Paramètres d'entrée :
-- nschema = nom du schéma
-- couche = nom de la couche sur laquelle créer le geomloc
-- geom = nom de la géométrie

-- Exemple d'appel à cette fonction :
-- SELECT public.__util_create_geomloc('r_ign_rpg', 'parcelles_graphiques_2021', 'geom');

DECLARE
	heure1 varchar; -- heure de début du traitement
	heure2 varchar; -- heure de fin du traitement

BEGIN
	heure1 = current_timestamp;

	RAISE NOTICE 'Début du traitement : %', heure1;

	-- Création d'un index sur le champ géométrie de la couche (par exemple sur the_geom de parcelles_graphiques_'||an_rpg||')
	EXECUTE 'DROP INDEX IF EXISTS '||couche||'_'||geom||'_gist';
	EXECUTE 'CREATE INDEX '||couche||'_'||geom||'_gist ON '||nschema||'.'||couche||' USING gist('||geom||')';

	-- Création d'un centroïde geomloc dans la couche (application par exemple à la couche parcelles_graphiques_'||an_rpg||')
	EXECUTE 'ALTER TABLE '||nschema||'.'||couche||'
	DROP COLUMN IF EXISTS geomloc,
	ADD COLUMN geomloc geometry(POINT,2154)';
	EXECUTE 'UPDATE '||nschema||'.'||couche||'
	SET geomloc = ST_Centroid('||geom||')';

	-- Création d'un index sur geomloc (par exemple de parcelles_graphiques_'||an_rpg||')
	EXECUTE 'CREATE INDEX '||couche||'_geomloc_gist ON '||nschema||'.'||couche||' USING gist(geomloc)';

	heure2 = clock_timestamp();
	RAISE NOTICE 'Fin du traitement : %', heure2;
	RAISE NOTICE 'Durée du traitement : %', CAST(heure2 as time)-CAST(heure1 as time);
	RAISE NOTICE '';

END;
$function$
