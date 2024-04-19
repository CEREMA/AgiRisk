"""
/***************************************************************************
        Plugin du projet AgiRisk
        begin                : 2022-04-06
        copyright            : (C) 2023 by Cerema
        email                : agirisk@cerema.fr
 ***************************************************************************/

/***************************************************************************
 *                                                                         *
 *   Ce programme est un logiciel libre, distribué selon les termes de la  *
 *   licence CeCILL v2.1 disponible à l'adresse suivante :                 *
 *   http://www.cecill.info/licences/Licence_CeCILL_V2.1-fr.html           *
 *   ou toute autre version ultérieure.                                    *
 *                                                                         *
 ***************************************************************************/
"""

import os
import csv
import psycopg2
import psycopg2.extras


with open(os.path.join(os.path.dirname(__file__),"Type_result_niv_zoom.csv"), 'r', encoding="UTF-8") as f:
    # En-tête de la procédure SQL
    code_proc = "CREATE OR REPLACE PROCEDURE public.__init_niv_zoom()\n"
    code_proc += " LANGUAGE plpgsql\n"
    code_proc += "AS $$\n"

    code_proc += "-- Procédure SQL d'initialisation de la table niv_zoom (niveaux de zoom à afficher selon chaque indicateur) dans le schéma r_ressources\n"
    code_proc += "-- Copyright Cerema / GT AgiRisk\n"
    code_proc += "-- Commande d'appel à cette procédure : CALL public.__init_niv_zoom();\n"
    code_proc += "BEGIN\n"

    code_proc += "\tSET search_path TO r_ressources, public;\n"
	
    code_proc += "\tRAISE NOTICE '';\n"
    code_proc += "\tRAISE NOTICE '====== RAPPORT ======';\n"
    code_proc += "\tRAISE NOTICE 'Initialisation de la table de définition des niveaux de zoom à afficher selon chaque indicateur';\n"
	
    code_proc += "\tRAISE NOTICE 'Création de la structure de table attributaire niv_zoom';\n"

    code_proc += "\tEXECUTE 'DROP TABLE IF EXISTS niv_zoom CASCADE';\n"
    code_proc += "\tEXECUTE 'CREATE TABLE niv_zoom (\n"
    code_proc += "\t\tid serial primary key,\n"
    code_proc += "\t\tcode_indic varchar(50),\n"
    code_proc += "\t\tniv_zoom integer DEFAULT 0,\n"
    code_proc += "\t\ttype_result varchar(50))';\n"
    
    code_proc += "\tRAISE NOTICE 'Création de la table niv_zoom effectuée';\n"

    code_proc += "\tRAISE NOTICE 'Insertion des données dans la table niv_zoom';\n\n"

    # Lecture du fichier csv
    reader = csv.reader(f, delimiter=';')
    # Lecture des entêtes en première ligne
    entetes = next(reader)
    niv_zoom = entetes[1:]
    # Lecture des lignes
    lst_indics = {}
    for ligne in reader:
        code_indic = ligne[0]
        lst_types_result = ligne[1:]
        lst_indics[code_indic] = lst_types_result
    
    # Ecriture des EXECUTE
    for code_indic in lst_indics:
        lst_types_result = lst_indics[code_indic]
        for i in range(len(lst_types_result)):
            type_result = lst_types_result[i]
            niv_zoom = i
            code_proc += f"\tEXECUTE 'INSERT INTO niv_zoom (code_indic, type_result, niv_zoom) VALUES (''{code_indic}'', ''{type_result}'', {niv_zoom});';\n"
    
    code_proc += "\n"
    code_proc += "\tRAISE NOTICE '====== FIN TRAITEMENT ======';\n"
    code_proc += "\tRAISE NOTICE '[INFO] La table niv_zoom a été initialisée dans le schéma r_ressources';\n"
    code_proc += "\tRAISE NOTICE '';\n\n"
    code_proc += "END;\n"
    code_proc += "$$;"

    with open(os.path.join(os.path.dirname(__file__),"__init_niv_zoom.sql"), 'w', encoding="UTF-8") as f:
        f.writelines(code_proc)

    cred = f"host={'127.0.0.1'} port={5436} dbname={'demo_agirisk'} user={'admin_agirisk'} password={'@giRisk!2022'}"
    conn = psycopg2.connect(cred)
    cur = conn.cursor()
    cur.execute(code_proc)
    conn.commit()
    cur.execute("CALL public.__init_niv_zoom();")
    conn.commit()
    conn.close()