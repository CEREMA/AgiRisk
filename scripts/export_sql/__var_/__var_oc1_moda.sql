SET client_encoding = 'UTF8';

CREATE OR REPLACE FUNCTION public.__var_oc1_moda()
 RETURNS void
 LANGUAGE plpgsql
AS $function$

-- Fonction SQL créant la table des différentes modalités de calcul d'Oc1 (combinaison de différentes modalités de calcul de plusieurs variables)
-- © Cerema / GT AgiRisk (auteure du script : Lucie)
-- Dernière mise à jour du script le 31/03/2023 par Sébastien

-- Appel à cette fonction : SELECT public.__var_oc1_moda();

BEGIN

	DROP TABLE IF EXISTS c_occupation_sol.oc1_moda CASCADE;
	CREATE TABLE c_occupation_sol.oc1_moda (code_moda, ordre_exec, fonction) AS VALUES
		('m1'::varchar(10), 1::integer, '__var_oc1'::varchar(100)),
		('m1'::varchar(10), 2::integer, '__var_oc2_amc'),
		('m1'::varchar(10), 3::integer, '__var_oc3'),
		('m1'::varchar(10), 4::integer, '__var_pop1'),
		('m1'::varchar(10), 5::integer, '__var_pop5'),
		
		('m2'::varchar(10), 1::integer, '__var_oc1'),
		('m2'::varchar(10), 2::integer, '__var_oc2_ref'),
		('m2'::varchar(10), 3::integer, '__var_oc3'),
		('m2'::varchar(10), 4::integer, '__var_pop1'),
		('m2'::varchar(10), 5::integer, '__var_pop5');
	
	CREATE INDEX ON c_occupation_sol.oc1_moda USING btree(code_moda);
	CREATE INDEX ON c_occupation_sol.oc1_moda USING btree(ordre_exec);
	CREATE INDEX ON c_occupation_sol.oc1_moda USING btree(fonction);

END;
$function$
