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

-- FUNCTION: public.__util_iris2com_epci(text, text, text, text)

-- DROP FUNCTION IF EXISTS public.__util_iris2com_epci(text, text, text, text);

CREATE OR REPLACE FUNCTION public.__util_iris2com_epci(
	schema_iris text,
	schema_bdtopo text,
	an_iris text,
	an_bdtopo text)
    RETURNS void
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$

--SELECT public.__util_iris2com_epci('r_ign_irisge','r_ign_bdtopo','2023','2023')

DECLARE
	heure1 varchar;
	heure2 varchar;
	ldep1 varchar[] := array['13','69','75'];
	ldep2 varchar[] := array['01','02','03','04','05','06','07','08','09','10','11','12','14','15','16','17','18','19','2a','2b','21','22','23','24','25','26','27','28','29','30','31','32','33','34','35','36','37','38','39','40','41','42','43','44','45','46','47','48','49','50','51','52','53','54','55','56','57','58','59','60','61','62','63','64','65','66','67','68','70','71','72','73','74','76','77','78','79','80','81','82','83','84','85','86','87','88','89','90','91','92','93','94','95'];
	dep varchar;

BEGIN

	heure1 = clock_timestamp();
	RAISE NOTICE 'Début du traitement : %', heure1;
	
	--Traitement des 3 départements avec code IRIS posant pb avec code com (13, 69, 75) - arrondissements
    FOREACH dep IN ARRAY ldep1

        LOOP
			
			RAISE NOTICE '%', dep;
			
			--mise à jour des tables communales
			EXECUTE 'DROP TABLE IF EXISTS ' || schema_bdtopo || '.temp';
			EXECUTE 'CREATE TABLE ' || schema_bdtopo || '.temp AS			
				WITH iris AS (
					SELECT				 	
						insee_com,
						st_union(geom) geom				
					FROM ' || schema_iris || '.irisge_2023
					WHERE left(insee_com,2)=''' || dep || '''
					group by insee_com)
				SELECT
					id,iris.insee_com,insee_dep,insee_reg, code_post,nom,siren_epci,iris.geom
				FROM
					iris
				left join
					' || schema_bdtopo || '.commune_2023 as commune
				on (case
						when iris.insee_com::numeric>=75101 and iris.insee_com::numeric<=75120 then ''75056''
						when iris.insee_com::numeric>=69381 and iris.insee_com::numeric<=69389 then ''69123''
						when iris.insee_com::numeric>=13201 and iris.insee_com::numeric<=13216 then ''13055''
						else iris.insee_com end) = commune.insee_com				
				';	
			
			EXECUTE 'ALTER TABLE IF EXISTS ' || schema_bdtopo || '.commune_' || an_bdtopo || ' DETACH  PARTITION ' || schema_bdtopo || '.commune_' || an_bdtopo || '_d0' || dep || '';
			EXECUTE 'DROP TABLE IF EXISTS ' || schema_bdtopo || '.commune_' || an_bdtopo || '_d0' || dep || '';
			EXECUTE 'ALTER TABLE ' || schema_bdtopo || '.temp RENAME TO commune_' || an_bdtopo || '_d0' || dep || '';
			EXECUTE 'ALTER TABLE ' || schema_bdtopo || '.commune_' || an_bdtopo || '_d0' || dep || ' ALTER COLUMN geom type geometry(MultiPolygon, 2154) using ST_Multi(geom)';
			EXECUTE 'CREATE INDEX ON ' || schema_bdtopo || '.commune_' || an_bdtopo || '_d0' || dep || ' using gist(geom)';
			EXECUTE 'CREATE INDEX ON ' || schema_bdtopo || '.commune_' || an_bdtopo || '_d0' || dep || ' using btree(insee_com)';						
			EXECUTE 'ALTER TABLE IF EXISTS ' || schema_bdtopo || '.commune_' || an_bdtopo || ' ATTACH PARTITION ' || schema_bdtopo || '."commune_' || an_bdtopo || '_d0' || dep || '" FOR VALUES IN (''' || dep || ''')';
			EXECUTE 'DROP TABLE IF EXISTS ' || schema_bdtopo || '.temp';
		
			--mise à jour des tables EPCI
			EXECUTE 'DROP TABLE IF EXISTS public.temp';
			EXECUTE 'CREATE TABLE public.temp AS
				SELECT b.id, st_union(a.geom) as geom
				FROM ' || schema_iris || '.irisge_' || an_iris || '_d0' || dep || ' a, ' || schema_bdtopo || '.epci_' || an_bdtopo || '_d0' || dep || ' b
				WHERE ST_Intersects(ST_centroid(a.geom),b.geom)
				GROUP BY b.id';	
			EXECUTE 'ALTER TABLE public.temp ALTER COLUMN geom type geometry(MultiPolygon, 2154) using ST_Multi(geom)';
			EXECUTE 'CREATE INDEX ON public.temp using gist(geom)';
			EXECUTE 'CREATE INDEX ON public.temp using btree(id)';
			EXECUTE 'UPDATE ' || schema_bdtopo || '.epci_' || an_bdtopo || '_d0' || dep || ' a SET geom=(SELECT geom from public.temp b WHERE a.id=b.id)';			
			
        END LOOP;	
	
	--Traitement des autres départements
	FOREACH dep IN ARRAY ldep2

        LOOP
			
			RAISE NOTICE '%', dep;
			
			--mise à jour des tables communales
			EXECUTE 'DROP TABLE IF EXISTS public.temp';
			EXECUTE 'CREATE TABLE public.temp AS			
				SELECT 
					insee_com,
					st_union(geom) as geom
				FROM ' || schema_iris || '.irisge_' || an_iris || '_d0' || dep || '
				GROUP BY insee_com';	
			EXECUTE 'ALTER TABLE public.temp ALTER COLUMN geom type geometry(MultiPolygon, 2154) using ST_Multi(geom)';
			EXECUTE 'CREATE INDEX ON public.temp using gist(geom)';
			EXECUTE 'CREATE INDEX ON public.temp using btree(insee_com)';
			EXECUTE 'UPDATE ' || schema_bdtopo || '.commune_' || an_bdtopo || '_d0' || dep || ' a SET geom=(SELECT geom from public.temp b WHERE a.insee_com=b.insee_com)';
		
			--mise à jour des tables EPCI
			EXECUTE 'DROP TABLE IF EXISTS public.temp';
			EXECUTE 'CREATE TABLE public.temp AS
				SELECT b.id, st_union(a.geom) as geom
				FROM ' || schema_iris || '.irisge_' || an_iris || '_d0' || dep || ' a, ' || schema_bdtopo || '.epci_' || an_bdtopo || '_d0' || dep || ' b
				WHERE ST_Intersects(ST_centroid(a.geom),b.geom)
				GROUP BY b.id';	
			EXECUTE 'ALTER TABLE public.temp ALTER COLUMN geom type geometry(MultiPolygon, 2154) using ST_Multi(geom)';
			EXECUTE 'CREATE INDEX ON public.temp using gist(geom)';
			EXECUTE 'CREATE INDEX ON public.temp using btree(id)';
			EXECUTE 'UPDATE ' || schema_bdtopo || '.epci_' || an_bdtopo || '_d0' || dep || ' a SET geom=(SELECT geom from public.temp b WHERE a.id=b.id)';			
			
        END LOOP;	
	
	heure2 = clock_timestamp();
	RAISE NOTICE 'Fin du traitement : %', heure2;
	RAISE NOTICE 'Durée du traitement : %', CAST(heure2 as time)-CAST(heure1 as time);
	RAISE NOTICE '';	

END;
$BODY$;

ALTER FUNCTION public.__util_iris2com_epci(text, text, text, text)
    OWNER TO postgres;
