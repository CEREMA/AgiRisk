SET client_encoding = 'UTF8';

CREATE OR REPLACE FUNCTION public.__util_drop_index(ntable text, nschema text)
 RETURNS void
 LANGUAGE plpgsql
AS $function$

DECLARE
att TEXT; -- liste des attributs de la table
typ TEXT; -- liste des TYPES d'attributs de la TABLE
nindex TEXT; -- liste des index de ntable

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

	nindex := NULL;
	EXECUTE 'SELECT indexname
		FROM pg_indexes
		WHERE
			schemaname = '''||nschema||'''
			AND tablename = '''||ntable||'''
			AND substring(split_part(indexdef,''('',2), 1, char_length(split_part(indexdef,''('',2))-1) = '''||att||'''
		ORDER BY indexname'
	INTO nindex;
	IF nindex IS NOT NULL
		THEN
			EXECUTE 'DROP INDEX IF EXISTS '||nschema||'.'||nindex||'';
		
	END IF;

END LOOP;

END;
$function$
