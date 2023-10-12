@echo off
path=%path%;C:\Program Files\PostgreSQL\15\bin

set "InputServ=%1"
set "defaultInputServ=127.0.0.1"
if "%InputServ%"=="" set /p "InputServ=Saisir adresse IP serveur (Default "%defaultInputServ%"): " || set "InputServ=%defaultInputServ%"
echo %InputServ%

set "InputPort=%1"
set "defaultInputPort=5432"
if "%InputPort%"=="" set /p "InputPort=Saisir port (Default "%defaultInputPort%"): " || set "InputPort=%defaultInputPort%"
echo %InputPort%

set "InputBdd=%1"
set "defaultInputBdd=agirisk_v1"
if "%InputBdd%"=="" set /p "InputBdd=Saisir nom base (Default "%defaultInputBdd%"): " || set "InputBdd=%defaultInputBdd%"
echo %InputBdd%

set "InputLogin=%1"
set "defaultInputLogin=postgres"
if "%InputLogin%"=="" set /p "InputLogin=Saisir login (Default "%defaultInputLogin%"): " || set "InputLogin=%defaultInputLogin%"
echo %InputLogin%

set "InputPwd=%1"
set "defaultInputPwd=postgres"
if "%InputPwd%"=="" set /p "InputPwd=Saisir mot de passe (Default "%defaultInputPwd%"): " || set "InputPwd=%defaultInputPwd%"
echo %InputPwd%

set /p InputDept=Saisir le numero du departement : 
echo %InputDept%

echo Cette operation va creer la base %InputBdd% (qui sera supprimee si elle existe) et importer tous les referentiels sur le departement %InputDept% !!
Set /p "string=voulez-vous continuer o/n :  "

