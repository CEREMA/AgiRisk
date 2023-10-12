SET client_encoding = 'UTF8';

CREATE OR REPLACE FUNCTION public.__util_to_snake_case(text)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
BEGIN
	RETURN lower(unaccent(replace(replace(replace(replace(replace(replace(replace(replace($1,'''','_'),' - ','_'),'-','_'),' / ','_'),'/','_'),' ','_'),'+','plus'),'%','pct')));
END;
$function$
