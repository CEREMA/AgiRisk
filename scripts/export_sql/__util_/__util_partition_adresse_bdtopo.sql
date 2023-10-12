SET client_encoding = 'UTF8';

CREATE OR REPLACE FUNCTION public.__util_partition_adresse_bdtopo(millesime text, nom_schema_bdtopo text)
 RETURNS void
 LANGUAGE plpgsql
AS $function$

DECLARE
	ldep varchar[] := array['01','02','03','04','05','06','07','08','09','10','11','12','13','14','15','16','17','18','19','2A','2B','21','22','23','24','25','26','27','28','29','30','31','32','33','34','35','36','37','38','39','40','41','42','43','44','45','46','47','48','49','50','51','52','53','54','55','56','57','58','59','60','61','62','63','64','65','66','67','68','69','70','71','72','73','74','75','76','77','78','79','80','81','82','83','84','85','86','87','88','89','90','91','92','93','94','95'];
	dep varchar;
	
BEGIN

	FOREACH dep IN ARRAY ldep
		LOOP
			RAISE NOTICE '%', dep;
			
			--Suppression des points hors département
			EXECUTE 'DELETE FROM ' || nom_schema_bdtopo || '.adresse_' || millesime || '_d0' || dep || ' WHERE code_insee NOT LIKE ''' || dep || '%''';
	
			--Ajout du champ insee_dep aux tables lien adresse parcelles départementales
			EXECUTE 'ALTER TABLE ' || nom_schema_bdtopo || '.adresse_' || millesime || '_d0' || dep || ' ADD COLUMN IF NOT EXISTS insee_dep VARCHAR(2)';

			--Mise à jour du champ insee_dep des tables lien adresse parcelles départementales
			EXECUTE 'UPDATE ' || nom_schema_bdtopo || '.adresse_' || millesime || '_d0' || dep || ' SET insee_dep=left(code_insee,2)';
			
		END LOOP;

	--Création de la table partition mère	
	EXECUTE 'DROP TABLE IF EXISTS ' || nom_schema_bdtopo || '.adresse_' || millesime || '';
	EXECUTE 'CREATE TABLE ' || nom_schema_bdtopo || '.adresse_' || millesime || ' (LIKE ' || nom_schema_bdtopo || '.adresse_' || millesime || '_d001 INCLUDING COMMENTS) 
	PARTITION BY LIST (insee_dep)';

	FOREACH dep IN ARRAY ldep
		LOOP
			RAISE NOTICE '%', dep;
			--Lien entre partition mère et filles
			EXECUTE 'ALTER TABLE IF EXISTS ' || nom_schema_bdtopo || '.adresse_' || millesime || ' ATTACH PARTITION ' || nom_schema_bdtopo || '.adresse_' || millesime || '_d0' || dep || ' FOR VALUES IN (''' || dep || ''')';
		END LOOP;

	RAISE NOTICE 'Fin';	

END;
$function$
