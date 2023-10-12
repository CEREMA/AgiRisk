'''
    Class ArborescenceActions.py

    Cette classe permet de charger un tableau interactif de choix des actions.

'''

from PyQt5 import QtGui, QtWidgets
# from PyQt5.QtWidgets import QHBoxLayout, QPushButton, QWidget, QVBoxLayout, QLayout
from PyQt5.QtGui import QPainter, QPen, QGradient, QColor, QIcon
from PyQt5.QtCore import Qt, QPoint, QSize

from qgis.core import QgsMessageLog, Qgis
from qgis.PyQt.QtCore import QCoreApplication, QVariant
from qgis.PyQt.QtWidgets import QWidget, QVBoxLayout, QHBoxLayout, QPushButton

import json, os, webbrowser
from functools import partial

class ArborescenceActions:
    def __init__(self, parent=None):
        '''L'initialisation de la classe se limite aux initialisations d'attributs et à la création du layout principal de l'arborescence'''
        self.dlg = parent

        self.widgets_actions = {}
        self.lst_indic_retenus = {}

        # Préparation du conteneur des actions
        self.layout_super = QVBoxLayout(self.dlg.w_conteneur_glob_actions)
        self.layout_super.setSpacing(0)
        self.layout_super.setContentsMargins(0,0,0,0)


    def afficher_onglet(self):
        '''Méthode appelée par le clic sur le bouton du menu pour afficher l'onglet correspondant
        L'objectif de cette méthode est d'appeler, seulement si nécessaire, les méthodes d'initialisation 
        de l'arborescence des actions et de la combobox des indicateurs retenus'''

        # On vérifie si le point de vue actif a déjà été initialisé
        init_lst_indic_retenus = self.dlg.pt_vue_actif not in self.lst_indic_retenus.keys()
        init_widgets_actions = self.dlg.pt_vue_actif not in self.widgets_actions.keys()
        if init_lst_indic_retenus  or init_widgets_actions:
            self.lst_indic_retenus[self.dlg.pt_vue_actif] = {}
            self.widgets_actions[self.dlg.pt_vue_actif] = {}

        # On charge ensuite l'arborescence des actions en lien avec les indicateurs et on complète les items de la combobox des indicateurs retenus
        self.maj_onglet()

    
    def maj_onglet(self):
        '''Méthode qui permet de mettre à jour la combobox des indicateurs retenus et 
        l'arborescence des actions en fonction des indicateurs choisis par l'utilisateur'''
        
        # On déconnecte le signal avant d'éventuellement modifier la combobox
        try:
            self.dlg.cb_lst_indic_retenus.currentIndexChanged.disconnect(self.active_arborescence)
        except: 
            pass
        
        # On parcours ensuite la liste des indicateurs retenus pour vérifier si de nouveaux indicateurs ont été retenus ou écartés
        lst_indic_cb = [key for key in self.lst_indic_retenus[self.dlg.pt_vue_actif].keys()]
        for indic, widget_indic in self.dlg.modele_terr_actif.arbo_indicateurs.widgets_indicateurs[self.dlg.pt_vue_actif].items():
            if widget_indic.bouton.retenu == True:
                if indic not in lst_indic_cb:
                    self.lst_indic_retenus[self.dlg.pt_vue_actif][indic] = {"code_indic": indic, "nom_indic": widget_indic.bouton.text()}
                    lst_indic_cb.append(indic)
                    self.dlg.cb_lst_indic_retenus.addItem(widget_indic.bouton.text())
            else:
                pass
                # TODO : On traite le cas où un indicateur a été écarté (NB : cela supprime aussi le widget associé)
                # if indic in lst_indic_cb:
                #     for dic in self.lst_indic_retenus[self.dlg.pt_vue_actif]:
                #         try:
                #             if dic["code_indic"] == indic:
                #                 self.lst_indic_retenus[self.dlg.pt_vue_actif].pop(indic)
                #         except:
                #             pass
        
        # Mise à jour de la combobox des indicateurs retenus
        self.dlg.cb_lst_indic_retenus.clear()
        for indic in self.lst_indic_retenus[self.dlg.pt_vue_actif].keys():
            self.dlg.cb_lst_indic_retenus.addItem(self.lst_indic_retenus[self.dlg.pt_vue_actif][indic]["nom_indic"])
        
        # Reconnexion du signal de la combobox
        self.dlg.cb_lst_indic_retenus.currentIndexChanged.connect(self.active_arborescence)

        # On lance la reconstruction / màj de l'arborescence des actions
        for code_indic, dic in self.lst_indic_retenus[self.dlg.pt_vue_actif].items():
            if "widget" not in dic.keys():
                dic["widget"] = QWidget(self.dlg.w_conteneur_glob_actions)
                self.layout_super.addWidget(dic["widget"])
                dic["layout"] = QVBoxLayout(dic["widget"])
                dic["layout"].setSpacing(0)
                items_niveau_superieur = self.dlg.bdd.recup_actions(code_indic) # Liste des actions correspondant à l'indicateur
                liste_item_crees = self.charger_actions(items_niveau_superieur, dic["widget"], code_indic)

                # Une fois les items créés, on les ajoute dans le layout de niveau supérieur
                for item in liste_item_crees:
                    dic["layout"].addWidget(item.conteneur_parent)
                    dic["layout"].update()
            
        # On met à jour l'affichage de l'arborescence
        self.active_arborescence()
        
        
    def active_arborescence(self):
        '''Permet d'activer l'affichage de l'indicateur et désactiver les autres'''

        # On cache les arborescences éventuelles correspondant à un autre point de vue que le point de vue actif
        for pt_vue in self.lst_indic_retenus.keys():
            if pt_vue != self.dlg.pt_vue_actif:
                [dic["widget"].setVisible(False) for dic in self.lst_indic_retenus[pt_vue].values()]

        # Tant qu'un indicateur n'est pas sélectionné dans la combobox, on cache toutes les arborescences
        if self.dlg.cb_lst_indic_retenus.currentIndex() == -1:
            [dic["widget"].setVisible(False) for dic in self.lst_indic_retenus[self.dlg.pt_vue_actif].values()]
        else:
            indic_choisi = self.dlg.cb_lst_indic_retenus.currentText()
            for dic in self.lst_indic_retenus[self.dlg.pt_vue_actif].values():
                dic["widget"].setVisible(indic_choisi == dic["nom_indic"])


    def charger_actions(self, items_a_creer, widget_parent, code_indic):
        '''Méthode qui crée l'ensemble des items, leurs boutons et leurs conteneurs d'éventuels enfants. On créé ensuite les objets enfants que l'on intègre aux conteneurs des parents'''
        
        # On vérifie si le point de vue actif et l'indicateur fourni en argument ont déjà été initialisés
        if self.dlg.pt_vue_actif not in self.widgets_actions.keys():
            self.widgets_actions[self.dlg.pt_vue_actif] = {}
        if code_indic not in self.widgets_actions[self.dlg.pt_vue_actif].keys():
            self.widgets_actions[self.dlg.pt_vue_actif][code_indic] = {}

        item_crees = []
        for item in items_a_creer:
            nom_action = item['nom'] if 'nom' in item.keys() else ""
            # Création de l'item qui contient le bouton correspondant à l'item et le conteneur des éventuels enfants
            if item['nom'] not in self.widgets_actions[self.dlg.pt_vue_actif][code_indic].keys():
                bouton_action = not item['macro_action'] if "macro_action" in item.keys() else False
                infobulle = item['code'] if "code" in item.keys() else ""
                infobulle += item['axe'] if "axe" in item.keys() else ""
                lien_doc = "https://projet-agirisk.gitlab.io/site_web/04_ReferentielActions/" if "doc_fiche_action" in item.keys() and item['doc_fiche_action'] is not None else "" #"https://projet-agirisk.gitlab.io/site_web/04_ReferentielActions/ReferentielActions/"
                lien_doc += item['doc_fiche_action'] if "doc_fiche_action" in item.keys() and item['doc_fiche_action'] is not None else ""
                self.widgets_actions[self.dlg.pt_vue_actif][code_indic][item['code']] = MacroItem(widget_parent, self, code_indic, nom_action, lien_doc, bouton_action, infobulle)
                item_crees.append(self.widgets_actions[self.dlg.pt_vue_actif][code_indic][item['code']])
            else:
                QgsMessageLog.logMessage(f"L'action {item['nom']} est déjà présente dans l'aborescence, le doublon n'a pas été inséré.", "AgiRisk", level=Qgis.Warning)
            
            # S'il y a des enfants, on crée puis on ajoute les enfants
            if "sous_actions" in item.keys():
                item_enfant_crees = self.charger_actions(item['sous_actions'], self.widgets_actions[self.dlg.pt_vue_actif][code_indic][item['code']].conteneur_enfants, code_indic)
                for item_enfant in item_enfant_crees:
                    self.widgets_actions[self.dlg.pt_vue_actif][code_indic][item['code']].ajout_enfant(item_enfant)
        return item_crees


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
    def __init__(self, *args, aieul=None, nom_action="", lien_doc="", bouton_action=False):
        '''Création du layout de l'action dans l'arborescence, paramètrage du layout et positionnement des éléments du layout (texte, icone d'aide...).
        Le style s'adapte au fait que l'action est une action. Si l'action n'est pas une action retenue, la méthode suivante change sa représentation'''
        super().__init__(*args)

        self.couleurs = {True: "rgb(96, 180, 103)", False: "#f2f2f2"}
        self.coul_texte = {True: "white", False: "#969696"}
        self.coul_bordure = {True: "none", False: "none"} # 1px solid #EF7858
        self.retenu = True
        self.est_une_action = bouton_action
        self.aieul = aieul

        # Ajout d'un layout pour positionner le bouton d'aide à droite
        self.layout = QHBoxLayout()
        self.layout.setContentsMargins(80, 0, 0, 0)
        self.layout.setSpacing(0)
        self.setLayout(self.layout)
        
        # Ajout d'un bouton à l'intérieur du bouton self pour afficher l'aide du site web
        self.bt_aide = AideItem(lien_doc, "", self)
        self.layout.addWidget(self.bt_aide)
        self.layout.setAlignment(self.bt_aide, Qt.AlignRight)

        self.setAttribute(Qt.WA_StyledBackground) #Allow stylesheet
        self.setFixedHeight(30)
        self.setFixedWidth(350 if self.est_une_action else 300)

        self.change_etat() if self.est_une_action else self.setStyleSheet("background-color:rgb(90, 113, 180);border:none; border-radius:2px; color:white; margin:0px; padding:0px; margin-top:1px")

        # Connexion du signal clicked au slot
        self.clicked.connect(self.change_etat)


    def change_etat(self):
        '''Change le style du layout de l'action si celle-ci n'en est pas une action retenue'''
        if self.est_une_action:
            self.retenu = not self.retenu
            self.setStyleSheet(f"background-color:{self.couleurs[self.retenu]};border:{self.coul_bordure[self.retenu]}; border-radius:2px; color:{self.coul_texte[self.retenu]}; margin:0px; padding:0px; margin-top:1px")


