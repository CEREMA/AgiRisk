'''
    Class ArborescenceIndicateurs.py

    Cette classe permet de charger une carte mentale des indicateurs dans self.dlg.gl_tableau_indicateurs.

'''

import code
from PyQt5 import QtGui, QtWidgets
from PyQt5.QtWidgets import QHBoxLayout, QPushButton, QWidget, QVBoxLayout, QLayout
from PyQt5.QtGui import QPainter, QPen, QGradient, QColor, QIcon
from PyQt5.QtCore import Qt, QPoint, QSize
from qgis.core import QgsMessageLog, Qgis

import json, os, webbrowser

class ArborescenceIndicateurs:
    def __init__(self, parent=None, modele_terr=None):
        '''initialisation des listes, widgets et conteneurs. Création des widgets pour chaque point de vue de ressources.data et place par défaut sur le point de vue SNGRI.'''
        self.dlg = parent
        self.modele_terr = modele_terr
        self.liste_rep_carto_dispos_en_base = []
        self.liste_codes_indicateurs_dispos()
        self.widgets_indicateurs = {}
        self.conteneurs_widgets = {}
        self.main_layout = {}
        self.arbo_couches = {}
        # TODO : gérer le cochage / décochage des indicateurs dans self.arbo_couches

        self.data = self.dlg.ressources.data # Liste des points de vue et arborescences d'indicateurs associées
        self.indicateurs_retenus = {}
        self.liste_pts_vue = self.dlg.ressources.liste_pts_vue
        
        for pt_vue in self.liste_pts_vue:
            self.conteneurs_widgets[pt_vue] = QWidget(self.dlg.widget_14)
            self.dlg.layout_arborescences.addWidget(self.conteneurs_widgets[pt_vue])
            self.indicateurs_retenus[pt_vue] = {}
            
        self.init_arborescence()
        self.active_arborescence('SNGRI')


    def init_arborescence(self):
        '''Permet de créer à l'initialisation les arborescences de chaque point de vue'''
        for dict_pt_vue in self.data:
            # Création de l'arborescence
            code_pt_vue = dict_pt_vue['code']
            self.arbo_couches[code_pt_vue] = [{'type': "couche", 'code': "Territoire d'étude", 'style': "styles_territoires.qml"}]
            self.main_layout[code_pt_vue] = QVBoxLayout(self.conteneurs_widgets[code_pt_vue])
            self.main_layout[code_pt_vue].setSpacing(0)
            items_niveau_superieur = dict_pt_vue['enfants'] # Liste des macro_indicateurs / indicateurs à créer
            liste_item_crees, arbo_couche = self.charger_pt_vue(items_niveau_superieur, self.conteneurs_widgets[code_pt_vue], code_pt_vue)
            # Une fois les items créés, on les ajoute dans le layout de niveau supérieur
            for item in liste_item_crees:
                self.main_layout[code_pt_vue].addWidget(item.conteneur_parent)
                self.main_layout[code_pt_vue].update()
            # Une fois qu'on a mis à jour l'UI, on prépare l'arborescence du gestionnaire de couche
            self.modele_terr.def_dict_couches(code_pt_vue, arbo_couche)
            self.arbo_couches[code_pt_vue] += arbo_couche
            self.arbo_couches[code_pt_vue].append({'type': "groupe", 'nom_groupe': "Aléas", "enfants": []})
            self.arbo_couches[code_pt_vue].append({'type': "couche", 'code': "OpenStreetMap", 'style': "styles_osm.qml"})


    def active_arborescence(self, code_pt_vue):
        '''Permet d'activer le point de vue <code_pt_vue> et désactiver les autres'''
        [self.conteneurs_widgets[pt_vue].setVisible(code_pt_vue == pt_vue) for pt_vue in self.liste_pts_vue]


    def liste_codes_indicateurs_dispos(self):
        '''Ajout dans la liste_rep_carto_dispos_en_base des codes de chaque indicateurs'''
        for indic in self.dlg.liste_rep_carto_dispos_en_base:
            # Le code de l'indicateur est avant '_rc_' et le nom du territoire est après '_rc_'
            code_indic = indic.split('_rc_')[0]
            if code_indic not in self.liste_rep_carto_dispos_en_base:
                self.liste_rep_carto_dispos_en_base.append(code_indic)


    def charger_pt_vue(self, items_a_creer, widget_parent, code_pt_vue):
        '''La méthode sélectionne uniquement les indicateurs qui doivent apparaitre pour le point de vue sélectionné. Méthode qui crée l'ensemble des indicateurs, leurs boutons et leurs conteneurs d'éventuels enfants. On créé ensuite les objets enfants que l'on intègre aux conteneurs des parents'''
        if code_pt_vue not in self.widgets_indicateurs.keys():
            self.widgets_indicateurs[code_pt_vue] = {}
        item_crees = []
        arbo_couches = []
        for item in items_a_creer:
            code_indic = item['code'].replace("/", "_").lower() if 'code' in item.keys() else ""
            # Création de l'item qui contient le bouton correspondant à l'item et le conteneur des éventuels enfants
            if item['code'] not in self.widgets_indicateurs[code_pt_vue].keys():
                nom_complet = item['nom'] if "nom" in item.keys() else item['nom_reformule']
                lien_doc_web = item['lien_doc_web'] if "lien_doc_web" in item.keys() else None
                code_bouton = item['libelle'] if item['type'] == "macro_indic" else (item['nom_reformule'] if "nom_reformule" in item.keys() else item['code'])
                bouton_indicateur = "nom" not in item.keys()
                disponible = code_indic in self.liste_rep_carto_dispos_en_base if 'code' in item.keys() else False
                self.widgets_indicateurs[code_pt_vue][code_indic] = MacroItem(code_bouton, nom_complet, widget_parent, self, code_pt_vue, code_indic, lien_doc_web, bouton_indicateur, disponible)
                item_crees.append(self.widgets_indicateurs[code_pt_vue][code_indic])
                if bouton_indicateur:
                    arbo_couches.append({'type': "couche", 'code': code_indic, 'style': item['style']} if 'style' in item.keys() else {'type': "couche", 'code': code_indic})
            else:
                QgsMessageLog.logMessage(f"L'indicateur {item['code']} est déjà présent dans l'aborescence du point de vue, le doublon n'a pas été inséré.", "AgiRisk", level=Qgis.Warning)
            
            # S'il y a des enfants, on crée puis on ajoute les enfants
            if item['type'] == "macro_indic":
                if "enfants" in item.keys():
                    item_enfant_crees, arbo_couches_enfants = self.charger_pt_vue(item['enfants'], self.widgets_indicateurs[code_pt_vue][code_indic].conteneur_enfants, code_pt_vue)
                    arbo_couches.append({'type': "groupe", 'nom_groupe': item['libelle'], 'enfants': arbo_couches_enfants})
                    for item_enfant in item_enfant_crees:
                        self.widgets_indicateurs[code_pt_vue][code_indic].ajout_enfant(item_enfant)
                else:
                    arbo_couches.append({'type': "groupe", 'nom_groupe': item['libelle'], 'enfants': []})
        return item_crees, arbo_couches
    

    def liste_indicateurs(self):
        '''Retourne la liste des indicateurs en liste de code_indicateurs pour le point de vue actif'''
        liste_indicateurs = []
        for dict_pt_vue in self.data:
            if dict_pt_vue['code'] == self.dlg.pt_vue_actif:
                liste_indicateurs = self.list_recurs(dict_pt_vue['enfants'])

        return liste_indicateurs

    
    def list_recurs(self, items):
        '''Appel récursif pour récupérer tous les enfants d'un dictionnaire contenant la clef ['enfants'] récursivement.'''
        res = []
        for item in items:
            if "enfants" not in item.keys():
                res += [item]
            else:
                res += self.list_recurs(item["enfants"])
        return res


    def etats_indicateurs(self):
        ''' Cette fonction permet de retourner la liste widgets macro_item qui contient pour chaque indicateur le caractère retenu ou non par l'utilisateur '''
        # Ci-dessous syntaxe pour retourner la liste des macro_item indicateurs du point de vue actif
        return [self.widgets_indicateurs[self.dlg.pt_vue_actif][code_indic] for code_indic in self.widgets_indicateurs[self.dlg.pt_vue_actif].keys()]


    def maj_indic_retenus(self, code_pt_vue, code_indic, checked):
        ''' Permet de faire 'remonter dans l'héritage' la sélection d'un indicateur.'''

        if checked:
            self.indicateurs_retenus[code_pt_vue][code_indic] = True
        else:
            self.indicateurs_retenus[code_pt_vue][code_indic] = False


