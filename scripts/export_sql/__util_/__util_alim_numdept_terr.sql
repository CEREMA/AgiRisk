SET client_encoding = 'UTF8';

CREATE OR REPLACE FUNCTION public.__util_alim_numdept_terr()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
  NEW.insee_dep := ARRAY(
    SELECT insee_dep
    FROM r_ign_bdtopo.departement_2023 d
    WHERE ST_Intersects(St_Buffer(NEW.geom,-100), d.geom) AND NEW.geom && d.geom
  );
  RETURN NEW;
END;
$function$
