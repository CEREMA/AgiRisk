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
set "defaultInputLogin=admin_agirisk"
if "%InputLogin%"=="" set /p "InputLogin=Saisir login (Default "%defaultInputLogin%"): " || set "InputLogin=%defaultInputLogin%"
echo %InputLogin%

set "InputPwd=%1"
set "defaultInputPwd=AdminRisk*"
if "%InputPwd%"=="" set /p "InputPwd=Saisir mot de passe (Default "%defaultInputPwd%"): " || set "InputPwd=%defaultInputPwd%"
echo %InputPwd%

set /p InputDept=Saisir le numero du departement : 
echo %InputDept%

echo Cette operation va importer tous les referentiels sur le departement %InputDept% !! (la base doit être présente)
Set /p "string=voulez-vous continuer o/n :  "

If %string%==o (							  
	SET PGPASSWORD=AdminRisk*
	
	for %%x in (r_ban_plus.adresse_2023_d0%InputDept%.sql r_ban_plus.lien_adresse_bati_2023_d0%InputDept%.sql r_cerema_acb.logements_2022_d0%InputDept%.sql r_cerema_acb.sous_sols_2022_d0%InputDept%.sql r_fichiersfonciers.tup_2022_d0%InputDept%.sql r_fichiersfonciers.local_2022_d0%InputDept%.sql r_ign_bdtopo.batiment_2023_d0%InputDept%.sql r_ign_bdtopo.commune_2023_d0%InputDept%.sql r_ign_bdtopo.departement_2023_d0%InputDept%.sql r_ign_bdtopo.epci_2023_d0%InputDept%.sql r_ign_bdtopo.erp_2023_d0%InputDept%.sql r_ign_bdtopo.troncon_de_route_2023_d0%InputDept%.sql r_ign_bdtopo.troncon_de_voie_ferree_2023_d0%InputDept%.sql r_ign_bdtopo.zone_de_vegetation_2023_d0%InputDept%.sql r_ign_bdtopo.zone_d_activite_ou_d_interet_2023_d0%InputDept%.sql r_ign_irisge.irisge_2023_d0%InputDept%.sql r_ign_rpg.parcelles_graphiques_2021_d0%InputDept%.sql r_insee_pop.filosofi_2017_d0%InputDept%.sql r_rep_carto.hexag_100ha_d0%InputDept%.sql r_rep_carto.hexag_10ha_d0%InputDept%.sql r_rep_carto.hexag_1ha_d0%InputDept%.sql r_rep_carto.hexag_50ha_d0%InputDept%.sql r_rep_carto.hexag_5ha_d0%InputDept%.sql r_insee_sirene.sirene_v3_2023_d0%InputDept%.sql r_ign_gpu.zonage_urbanisme_2023_d0%InputDept%.sql) do (
		echo %%x
		psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "_dep\d%InputDept%\%%x"
	)

	rem initialisation des index
	echo Initialisation des index
	psql -U admin_agirisk -d %InputBdd% -q -h %InputServ% -p %InputPort% -f "..\export_sql\__init_\_dep\__init_index_d0%InputDept%.sql"
)
echo installation terminee
pause