class AideItem(QPushButton):
    def __init__(self, lien_doc_web, *args):
        '''Création et positionnement de l'icone contenant le lien vers la doc web pour une action'''
        super().__init__(*args)
        if lien_doc_web:
            
            self.lien_doc_web = lien_doc_web
            self.setFixedSize(QSize(20, 20))
            self.setIcon(QIcon(os.path.join(os.path.dirname(__file__), "../ressources/aide.png")))
            self.setIconSize(QSize(15, 15))
            self.clicked.connect(self.ouvrir_aide)
        self.setStyleSheet("QPushButton {border: none; background-color: transparent;}")
    

    def ouvrir_aide(self):
        # Ouverture de la page web de l'aide
        webbrowser.open(self.lien_doc_web)


class Item(QPushButton):
    def __init__(self, *args, aieul=None, code_pt_vue="", code_indic="", lien_doc_web=None, bouton_indicateur=False, disponible=False):
        super().__init__(*args)
        '''Création du layout de l'indicateur dans l'arborescence, paramètrage du layout et positionnement des éléments du layout (texte, icone d'aide...).
        Le style s'adapte au fait que l'indicateur est sélectionné (vert et icone d'aide), non sélectionné (gris et icone d'aide) ou si ce n'est pas un indicateur mais un thême d'inidcateur (bleu sans icone d'aide). La sélection ou la déselection d'un indicateur entraîne son changement d'état par la méthode suivante, mais la connexion du clic au slot ce fait dans la présente méthode.'''

        self.couleurs = {True: "rgb(96, 180, 103)", False: "#f2f2f2"}
        self.coul_texte = {True: "white", False: "#969696"}
        self.coul_bordure = {True: "none", False: "none"} # 1px solid #EF7858
        self.retenu = False
        self.indicateur = bouton_indicateur
        self.aieul = aieul
        self.code_indic = code_indic
        self.code_pt_vue = code_pt_vue


        # Ajout d'un layout pour positionner le bouton d'aide à droite
        self.layout = QHBoxLayout()
        self.layout.setContentsMargins(80, 0, 0, 0)
        self.layout.setSpacing(0)
        self.setLayout(self.layout)
        
        # Ajout d'un bouton à l'intérieur du bouton self pour afficher l'aide du site web
        self.bt_aide = AideItem(lien_doc_web, "", self)
        self.layout.addWidget(self.bt_aide)
        self.layout.setAlignment(self.bt_aide, Qt.AlignRight)

        
        self.setAttribute(Qt.WA_StyledBackground) #Allow stylesheet
        self.setFixedHeight(30)
        self.setFixedWidth(550 if self.indicateur else 160)

        self.change_etat() if self.indicateur else self.setStyleSheet("background-color:rgb(90, 113, 180);border:none; border-radius:2px; color:white; margin:0px; padding:0px; margin-top:1px")
        self.change_etat() if not disponible else None
        self.setEnabled(disponible)

        # Connexion du signal clicked au slot
        # self.clicked.connect(self.change_etat) # Désactivation de la fonctionnalité de sélection des indicateurs pour la v1


    def change_etat(self):
        '''Change le layout d'un indicateur au moment de sa sélection'''
        if self.indicateur:
            self.retenu = not self.retenu
            self.aieul.maj_indic_retenus(self.code_pt_vue, self.code_indic, self.retenu)
            self.setStyleSheet(f"background-color:{self.couleurs[self.retenu]};border:{self.coul_bordure[self.retenu]}; border-radius:2px; color:{self.coul_texte[self.retenu]}; margin:0px; padding:0px; margin-top:1px")


    def change_dispo(self, disponible):
        '''Change le layout d'un indicateur lors de sa déselection'''
        if self.indicateur:
            self.retenu = disponible
            self.aieul.maj_indic_retenus(self.code_pt_vue, self.code_indic, self.retenu)
            self.setStyleSheet(f"background-color:{self.couleurs[self.retenu]};border:{self.coul_bordure[self.retenu]}; border-radius:2px; color:{self.coul_texte[self.retenu]}; margin:0px; padding:0px; margin-top:1px")
            self.setEnabled(disponible)


