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

import sys

# Récupération des arguments
[file, table, insee_dep] = sys.argv[1:]
print(f"Modification du dump {file} pour ajout de la partition")

# Paramètres
mot_clef = "ATTACH PARTITION"
line = f"CREATE TABLE IF NOT EXISTS {'_'.join(table.split('_')[:-1])} (LIKE {table} INCLUDING COMMENTS) PARTITION BY LIST ({insee_dep});\n"

with open(file, "r", encoding='utf8') as f:
    contents = f.readlines() 

indexes = [i for i, item in enumerate(contents) if mot_clef in item] # liste les indexes où on trouve le mot-clef
[contents.pop(index) for index in indexes[1:][::-1]] # à l'envers pour les suppressions
contents.insert(indexes[0], line)  # ajout de la ligne <create partition>

# réécriture
with open(file, "w", encoding='utf8') as f:
    contents = "".join(contents)
    f.write(contents)
