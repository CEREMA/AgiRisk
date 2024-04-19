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

CREATE OR REPLACE FUNCTION public.__util_partition_batiment_bdtopo(millesime text, nom_schema_bdtopo text, dep text)
 RETURNS void
 LANGUAGE plpgsql
AS $function$


DECLARE
	
BEGIN
	RAISE NOTICE '%', dep;

	--suppression des doublons en limite de département et ajout d'un champ insee_dep
	EXECUTE 'CREATE INDEX ON ' || nom_schema_bdtopo || '.batiment_' || millesime || '_d0' ||dep|| ' using gist(geom)';
	EXECUTE 'CREATE INDEX ON ' || nom_schema_bdtopo || '.commune_' || millesime || '_d0' ||dep|| ' using gist(geom)';
	EXECUTE 'ALTER TABLE ' || nom_schema_bdtopo || '.batiment_' || millesime || '_d0' ||dep|| ' ADD COLUMN insee_dep varchar(2)';
	EXECUTE 'UPDATE ' || nom_schema_bdtopo || '.batiment_' || millesime || '_d0' ||dep|| ' a SET insee_dep = 
		(SELECT left(insee_com,2) FROM ' || nom_schema_bdtopo || '.commune_' || millesime || '_d0' ||dep|| ' b
		 WHERE ST_Intersects(a.geom,b.geom) limit 1)';
	EXECUTE 'DELETE FROM ' || nom_schema_bdtopo || '.batiment_' || millesime || '_d0' ||dep|| ' WHERE insee_dep is null or insee_dep!=''' ||dep|| '''';
	EXECUTE 'ALTER TABLE ' || nom_schema_bdtopo || '.batiment_' || millesime || '_d0' ||dep|| ' ADD COLUMN geomloc geometry(point,2154)';
	EXECUTE 'UPDATE ' || nom_schema_bdtopo || '.batiment_' || millesime || '_d0' ||dep|| ' SET geomloc=ST_Centroid(geom)';
	EXECUTE 'CREATE INDEX ON ' || nom_schema_bdtopo || '.batiment_' || millesime || '_d0' ||dep|| ' using gist(geomloc)';

	--Lien entre partition mère et filles
	EXECUTE 'ALTER TABLE IF EXISTS ' || nom_schema_bdtopo || '.batiment_' || millesime || ' ATTACH PARTITION ' || nom_schema_bdtopo || '.batiment_' || millesime || '_d0' || dep || ' FOR VALUES IN (''' || dep || ''')';

	RAISE NOTICE 'Fin';	

END;
$function$
