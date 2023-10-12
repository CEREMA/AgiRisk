CREATE OR REPLACE FUNCTION public.__testoc3()
 RETURNS void
 LANGUAGE plpgsql
AS $function$

DECLARE 
	c integer;
	heure varchar;
	nom_terr varchar;

BEGIN
nom_terr='Vienne Clain';	
	IF NOT EXISTS (
		SELECT *
		FROM information_schema.tables
		WHERE table_name='oc3' AND table_schema='c_occupation_sol'
	)
	THEN 
		CREATE TABLE c_occupation_sol.oc3 AS
		SELECT 
			siret, id_bat, id_adr, similarity, dif_numero, numero_ban, adresse_ban, 
			numero_sirene, adresse_sirene, territoire, surf_bat, nb_bat, nb_etab, 
			surf_bat_etab, employes_haut_etab, employes_bas_etab 
		FROM public.oc3;
		ALTER TABLE c_occupation_sol.oc3 ADD COLUMN id serial;
		ALTER TABLE c_occupation_sol.oc3 ADD CONSTRAINT c_occupation_sol_oc3_pkey primary key (id);
	ELSE
		DELETE FROM c_occupation_sol.oc3 WHERE territoire=''||nom_terr||'';
	
	END IF;		
	
END;
$function$
;
