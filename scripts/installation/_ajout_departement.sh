#!/bin/bash

echo "---------------------"
echo "Ajout d'un département"
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

echo "Saisir login (par défault admin_agirisk) :"
read user
user=${user:-admin_agirisk}

echo "Saisir mot de passe (par défault AdminRisk*) :"
read -s password
password=${password:-AdminRisk*}

echo "Saisir le numéro de département :"
read departement

echo "---------------------"
echo "Cette opération va importer tous les référentiels sur le département $departement !"
echo "Souhaitez-vous continuer ? [o/N]"
read c

if [[ $c == "o" ]]; then
	export PGPASSWORD=$password

	echo "Restauration des référentiels partitionnés par département"
	for ref_part in r_ban_plus.adresse_2023_d0$departement.sql r_ban_plus.lien_adresse_bati_2023_d0$departement.sql r_cerema_acb.logements_2022_d0$departement.sql r_cerema_acb.sous_sols_2022_d0$departement.sql r_fichiersfonciers.tup_2022_d0$departement.sql r_fichiersfonciers.local_2022_d0$departement.sql r_ign_bdtopo.batiment_2023_d0$departement.sql r_ign_bdtopo.commune_2023_d0$departement.sql r_ign_bdtopo.departement_2023_d0$departement.sql r_ign_bdtopo.epci_2023_d0$departement.sql r_ign_bdtopo.erp_2023_d0$departement.sql r_ign_bdtopo.troncon_de_route_2023_d0$departement.sql r_ign_bdtopo.troncon_de_voie_ferree_2023_d0$departement.sql r_ign_bdtopo.zone_de_vegetation_2023_d0$departement.sql r_ign_bdtopo.zone_d_activite_ou_d_interet_2023_d0$departement.sql r_ign_irisge.irisge_2023_d0$departement.sql r_ign_rpg.parcelles_graphiques_2021_d0$departement.sql r_insee_pop.filosofi_2017_d0$departement.sql r_rep_carto.hexag_100ha_d0$departement.sql r_rep_carto.hexag_10ha_d0$departement.sql r_rep_carto.hexag_1ha_d0$departement.sql r_rep_carto.hexag_50ha_d0$departement.sql r_rep_carto.hexag_5ha_d0$departement.sql r_insee_sirene.sirene_v3_2023_d0$departement.sql
	do
			echo "Restauration de $ref_part"
			psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "_dep/d$departement/$ref_part"
	done

	echo "Initialisation des index"
	psql -U admin_agirisk -d $bdd -q -h $host -p $port -f "../export_sql/__init_/_dep/__init_index_d0$departement.sql"

	echo "---------------------"
	echo "Ajout du département terminé"
fi
