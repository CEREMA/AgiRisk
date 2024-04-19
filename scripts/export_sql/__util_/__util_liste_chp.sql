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

CREATE OR REPLACE FUNCTION public.__util_liste_chp(couche text)
 RETURNS text
 LANGUAGE plpgsql
AS $function$

DECLARE
att text; -- variable qui prend le nom des champs non géométriques de la couche d'entrée
liste_chp text; -- liste des champs non géométriques de la couche d'entrée

begin

-- couche = couche dont on récupère la liste des champs non géométriques

EXECUTE 'DROP TABLE IF EXISTS attname CASCADE';
EXECUTE 'CREATE TEMP TABLE attname
AS SELECT pg_attribute.attname
FROM pg_class
JOIN pg_attribute ON pg_class.relname='''||couche||''' AND pg_attribute.attrelid=pg_class.oid AND attnum > 0
JOIN pg_type ON pg_type.oid=pg_attribute.atttypid
WHERE pg_type.typname !=''geometry''';

EXECUTE 'DROP TABLE IF EXISTS liste CASCADE';
EXECUTE 'CREATE TEMP TABLE liste (arr) AS VALUES (array[]:: varchar[])';

FOR att IN SELECT * FROM attname

LOOP

EXECUTE'
WITH tempa as
(
SELECT array_append(arr, '''||att||''') as arr
FROM liste
)
UPDATE liste
SET arr = tempa.arr
FROM tempa';

END LOOP;

EXECUTE 'SELECT array_to_string(arr, '','')
FROM liste'
INTO liste_chp;

RETURN liste_chp;

END;
$function$
