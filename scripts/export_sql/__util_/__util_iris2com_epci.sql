SET client_encoding = 'UTF8';

CREATE OR REPLACE FUNCTION public.__util_iris2com_epci(schema_iris text, schema_bdtopo text, an_iris text, an_bdtopo text)
 RETURNS void
 LANGUAGE plpgsql
AS $function$

--SELECT public.__util_iris2com_epci('r_ign_irisge','r_ign_bdtopo','2023','2023')

DECLARE
	heure1 varchar;
	heure2 varchar;
	dep varchar;

BEGIN

	heure1 = clock_timestamp();
	RAISE NOTICE 'Début du traitement : %', heure1;
	
	EXECUTE 'DROP TABLE IF EXISTS public.depcom';
	EXECUTE 'CREATE TABLE public.depcom AS
		SELECT insee_dep FROM ' || schema_bdtopo || '.commune_' || an_bdtopo ||' GROUP BY insee_dep order by insee_dep';	
	
	
    FOR dep IN SELECT insee_dep FROM public.depcom order by insee_dep

        LOOP
			
			RAISE NOTICE '%', dep;
			
			--mise à jour des tables communales
			EXECUTE 'DROP TABLE IF EXISTS public.temp';
			EXECUTE 'CREATE TABLE public.temp AS
				SELECT insee_com, st_union(geom) as geom
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
$function$
