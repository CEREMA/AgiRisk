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

CREATE OR REPLACE FUNCTION public.__util_partition_epci_bdtopo(millesime text, nom_schema_bdtopo text)
 RETURNS void
 LANGUAGE plpgsql
AS $function$


DECLARE
	ldep varchar[] := array['01','02','03','04','05','06','07','08','09','10','11','12','13','14','15','16','17','18','19','2a','2b','21','22','23','24','25','26','27','28','29','30','31','32','33','34','35','36','37','38','39','40','41','42','43','44','45','46','47','48','49','50','51','52','53','54','55','56','57','58','59','60','61','62','63','64','65','66','67','68','69','70','71','72','73','74','75','76','77','78','79','80','81','82','83','84','85','86','87','88','89','90','91','92','93','94','95'];
	dep varchar;
	
BEGIN

	--Création de la table partition mère	
	EXECUTE 'DROP TABLE IF EXISTS ' || nom_schema_bdtopo || '.epci_' || millesime || '';
	EXECUTE 'CREATE TABLE ' || nom_schema_bdtopo || '.epci_' || millesime || ' (LIKE ' || nom_schema_bdtopo || '.epci_' || millesime || '_d001 INCLUDING COMMENTS) 
	PARTITION BY LIST (insee_dep)';

	FOREACH dep IN ARRAY ldep
		LOOP
			RAISE NOTICE '%', dep;
			--Lien entre partition mère et filles
			EXECUTE 'ALTER TABLE IF EXISTS ' || nom_schema_bdtopo || '.epci_' || millesime || ' ATTACH PARTITION ' || nom_schema_bdtopo || '."epci_' || millesime || '_d0' || dep || '" FOR VALUES IN (''' || dep || ''')';
		END LOOP;

	--création des index
	EXECUTE 'CREATE INDEX ON ' || nom_schema_bdtopo || '."epci_' || millesime || '" using gist(geom)';
	EXECUTE 'CREATE INDEX ON ' || nom_schema_bdtopo || '."epci_' || millesime || '" using btree(id)';
	
	RAISE NOTICE 'Fin';	

END;
$function$