If %string%==o (							  
	SET PGPASSWORD=%InputPwd%
	psql -h %InputServ% -p %InputPort% -U %InputLogin%  -c "SELECT pg_terminate_backend(pg_stat_activity.pid) FROM pg_stat_activity WHERE pg_stat_activity.datname = '%InputBdd%';" -d postgres

	
	rem restauration de la base "vierge"
	psql -h %InputServ% -p %InputPort% -U %InputLogin%  -d postgres -f "_commun\_agirisk_v1.sql" -v nom_base=%InputBdd% 
	SET PGPASSWORD=AdminRisk*
	
	rem initialisation des sequences des tables logements et soussols
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "_commun\sequences_r_cerema_acb.sql"
	rem initialisation des sequences de la table zh
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "_commun\sequence_zh.sql"

	rem restauration des référentiels partitionnés par département
	
	for %%x in (r_ban_plus.adresse_2023_d0%InputDept%.sql r_ban_plus.lien_adresse_bati_2023_d0%InputDept%.sql r_cerema_acb.logements_2022_d0%InputDept%.sql r_cerema_acb.sous_sols_2022_d0%InputDept%.sql r_fichiersfonciers.tup_2022_d0%InputDept%.sql r_fichiersfonciers.local_2022_d0%InputDept%.sql r_ign_bdtopo.batiment_2023_d0%InputDept%.sql r_ign_bdtopo.commune_2023_d0%InputDept%.sql r_ign_bdtopo.departement_2023_d0%InputDept%.sql r_ign_bdtopo.epci_2023_d0%InputDept%.sql r_ign_bdtopo.erp_2023_d0%InputDept%.sql r_ign_bdtopo.troncon_de_route_2023_d0%InputDept%.sql r_ign_bdtopo.troncon_de_voie_ferree_2023_d0%InputDept%.sql r_ign_bdtopo.zone_de_vegetation_2023_d0%InputDept%.sql r_ign_bdtopo.zone_d_activite_ou_d_interet_2023_d0%InputDept%.sql r_ign_irisge.irisge_2023_d0%InputDept%.sql r_ign_rpg.parcelles_graphiques_2021_d0%InputDept%.sql r_insee_pop.filosofi_2017_d0%InputDept%.sql r_rep_carto.hexag_100ha_d0%InputDept%.sql r_rep_carto.hexag_10ha_d0%InputDept%.sql r_rep_carto.hexag_1ha_d0%InputDept%.sql r_rep_carto.hexag_50ha_d0%InputDept%.sql r_rep_carto.hexag_5ha_d0%InputDept%.sql r_insee_sirene.sirene_v3_2023_d0%InputDept%.sql r_ign_gpu.zonage_urbanisme_2023_d0%InputDept%.sql) do (
		echo %%x
		psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "_dep\d%InputDept%\%%x"
	)


	rem restauration des référentiels france entière
	for %%y in (r_atoutfrance r_geodatamine r_gouv_gaspar r_inrae_amc r_osm r_ressources r_sandre_bdtopage r_inao) do (
		echo %%y
		psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "_commun\%%y.sql"
	)
	
	rem restauration des fonctions et procédures agirisk

	rem util
	echo Restauration des fonctions __util_
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__util_\__util_alim_numdept_terr.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__util_\__util_alim_zx.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__util_\__util_alim_zx_fct.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__util_\__util_create_geomloc.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__util_\__util_create_index_concurrently.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__util_\__util_drop_index.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__util_\__util_iris2com_epci.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__util_\__util_iris_dep.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__util_\__util_liste_chp.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__util_\__util_lower_fields.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__util_\__util_partition_activite_bdtopo.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__util_\__util_partition_adresse_banplus.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__util_\__util_partition_adresse_bdtopo.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__util_\__util_partition_batiment_bdtopo.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__util_\__util_partition_commune_bdtopo.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__util_\__util_partition_departement_bdtopo.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__util_\__util_partition_epci_bdtopo.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__util_\__util_partition_erp_bdtopo.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__util_\__util_partition_ferree_bdtopo.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__util_\__util_partition_ff.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__util_\__util_partition_ff_tup.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__util_\__util_partition_filosofi.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__util_\__util_partition_geosirene_v3.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__util_\__util_partition_hexag.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__util_\__util_partition_lien_adresse_bati_banplus.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__util_\__util_partition_logements_acb.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__util_\__util_partition_route_bdtopo.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__util_\__util_partition_rpg.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__util_\__util_partition_sous_sols_acb.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__util_\__util_partition_vegetation_bdtopo.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__util_\__util_partition_gpu.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__util_\__util_quote_to_double_quote.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__util_\__util_quote_to_underscore.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__util_\__util_rename_tables.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__util_\__util_subdivide.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__util_\__util_to_snake_case.sql"

	rem _init
	echo Restauration des fonctions __init_
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__init_\__init_db.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__init_\__init_layer_styles.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__init_\__init_logt_zx.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__init_\__init_logt_zx_rc.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__init_\__init_oc0.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__init_\__init_oc1.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__init_\__init_oc11.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__init_\__init_oc2_amc.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__init_\__init_oc3.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__init_\__init_oc5.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__init_\__init_oc7.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__init_\__init_pop_agee_zx.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__init_\__init_pop_agee_zx_rc.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__init_\__init_s1_2a.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__init_\__init_s1_2a_rc.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__init_\__init_s1_2b.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__init_\__init_s1_2b_rc.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__init_\__init_s2_14a.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__init_\__init_s2_14a_rc.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__init_\__init_s2_2a_amc.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__init_\__init_s2_2a_amc_rc.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__init_\__init_s2_6a.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__init_\__init_s2_6a_rc.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__init_\__init_s3_1a.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__init_\__init_s3_1a_rc.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__init_\__init_s3_1f.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__init_\__init_s3_1f_rc.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__init_\__init_s3_2b.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__init_\__init_s3_2b_rc.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__init_\__init_salaries_zx.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__init_\__init_salaries_zx_rc.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__init_\__init_territoires.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__init_\__init_zf.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__init_\__init_zh.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__init_\__init_zp.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__init_\__init_zq.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__init_\__init_zt.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__init_\__init_zv.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__init_\__init_zx.sql"

	rem var
	echo Restauration des fonctions __var_
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__var_\__var_all.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__var_\__var_all_fct.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__var_\__var_oc0.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__var_\__var_oc11.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__var_\__var_oc1_geom.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__var_\__var_oc1_geomloc.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__var_\__var_oc1_moda.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__var_\__var_oc2_amc.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__var_\__var_oc3.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__var_\__var_oc5.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__var_\__var_oc7.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__var_\__var_pop1.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__var_\__var_pop5.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__var_\__var_zq.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__var_\__var_zt.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__var_\__var_zx.sql"

	rem indic
	echo Restauration des fonctions __indic_
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__indic_\__indic_all.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__indic_\__indic_all_fct.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__indic_\__indic_logt_zx.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__indic_\__indic_logt_zx_rc.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__indic_\__indic_pop_agee_zx.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__indic_\__indic_pop_agee_zx_rc.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__indic_\__indic_rc_all.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__indic_\__indic_rc_all_fct.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__indic_\__indic_s1_2a.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__indic_\__indic_s1_2a_rc.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__indic_\__indic_s1_2b.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__indic_\__indic_s1_2b_rc.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__indic_\__indic_s2_14a.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__indic_\__indic_s2_14a_rc.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__indic_\__indic_s2_2a_amc.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__indic_\__indic_s2_2a_amc_rc.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__indic_\__indic_s2_6a.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__indic_\__indic_s2_6a_rc.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__indic_\__indic_s3_1a.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__indic_\__indic_s3_1a_rc.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__indic_\__indic_s3_1f.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__indic_\__indic_s3_1f_rc.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__indic_\__indic_s3_2b.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__indic_\__indic_s3_2b_rc.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__indic_\__indic_salaries_zx.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__indic_\__indic_salaries_zx_rc.sql"
	
	rem initialisation des tables variables phenomene zt, zq et zx
	echo Initialisation des tables variables phenomene zt, zq et zx
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -c "call __init_zt();"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -c "call __init_zq();"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -c "call __init_zx();"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -c "call __init_zh();"	
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -c "call __init_zp();"	
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -c "call __init_zf();"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -c "call __init_zv();"		

	rem initialisation des tables variables
	echo Initialisation du reste de la base de données
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -c "call __init_db();"

	rem initialisation des index
	echo Initialisation des index
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__init_\__init_index.sql"
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__init_\_dep\__init_index_d0%InputDept%.sql"
	
)
echo installation terminee
pause
