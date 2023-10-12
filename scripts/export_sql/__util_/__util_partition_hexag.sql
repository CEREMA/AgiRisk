SET client_encoding = 'UTF8';

CREATE OR REPLACE FUNCTION public.__util_partition_hexag(tab_hexag_fr text, maille_hexag text, nom_schema_hexag text, millesime_bdtopo text, nom_schema_bdtopo text)
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
			EXECUTE 'DROP TABLE IF EXISTS ' || nom_schema_hexag || '.hexag_' || maille_hexag || '_d0' || dep || '';
			EXECUTE 'CREATE TABLE ' || nom_schema_hexag || '.hexag_' || maille_hexag || '_d0' || dep || ' AS 
				SELECT a.*,''' || dep || '''::varchar(2) AS insee_dep FROM public.' || tab_hexag_fr || ' a,' || nom_schema_bdtopo || '.departement_' || millesime_bdtopo || '_d0' || dep || ' b WHERE ST_Intersects(ST_Centroid(a.geom),b.geom)';
			EXECUTE 'CREATE INDEX ON ' || nom_schema_hexag || '.hexag_' || maille_hexag || '_d0' || dep || ' using GIST(geom)';

		END LOOP;	

	--Création de la table partition mère	
	EXECUTE 'DROP TABLE IF EXISTS ' || nom_schema_hexag || '.hexag_' || maille_hexag || '';
	EXECUTE 'CREATE TABLE ' || nom_schema_hexag || '.hexag_' || maille_hexag || ' (LIKE ' || nom_schema_hexag || '.hexag_' || maille_hexag || '_d001 INCLUDING COMMENTS) 
	PARTITION BY LIST (insee_dep)';

	FOREACH dep IN ARRAY ldep
		LOOP
			RAISE NOTICE '%', dep;
			--Lien entre partition mère et filles
			EXECUTE 'ALTER TABLE IF EXISTS ' || nom_schema_hexag || '.hexag_' || maille_hexag || ' ATTACH PARTITION ' || nom_schema_hexag || '.hexag_' || maille_hexag || '_d0' || dep || ' FOR VALUES IN (''' || dep || ''')';
		END LOOP;

	RAISE NOTICE 'Fin';	

END;
$function$
