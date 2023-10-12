SET client_encoding = 'UTF8';

CREATE OR REPLACE FUNCTION public.__util_quote_to_underscore(text)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
BEGIN
	RETURN lower(replace($1,'''','_'));
END;
$function$
