SET client_encoding = 'UTF8';

CREATE OR REPLACE FUNCTION public.__util_alim_zx_fct(nom_ter text)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
begin
	execute '	
		delete from c_phenomenes.zx where territoire = ''' || nom_ter || '''
	';	
	execute '
		insert into c_phenomenes.zx(territoire, occurrence, code_occurrence, type_alea, geom) 
		select territoire, occurrence, code_occurrence, type_alea, st_multi(st_union(geom))
		from c_phenomenes.zq
		where territoire = ''' || nom_ter || '''
		group by territoire, occurrence, code_occurrence, type_alea
	';
end;
$function$
