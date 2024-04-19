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

CREATE OR REPLACE FUNCTION public.__util_alim_zx_fct(nom_ter text)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
begin
	execute '	
		delete from c_phenomenes.zx where territoire = ''' || nom_ter || '''
	';	
	execute '
		insert into c_phenomenes.zx(territoire, occurrence, code_occurrence, type_alea, geom) 
		select territoire, occurrence, code_occurrence, type_alea, st_multi(st_union(geom))
		from c_phenomenes.zq
		where territoire = ''' || nom_ter || '''
		group by territoire, occurrence, code_occurrence, type_alea
	';
end;
$function$
