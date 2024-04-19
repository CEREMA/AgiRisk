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

CREATE OR REPLACE FUNCTION public.__util_subdivide(couche text, abrv_couche text, geom text)
 RETURNS void
 LANGUAGE plpgsql
AS $function$

-- Fonction SQL permettant de sous-diviser les objets d'une couche (pour optimisation des temps de calcul)

DECLARE chp text;

BEGIN

chp := __util_liste_chp(''||couche||'');

-- couche = couche géométrique à découper via un st_subdivide
-- abrv_couche = abréviation de la couche géométrique à découper via un st_subdivide
-- geom = nom du champ géométrique

-- 0.6.1 Optimisation des couches à sous-découper et nettoyage des géométries
--------

--EXECUTE 'CREATE INDEX IF NOT EXISTS ON '||couche||' USING gist('||geom||')';
EXECUTE 'UPDATE '||couche||' SET '||geom||'=ST_Multi(ST_CollectionExtract(ST_ForceCollection(ST_MakeValid('||geom||')),3))';

-- 0.6.2 Sous-découpage des couches
--------

EXECUTE 'DROP TABLE IF EXISTS l_subdivide_'||abrv_couche||'';
EXECUTE 'CREATE TEMP TABLE l_subdivide_'||abrv_couche||' AS
SELECT '||chp||', ST_Multi(ST_CollectionExtract(ST_ForceCollection(ST_MakeValid(ST_Subdivide('||geom||'))),3))::geometry (MultiPolygon,2154) as geom
FROM '||couche||'';

-- 0.6.3 Optimisation des couches sous-découpées et nettoyage des géométries
--------
EXECUTE 'CREATE INDEX ON l_subdivide_'||abrv_couche||' USING gist('||geom||')';

END;
$function$
