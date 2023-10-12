SET client_encoding = 'UTF8';

CREATE OR REPLACE FUNCTION public.__util_partition_ff(millesime text, nom_schema_ff text)
 RETURNS void
 LANGUAGE plpgsql
AS $function$

DECLARE
	ldep varchar[] := array['01','02','03','04','05','06','07','08','09','10','11','12','13','14','15','16','17','18','19','2a','2b','21','22','23','24','25','26','27','28','29','30','31','32','33','34','35','36','37','38','39','40','41','42','43','44','45','46','47','48','49','50','51','52','53','54','55','56','57','58','59','60','61','62','63','64','65','66','67','68','69','70','71','72','73','74','75','76','77','78','79','80','81','82','83','84','85','86','87','88','89','90','91','92','93','94','95'];
	dep varchar;
	
BEGIN
	
	FOREACH dep IN ARRAY ldep
			
		LOOP
			RAISE NOTICE '%', dep;	
			EXECUTE 'ALTER TABLE ' || nom_schema_ff || '.d' || dep || '_ffta_' || millesime || '_batiment ADD COLUMN insee_dep varchar(2)';
			EXECUTE 'UPDATE ' || nom_schema_ff || '.d' || dep || '_ffta_' || millesime || '_batiment a SET insee_dep = ''' || dep || '''';
			
				--suppression heritage
			EXECUTE 'ALTER TABLE IF EXISTS ' || nom_schema_ff || '.d' || dep || '_ffta_' || millesime || '_batiment NO INHERIT r_dgfip_ff2.ffta_' || millesime || '_batiment';
			EXECUTE 'ALTER TABLE IF EXISTS ' || nom_schema_ff || '.d' || dep || '_ffta_' || millesime || '_tup NO INHERIT r_dgfip_ff2.ffta_' || millesime || '_tup';
			EXECUTE 'ALTER TABLE IF EXISTS ' || nom_schema_ff || '.d' || dep || '_fftp_' || millesime || '_pb0010_local NO INHERIT r_dgfip_ff2.fftp_' || millesime || '_pb0010_local';
			EXECUTE 'ALTER TABLE IF EXISTS ' || nom_schema_ff || '.d' || dep || '_fftp_' || millesime || '_pnb10_parcelle NO INHERIT r_dgfip_ff2.fftp_' || millesime || '_pnb10_parcelle';
			EXECUTE 'ALTER TABLE IF EXISTS ' || nom_schema_ff || '.d' || dep || '_fftp_' || millesime || '_proprietaire_droit NO INHERIT r_dgfip_ff2.fftp_' || millesime || '_proprietaire_droit';
		END LOOP;

	
	--Création des tables partitions mère	
	EXECUTE 'DROP TABLE IF EXISTS ' || nom_schema_ff || '.ffta_' || millesime || '_batiment ';
	EXECUTE 'CREATE TABLE ' || nom_schema_ff || '.ffta_' || millesime || '_batiment (LIKE ' || nom_schema_ff || '.d17_ffta_' || millesime || '_batiment) 
		PARTITION BY LIST (insee_dep)';
	EXECUTE 'DROP TABLE IF EXISTS ' || nom_schema_ff || '.ffta_' || millesime || '_tup ';
	EXECUTE 'CREATE TABLE ' || nom_schema_ff || '.ffta_' || millesime || '_tup (LIKE ' || nom_schema_ff || '.d17_ffta_' || millesime || '_tup) 
		PARTITION BY LIST (ccodep)';
	EXECUTE 'DROP TABLE IF EXISTS ' || nom_schema_ff || '.fftp_' || millesime || '_pb0010_local ';
	EXECUTE 'CREATE TABLE ' || nom_schema_ff || '.fftp_' || millesime || '_pb0010_local (LIKE ' || nom_schema_ff || '.d17_fftp_' || millesime || '_pb0010_local ) 
		PARTITION BY LIST (ccodep)';
	EXECUTE 'DROP TABLE IF EXISTS ' || nom_schema_ff || '.fftp_' || millesime || '_pnb10_parcelle ';
	EXECUTE 'CREATE TABLE ' || nom_schema_ff || '.fftp_' || millesime || '_pnb10_parcelle (LIKE ' || nom_schema_ff || '.d17_fftp_' || millesime || '_pnb10_parcelle) 
		PARTITION BY LIST (ccodep)';
	EXECUTE 'DROP TABLE IF EXISTS ' || nom_schema_ff || '.fftp_' || millesime || '_proprietaire_droit ';
	EXECUTE 'CREATE TABLE ' || nom_schema_ff || '.fftp_' || millesime || '_proprietaire_droit (LIKE ' || nom_schema_ff || '.d17_fftp_' || millesime || '_proprietaire_droit ) 
		PARTITION BY LIST (ccodep)';
		

	FOREACH dep IN ARRAY ldep
		LOOP
			RAISE NOTICE '%', dep;			
			--Lien entre partition mère et filles
			EXECUTE 'ALTER TABLE IF EXISTS ' || nom_schema_ff || '.ffta_' || millesime || '_batiment ATTACH PARTITION ' || nom_schema_ff || '.d' || dep || '_ffta_' || millesime || '_batiment FOR VALUES IN (''' || dep || ''')';
			EXECUTE 'ALTER TABLE IF EXISTS ' || nom_schema_ff || '.ffta_' || millesime || '_tup ATTACH PARTITION ' || nom_schema_ff || '.d' || dep || '_ffta_' || millesime || '_tup FOR VALUES IN (''' || dep || ''')';
			EXECUTE 'ALTER TABLE IF EXISTS ' || nom_schema_ff || '.fftp_' || millesime || '_pb0010_local ATTACH PARTITION ' || nom_schema_ff || '.d' || dep || '_fftp_' || millesime || '_pb0010_local FOR VALUES IN (''' || dep || ''')';
			EXECUTE 'ALTER TABLE IF EXISTS ' || nom_schema_ff || '.fftp_' || millesime || '_pnb10_parcelle ATTACH PARTITION ' || nom_schema_ff || '.d' || dep || '_fftp_' || millesime || '_pnb10_parcelle FOR VALUES IN (''' || dep || ''')';
			EXECUTE 'ALTER TABLE IF EXISTS ' || nom_schema_ff || '.fftp_' || millesime || '_proprietaire_droit ATTACH PARTITION ' || nom_schema_ff || '.d' || dep || '_fftp_' || millesime || '_proprietaire_droit FOR VALUES IN (''' || dep || ''')';
		END LOOP;

	RAISE NOTICE 'Fin';	

END;
$function$