class GroupeEnfants(QWidget):
    def __init__(self, *args):
        '''Initialisation du nombre d'enfant'''
        super().__init__(*args)
        self.nbr_enfants = 0
        # Réduit la taille horizontale du widget au minimum
        # self.setMinimumWidth(0)


    def nouvel_enfant(self):
        '''A chaque nouvel enfant, on le compte dans nbr_enfants, qui sert à définir la longueur de la ligne faisant lien entre un parent et ses enfants'''
        self.nbr_enfants += 1


    def paintEvent(self, event):
        '''Création des lignes parents/enfants dans l'affichage des actions'''
        if self.nbr_enfants > 1:
            r = event.rect()
            top_left = r.topLeft()
            top_right = r.topRight()
            bottom_left = r.bottomLeft()
            bottom_right = r.bottomRight()
            p = QPainter(self)
            pen = p.pen()
            pen.setColor(QColor(Qt.black))
            p.setPen(pen)
            p.setRenderHint(QPainter.Antialiasing) 
            pen.setWidth(2)
            p.drawLine(QPoint(top_left.x() + 10, top_left.y() + 10), QPoint(bottom_left.x() + 10, bottom_left.y() - 10))
            p.drawLine(QPoint(top_left.x(), int(abs(top_left.y() - bottom_left.y()) / 2)), QPoint(top_left.x() + 10, int(abs(top_left.y() - bottom_left.y()) / 2)))


