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

CREATE OR REPLACE FUNCTION public.__util_to_snake_case(text)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
BEGIN
	RETURN lower(unaccent(replace(replace(replace(replace(replace(replace(replace(replace($1,'''','_'),' - ','_'),'-','_'),' / ','_'),'/','_'),' ','_'),'+','plus'),'%','pct')));
END;
$function$
