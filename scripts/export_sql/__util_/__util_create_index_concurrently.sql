SET client_encoding = 'UTF8';

CREATE OR REPLACE FUNCTION public.__util_create_index_concurrently(ntable text, nschema text)
 RETURNS TABLE(query text)
 LANGUAGE plpgsql
AS $function$

DECLARE
att TEXT; -- liste des attributs de la table
typ TEXT; -- liste des TYPES d'attributs de la TABLE

BEGIN

-- Création d'une table qui liste tous les attributs d'une table
EXECUTE 'DROP TABLE IF EXISTS attname CASCADE;
CREATE TEMP TABLE attname AS
SELECT pg_attribute.attname, pg_type.typname
FROM pg_class
JOIN pg_attribute ON pg_class.relname='''||ntable||''' AND pg_attribute.attrelid=pg_class.oid AND attnum > 0
JOIN pg_type ON pg_type.oid=pg_attribute.atttypid';

FOR att, typ IN SELECT * FROM attname

LOOP

	IF typ = 'geometry'
		THEN query := 'CREATE INDEX CONCURRENTLY ON '||nschema||'.'||ntable||' USING gist('||att||');';
		ELSE query := 'CREATE INDEX CONCURRENTLY ON '||nschema||'.'||ntable||' USING btree('||att||');';
	END IF;
	
	RETURN NEXT ;

END LOOP;

END;
$function$
