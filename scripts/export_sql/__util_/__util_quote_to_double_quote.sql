SET client_encoding = 'UTF8';

CREATE OR REPLACE FUNCTION public.__util_quote_to_double_quote(text)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
BEGIN
	RETURN lower(replace($1,'''',''''''));
END;
$function$
