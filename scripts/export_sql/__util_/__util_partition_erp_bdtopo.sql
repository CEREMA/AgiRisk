SET client_encoding = 'UTF8';

CREATE OR REPLACE FUNCTION public.__util_partition_erp_bdtopo(millesime text, nom_schema_bdtopo text)
 RETURNS void
 LANGUAGE plpgsql
AS $function$


DECLARE
	ldep varchar[] := array['01','02','03','04','07','08','09','10','12','15','18','19','23','24','26','29','30','31','32','33','34','38','41','42','43','47','49','51','53','54','55','58','59','60','61','63','64','65','67','69','72','73','74','76','77','81','87','88','91','94','95']; 
	--pas de table ERP pour les départements 05, 06, 11, 13, 14, 16, 17, 21, 22, 25, 27, 28, 2a, 2b, 35, 36, 37, 39, 40, 44, 45, 46, 48, 50, 52, 56, 57, 62, 66, 68, 70, 71, 75, 78, 79, 80, 82, 83, 84, 85, 86, 89, 90, 92, 93 en 2023
	dep varchar;
	
BEGIN

	--Création de la table partition mère	
	EXECUTE 'DROP TABLE IF EXISTS ' || nom_schema_bdtopo || '.erp_' || millesime || '';
	EXECUTE 'CREATE TABLE ' || nom_schema_bdtopo || '.erp_' || millesime || ' (LIKE ' || nom_schema_bdtopo || '.erp_' || millesime || '_d001 INCLUDING COMMENTS) 
	PARTITION BY LIST (insee_dep)';

	FOREACH dep IN ARRAY ldep
		LOOP
			RAISE NOTICE '%', dep;
			--Lien entre partition mère et filles
			EXECUTE 'ALTER TABLE IF EXISTS ' || nom_schema_bdtopo || '.erp_' || millesime || ' ATTACH PARTITION ' || nom_schema_bdtopo || '."erp_' || millesime || '_d0' || dep || '" FOR VALUES IN (''' || dep || ''')';
		END LOOP;

	--création des index
	EXECUTE 'CREATE INDEX ON ' || nom_schema_bdtopo || '."erp_' || millesime || '" using gist(geom)';
	EXECUTE 'CREATE INDEX ON ' || nom_schema_bdtopo || '."erp_' || millesime || '" using btree(id)';
	
	RAISE NOTICE 'Fin';	

END;
$function$
