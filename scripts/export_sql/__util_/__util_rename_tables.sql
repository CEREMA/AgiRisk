SET client_encoding = 'UTF8';

CREATE OR REPLACE PROCEDURE public.__util_rename_tables(IN nschema text)
 LANGUAGE plpgsql
AS $procedure$

-- Script permettant de renommer les tables d'un schéma (script à lancer schéma par schéma)

-- Paramètre d'entrée :
-- nschema = nom du schéma qui contient les tables à renommer

-- Exemple de commande d'appel à cette procédure :
-- CALL public.__util_rename_tables(p_indicateurs);

DECLARE
    tab text; -- nom de chaque table du schéma

BEGIN

    EXECUTE 'DROP TABLE IF EXISTS l_tables CASCADE;
    CREATE TEMP TABLE l_tables AS
    SELECT table_name
    FROM information_schema.tables
    WHERE table_schema = '''||nschema||'''';

    FOR tab IN SELECT * FROM l_tables

    LOOP

        EXECUTE 'ALTER TABLE '||nschema||'.'||tab||' RENAME TO '||tab||'_old_'||regexp_replace(to_char(current_date,'YYYYMMDD'),'_','','g');

        COMMIT;

    END LOOP;

END;
$procedure$
