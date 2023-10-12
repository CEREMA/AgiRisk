CREATE OR REPLACE FUNCTION public.__var_oc1_test(nom_ter text, an_bdtopo text)
 RETURNS void
 LANGUAGE plpgsql
AS $function$

-- Fonction SQL d'incrémentation de la table oc1 (bâtiments) dans le schéma c_occupation_sol
-- Copyright Cerema / GT AgiRisk

-- Exemple d'appel à cette fonction : SELECT public.__var_oc1('Jura', '2022');

DECLARE 
	c integer;
	heure varchar;
	heure2 varchar;

BEGIN
	heure = clock_timestamp();
	
	--************************************************************************
	-- Définition des schémas de travail
	--************************************************************************
	SET SEARCH_PATH TO c_general, c_phenomenes, c_occupation_sol, r_ign_bdtopo, public;
	
	RAISE NOTICE '';
    RAISE NOTICE '====== RAPPORT ======';
    RAISE NOTICE 'Calcul de la variable Oc1 (bâtiments) sur le territoire ''%''', nom_ter;
    RAISE NOTICE 'Début du traitement : %', heure;
	
    --************************************************************************
    -- Vérification de l'existence du territoire renseigné dans la table c_phenomenes.zt
    --************************************************************************
	IF NOT EXISTS (
		SELECT *
		FROM zt
		WHERE territoire = nom_ter
	)
	THEN
		RAISE EXCEPTION 'Il n''y a pas de territoire "%" dans la table c_phenomenes.zt. Fin de l''exécution.', nom_ter;
	END IF;
	
	EXECUTE 'DROP TABLE IF EXISTS public.temp222;';
	EXECUTE 'CREATE TABLE public.temp222 AS
		SELECT row_number() over() as id,
			ST_Buffer(geom,5) as geom
		FROM r_ign_bdtopo.batiment_2022_d017
		LIMIT 10000';			

	heure2 = clock_timestamp();
	RAISE NOTICE 'Fin de traitement : %', heure2;
	RAISE NOTICE 'Durée de traitement : %', CAST(heure2 as time)-CAST(heure as time);

END;
$function$
