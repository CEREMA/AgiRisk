#!/bin/bash

echo "---------------------"
echo "Installation de la base AgiRisk"
echo "---------------------"

echo "Saisir adresse IP serveur (par défault 127.0.0.1) :"
read host
host=${host:-127.0.0.1}

echo "Saisir port (par défault 5432) :"
read port
port=${port:-5432}

echo "Saisir nom base (par défault agirisk_v1) :"
read bdd
bdd=${bdd:-agirisk_v1}

echo "Saisir login (par défault postgres) :"
read user
user=${user:-postgres}

echo "Saisir mot de passe (par défault postgres) :"
read -s password
password=${password:-postgres}

echo "Saisir le numéro de département :"
read departement

echo "---------------------"
echo "Cette operation va créer la base $bdd (qui sera supprimée si elle existe) et importer tous les referentiels sur le departement $departement !!"
echo "Souhaitez-vous continuer ? [o/N]"
read c

if [[ $c == "o" ]]; then

	echo "Suppression des connexions à la base de données"
	export PGPASSWORD=$password
	psql -h $host -p $port -U $user  -c "SELECT pg_terminate_backend(pg_stat_activity.pid) FROM pg_stat_activity WHERE pg_stat_activity.datname = '$bdd';" -d postgres

	
	echo "Restauration de la base vierge"
	psql -h $host -p $port -U $user  -f "_commun/_agirisk_v1.sql" -d postgres -v nom_base=$bdd
	export PGPASSWORD=AdminRisk*
	
	echo "Initialisation des séquences des tables logements et sous-sols"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "_commun/sequences_r_cerema_acb.sql"

	echo "Initialisation des sequences de la table zh"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "_commun/sequence_zh.sql"

	echo "Restauration des référentiels partitionnés par département"
	for ref_part in r_ban_plus.adresse_2023_d0$departement.sql r_ban_plus.lien_adresse_bati_2023_d0$departement.sql r_cerema_acb.logements_2022_d0$departement.sql r_cerema_acb.sous_sols_2022_d0$departement.sql r_fichiersfonciers.tup_2022_d0$departement.sql r_fichiersfonciers.local_2022_d0$departement.sql r_ign_bdtopo.batiment_2023_d0$departement.sql r_ign_bdtopo.commune_2023_d0$departement.sql r_ign_bdtopo.departement_2023_d0$departement.sql r_ign_bdtopo.epci_2023_d0$departement.sql r_ign_bdtopo.erp_2023_d0$departement.sql r_ign_bdtopo.troncon_de_route_2023_d0$departement.sql r_ign_bdtopo.troncon_de_voie_ferree_2023_d0$departement.sql r_ign_bdtopo.zone_de_vegetation_2023_d0$departement.sql r_ign_bdtopo.zone_d_activite_ou_d_interet_2023_d0$departement.sql r_ign_irisge.irisge_2023_d0$departement.sql r_ign_rpg.parcelles_graphiques_2021_d0$departement.sql r_insee_pop.filosofi_2017_d0$departement.sql r_rep_carto.hexag_100ha_d0$departement.sql r_rep_carto.hexag_10ha_d0$departement.sql r_rep_carto.hexag_1ha_d0$departement.sql r_rep_carto.hexag_50ha_d0$departement.sql r_rep_carto.hexag_5ha_d0$departement.sql r_insee_sirene.sirene_v3_2023_d0$departement.sql
	do 
		echo "Restauration de $ref_part"
		psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "_dep/d$departement/$ref_part"
	done


	echo "Restauration des référentiels france entière"
	for ref_france in r_atoutfrance r_geodatamine r_gouv_gaspar r_ign_gpu r_inrae_amc r_osm r_ressources r_sandre_bdtopage r_inao
	do
		echo "Restauration de $ref_france"
		psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "_commun/$ref_france.sql"
	done
	
	echo "Restauration des fonctions et procédures agirisk"
	echo "Restauration des fonctions __util_"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__util_/__util_alim_numdept_terr.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__util_/__util_alim_zx.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__util_/__util_alim_zx_fct.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__util_/__util_create_geomloc.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__util_/__util_create_index_concurrently.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__util_/__util_drop_index.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__util_/__util_iris2com_epci.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__util_/__util_iris_dep.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__util_/__util_liste_chp.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__util_/__util_lower_fields.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__util_/__util_partition_activite_bdtopo.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__util_/__util_partition_adresse_banplus.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__util_/__util_partition_adresse_bdtopo.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__util_/__util_partition_batiment_bdtopo.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__util_/__util_partition_commune_bdtopo.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__util_/__util_partition_departement_bdtopo.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__util_/__util_partition_epci_bdtopo.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__util_/__util_partition_erp_bdtopo.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__util_/__util_partition_ferree_bdtopo.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__util_/__util_partition_ff.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__util_/__util_partition_ff_tup.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__util_/__util_partition_filosofi.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__util_/__util_partition_geosirene_v3.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__util_/__util_partition_hexag.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__util_/__util_partition_lien_adresse_bati_banplus.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__util_/__util_partition_logements_acb.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__util_/__util_partition_route_bdtopo.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__util_/__util_partition_rpg.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__util_/__util_partition_sous_sols_acb.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__util_/__util_partition_vegetation_bdtopo.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__util_/__util_quote_to_double_quote.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__util_/__util_quote_to_underscore.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__util_/__util_rename_tables.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__util_/__util_subdivide.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__util_/__util_to_snake_case.sql"

	echo "Restauration des fonctions __init_"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__init_/__init_db.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__init_/__init_layer_styles.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__init_/__init_logt_zx.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__init_/__init_logt_zx_rc.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__init_/__init_oc0.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__init_/__init_oc1.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__init_/__init_oc11.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__init_/__init_oc2_amc.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__init_/__init_oc3.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__init_/__init_oc5.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__init_/__init_oc7.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__init_/__init_pop_agee_zx.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__init_/__init_pop_agee_zx_rc.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__init_/__init_s1_2a.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__init_/__init_s1_2a_rc.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__init_/__init_s1_2b.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__init_/__init_s1_2b_rc.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__init_/__init_s2_14a.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__init_/__init_s2_14a_rc.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__init_/__init_s2_2a_amc.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__init_/__init_s2_2a_amc_rc.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__init_/__init_s2_6a.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__init_/__init_s2_6a_rc.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__init_/__init_s3_1a.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__init_/__init_s3_1a_rc.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__init_/__init_s3_1f.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__init_/__init_s3_1f_rc.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__init_/__init_s3_2b.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__init_/__init_s3_2b_rc.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__init_/__init_salaries_zx.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__init_/__init_salaries_zx_rc.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__init_/__init_territoires.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__init_/__init_zf.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__init_/__init_zh.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__init_/__init_zp.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__init_/__init_zq.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__init_/__init_zt.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__init_/__init_zv.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__init_/__init_zx.sql"

	echo "Restauration des fonctions __var_"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__var_/__var_all.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__var_/__var_all_fct.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__var_/__var_oc0.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__var_/__var_oc11.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__var_/__var_oc1_geom.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__var_/__var_oc1_geomloc.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__var_/__var_oc2_amc.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__var_/__var_oc3.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__var_/__var_oc5.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__var_/__var_oc7.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__var_/__var_pop1.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__var_/__var_pop5.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__var_/__var_zq.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__var_/__var_zt.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__var_/__var_zx.sql"

	echo "Restauration des fonctions __indic_"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__indic_/__indic_all.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__indic_/__indic_all_fct.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__indic_/__indic_logt_zx.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__indic_/__indic_logt_zx_rc.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__indic_/__indic_pop_agee_zx.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__indic_/__indic_pop_agee_zx_rc.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__indic_/__indic_rc_all.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__indic_/__indic_rc_all_fct.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__indic_/__indic_s1_2a.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__indic_/__indic_s1_2a_rc.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__indic_/__indic_s1_2b.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__indic_/__indic_s1_2b_rc.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__indic_/__indic_s2_14a.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__indic_/__indic_s2_14a_rc.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__indic_/__indic_s2_2a_amc.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__indic_/__indic_s2_2a_amc_rc.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__indic_/__indic_s2_6a.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__indic_/__indic_s2_6a_rc.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__indic_/__indic_s3_1a.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__indic_/__indic_s3_1a_rc.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__indic_/__indic_s3_1f.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__indic_/__indic_s3_1f_rc.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__indic_/__indic_s3_2b.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__indic_/__indic_s3_2b_rc.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__indic_/__indic_salaries_zx.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__indic_/__indic_salaries_zx_rc.sql"
	
	echo "Initialisation des tables variables phenomene zt, zq et zx"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -c "call __init_zt();"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -c "call __init_zq();"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -c "call __init_zx();"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -c "call __init_zh();"	
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -c "call __init_zp();"	
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -c "call __init_zf();"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -c "call __init_zv();"		

	echo "Initialisation du reste de la base de données"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -c "call __init_db();"

	echo "Initialisation des index"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__init_/__init_index.sql"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__init_/_dep/__init_index_d0$departement.sql"

	echo "---------------------"
	echo "Installation de la base AgiRisk terminée"
fi

