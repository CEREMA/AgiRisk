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

CREATE OR REPLACE FUNCTION public.__util_partition_rpg(tab_rpg_fr text, millesime_rpg text, millesime_bdtopo text, nom_schema_bdtopo text, nom_schema_rpg text)
 RETURNS void
 LANGUAGE plpgsql
AS $function$

DECLARE
	ldep varchar[] := array['01','02','03','04','05','06','07','08','09','10','11','12','13','14','15','16','17','18','19','2a','2b','21','22','23','24','25','26','27','28','29','30','31','32','33','34','35','36','37','38','39','40','41','42','43','44','45','46','47','48','49','50','51','52','53','54','55','56','57','58','59','60','61','62','63','64','65','66','67','68','69','70','71','72','73','74','75','76','77','78','79','80','81','82','83','84','85','86','87','88','89','90','91','92','93','94','95'];
	dep varchar;
	
BEGIN
	
	--découpage par département
	FOREACH dep IN ARRAY ldep
			
		LOOP
			RAISE NOTICE '%', dep;	
			EXECUTE 'DROP TABLE IF EXISTS ' || nom_schema_rpg || '.parcelles_graphiques_' || millesime_rpg || '_d0' || dep || '';
			EXECUTE 'CREATE TABLE ' || nom_schema_rpg || '.parcelles_graphiques_' || millesime_rpg || '_d0' || dep || ' AS 
				SELECT a.*,''' || dep || '''::varchar(2) AS insee_dep FROM ' || nom_schema_rpg || '.' || tab_rpg_fr || ' a,' || nom_schema_bdtopo || '.departement_' || millesime_bdtopo || '_d0' || dep || ' b WHERE ST_Intersects(ST_Centroid(a.geom),b.geom)';
			EXECUTE 'CREATE INDEX ON ' || nom_schema_rpg || '.parcelles_graphiques_' || millesime_rpg || '_d0' || dep || ' using GIST(geom)';

		END LOOP;	

	--Création de la table partition mère	
	EXECUTE 'DROP TABLE IF EXISTS ' || nom_schema_rpg || '.parcelles_graphiques_' || millesime_rpg || '';
	EXECUTE 'CREATE TABLE ' || nom_schema_rpg || '.parcelles_graphiques_' || millesime_rpg || ' (LIKE ' || nom_schema_rpg || '.parcelles_graphiques_' || millesime_rpg || '_d001 INCLUDING COMMENTS) 
	PARTITION BY LIST (insee_dep)';

	FOREACH dep IN ARRAY ldep
		LOOP
			RAISE NOTICE '%', dep;
			--Lien entre partition mère et filles
			EXECUTE 'ALTER TABLE IF EXISTS ' || nom_schema_rpg || '.parcelles_graphiques_' || millesime_rpg || ' ATTACH PARTITION ' || nom_schema_rpg || '.parcelles_graphiques_' || millesime_rpg || '_d0' || dep || ' FOR VALUES IN (''' || dep || ''')';
		END LOOP;

	RAISE NOTICE 'Fin';	

END;
$function$
