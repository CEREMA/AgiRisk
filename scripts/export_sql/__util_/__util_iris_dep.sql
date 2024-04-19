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

CREATE OR REPLACE FUNCTION public.__util_iris_dep(table_iris_nat text, schema_iris text, an_iris text)
 RETURNS void
 LANGUAGE plpgsql
AS $function$

DECLARE
	heure1 varchar;
	heure2 varchar;
	dep varchar;

BEGIN
	heure1 = clock_timestamp();
	RAISE NOTICE 'Début du traitement : %', heure1;
	
	--Ajout du champ insee_dep dans la table nationale des IRIS
	EXECUTE '
		ALTER TABLE ' || schema_iris || '.' || table_iris_nat || ' ADD COLUMN IF NOT EXISTS insee_dep varchar(2);
		UPDATE ' || schema_iris || '.' || table_iris_nat || ' SET insee_dep = left(insee_com,2);
	';
		
	--création de la couche des IRIS du département '01' pour initialiser la table mère des partitions
	EXECUTE '
		DROP TABLE IF EXISTS ' || schema_iris || '.irisge_' || an_iris || '_d001;
		CREATE TABLE ' || schema_iris || '.irisge_' || an_iris || '_d001 AS
		SELECT *
		FROM ' || schema_iris || '.' || table_iris_nat || '
		WHERE insee_dep = ''01''
	';
	
	--Création de la partition mère
	EXECUTE '
		DROP TABLE IF EXISTS ' || schema_iris || '.irisge_' || an_iris || ';
		CREATE TABLE ' || schema_iris || '.irisge_' || an_iris || ' (LIKE ' || schema_iris || '.irisge_' || an_iris || '_d001 INCLUDING COMMENTS) 
		PARTITION BY LIST (insee_dep);
	';
	
	--Création des tables départementales et partitionnement
	EXECUTE 'DROP TABLE IF EXISTS public.tab_iris_nat';
	EXECUTE 'CREATE TABLE public.tab_iris_nat AS
		SELECT insee_dep FROM ' || schema_iris || '.'|| table_iris_nat ||' GROUP BY insee_dep order by insee_dep';
	
    FOR dep IN SELECT insee_dep FROM public.tab_iris_nat order by insee_dep

        LOOP
			
			EXECUTE '
				DROP TABLE IF EXISTS ' || schema_iris || '.irisge_' || an_iris || '_d0' || dep || ';
				CREATE TABLE ' || schema_iris || '.irisge_' || an_iris || '_d0' || dep || ' AS
				SELECT *
				FROM ' || schema_iris || '.' || table_iris_nat || '
				WHERE insee_dep = ''' || dep || '''
			';
			
			EXECUTE 'ALTER TABLE ' || schema_iris || '.irisge_' || an_iris || '_d0' || dep || ' ADD COLUMN IF NOT EXISTS gid serial';
			EXECUTE 'ALTER TABLE ' || schema_iris || '.irisge_' || an_iris || '_d0' || dep || ' ADD CONSTRAINT irisge_' || an_iris || '_d0' || dep || '_pkey PRIMARY KEY (gid)';
			EXECUTE 'CREATE INDEX ON ' || schema_iris || '.irisge_' || an_iris || '_d0' || dep || ' USING gist(geom)';
			EXECUTE 'CREATE INDEX ON ' || schema_iris || '.irisge_' || an_iris || '_d0' || dep || ' USING btree(insee_dep)';
			EXECUTE 'CREATE INDEX ON ' || schema_iris || '.irisge_' || an_iris || '_d0' || dep || ' USING btree(insee_com)';
			EXECUTE 'CREATE INDEX ON ' || schema_iris || '.irisge_' || an_iris || '_d0' || dep || ' USING btree(code_iris)';
			
			EXECUTE 'ALTER TABLE IF EXISTS ' || schema_iris || '.irisge_' || an_iris || ' ATTACH PARTITION ' || schema_iris || '.irisge_' || an_iris || '_d0' || dep || ' FOR VALUES IN ('''|| dep ||''');';
			
			RAISE NOTICE '%', dep;
    
        END LOOP;
	
	heure2 = clock_timestamp();
	RAISE NOTICE 'Fin du traitement : %', heure2;
	RAISE NOTICE 'Durée du traitement : %', CAST(heure2 as time)-CAST(heure1 as time);
	RAISE NOTICE '';	

END;
$function$
