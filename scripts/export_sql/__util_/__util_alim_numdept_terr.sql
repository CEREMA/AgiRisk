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
