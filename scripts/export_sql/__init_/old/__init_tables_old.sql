CREATE OR REPLACE FUNCTION public.__init_tables_old(an_oc1 text)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE
nom_chp_oc1 text; -- variable qui prend le nom du champ n à ajouter à la table oc1
type_chp_oc1 text; -- variable qui prend le type du champ n à ajouter à la table oc1
req_oc1 text; -- variable d'exécution des commentaires de champs sur la table oc1

BEGIN

-- Section territoire d'étude
-- On vérifie si la table c_general.territoires existe
IF EXISTS (SELECT 1
		  FROM information_schema.tables
		  WHERE table_schema = 'c_general'
		  AND table_name = 'territoires'
		)
THEN
	-- Si elle existe effectivement, on renvoie le message ci-dessous
	RAISE NOTICE 'La table c_general.territoires existe déjà. Pour la supprimer, lancer la requête suivante : DROP TABLE c_general.territoires CASCADE;';
	
ELSE
	-- Si la table c_general.territoires n'existe pas, on renvoie le message suivant
	RAISE NOTICE 'La table c_general.territoires n''existe pas. Création de la table en cours.';
	-- Et on la crée
	EXECUTE 'CREATE TABLE c_general.territoires';
	-- Puis on ajoute les champs utiles au calcul des indicateurs
	EXECUTE 'ALTER TABLE c_general.territoires
			 ADD COLUMN id INTEGER
			 ADD COLUMN territoire varchar(50)
			 ADD COLUMN geom geometry(multipolygon,2154), 
			 CONSTRAINT terr_pkey PRIMARY KEY (id)';
END IF;

COMMENT ON COLUMN c_general.territoires.territoire IS 'Nom du territoire d''étude.';


-- Section oc1
-- On vérifie si la table c_occupation_sol.oc1 existe
IF EXISTS (SELECT 1
		  FROM information_schema.tables
		  WHERE table_schema = 'c_occupation_sol'
		  AND table_name = 'oc1'
		)
THEN
	-- Si elle existe effectivement, on renvoie le message ci-dessous
	RAISE NOTICE 'La table c_occupation_sol.oc1 existe déjà. Pour la supprimer, lancer la requête suivante : DROP TABLE c_occupation_sol.oc1 CASCADE;';
	
ELSE
	-- Si la table c_occupation_sol.oc1 n'existe pas, on renvoie le message suivant
	RAISE NOTICE 'La table c_occupation_sol.oc1 n''existe pas. Création de la table en cours, ainsi que de tous les champs utiles au calcul des indicateurs.';
	-- Et on la crée
	EXECUTE 'CREATE TABLE c_occupation_sol.oc1 (LIKE r_ign_bdtopo.batiment_'||an_oc1||' INCLUDING ALL)';
	-- Puis on ajoute les champs utiles au calcul des indicateurs
	EXECUTE 'ALTER TABLE c_occupation_sol.oc1
			 ADD COLUMN territoire varchar(50),
			 ADD COLUMN date_donnee date,
			 ADD COLUMN date_calcul date,
			 ADD COLUMN plainpied boolean,
		     ADD COLUMN nombre_d_etages integer,
			 ADD COLUMN haut_modif double precision,
			 ADD COLUMN idtup varchar(50),
			 ADD COLUMN oc2 boolean,
			 ADD COLUMN oc3 boolean,
			 ADD COLUMN pop1 double precision,
			 ADD COLUMN pop2 double precision,
			 ADD COLUMN pop3 double precision,
			 ADD COLUMN pop4 double precision,
			 ADD COLUMN pop5 double precision,
			 ADD COLUMN pop6 double precision';
		
END IF;

COMMENT ON TABLE c_occupation_sol.oc1 IS 'Couche des bâtiments.';
COMMENT ON COLUMN c_occupation_sol.oc1.territoire IS 'Nom du territoire d''étude.';
COMMENT ON COLUMN c_occupation_sol.oc1.date_donnee IS 'Date de la donnée qui a permis de constituer la couche.';
COMMENT ON COLUMN c_occupation_sol.oc1.date_calcul IS 'Date de création de la couche.';
COMMENT ON COLUMN c_occupation_sol.oc1.plainpied IS 'Indique si le bâtiment est a priori de plain-pied ou non.';
COMMENT ON COLUMN c_occupation_sol.oc1.nombre_d_etages IS 'Nombre d''étages obtenu à partir de la BDTOPOv3 lorsqu''elle est renseignée. Lorsqu''elle ne l''est pas, division de la hauteur (haut_modif) par 3 si le bâtiment est concerné par des locaux d''habitation, par 5 pour le reste des bâtiments.';
COMMENT ON COLUMN c_occupation_sol.oc1.haut_modif IS 'Hauteur du bâtiment issue de la BDTOPOv3 lorsqu''elle est renseignée. Lorsqu''elle ne l''est pas, 3m si le bâtiment est concerné par des locaux d''habitation, sinon 5m.';
COMMENT ON COLUMN c_occupation_sol.oc1.idtup IS 'Identifiant de parcelle dans laquelle se situe le bâtiment (issu de la TUP des Fichiers Fonciers).';
COMMENT ON COLUMN c_occupation_sol.oc1.oc2 IS 'Indique si oui ou non le bâtiment est concerné par des locaux d''habitation. Champ booléen.';
COMMENT ON COLUMN c_occupation_sol.oc1.oc3 IS 'Indique sur oui ou non le bâtiment est concerné par des locaux d''activité.';
COMMENT ON COLUMN c_occupation_sol.oc1.pop1 IS 'Nombre de résidents permanents à l''intérieur du bâtiment.';
COMMENT ON COLUMN c_occupation_sol.oc1.pop2 IS 'Nombre de salariés à l''intérieur du bâtiment.';
COMMENT ON COLUMN c_occupation_sol.oc1.pop3 IS 'Nombre de personnes sensibles à l''intérieur du bâtiment.';
COMMENT ON COLUMN c_occupation_sol.oc1.pop4 IS 'Nombre de personnes en zone de forte concentration à l''intérieur du bâtiment.';
COMMENT ON COLUMN c_occupation_sol.oc1.pop5 IS 'Nombre de résidents saisonniers à l''intérieur du bâtiment.';
COMMENT ON COLUMN c_occupation_sol.oc1.pop6 IS 'Nombre total d''occupants à l''intérieur du bâtiment.';

END;
$function$
;
