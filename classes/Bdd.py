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

import psycopg2
import psycopg2.extras
from qgis.core import QgsMessageLog, Qgis, QgsDataSourceUri, QgsMapLayer, QgsVectorLayerExporter, QgsVectorLayer, QgsFeatureRequest, QgsField
from PyQt5.QtWidgets import QMessageBox
import re
from datetime import datetime
from collections import deque
import json, os


class Bdd:
    def __init__(self, parent, credentials):
        '''Création des paramètres de connexion à la base de données et connexion à la base
        '''
        self.dlg = parent
        # Définition des attributs de connexion à la bdd en fonction du fichier json credentials
        self.hostname = ""
        self.port = ""
        self.bdd = ""
        self.login = ""
        self.mdp = ""

        # Chargement des credentials
        self.fichier = os.path.join(os.path.dirname(__file__), credentials)
        self.charge_credentials() if os.path.isfile(self.fichier) else None     # on charge les credentials s'ils existent
        self.test_db_connexion()

        # Initialisation de l'uri de connexion à la bdd  
        self.conn = f"host={self.hostname} port={self.port} dbname={self.bdd} user={self.login} password={self.mdp}"
        self.uri = QgsDataSourceUri()
        self.uri.setConnection(self.hostname, self.port, self.bdd, self.login, self.mdp)


    def charge_credentials(self):
        '''Ouverture des credentials dans lesquels sont stockés les paramètres de connexion à la base'''
        with open(self.fichier, "r") as f:
            creds = json.load(f)

            self.hostname = creds["hostname"]
            self.port = creds["port"]
            self.bdd = creds["bdd"]
            self.login = creds["login"]
            self.mdp = creds["mdp"]


    def sauve_credentials(self, hostname, port, bdd, login, mdp):
        ''' Sauvegarde des paramètres de connexion dans le fichier de credentials'''
        with open(self.fichier, "w") as f:
            json.dump({"hostname": hostname, "port": port, "bdd": bdd,"login": login, "mdp": mdp}, f, indent=4)


    def test_db_connexion(self):
        '''Méthode pour tester la bonne connexion à la base de données'''
        try:
            self.conn = f"host={self.hostname} port={self.port} dbname={self.bdd} user={self.login} password={self.mdp}"
            psycopg2.connect(self.conn).cursor().execute("select version()")
            self.successful_init = True
        except:
            hostname, port, bdd, login, mdp, retour = self.dlg.entrer_infos_connexion(self.hostname, self.port, self.bdd, self.login, self.mdp)

            if retour: # appui sur le bouton "Ok"
                self.sauve_credentials(hostname, port, bdd, login, mdp)
                self.charge_credentials()
                self.test_db_connexion()
            else:   # l'utilisateur ferme la fenêtre
                self.successful_init = False
        

    def import_donnees(self, layer, schema, table):
        '''Fonction qui permet de charger une couche dans la base de données demo_agirisk'''

        if not layer.type() == QgsMapLayer.VectorLayer:
            QMessageBox.critical(self.dlg, "Erreur", f"{str(layer)} n'est pas un couche vectorielle.")
            return None

        self.uri.setDataSource(schema, table, "geom", aKeyColumn="id")
        err = QgsVectorLayerExporter.exportLayer(layer, str(self.uri), "postgres", layer.crs(), options = {"overwrite": True})
        if err[0] != 0:
            QMessageBox.critical(self.dlg, "Erreur lors de l'import", f"L'import de {layer} a échoué.\nErreur : {err[1]}")
            return None
        else:
            QMessageBox.information(self.dlg, "Import", f"Import réussi")


    def lancement_calcul(self, fonction, parametres, type = 'fonction'):
        ''' Lancement du calcul de variables / indicateurs par appel des fonctions __****() du schéma public
        TODO : Catcher les erreurs éventuelles d'exécution et les afficher dans le log adéquat (idéalement, afficher les différents 'Raise Notice' au fur et à mesure de l'exécution du calcul)
        '''

        param_sql = "', '".join([param.replace("'", "''") for param in parametres])
        req_sql = f"CALL public.{fonction}('{param_sql}');" if type == 'procedure' else f"select public.{fonction}('{param_sql}');"
        # QgsMessageLog.logMessage(f"{req_sql}", "plugin_agirisk_bdd", level=Qgis.Info)

        db_conn = psycopg2.connect(self.conn)
        cur = db_conn.cursor()
        db_conn.notices = deque(maxlen=5000) # On limite le nombre de notices à 1000
        cur.execute(req_sql)
        db_conn.commit()

        # Affichage des retour d'exécution SQL
        log_exec = self.affiche_raises(db_conn.notices)
        cur.close()
        db_conn.close()
        return log_exec


    def affiche_raises(self, conn_notices):
        ''' Affiche les logs de calcul de lancement_calcul dans le journal des messages QGIS plugin_agirisk_bdd
        Et copie intégrale du log dans un fichier log.txt à la racine du plugin'''

        timestamp_execution = datetime.now().strftime("%Y-%m-%d_%Hh%Mm%Ss")
        # Création du répertoire paramètres_locaux s'il n'existe pas
        if not os.path.exists(os.path.join(os.path.dirname(__file__), '..', 'parametres_locaux')):
            os.makedirs(os.path.join(os.path.dirname(__file__), '..', 'parametres_locaux'))
        # Création du répertoire de logs s'il n'existe pas
        if not os.path.exists(os.path.join(os.path.dirname(__file__), '..', 'parametres_locaux', 'logs')):
            os.makedirs(os.path.join(os.path.dirname(__file__), '..', 'parametres_locaux', 'logs'))
        with open(os.path.join(os.path.dirname(__file__), '..', 'parametres_locaux', 'logs', f"log{timestamp_execution}.txt"), "w") as f:
            for ligne in conn_notices:
                log = ligne.split("\n")[0].replace("NOTICE:  ", "")
                f.write(f"{log}\n")
        
        return conn_notices


    def liste_fonctions(self):
        '''Retourne  la liste des fonctions "agirisk" (préfixées par '__'), 
        en les catégorisant par leur type (indicateur, variable, initialisation, utilitaire)'''

        req_sql = r"SELECT p.proname, obj_description(p.oid,'pg_proc') as descr FROM pg_catalog.pg_namespace n JOIN pg_catalog.pg_proc p ON p.pronamespace = n.oid WHERE p.prokind in ('f','p') AND n.nspname = 'public' and p.proname like '\_\_%';"
        db_conn = psycopg2.connect(self.conn)
        cur = db_conn.cursor(cursor_factory = psycopg2.extras.RealDictCursor)
        cur.execute(req_sql)
        resultat = cur.fetchall()
        cur.close()
        liste_resultat = {"indic": [], "util": [], "var": [], "init": []}
        for res in resultat:
            fonc = res['proname'].replace("__", "")
            if fonc.startswith("indic"):
                liste_resultat["indic"].append(fonc[6:])
            elif fonc.startswith("util"):
                liste_resultat["util"].append(fonc[5:])
            elif fonc.startswith("var"):
                liste_resultat["var"].append(fonc[4:])
            elif fonc.startswith("init"):
                liste_resultat["init"].append(fonc[5:])
            else:
                QgsMessageLog.logMessage(f"{fonc} n'est pas une fonction agirisk correctement préfixée", "AgiRisk", level=Qgis.Warning)

        return liste_resultat


    def liste_indicateurs(self):
        '''Retourne  la liste des noms de vues matérialisées du schéma p_rep_carto'''

        req_sql = "SELECT schemaname as schema_name, matviewname as view_name, matviewowner as owner, ispopulated as is_populated, definition FROM pg_matviews WHERE pg_matviews.schemaname='p_rep_carto' ORDER by view_name;"
        db_conn = psycopg2.connect(self.conn)
        cur = db_conn.cursor(cursor_factory = psycopg2.extras.RealDictCursor)
        cur.execute(req_sql)
        resultat = cur.fetchall()
        cur.close()
        liste_resultat = []
        for res in resultat:
            liste_resultat.append(res['view_name'])
        return liste_resultat
    

    def recup_actions(self, code_indic, code_action = ""):
        '''Récupère dans la table actions_possibles la liste des actions associées à l'indicateur <code_indic>
        La table d'association utilisée est lien_indicateurs_actions (code_action, code_indicateur)
        La table actions_possibles contient les champs suivants :
        id : identifiant unique de l'action
        code : code de l'action
        niveau : niveau de l'action (1, 2 ou 3)
        code_sup : code de l'action supérieure (si niveau 2 ou 3)
        nom : nom de l'action
        axe : axe de l'action

        La méthode retourne un liste (de dictionnaires récursifs) de la forme :
        [{'nom': nom_action1, 'code': 'id', 'axe': 'axe_action1', 'sous_actions': [{'nom': 'nom_action2', 'code': 'id', 'axe': 'axe_action2', 'sous_actions': [{'nom': 'nom_action3', 'code': 'id', 'sujet': nom_action3, 'comm': nom_action3, 'axe': 'axe_action3'}]}]}]
        TODO : remplacer le fix '.replace("_amc", "")' par une refonte de l'arborescence des actions en se basant sur la base de données plutôt que sur le json
        '''
        code_indic = code_indic.replace("_amc", "")

        if code_action == "":
            # Lorsque le code action n'est pas fourni, on récupère les actions de niveau 1
            req_sql = f'''SELECT * FROM r_ressources.actions_possibles WHERE niveau = '1' AND code IN (with codes as (select code_action from r_ressources.lien_indicateurs_actions where code_indicateur = '{code_indic}'),
codes0 as (select a.code, a.niveau, a.code_sup from r_ressources.actions_possibles a join codes b on a.code =  b.code_action),
codes1 as (select a.code, a.niveau, a.code_sup from r_ressources.actions_possibles a join codes0 c on a.code = c.code_sup),
codes2 as (select  a.code, a.niveau from r_ressources.actions_possibles a join codes1 b on a.code = b.code_sup)
select code from codes0
union select code from codes1
union select code from codes2
order by code);'''
        else:
            # On récupère les actions dont le parent est code_action et qui correspondent à l'indicateur code_indic
            req_sql = f'''SELECT * FROM r_ressources.actions_possibles WHERE code_sup = '{code_action}' AND code IN (with codes as (select code_action from r_ressources.lien_indicateurs_actions where code_indicateur = '{code_indic}'),
codes0 as (select a.code, a.niveau, a.code_sup from r_ressources.actions_possibles a join codes b on a.code =  b.code_action),
codes1 as (select a.code, a.niveau, a.code_sup from r_ressources.actions_possibles a join codes0 c on a.code = c.code_sup),
codes2 as (select  a.code, a.niveau from r_ressources.actions_possibles a join codes1 b on a.code = b.code_sup)
select code from codes0
union select code from codes1
union select code from codes2
order by code);'''
        
        lst_dic_actions = []
        db_conn = psycopg2.connect(self.conn)
        cur = db_conn.cursor(cursor_factory = psycopg2.extras.RealDictCursor)
        cur.execute(req_sql)
        res_actions = cur.fetchall()
        cur.close()
        for res in res_actions:
            ss_actions = self.recup_actions(code_indic, code_action = res['code'])
            if code_action == "":
                lst_dic_actions.append({"nom": res['nom'], "code": res['code'], "axe": res['axe'], "sous_actions": ss_actions, "macro_action" : True, "doc_fiche_action": res['doc_fiche_action']})
            else:
                lst_dic_actions.append({"nom": res['nom'], "code": res['code'], "axe": res['axe'], "sous_actions": ss_actions, "macro_action" : False, "doc_fiche_action": res['doc_fiche_action']})

        return lst_dic_actions

    
    def construit_liste_actions(self, liste_actions):
        '''Construit la liste des actions à partir de la liste des actions brutes (issues de la table actions_possibles)'''
        # On commence par créer un dictionnaire des actions, indexé par leur code
        dico_actions = {}
        for action in liste_actions:
            dico_actions[action['code']] = action

        # On parcourt ensuite la liste des actions pour créer la liste des actions avec sous-actions
        liste_actions = []
        for action in dico_actions.values():
            if action['niveau'] == 1:
                liste_actions.append(action)
            else:
                # On récupère l'action supérieure
                action_sup = dico_actions[action['code_sup']]
                # On ajoute l'action dans la liste des sous-actions de l'action supérieure
                if 'sous_actions' in action_sup.keys():
                    action_sup['sous_actions'].append(action)
                else:
                    action_sup['sous_actions'] = [action]
                # On ajoute l'action supérieure dans la liste des actions si elle n'y est pas déjà
                if action_sup not in liste_actions:
                    liste_actions.append(action_sup)
        return liste_actions


    def recup_statut_calculs(self, territoire):
        '''Interroge la base de données pour identifier sur les variables, indicateurs et représentations cartographiques ont déjà été calculés ou non sur le territoire considéré'''

        sql_variables = f"select count(*) as res from c_phenomenes.zt where territoire ='{territoire}';"
        sql_indicateurs = f"select count(*) as res from p_indicateurs.s3_1a where territoire ='{territoire}';"
        sql_rep_carto = f"select count(*) as res from p_rep_carto.s3_1a_rc where territoire ='{territoire}';"

        # Exécution des requêtes
        db_conn = psycopg2.connect(self.conn)
        cur = db_conn.cursor()
        cur.execute(sql_variables)
        variables_calculees = cur.fetchone()[0] > 0
        cur.execute(sql_indicateurs)
        indicateurs_calcules = cur.fetchone()[0] > 0
        cur.execute(sql_rep_carto)
        rep_carto_calculees = cur.fetchone()[0] > 0
        cur.close()
        db_conn.close()

        return variables_calculees, indicateurs_calcules, rep_carto_calculees


    def recup_donnees(self, liste_champs, table, where="", tri="", unique=""):
        '''Récupère les données des champs listés, sans géométrie. Le nom de la table doit contenir le nom du schéma'''
        
        if where:
            clause_where = " WHERE " + where
        else:
            clause_where = ""
        if tri:
            clause_tri = " ORDER BY " + tri
        else:
            clause_tri = ""
        if unique:
            clause_unique = " GROUP BY " + unique
        else:
            clause_unique = ""
        req_sql = "SELECT " + ','.join(liste_champs) + " FROM " + table + clause_where + clause_unique + clause_tri
        db_conn = psycopg2.connect(self.conn)
        cur = db_conn.cursor(cursor_factory = psycopg2.extras.RealDictCursor)
        cur.execute(req_sql)
        resultat = cur.fetchall()
        cur.close()

        return resultat


    def recup_territoire(self, nom_territoire):
        '''Retourne la couche du territoire d'étude'''

        self.uri.setDataSource("c_general", "territoires", "geom", aKeyColumn="id")
        self.uri.setSrid("2154")
        self.uri.setSql(f'''territoire = '{nom_territoire.replace("'", "''")}' ''')

        territoire_en_base = QgsVectorLayer(self.uri.uri(),f"Territoire d'étude - {nom_territoire}", "postgres")
        territoire_en_memoire = territoire_en_base.materialize(QgsFeatureRequest().setFilterFids(territoire_en_base.allFeatureIds()))

        return territoire_en_memoire

  
    def recup_alea(self, code_alea, nom_terr, type_alea, code_occurrence):
        '''Retourne la couche 'code_alea' (Zx, Zq, Zh) de l'aléa correspondant aux territoire, type d'aléa et code occurrence choisis'''
        
        if code_alea in ["zx", "zq", "zh"]:
            vue_materialisee = self.get_materialized_view_name(code_alea, nom_terr)
            self.uri.setDataSource("c_phenomenes", vue_materialisee, "geom", aKeyColumn="id")
            self.uri.setSrid("2154")
            self.uri.setSql(f'''type_alea='{type_alea.replace("'", "''")}' AND code_occurrence='{code_occurrence.replace("'", "''")}' ''')

            alea_en_base = QgsVectorLayer(self.uri.uri(),f"{code_alea} - {code_occurrence}", "postgres")
            alea_en_memoire = alea_en_base.materialize(QgsFeatureRequest().setFilterFids(alea_en_base.allFeatureIds()))

            return alea_en_memoire
        else:
            QgsMessageLog.logMessage(f"{code_alea} n'est pas un code de couche valide", "AgiRisk", level=Qgis.Warning)
            return None
    

    def recup_indic(self, code_indic, nom_terr = "", type_alea = "", code_occurrence = "", aggr = "", nom_couche=""):
        '''Retourne la couche indicateur 'code_indic', sur le territoire sélectionné et l'occurrence d'aléa choisie
        '''

        vue_materialisee = self.get_materialized_view_name(code_indic, nom_terr, '_rc')
        self.uri.setDataSource("p_rep_carto", vue_materialisee, "geom")
        self.uri.setSrid("2154")
        self.uri.setSql(f'''type_alea='{type_alea.replace("'", "''")}' AND code_occurrence='{code_occurrence.replace("'", "''")}' AND type_result='{aggr.replace("'", "''")}' ''')

        couche_en_base = QgsVectorLayer(self.uri.uri(), nom_couche, "postgres")
        if couche_en_base.featureCount() == 0:
            if not couche_en_base.isValid():
                QgsMessageLog.logMessage(f"La couche {couche_en_base.name()} n'est pas valide - l'erreur est : {couche_en_base.error().message()}", "AgiRisk", level=Qgis.Warning)
            return None
        else:
            return couche_en_base.materialize(QgsFeatureRequest().setFilterFids(couche_en_base.allFeatureIds()))


    def recup_millesimes(self):
        '''Retourne les millésimes des couches sources utilisées'''
        millesimes = {}

        sql = { 'gpu': "r_ign_gpu", 
                'bdtopo': "r_ign_bdtopo", 
                'rpg': "r_ign_rpg", 
                'adresse': "r_ign_adresse_premium", 
                'insee': "r_insee_sirene", 
                'inao': "r_inao", 
                'sirene': "r_insee_sirene"}
        db_conn = psycopg2.connect(self.conn)
        cur = db_conn.cursor(cursor_factory = psycopg2.extras.RealDictCursor)
        for couche in sql.keys():
            # req_sql = sql[couche]
            req_sql = f"SELECT tablename FROM pg_tables WHERE schemaname = '{sql[couche]}'"            
            cur.execute(req_sql)
            resultat = cur.fetchall()
            
            liste_resultat = []
            millesimes[couche] = {'dispos': list()}
            for res in resultat:
                # On matche ensuite les résultats pour récupérer les millésimes (suites de 4 chiffres situées à la fin du nom de la table)
                match = re.search(r'(\d{4})$', res['tablename'])
                if match:
                    millesimes[couche]['dispos'].append(int(match.group(1)))
                # millesimes[couche]['dispos'].append(res['millesime'])
            millesimes[couche] = {'dispos': list(set(millesimes[couche]['dispos']))}
            millesimes[couche]['plus_recent'] = max(millesimes[couche]['dispos']) if len(millesimes[couche]['dispos']) > 0 else 0
        cur.close()
        db_conn.close()
        return millesimes


    def import_layer_into_table(self, layer, schema, table, idColumn, verbose = True):
        '''Intègre un layer dans une table'''

        self.uri.setDataSource(schema, table, "geom", aKeyColumn=idColumn)
        self.uri.setSrid("2154")

        layer_bdd = QgsVectorLayer(self.uri.uri(), f"{schema}.{table}", "postgres")
        layer_bdd.startEditing()
        [layer_bdd.addFeature(f) for f in layer.getFeatures()]
        if not layer_bdd.commitChanges():
            QMessageBox.critical(self.dlg, "Import en base échoué", f"L'import en base a échoué :  \n\n{chr(10).join(layer_bdd.commitErrors())}\n\nMerci de vérifier que l'utilisateur a bien les droits en écriture dans la base de données.")     # chr(10) = \n
            return False

        QgsMessageLog.logMessage(f"Import de [{layer.name()}] dans la table [{schema}.{table}] de la base de données.", "AgiRisk", level = Qgis.Info)
        if verbose:
            QMessageBox.information(self.dlg, "Import en base", f"Import de [{layer.name()}] dans la table [{schema}.{table}] de la base de données. ")


    def get_materialized_view_name(self, code, nom_terr, suffixe_table = ''):
        '''Renvoie le nom de la vue matérialisée de l'indicateur sur le territoire'''

        req_sql = f"SELECT '{code}{suffixe_table}_' || __util_to_snake_case('{nom_terr.replace(chr(39), '_')}')"
        db_conn = psycopg2.connect(self.conn)
        cur = db_conn.cursor()
        cur.execute(req_sql)
        resultat = cur.fetchall()[0]
        cur.close()

        return resultat[0]
    

    def get_niv_zoom(self):
        ''' Récupère les correspondances entre codes indicateurs, niveaux de zoom et types result
        Le résultat est un dictionnaire de la forme :
        {'code_indic1': {'niv_zoom1': 'type_result1', 'niv_zoom2': 'type_result2', ...}, 
         'code_indic2': {'niv_zoom1': 'type_result1', 'niv_zoom2': 'type_result2', ...}, ...}
        '''
   
        db_conn = psycopg2.connect(self.conn)
        cur = db_conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor)
        cur.execute("SELECT distinct code_indic FROM r_ressources.niv_zoom;")
        liste_indics = cur.fetchall()

        dico = {}
        for indic in liste_indics:
            dico[indic['code_indic']] = {}
            cur.execute(f"SELECT niv_zoom, type_result FROM r_ressources.niv_zoom WHERE code_indic = '{indic['code_indic']}';")
            res = cur.fetchall()
            for r in res:
                dico[indic['code_indic']][r['niv_zoom']] = r['type_result']

        cur.close()
        db_conn.close()
        return dico
    

    def get_lst_niv_zoom(self):
        ''' Récupère les niveaux de zoom disponibles et les renvoie sous forme de liste'''

        req_sql = f"SELECT distinct niv_zoom FROM r_ressources.niv_zoom;"
        db_conn = psycopg2.connect(self.conn)
        cur = db_conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor)
        cur.execute(req_sql)
        resultat = cur.fetchall()
        cur.close()
        db_conn.close()

        lst_niv_zoom = []
        for r in resultat:
            lst_niv_zoom.append(r['niv_zoom'])
        return lst_niv_zoom
    

    def get_liste_champs(self, nom_couche):
        '''Renvoie les champs et leur typage de la couche <nom_couche>'''
        req_sql = f'''
            SELECT pg_attribute.attname, pg_type.typname
            FROM pg_class
            JOIN pg_attribute ON pg_class.relname='{nom_couche}' AND pg_attribute.attrelid=pg_class.oid AND attnum > 0
            JOIN pg_type ON pg_type.oid=pg_attribute.atttypid
            WHERE pg_type.typname !='geometry' 
        '''
        db_conn = psycopg2.connect(self.conn)
        cur = db_conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor)
        cur.execute(req_sql)
        resultat = cur.fetchall()
        cur.close()
        db_conn.close()
        liste_qgsfield = [QgsField(resultat[-1]['attname'], self.dlg.ressources.correspondances_types_sql[resultat[-1]['typname']])]

        for res in resultat[:-1]:
            type_qvariant = self.dlg.ressources.correspondances_types_sql[res['typname']]
            liste_qgsfield.append(QgsField(res['attname'], type_qvariant))

        return liste_qgsfield
