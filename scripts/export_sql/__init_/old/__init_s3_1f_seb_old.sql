CREATE OR REPLACE PROCEDURE public.__init_s3_1f_seb_old()
 LANGUAGE plpgsql
AS $procedure$
begin

	raise notice '';
	raise notice '======	Initialisation de S3/1f		======';

	drop table if exists p_indicateurs.s3_1f cascade;
	create table p_indicateurs.s3_1f (
		id serial primary key,
		territoire varchar(200),
		type_culture varchar(200),
		surface_agricole_inondable_ha float,
		date_calcul date,
		geom geometry (MultiPolygon,2154)
	); 
	raise notice 'Création de la table s3_1f effectuée';
	raise notice '';

end $procedure$
;
