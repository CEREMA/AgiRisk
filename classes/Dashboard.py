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

from PyQt5 import QtCore
from PyQt5.QtCore import Qt, QObject, QVariant
from PyQt5.QtGui import QColor
from PyQt5.QtQuick import QQuickView
from PyQt5.QtWidgets import QWidget
from qgis.PyQt.QtCore import QUrl, Qt
from qgis.PyQt.QtWidgets import QWidget, QDockWidget
from qgis.core import QgsMessageLog, Qgis
from qgis.utils import iface
from .Cards import Card
import os

class Dashboard():
    def __init__(self, dlg, mt):
        self.dlg = dlg
        self.mt = mt
        self.pt_vue = None
        self.dash = {}
        self.cards = {}

        self.qml = os.path.join(os.path.dirname(__file__), 'dashboard.qml')

        self.init_ptvue_sngri()
        self.init_ptvue_amenagement()
        self.init_ptvue_crise()


    def init_ptvue_sngri(self):
        self.cards['SNGRI'] = {
            "s3_1a": {
                "icone": 's3_1a.png',
                "code": 's3_1a',
                "text": self.dlg.ressources.legendes_couches['s3_1a'],
                "suffixe": 'occ.',
                "coords": [30, 50, 250, 100]
            },
            "s1_2a": {  "icone": 's1_2a.png',
                "code": 's1_2a',
                "text": self.dlg.ressources.legendes_couches["s1_2a"],
                "suffixe": 'occ.',
                "coords": [30, 180, 250, 100]
            },
            "s1_2b": {
                "icone": 's1_2b.png',
                "code": 's1_2b',
                "text": self.dlg.ressources.legendes_couches["s1_2b"],
                "suffixe": 'occ.',
                "coords": [30, 310, 250, 100]
            },
            "s2_2a_amc": {
                "icone": 's2_2a.png',
                "code": 's2_2a_amc',
                "text": self.dlg.ressources.legendes_couches["s2_2a_amc"],
                "suffixe": '€',
                "coords": [390, 50, 250, 80]
            },
            "s2_6a": {
                "icone": 's2_6a.png',
                "code": 's2_6a',
                "text": self.dlg.ressources.legendes_couches["s2_6a"],
                "suffixe": '€',
                "coords": [390, 150, 250, 80]
            },
            "s2_14a": {
                "icone": 's2_14a.png',
                "code": 's2_14a',
                "text": self.dlg.ressources.legendes_couches["s2_14a"],
                "suffixe": 'ha',
                "coords": [390, 260, 250, 150]
            },
            "s3_1abis": {
                "icone": 's3_1a.png',
                "code": 's3_1a',
                "text": self.dlg.ressources.legendes_couches["s3_1a"],
                "suffixe": 'occ.',
                "coords": [750, 50, 250, 80]
            },
            "s3_1f": {
                "icone": 's3_1f.png',
                "code": 's3_1f',
                "text": self.dlg.ressources.legendes_couches["s3_1f"],
                "suffixe": 'ha',
                "coords": [750, 150, 250, 80]
            },
            "s3_2b": {
                "icone": 's3_2b.png',
                "code": 's3_2b',
                "text": self.dlg.ressources.legendes_couches["s3_2b"],
                "suffixe": 'pers.',
                "coords": [750, 260, 250, 150]
            }
        }

        for code, card in self.cards['SNGRI'].items():
            card['card'] = Card(card['icone'], card['text'], self.dlg.db_sngri, card['coords'], card['suffixe'], card['code'], self.dlg, self.mt)
            if code in ["s2_14a", "s3_2b"]:
                card['conteneur'] = card['card'].set_quickview()


    def init_ptvue_amenagement(self):
        self.cards['Aménagement'] = {
            "logt_zx": {
                "icone": 's1_2a.png',
                "code": 'logt_zx',
                "text": self.dlg.ressources.legendes_couches["logt_zx"],
                "suffixe": 'logt.',
                "coords": [30, 50, 250, 100]
            },
            "s2_2a_amc": {
                "icone": 's2_2a.png',
                "code": 's2_2a_amc',
                "text": self.dlg.ressources.legendes_couches["s2_2a_amc"],
                "suffixe": '€',
                "coords": [30, 180, 250, 100]
            },
            "s2_6a": {
                "icone": 's2_6a.png',
                "code": 's2_6a',
                "text": self.dlg.ressources.legendes_couches["s2_6a"],
                "suffixe": '€',
                "coords": [390, 50, 250, 100]
            },
            "s2_7a": {
                "icone": 's2_7a.png',
                "code": 's2_7a',
                "text": self.dlg.ressources.legendes_couches["s2_7a"],
                "suffixe": '€',
                "coords": [390, 180, 250, 100]
            },
            "salaries_zx": {
                "icone": 's2_7a.png',
                "code": 'salaries_zx',
                "text": self.dlg.ressources.legendes_couches["salaries_zx"],
                "suffixe": 'salariés',
                "coords": [390, 310, 250, 100]
            },
            "s2_14a": {
                "icone": 's2_14a.png',
                "code": 's2_14a',
                "text": self.dlg.ressources.legendes_couches["s2_14a"],
                "suffixe": 'ha',
                "coords": [750, 50, 250, 150]
            },
            "s3_2b": {
                "icone": 's3_2b.png',
                "code": 's3_2b',
                "text": self.dlg.ressources.legendes_couches["s3_2b"],
                "suffixe": 'pers.',
                "coords": [750, 230, 250, 150]
            }
        }

        for code, card in self.cards['Aménagement'].items():
            card['card'] = Card(card['icone'], card['text'], self.dlg.db_amenagement, card['coords'], card['suffixe'], card['code'], self.dlg, self.mt)
            if code in ["s2_14a", "s3_2b"]:
                card['conteneur'] = card['card'].set_quickview()


    def init_ptvue_crise(self):
        self.cards['Crise'] = {
            "s3_1a": {
                "icone": 's3_1a.png',
                "code": 's3_1a',
                "text": self.dlg.ressources.legendes_couches['s3_1a'],
                "suffixe": 'occ.',
                "coords": [30, 50, 250, 100]
            },
            "pop_agee_zx": {
                "icone": 'pop_agee_zx.png',
                "code": 'pop_agee_zx',
                "text": self.dlg.ressources.legendes_couches['pop_agee_zx'],
                "suffixe": 'occ.',
                "coords": [30, 180, 250, 100]
            },
            "s3_2b": {
                "icone": 's3_2b.png',
                "code": 's3_2b',
                "text": self.dlg.ressources.legendes_couches["s3_2b"],
                "suffixe": 'pers.',
                "coords": [750, 50, 250, 150]
            }
        }

        for code, card in self.cards['Crise'].items():
            card['card'] = Card(card['icone'], card['text'], self.dlg.db_crise, card['coords'], card['suffixe'], card['code'], self.dlg, self.mt)
            if code in ["s2_14a", "s3_2b"]:
                card['conteneur'] = card['card'].set_quickview()


    def maj_secteur_etude(self):
        '''Cette méthode déclenche la mise à jour de l'onglet dashboard (cards et quickviews associées)
        Elle est sans effet sur le ou les QDockWidget qui dépendent de l'échelle de synthèse
        '''
        for pt_vue in ['SNGRI', 'Aménagement', 'Crise']:
            for code, card in self.cards[pt_vue].items():
                if card['code'] in self.dlg.modele_terr_actif.synthese_indic.keys():
                    regr = {}
                    for champ in self.dlg.ressources.codes_champs[card['code']]:
                        regroupement = self.dlg.modele_terr_actif.synthese_indic[card['code']][champ][self.dlg.echelle]
                        if len(regroupement.keys()) > 0:
                            sect_etude = self.dlg.cbox_secteur_etude.currentText()
                            if sect_etude in regroupement.keys():
                                regr[champ] = regroupement[sect_etude]
                            else:
                                regr[champ] = -9999
                    for champ, valeur in regr.items():
                        card['card'].change_value(champ, valeur)
                    card['card'].update()


    def maj_echelle_synthese(self):
        '''Cette méthode déclenche la mise à jour de la liste des secteurs d'étude associés à l'échelle de synthèse choisie'''
        self.dlg.cbox_secteur_etude.currentIndexChanged.disconnect(self.dlg.maj_secteur_etude)
        self.dlg.cbox_secteur_etude.clear()
        ens_secteurs = []
        for indic in self.mt.synthese_indic.keys():
            champ = self.dlg.ressources.codes_champs[indic][0]
            if self.dlg.echelle in self.mt.synthese_indic[indic][champ].keys():
                secteurs = self.mt.synthese_indic[indic][champ][self.dlg.echelle].keys()
                for sect in secteurs:
                    ens_secteurs.append(sect) if sect not in ens_secteurs and not(isinstance(sect, QVariant)) else None
        self.dlg.cbox_secteur_etude.addItems(ens_secteurs)
        self.dlg.cbox_secteur_etude.setCurrentIndex(-1)
        self.dlg.cbox_secteur_etude.currentIndexChanged.connect(self.dlg.maj_secteur_etude)
        # Une fois la comboBox mise à jour, on sélectionne par défaut le premier secteur d'étude pour déclencer la mise à jour du dashboard
        self.dlg.cbox_secteur_etude.setCurrentIndex(0)
        self.dlg.cbox_secteur_etude.currentIndexChanged.emit(0)

        # Affichage de l'aléa dans le dashboard
        self.dlg.lbl_type_alea_dashboard_value.setText(f"{self.mt.type_alea}")
        self.dlg.lbl_occurrence_dashboard_value.setText(f"{self.mt.occurrence}")

        # On lance la mise à jour des QDockWidget
        if self.dlg.chb_diagrammes.isChecked():
            self.charger_dashboard()


    def charger_dashboard(self):
        '''Cette méthode charge le dashboard correspondant au pt_vue passé en argument'''
        # TODO : rendre la fonction insensible à la composition de self.dlg.modele_terr_actif.synthese_indic

        self.pypie = PyPie()

        parcouru = False
        # Etape 1 : on extrait les regroupements de valeurs pour les indicateurs sélectionnés
        regroupements = {}
        for indic in self.dlg.modele_terr_actif.synthese_indic.keys():
            if indic in self.cards[self.dlg.pt_vue_actif].keys():
                if self.cards[self.dlg.pt_vue_actif][indic]['card'].selectionne:
                    # On affiche dans le dockwidget le dashboard correspondant au premier champ récupéré pour l'indicateur
                    champ = self.dlg.ressources.codes_champs[indic][0]
                    regroupements[indic] = self.mt.synthese_indic[indic][champ][self.dlg.echelle]
        
        # Etape 2 : on ordonne les regroupements de valeurs de façon à ce que les clés soient dans le même ordre
        # On récupère la liste des clés pour chaque regroupement
        ens_cles = []
        for regroupement in regroupements.values():
            ens_cles.append(list(regroupement.keys()))
        # On récupère la liste des clés communes à tous les regroupements
        zones_communes = ens_cles[0] if len(ens_cles) > 0 else []
        for ens in ens_cles:
            zones_communes = [zone for zone in zones_communes if zone in ens]
        zones_communes = sorted(zones_communes)
        # On construit les regroupements ordonnés
        regroupements_ord = {"zones": zones_communes}
        for indic in self.dlg.modele_terr_actif.synthese_indic.keys():
            if indic in self.cards[self.dlg.pt_vue_actif].keys():
                if self.cards[self.dlg.pt_vue_actif][indic]['card'].selectionne:
                    regroupements_ord[indic] = []
                    for zone in regroupements_ord["zones"]:
                        regroupements_ord[indic].append(regroupements[indic][zone])

        # Etape 3 : on crée le dashboard
        if len(regroupements_ord["zones"]) > 0 and len(regroupements_ord.keys()) > 1:
            for zone in regroupements_ord["zones"]:
                self.pypie.add_category(zone)
            for indic in regroupements_ord.keys():
                if indic != "zones":
                    self.pypie.add_barset(self.dlg.ressources.legendes_couches[indic], regroupements_ord[indic])
                    self.pypie.def_mini(0)
                    self.pypie.def_maxi(int(round(max(regroupements_ord[indic]), -1 * (int(len(str(max(regroupements_ord[indic])))) - 1))))
                    parcouru = True

        if parcouru:
            self.view = QQuickView()
            self.view.setResizeMode(QQuickView.SizeRootObjectToView)
            self.view.setColor(QColor("#404040"))
            self.view.rootContext().setContextProperty("pypie", self.pypie) # Doit être fait avant le setSource
            self.view.setSource(QUrl.fromLocalFile(self.qml))

            if self.view.status() == QQuickView.Error:
                for error in self.view.errors():
                    QgsMessageLog.logMessage(error.description(), "AgiRisk", level=Qgis.Info)
            else:
                self.container = QWidget.createWindowContainer(self.view)
                self.widget = QDockWidget()
                self.widget.setWidget(self.container)
                self.widget.setMinimumHeight(300)
                self.widget.setVisible(True)
                iface.addDockWidget(Qt.BottomDockWidgetArea, self.widget)