class MacroItem():
    def __init__(self, indic, tooltip, parent=None, aieul=None, code_pt_vue="", code_indic="", lien_doc_web=None, bouton_indicateur=False, disponible=False):
        '''Méthode organisant les actions en colonne différenciées si l'indicateur est enfant ou parent en ajoutant les actions dans les bons widgets avec les bons layout, en particulier rendre cliquable ou non les indicateurs.'''
        self.indic = indic
        self.conteneur_parent = QWidget(parent)
        self.conteneur_parent.setAttribute(Qt.WA_StyledBackground) #Allow stylesheet
        self.conteneur_parent.setStyleSheet("margin:0px; margin-left:10px; padding:0px;")
        
        self.bouton = Item(self.indic, self.conteneur_parent, aieul=aieul, code_pt_vue=code_pt_vue, code_indic=code_indic, lien_doc_web=lien_doc_web, bouton_indicateur=bouton_indicateur, disponible=disponible)
        self.bouton.setToolTip(tooltip)

        self.conteneur_enfants = GroupeEnfants(self.conteneur_parent)
        self.conteneur_enfants.setAttribute(Qt.WA_StyledBackground) #Allow stylesheet
        self.conteneur_enfants.setStyleSheet("margin:0px; padding:0px")

        self.layout_parent = QHBoxLayout(self.conteneur_parent)
        self.layout_parent.addWidget(self.bouton)
        self.layout_parent.addWidget(self.conteneur_enfants)
        self.layout_parent.setSpacing(0)
        self.layout_parent.setContentsMargins(10,0,0,0)
        
        self.layout_enfants = QVBoxLayout(self.conteneur_enfants)
        self.layout_enfants.setSpacing(0)
        self.layout_enfants.setContentsMargins(10,0,0,0)
        self.enfants = []


    def set_visible(self, visible):
        '''Rend la colonne des parents visible'''
        self.conteneur_parent.setVisible(visible)
   
   
    def ajout_enfant(self, enfant):
        '''On ajoute les enfants dans le widget du parent et on adapte la longueur de la ligne faisant le lien entre parent et enfants '''
        self.enfants.append(enfant.conteneur_parent)
        self.layout_enfants.addWidget(enfant.conteneur_parent)
        self.conteneur_enfants.nouvel_enfant()

