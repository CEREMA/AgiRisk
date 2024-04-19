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
'''
Récupération des fonctions SQL de la base demo_agirisk et écriture dans le dépôt local du plugin, puis commit-push des modificiations si besoin.

Exécution :
    python export_sql_to_repo.py
'''


__author__ = ("Thomas Escrihuela","Lucie Duranton")
__contact__ = ("Thomas.Escrihuela@cerema.fr","Lucie.Duranton@cerema.fr")
__date__ = "2022/11"
__version__ = '1.0'


import psycopg2
import os
import json
import datetime
from git import Repo


## Paramètres
credentials_file = "../../parametres_locaux/credentials_bdd.json"
type_script = ["init", "indic", "var", "util"]  # liste des différents types de scripts SQL


## Fonctions
def git_push():
    '''Permet d'indexer, de commiter et de pusher les scripts SQL sur le dépôt s'ils ont été modifiés.'''
    repo = Repo(f"{dirname}/../..")
    changed_files = [item.a_path for item in repo.index.diff(None)]
    if len(changed_files) > 0 :
        print('     Fichiers modifiés :')
        [print(f'       {file}') for file in changed_files]
        repo.git.add(dirname, all=True)
        repo.index.commit(f'Synchronisation des fichiers SQL (fonctions base prod au 28.09.2023)  : {datetime.datetime.now().strftime("%d/%m/%Y")}')
        origin = repo.remote(name='origin')
        # origin.push()
    else:
        print('     Aucun fichier modifié depuis la dernière synchronisation')


## MAIN
if __name__ == '__main__':
    print()
    print('===  Export des fonctions SQL')

    # Environnement du script
    dirname = os.path.dirname(__file__)
    fichier = os.path.join(dirname, credentials_file)

    # Chargement des credentials        
    with open(fichier, "r") as f:
        creds = json.load(f)
        host = creds["hostname"]
        port = creds["port"]
        db = creds["bdd"]
        user = creds["login"]
        pwd = creds["mdp"]

    # Connexion à la bdd
    try:
        conn = psycopg2.connect("dbname='"+ db + "' user='" + user + "' host='" + host + "' password='" + pwd + "' port='" + port + "'")
    except Exception as error:
        print ("    Erreur : ", error)
        print ("    Connexion refusee !!!")
        exit(1)
    cur = conn.cursor()

    # Synchronisation des scripts SQL
    for type in type_script:
        # On récupère les noms et le contenu des fonctions SQL
        sql = f"""
            SELECT p.proname, pg_get_functiondef(p.oid) as code_src
            FROM pg_catalog.pg_namespace n
            JOIN pg_catalog.pg_proc p
            ON p.pronamespace = n.oid
            WHERE p.prokind in ('f','p')
            AND n.nspname = 'public'
            AND p.proname like '\_\_{type}%';
        """
        cur.execute(sql)
        res = cur.fetchall()

        # On écrase les fichiers SQL avec le contenu de la base demo_agirisk
        for function in res:
            file = f"{function[0]}.sql"
            path_file = f"{dirname}/__{type}_/{file}"
            print(f"    {path_file}")
            with open(path_file, 'w', encoding = 'utf8', newline='') as fp:
                fp.write("SET client_encoding = 'UTF8';\n\n")
                fp.write(function[1])

    # Push sur le dépôt git
    print()
    print('===  Envoi des scripts SQL sur le dépôt git...')
    # git_push()
    print()
    print('===  Script terminé avec succès')
    print()