class GroupeEnfants(QWidget):
    def __init__(self, *args):
        '''initialisation du nombre d'enfant'''
        super().__init__(*args)
        self.nbr_enfants = 0
        

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
    def __init__(self, parent=None, aieul=None, mode="", nom_action="", lien_doc=None, bouton_action=False, infobulle=""):
        '''Méthode organisant les actions en colonne différenciées si l'action est enfant ou parent en ajoutant les actions dans les bons widgets avec les bons layout'''
        self.nom_action = nom_action
        self.conteneur_parent = QWidget(parent)
        self.conteneur_parent.setAttribute(Qt.WA_StyledBackground) #Allow stylesheet
        self.conteneur_parent.setStyleSheet("margin:0px; margin-left:10px; padding:0px;")
        
        self.bouton = Item(self.nom_action, self.conteneur_parent, aieul=aieul, nom_action=nom_action, lien_doc=lien_doc, bouton_action=bouton_action)
        self.bouton.setToolTip(infobulle)

        self.conteneur_enfants = GroupeEnfants(self.conteneur_parent)
        self.conteneur_enfants.setAttribute(Qt.WA_StyledBackground) #Allow stylesheet
        self.conteneur_enfants.setStyleSheet("margin:0px; padding:0px")
        #self.conteneur_enfants.setMaximumWidth(50)

        self.layout_parent = QHBoxLayout(self.conteneur_parent)
        self.layout_parent.addWidget(self.bouton)
        self.layout_parent.addWidget(self.conteneur_enfants)
        self.layout_parent.setSpacing(0)
        self.layout_parent.setContentsMargins(10,0,0,0)
        #self.layout_parent.setSizeConstraint(QLayout.SetMinimumSize)
        
        self.layout_enfants = QVBoxLayout(self.conteneur_enfants)
        self.layout_enfants.setSpacing(0)
        self.layout_enfants.setContentsMargins(10,0,0,0)
        self.enfants = []

  
    def set_visible(self, visible):
        '''rend la colonne des parents visible'''
        self.conteneur_parent.setVisible(visible)


    def ajout_enfant(self, enfant):
        '''On ajoute les enfants dans le widget du parent et on adapte la longueur de la ligne faisant le lien entre parent et enfants '''
        self.enfants.append(enfant.conteneur_parent)
        self.layout_enfants.addWidget(enfant.conteneur_parent)
        self.conteneur_enfants.nouvel_enfant()

