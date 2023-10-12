SET client_encoding = 'UTF8';

CREATE OR REPLACE PROCEDURE public.__init_layer_styles()
 LANGUAGE plpgsql
AS $procedure$

-- Procédure SQL d'initialisation de la table layer_styles dans le schéma public
-- © Cerema / GT AgiRisk (auteur du script : Sébastien)
-- Dernière mise à jour du script le 31/03/2023 par Sébastien

-- Commande d'appel à cette procédure :
-- CALL public.__init_layer_styles();

BEGIN

	SET search_path TO public;

	RAISE NOTICE '';
	RAISE NOTICE '====== RAPPORT ======';
	RAISE NOTICE 'Initialisation de la table de définition des styles';

	RAISE NOTICE 'Création de la structure de table attributaire layer_styles';
	EXECUTE 'DROP TABLE IF EXISTS public.layer_styles CASCADE';
	EXECUTE 'CREATE TABLE public.layer_styles (
		id serial PRIMARY KEY,
		f_table_catalog varchar,
		f_table_schema varchar,
		f_table_name varchar,
		f_geometry_column varchar,
		stylename text,
		styleqml xml,
		stylesld xml,
		useasdefault boolean,
		description text,
		owner varchar,
		ui xml,
		update_time timestamp,
		type varchar)';
	RAISE NOTICE 'Création de la table layer_styles effectuée';

--	RAISE NOTICE 'Insertion des données dans la table layer_styles';
--	EXECUTE 'INSERT INTO layer_styles (..., ..., ...) VALUES (''...'', ''...'', ''...'');';

	RAISE NOTICE '====== FIN TRAITEMENT ======';
	RAISE NOTICE '[INFO] La table layer_styles a été initialisée dans le schéma public';
	RAISE NOTICE '';

END;
$procedure$
