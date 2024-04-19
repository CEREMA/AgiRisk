--***************************************************************************
--        Fonction de la base de données du projet AgiRisk
--        begin                : 2022-04-06
--        copyright            : (C) 2023 by Cerema
--        email                : agirisk@cerema.fr
--***************************************************************************/

--/***************************************************************************
--*                                                                         *
--*   Ce programme est un logiciel libre, distribué selon les termes de la  *
--*   licence CeCILL v2.1 disponible à l'adresse suivante :                 *
--*   http://www.cecill.info/licences/Licence_CeCILL_V2.1-fr.html           *
--*   ou toute autre version ultérieure.                                    *
--*                                                                         *
--/***************************************************************************/

SET client_encoding = 'UTF8';

CREATE OR REPLACE FUNCTION public.__util_lower_fields(nschema text, ntable text)
 RETURNS void
 LANGUAGE plpgsql
AS $function$

    DECLARE
    r text;

    BEGIN

    EXECUTE 'DROP TABLE IF EXISTS rename_column CASCADE';
    EXECUTE 'CREATE TEMP TABLE rename_column AS
    SELECT  ''ALTER TABLE '' || quote_ident(c.table_schema) || ''.''
    || quote_ident(c.table_name) || '' RENAME "'' || c.column_name || ''" TO '' || quote_ident(lower(c.column_name)) || '';'' As ddlsql
    FROM information_schema.columns As c
    WHERE c.table_schema = '''||nschema||'''
            AND c.table_name = '''||ntable||'''
            AND c.column_name <> lower(c.column_name)
    ORDER BY c.table_schema, c.table_name, c.column_name';
    
    FOR r IN SELECT * FROM rename_column

        LOOP
    
        EXECUTE ''||r||'';
    
        END LOOP;

    END;
    $function$
