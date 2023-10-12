import copy, os
from qgis.core import QgsVectorLayer, QgsFeature, QgsProject, QgsField, QgsMessageLog, Qgis, QgsCoordinateReferenceSystem, QgsCoordinateTransformContext, QgsFeature, QgsField, QgsFields, QgsWkbTypes, QgsCoordinateTransform
from PyQt5.QtCore import QVariant
from qgis import processing

from .ArborescenceIndicateurs import ArborescenceIndicateurs
from .Dashboard import Dashboard

class ModeleTerritorial:
    '''
    La classe ModeleTerritorial est un objet permettant de garder en mémoire (côté utilisateur) les différentes données
    du modèle territorial que constitue la démarche AgiRisk.
    Ce modèle territorial est synchronisé avec la bdd postgreSQL à la demande, via les méthodes définies ci-dessous.
    Les méthodes définies ci-dessous permettent également la synchronisation à la demande avec l'interface de QGis
    '''

    ##########################################################################################################
    # Section initialisations
    ##########################################################################################################

    def __init__(self, parent, nom_terr, vlayer = None, provisoire = False):
        __path__ = []
        # Initialisation accès à la base à partir du fichier ./parametres/credentials_bdd.json
        self.bdd = parent.bdd
        self.dlg = parent

        # Initialisation du territoire d'étude
        self.terr = None
        self.couche_terr = None
        self.couche_alea = None
        self.occurrence = None
        self.type_alea = None
        self.description_alea = None
        self.provider = None
        self.provisoire = provisoire

        self.millesimes_choisis = {}

        # Initialisation des couches indicateurs
        self.dict_couches = {}
        self.synthese_indic = {}
        self.mt_arbo_couches = {}
        self.layers = {} # Dictionnaire 'à plat' des couches pour chaque point de vue et chaque niveau d'aggrégation spatiale

        if not self.provisoire:
            # Initialisation des arborescences correspondant aux différents points de vue
            self.arbo_indicateurs = ArborescenceIndicateurs(self.dlg, self)

            # Initialisation des dashboards
            self.dashboard = Dashboard(self.dlg, self)

        # Définition de la géométrie du territoire d'étude
        self.def_terr_etude(nom_terr, vlayer)


    def change_nom_terr(self, nouveau_nom):
        '''Change le nom du territoire d'étude'''
        self.terr = nouveau_nom


    def rendre_invisible(self):
        '''Rend l'arborescence des indicateurs invisible pour un point de vue donné
        '''
        for pt_vue in self.arbo_indicateurs.liste_pts_vue:
            self.arbo_indicateurs.conteneurs_widgets[pt_vue].setVisible(False)


    def liste_couches(self):
        '''Récupère la liste des couches définies dans self.dict_couches
        TODO : corriger le fait que même si la couche est vide elle est chargée
        '''

        liste = []
        liste.append(self.dict_couches['terr_etude'])
        for couche_alea in self.dict_couches['alea'].values():
            if couche_alea is not None:
                liste.append(couche_alea)
        for couche_indic in self.dict_couches['indic'].values():
            if not couche_indic:
                liste.append(couche_indic)
        return liste


    def couches_a_afficher(self, niv_zoom):
        '''Renvoie la liste des couches (sous forme de dictionnaire arborescent) à afficher en fonction de l'échelle choisie'''

        return self.mt_arbo_couches[self.dlg.pt_vue_actif][niv_zoom]


    def calcul_regroupements(self):
        ''' Calcul des groupements selon communes, EPCI, départements, régions
        TODO : récupérer dynamiquement (json en entrée ?) les champs de résultat de chaque indicateur sélectionné'''

        # On calcule seulement les groupements sur le point de vue actif et pour chaque indicateur retenu (et pour chaque niveau de zoom hors hexagones)
        for indic, widget_indic in self.arbo_indicateurs.widgets_indicateurs[self.dlg.pt_vue_actif].items():
            if widget_indic.bouton.retenu == True:
                for champ in self.dlg.ressources.codes_champs[indic]:
                    for niv_zoom in self.dlg.ressources.lst_niv_zoom:
                        if self.dlg.ressources.code_niv_zoom[niv_zoom][:3] != 'Hex':
                            if 'layer' in self.layers[self.dlg.pt_vue_actif][niv_zoom][indic].keys():
                                couche_indic = self.layers[self.dlg.pt_vue_actif][niv_zoom][indic]['layer']
                                for feat in couche_indic.getFeatures():
                                    # Chacune des entités feat représente un niveau d'aggrégation spatiale donnée parmi : Entite / Commune / EPCI / Hexag_1ha à Hexag_100ha / IRIS
                                    if feat['nom_id_geom'] not in self.synthese_indic[indic][champ][niv_zoom].keys():
                                        self.synthese_indic[indic][champ][niv_zoom][feat['nom_id_geom']] = 0 if isinstance(feat[champ], QVariant) else int(feat[champ])
                                    else:
                                        self.synthese_indic[indic][champ][niv_zoom][feat['nom_id_geom']] += 0 if isinstance(feat[champ], QVariant) else int(feat[champ])


    def def_terr_etude(self, nom_terr, vlayer = None):
        '''Définit le territoire d'étude en mémoire'''

        # Lancé au choix d'un territoire dans la combobox
        if not vlayer:
            self.terr = nom_terr
            self.couche_terr = self.bdd.recup_territoire(self.terr)

        # Lancé si c'est un nouveau territoire chargé par l'utilisateur
        else:
            # Création de la geométrie union des entités du fichier uploadé par l'utilisateur
            union_geom = None
            for feat in vlayer.getFeatures():
                if union_geom == None:
                    union_geom = feat.geometry()
                else:
                    union_geom = union_geom.combine(feat.geometry())
            union_geom = union_geom.coerceToType(QgsWkbTypes.MultiPolygon)[0] # force en multipolygone en supprimant les dimensions Z et M si besoin
            union_geom.transform(QgsCoordinateTransform(vlayer.sourceCrs(), QgsCoordinateReferenceSystem("EPSG:2154"), QgsProject.instance())) # reprojete en 2154

            # Création de l'entité territoire
            feature = QgsFeature()
            fields = QgsFields()
            fields.append(QgsField('id', QVariant.Int))
            fields.append(QgsField('territoire', QVariant.String))
            feature.setFields(fields)
            feature.setGeometry(union_geom)
            feature['territoire'] = nom_terr
            feature['id'] = None    # Laisser à None pour utiliser la séquence postgres

            # Mise à jour de self.terr
            self.terr = nom_terr
            self.couche_terr = QgsVectorLayer("MultiPolygon", f"Territoire d'étude - {self.terr}", "memory")
            self.couche_terr.startEditing()
            self.provider = self.couche_terr.dataProvider()
            self.provider.addAttributes([QgsField("id", QVariant.Int), QgsField("territoire",  QVariant.String), QgsField("insee_dep",  QVariant.StringList)])
            self.couche_terr.updateFields()
            self.provider.addFeature(feature)
            self.couche_terr.commitChanges()

        # Ajout transparence au layer et gestion de la projection
        self.couche_terr.setOpacity(0.5)
        self.couche_terr.setTransformContext(QgsCoordinateTransformContext())
        self.couche_terr.setCrs(QgsCoordinateReferenceSystem("EPSG:2154"))

        # Ajout du QgsVectorLayer à la liste des couches à afficher dans le canvas (+ style associé)
        if not self.provisoire:
            for pt_vue in self.dlg.ressources.liste_pts_vue:
                fic_styles = self.dlg.ressources.fic_styles
                if pt_vue in fic_styles.keys():
                    if "terr_etude" in fic_styles[pt_vue].keys():
                        fichier_style = os.path.join(self.dlg.ressources.rep_styles, fic_styles[pt_vue]["terr_etude"]["Commune"])
                        self.couche_terr.loadNamedStyle(fichier_style)

                self.dict_couches['terr_etude'] = self.couche_terr
                self.dict_couches['alea'] = {'zx':None, 'zq':None, 'zh':None}
                self.dict_couches['indic'] = {}

                for niv_zoom in self.dlg.ressources.lst_niv_zoom:
                    self.mt_arbo_couches[pt_vue][niv_zoom][0]['layer'] = self.couche_terr
                    self.layers[pt_vue][niv_zoom]['terr_etude'] = self.mt_arbo_couches[pt_vue][niv_zoom][0]

            # Remise à zéro du calcul des regroupements
            self.synthese_indic = {}


    def create_alea(self, input_nom_terr, input_type_alea, input_occurrence, input_description, vlayer):
        '''Définit ou récupère depuis la base de données les couches d'aléa : Zx, Zh, Zq et les stocke en mémoire dans le modèle territorial.
        Cette méthode est appelée lorsque l'utilisateur choisit un type d'aléa dans la combobox ou lorsqu'il charge une nouvelle couche aléa
        Le dissolve permet de regrouper les différentes intensités d'aléa pour n'avoir qu'une entité d'aléa faible etc.
        '''

        alea = f"{input_description} - {input_occurrence}"
        champs_alea = ['occurrence','code_occurrence', 'type_alea', 'description_alea','intensite_alea']
        valid_layer = processing.run("native:fixgeometries", {'INPUT':vlayer,'METHOD':1,'OUTPUT':'TEMPORARY_OUTPUT'})['OUTPUT']
        dissolved = processing.run("native:dissolve", {'INPUT':valid_layer,'FIELD': champs_alea,'OUTPUT':'TEMPORARY_OUTPUT'})['OUTPUT']
        self.couche_alea = processing.run("native:reprojectlayer", {'INPUT':dissolved,'TARGET_CRS':QgsCoordinateReferenceSystem('EPSG:2154'),'OUTPUT':'TEMPORARY_OUTPUT'})['OUTPUT']
        self.couche_alea.setName(f"Alea - {alea}")

        # Ajout transparence au layer et gestion de la projection
        self.couche_alea.setOpacity(0.5)
        self.couche_alea.setTransformContext(QgsCoordinateTransformContext())
        self.couche_alea.setCrs(QgsCoordinateReferenceSystem("EPSG:2154"))

        self.def_terr(input_nom_terr)
        self.def_type_alea(input_type_alea)
        self.def_occurrence(input_occurrence)
        self.def_description_alea(input_description)

        # Sauvegarde en base de données
        self.save_alea(verbose = False)


    def def_alea(self):
        '''Méthode qui définit les couches d'aléa et qui stocke ses informations (emprise ZI, Niveau d'aléa et hauteurs d'eau). La méthode régénére l'arborescence des couches à afficher dans l'explorateur Qgis'''

        self.couche_alea_zx = self.bdd.recup_alea("zx", self.terr, self.type_alea, self.occurrence)
        self.couche_alea_zx.loadNamedStyle(os.path.join(self.dlg.ressources.rep_styles, 'zx.qml')) if self.couche_alea_zx else None
        self.couche_alea_zq = self.bdd.recup_alea("zq", self.terr, self.type_alea, self.occurrence)
        self.couche_alea_zq.loadNamedStyle(os.path.join(self.dlg.ressources.rep_styles, 'zq.qml')) if self.couche_alea_zq else None
        self.couche_alea_zh = self.bdd.recup_alea("zh", self.terr, self.type_alea, self.occurrence)
        self.couche_alea_zh.loadNamedStyle(os.path.join(self.dlg.ressources.rep_styles, 'zh.qml')) if self.couche_alea_zh else None

        self.dict_couches['alea'] = {'zx':self.couche_alea_zx, 'zq':self.couche_alea_zq, 'zh':self.couche_alea_zh}

        dict_zx = {'type': "couche", 'code': "zx", 'style': "styles_territoires.qml", 'layer': self.couche_alea_zx, 'visible': True, 'nom_couche': "Emprise de la zone inondable"}
        dict_zq = {'type': "couche", 'code': "zq", 'style': "styles_territoires.qml", 'layer': self.couche_alea_zq, 'visible': False, 'nom_couche': "Niveaux d'aléa"}
        dict_zh = {'type': "couche", 'code': "zh", 'style': "styles_territoires.qml", 'layer': self.couche_alea_zh, 'visible': False, 'nom_couche': "Hauteurs d'eau"}
        for pt_vue in self.dlg.ressources.liste_pts_vue:
            for niv_zoom in self.dlg.ressources.lst_niv_zoom:
                # Comme on vient de changer de couche aléa, on réinitialise les couches d'indicateurs
                self.purge_layers(self.mt_arbo_couches[pt_vue][niv_zoom])
                for groupe in self.mt_arbo_couches[pt_vue][niv_zoom]:
                    if groupe['type'] == "groupe" and groupe['nom_groupe'] == "Aléas":
                        groupe['legende_groupe'] = f"Aléa {self.type_alea} - {self.occurrence}"
                        groupe['enfants'] = []
                        if self.couche_alea_zx.featureCount() > 0:
                            groupe['enfants'].append(dict_zx)
                        if self.couche_alea_zq.featureCount() > 0:
                            groupe['enfants'].append(dict_zq)
                        if self.couche_alea_zh.featureCount() > 0:
                            groupe['enfants'].append(dict_zh)
                self.layers[pt_vue][niv_zoom] = {}
                self.extract_layers(self.mt_arbo_couches[pt_vue][niv_zoom], self.layers[pt_vue][niv_zoom])

        # Comme on vient de changer de couche aléa, on réinitialise les couches d'indicateurs
        self.dict_couches['indic'] = {}

        # Remise à zéro du calcul des regroupements
        self.synthese_indic = {}

        # On supprime la clé 'couche_chargee' dans self.layers[pt_vue][niv_zoom][code_indic].keys(), pour toutes les combinaisons pt_vue et niv_zoom, code_indic
        # de façon à relancer le chargement depuis la bdd des indicateurs
        for pt_vue in self.dlg.ressources.liste_pts_vue:
            for niv_zoom in self.dlg.ressources.lst_niv_zoom:
                for code_indic in self.dlg.ressources.codes_champs.keys():
                    try:
                        del self.layers[pt_vue][niv_zoom][code_indic]['couche_chargee']
                    except:
                        pass


    def def_occurrence(self, occurrence):
        ''' Mise à jour de self.alea'''
        if not occurrence == None:
            self.occurrence = occurrence
        else:
            self.occurrence = ""


    def def_type_alea(self, type_alea):
        '''Mise à jour de self.type_alea'''
        if not type_alea == None:
            self.type_alea = type_alea
        else:
            self.type_alea = ""


    def def_description_alea(self, description_alea):
        '''Mise à jour de self.description_alea'''
        if not description_alea == None:
            self.description_alea = description_alea
        else:
            self.description_alea = ""


    def def_terr(self, terr):
        '''Mise à jour de self.type_alea'''
        if not terr == None:
            self.terr = terr
        else:
            self.terr = ""


    def save_terr_etude(self):
        '''Importe couche_terr dans la Bdd'''
        self.bdd.import_layer_into_table(self.couche_terr, "c_general", "territoires", "id")


    def save_alea(self, verbose = True):
        '''importe la couche aléa dans la Bdd'''
        self.bdd.import_layer_into_table(self.couche_alea, "c_phenomenes", "zq", "id", verbose)
        self.bdd.lancement_calcul("__var_zq", [self.terr, self.type_alea, self.occurrence, self.description_alea])  # crée la vue matérialisée
        self.bdd.lancement_calcul("__var_zx", [self.terr, self.type_alea, self.occurrence, self.description_alea])  # dérive les enveloppes ZI


    def choix_millesime(self, couche, millesime):
        '''Méthode qui permet de stocker le millesime des couches utilisées!!!Appeler dans agirisk_dialog.py mais la méthode est conservé par historique uniquement '''
        self.millesimes_choisis[couche] = millesime


    def def_dict_couches(self, pt_vue, arbo_couche):
        '''Retrouve les couches à intégrer à l'arborescence Qgis. Création de l'arborescence à partir des trois grands groupes: territoire d'étude, aléa et OpenStreetMap'''
        self.mt_arbo_couches[pt_vue] = {}
        # On définit le dictionnaire 'à plat' des QgsVectorLayer et QgsRasterLayer pour y accéder plus facilement
        self.layers[pt_vue] = {}
        dict_terr_etude = {'type': "couche", 'code': "Territoire d'étude", 'style': "styles_territoires.qml", 'visible': True}
        dict_alea = {'type': "groupe", 'nom_groupe': "Aléas", "enfants": [], 'visible': True}
        dict_osm = {'type': "couche", 'code': "OpenStreetMap", 'style': "styles_osm.qml", 'layer': self.dlg.ressources.basemaps['osm'], 'visible': True}

        for niv_zoom in self.dlg.ressources.lst_niv_zoom:
            self.mt_arbo_couches[pt_vue][niv_zoom] = [dict_terr_etude]
            self.mt_arbo_couches[pt_vue][niv_zoom] += copy.deepcopy(arbo_couche)
            self.mt_arbo_couches[pt_vue][niv_zoom].append(dict_alea)
            self.mt_arbo_couches[pt_vue][niv_zoom].append(dict_osm)

            self.layers[pt_vue][niv_zoom] = {}
            self.extract_layers(self.mt_arbo_couches[pt_vue][niv_zoom], self.layers[pt_vue][niv_zoom])


    def change_visibilite_couches(self, name, visible):
        '''Si la couche existe et qu'elle n'est pas vide, rend la couche visible'''
        pt_vue = self.dlg.pt_vue_actif
        for niv_zoom in self.dlg.ressources.lst_niv_zoom:
            res = self.find_item(self.mt_arbo_couches[pt_vue][niv_zoom], name)
            if len(res) > 0:
                res[0]['visible'] = visible
                # TODO : cocher / décocher la card correspondance du dashboard
            else:
                QgsMessageLog.logMessage(f"(ModeleTerr) Impossible de trouver la couche {name} dans l'arborescence des couches", "AgiRisk", Qgis.Warning)
                break   # si la couche n'est pas trouvée au premier niveau, on considère qu'elle ne sera pas trouvée dans les niveaux suivants


    def find_item(self, l_dict_couches, name):
        '''Retourne le dictionnaire item correspondant soit à un groupe soit à une couche
        '''
        result = []
        for item in l_dict_couches:
            if item['type'] == "groupe":
                if ((item['nom_groupe'] == name or item['legende_groupe'] == name) if 'legende_groupe' in item.keys() else item['nom_groupe'] == name):
                    result.append(item)
                result += self.find_item(item['enfants'], name)
            elif item['type'] == "couche" :
                if 'nom_couche' in item.keys():
                    if item['nom_couche'] == name:
                        result.append(item)
                elif item['code'] == name:
                    result.append(item)
        return result


    def extract_layers(self, dict_couches, dict_a_plat):
        '''Retourne le layer correspondant au code passé en paramètre'''

        for item in dict_couches:
            if item['type'] == 'couche':
                dict_a_plat[item['code']] = item
            elif item['type'] == 'groupe':
                self.extract_layers(item['enfants'], dict_a_plat)
        return


    def purge_layers(self, dict_couches):
        '''Purge les couches en supprimant les couches qui ne sont pas: Territoire d'étude, OpenStreetMap et les aléas zx, zq et zh'''
        for item in dict_couches:
            if item['type'] == 'couche':
                if item['code'] not in ["Territoire d'étude", "OpenStreetMap", "zx", "zq", "zh"] and 'layer' in item.keys():
                    del item['layer']
            elif item['type'] == 'groupe':
                self.purge_layers(item['enfants'])


    def charger_couche_indic(self, code_indic):
        '''La méthode charge l'ensemble des couches des indicateurs sans recharger de couches qui le seraient déjà et sans charger de couches vides.
        La méthode permet également d'initialiser le dictionnaire contenant l'ensemble des aggrégations spatiales des différents indicateurs
        qui sont présents dans le dashboard.'''

        fic_styles = self.dlg.ressources.fic_styles
        pt_vue = self.dlg.pt_vue_actif

        aggr_non_dispos = []
        nom_couche=self.dlg.ressources.legendes_couches[code_indic]
        # for aggr in aggregations_spatiales:                # On teste d'abord si la couche n'est pas déjà chargée
        for niv_zoom in self.dlg.ressources.lst_niv_zoom: # niv_zoom correspond au code (0 à 8) de l'échelle du canvas affichée
            if 'couche_chargee' not in self.layers[pt_vue][niv_zoom][code_indic].keys():
                #  = {"osm" : self.dlg.ressources.basemaps['osm']}
                aggr = self.dlg.ressources.niv_zoom[code_indic][niv_zoom] # Le type result à afficher pour chaque niveau de zoom est défini pour chaque indicateur dans la base de données
                couche_indic = self.bdd.recup_indic(code_indic, self.terr, self.type_alea, self.occurrence, aggr, nom_couche=nom_couche)
                if couche_indic != None:
                    self.layers[pt_vue][niv_zoom][code_indic]['layer'] = couche_indic
                    self.layers[pt_vue][niv_zoom][code_indic]['nom_couche'] = nom_couche
                    self.layers[pt_vue][niv_zoom][code_indic]['visible'] = False
                    self.layers[pt_vue][niv_zoom][code_indic]['couche_chargee'] = True

                    # Si le fichier de style existe, on l'applique
                    if pt_vue in fic_styles.keys():
                        if code_indic in fic_styles[pt_vue].keys():
                            fichier_style = os.path.join(self.dlg.ressources.rep_styles, fic_styles[pt_vue][code_indic][self.dlg.ressources.code_niv_zoom[niv_zoom]])
                            self.layers[pt_vue][niv_zoom][code_indic]['layer'].loadNamedStyle(fichier_style)
                else:
                    aggr_non_dispos.append(aggr)
            else:
                QgsMessageLog.logMessage(f"(ModeleTerr) La couche {code_indic} est déjà chargée en mémoire dans le modèle territorial", "AgiRisk", Qgis.Info)
        if len(aggr_non_dispos) > 0:
            for aggr in aggr_non_dispos:
                QgsMessageLog.logMessage(f"(ModeleTerr) La couche {code_indic} ne contient aucune entité pour {str(aggr)}", "AgiRisk", Qgis.Warning)
        # Chacune des entités feat représente un niveau d'aggrégation spatiale donnée parmi : Entite / Commune / EPCI / Hexag_1ha à Hexag_100ha / IRIS
        if code_indic not in self.synthese_indic.keys():
            self.synthese_indic[code_indic] = {}
        for champ in self.dlg.ressources.codes_champs[code_indic]:
            if champ not in self.synthese_indic[code_indic].keys():
                self.synthese_indic[code_indic][champ] = {}
            for niv_zoom in self.dlg.ressources.lst_niv_zoom:
                if self.dlg.ressources.code_niv_zoom[niv_zoom][:3] != 'Hex':
                    self.synthese_indic[code_indic][champ][niv_zoom] = {}

        # self.synthese_indic[code_indic] = {
        #     "Entite": {},
        #     "IRIS": {},
        #     "Commune": {},
        #     "EPCI": {},
        #     "Hexag_1ha": {},
        #     "Hexag_5ha": {},
        #     "Hexag_10ha": {},
        #     "Hexag_50ha": {},
        #     "Hexag_100ha": {}
        # }


    ##########################################################################################################
    # Section interface avec la BDD
    ##########################################################################################################

    def lancement_calcul_bdd(self, pt_vue, variable):
        '''
        Méthode qui lance le calcul des variables, indicateurs ou représentations cartographiques en base de données. 
        TODO : récupérer les millésimes IrisGE disponibles
        TODO : récupérer les millésimes Carthage disponibles
        TODO : récupérer les millésimes Topage disponibles
        TODO : récupérer millésimes fichiers fonciers disponibles
        '''

        if variable == "__var_all":
            fonction = "__var_all_fct"
            # parametres = [self.terr,
            #                 '2021', # récupérer les millésimes fichiers fonciers disponibles
            #                 str(self.millesimes_choisis['adresse']),
            #                 str(self.millesimes_choisis['bdtopo']),
            #                 str(self.millesimes_choisis['gpu']),
            #                 '2022', # str(self.millesimes_choisis['iris']),
            #                 str(self.millesimes_choisis['rpg']),
            #                 str(self.millesimes_choisis['insee']),
            #                 str(self.millesimes_choisis['sirene']),
            #                 '2019'] # str(self.millesimes_choisis['topage'])]
            parametres = [self.terr, '2022', '2022', '2023', '2023', '2023', '2023', '2021', '2017', '2023', '2019', '2023']
            type = 'fonction'
        elif variable == "__indic_all":
            fonction = "__indic_all_fct"
            # parametres = [self.terr,
            #                 '2021',
            #                 str(self.millesimes_choisis['bdtopo']),
            #                 '2022']
            parametres = [self.terr, '2023', '2022']
            type = 'fonction'
        elif variable == "__indic_rc_all":
            fonction = "__indic_rc_all_fct"
            # parametres = [self.terr,
            #                 str(self.millesimes_choisis['bdtopo'])]
            parametres = [self.terr, '2023']
            type = 'fonction'
        else:
            fonction = ""
        if fonction != "":
            log_exec = self.bdd.lancement_calcul(fonction, parametres, type)
        
        return log_exec