class PyPie(QObject):
    titleUpdate = QtCore.pyqtSignal(str)
    categoriesUpdate = QtCore.pyqtSignal(list)
    miniUpdate = QtCore.pyqtSignal(int)
    maxiUpdate = QtCore.pyqtSignal(int)

    def __init__(self):
        '''Permet d'ouvrir la fenêtre graphique dans qgis '''
        super().__init__()

        self._title = "Chart Title"
        self._barsets = {} #{ "pop_zi": [20, 15, 12], "pop_zq_fort": [12, 30, 10], "pop_zq_faible": [10, 20, 30] } # Hypothèse 3 EPCI
        self._categories = [] #["EPCI 1", "EPCI 2", "EPCI 3"]
        self._mini = 0
        self._maxi = 100

    '''Gestion du titre du graphique'''
    @QtCore.pyqtProperty(str, notify=titleUpdate)
    def title(self):
        return self._title

    @title.setter
    def title(self, title):
       if self._title != title:
          self._title = title
          self.titleUpdate.emit(self._title)

    '''Gestion des noms de colonnes du graphique'''
    @QtCore.pyqtProperty(list, notify=categoriesUpdate)
    def categories(self):
         return self._categories

    @categories.setter
    def categories(self, liste):
        self._categories = liste
        self.categoriesUpdate.emit(self._categories)

    def add_category(self, value):
        self._categories.append(value)
        self.categoriesUpdate.emit(self._categories)

    '''Gestion des valeurs min/max des colonnes du graphique'''
    # Gestion du mini
    @QtCore.pyqtProperty(int, notify=miniUpdate)
    def mini(self):
        return self._mini

    @mini.setter
    def mini(self, value):
        self._mini = value
        self.miniUpdate.emit(self._mini)

    def def_mini(self, value):
        self._mini = min(self._mini, value)
        self.miniUpdate.emit(self._mini)

    # Gestion du maxi
    @QtCore.pyqtProperty(int, notify=maxiUpdate)
    def maxi(self):
        return self._maxi

    @maxi.setter
    def maxi(self, value):
        self._maxi = value
        self.maxiUpdate.emit(self._maxi)

    def def_maxi(self, value):
        self._maxi = max(self._maxi, value)
        self.maxiUpdate.emit(self._maxi)

    '''Gestion des colonnes'''
    # Gestion des barsets
    def init_barsets(self):
        self._barsets = {}

    def add_barset(self, name, values):
        self._barsets[name] = values

    @QtCore.pyqtProperty('QVariantMap')
    def barsets(self):
        return self._barsets


