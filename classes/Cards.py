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

from qgis.PyQt.QtWidgets import QWidget, QDockWidget
from qgis.core import QgsMessageLog, Qgis
from PyQt5 import QtGui, QtWidgets
from PyQt5.QtWidgets import QHBoxLayout, QPushButton, QWidget, QVBoxLayout, QLayout, QLabel
from PyQt5.QtGui import QPainter, QPen, QGradient, QColor, QIcon
from PyQt5.QtCore import Qt, QPoint, QSize
from functools import partial
import os, math


class Card(QPushButton):
    def __init__(self, icone, text, widget, coords, suffixe, code, dlg, mt):
        '''Initialisation des cards et des caractéristiques des cards (bordures, polices)'''
        super(Card, self).__init__(widget)
        self.icone = QIcon(os.path.join(os.path.dirname(__file__), "../ressources/icones", icone))
        self.label = QLabel(text, self)
        self.widget = widget
        self.dlg = dlg
        self.mt = mt
        self.libelle_indic = self.dlg.ressources.legendes_couches[code]
        self.code_indic = code
        self.x  = coords[0]
        self.y = coords[1]
        self.width = coords[2]
        self.height = coords[3]
        self.suffixe = suffixe
        self.selectionne = False
        self.valeurs = {}

        self.couleurs_bordures = {False: "rgba(251, 212, 81, 255)", True: "rgba(41, 37, 116, 255)"}

        self.init_ui()
        self.clicked.connect(self.select_indic)

        self.setStyleSheet('QPushButton {background-color: white; border:1px solid ' + self.couleurs_bordures[self.selectionne] + '; border-radius: 20px; margin: 0px; font: 22px "Arial"; font-weight: bold; color: rgba(41, 37, 116, 255); padding-left: 50px; padding-top: 25px;}')


    def mousePressEvent(self, QMouseEvent):
        '''Un clic droit sur une card ouvre l'onglet sur les actions correspondantes à cette action'''
        if QMouseEvent.button() == Qt.RightButton:
            self.dlg.affiche_page("actions_reduc")
            self.dlg.maj_etape_avancement("choix_actions")
        else:
            super().mousePressEvent(QMouseEvent)


    def init_ui(self):
        '''Initialisation de l'interface (taille de la page, style, fond, bordures...)'''
        self.label.setAlignment(Qt.AlignCenter)
        self.label.setGeometry(0, 5, 250, 30)
        self.label.setFixedHeight(25)
        self.label.setStyleSheet('QLabel {background-color: none; border:1px grey; color: rgb(239, 120, 88); font: 11px "Arial"; font-weight: bold;}')

        self.label_icon = QLabel(self)
        self.label_icon.setPixmap(self.icone.pixmap(QSize(50, 50)))
        self.label_icon.setAlignment(Qt.AlignLeft)
        self.label_icon.setGeometry(20, round((self.height - 30) / 2) -25 + 30, 50, 50)

        self.label_icon.setStyleSheet('QLabel {background-color: none; border:1px grey;}')
        self.label_icon.setAttribute(Qt.WA_TranslucentBackground)
        self.label_icon.setAttribute(Qt.WA_TransparentForMouseEvents)
        self.label_icon.setVisible(True)

        self.setGeometry(self.x, self.y, self.width, self.height)


    def set_quickview(self):
        '''Création d'un widget contenant un graphe en camembert'''
        self.quick = QWidget(self)
        self.quick.setGeometry(90, 35, 100, 100) # (90, 35, 250 - 90 - 15, 150 - 35 - 15)
        self.quick.setStyleSheet('QWidget {background-color: white; border:0px solid rgba(251, 212, 81, 255); border-radius: 0px; margin: 0px; padding: 0px;}')
        self.quick.setVisible(True)

        # Création d'un layout pour le camembert
        self.layout = QVBoxLayout(self.quick)
        self.layout.setContentsMargins(0, 0, 0, 0)
        self.layout.setSpacing(0)
        self.layout.setAlignment(Qt.AlignCenter)

        # Création du camembert
        self.camembert = Camembert(self)
        self.layout.addWidget(self.camembert)


        return self.quick


    def change_value(self, champ, valeur):
        '''Attribue la valeur à la card'''
        self.valeurs[champ] = valeur


    def update(self):
        '''La méthode ajoute le texte de la card indiquant à quel indicateur elle correspond. La méthode adapte l'affichage pour les grands nombres (k pour 1 000 et M pou 1 000 000).
        Les suffixes correspondants aux unités sont dans un dictionnaire dans Dashboard.py. La méthode prévoit aussi la mise à jour des graphes en camemberts
        "logt_zx": 'Logements en zone inondable',
        "s1_2a": 'Population dans des bâtiments\nde plain pied fortement inondables\n(estimation)',
        "s1_2b": 'Population occupant un RDC \nfortement inondable (estimation)',
        "s2_2a_amc": 'Coût des dommages aux logements \n(estimation)',
        "s2_6a": 'Coût des dommages aux cultures \n(estimation)',
        "s2_7a": "Coût des dommages aux entreprises \n(estimation)",
        "s2_14a": "Surfaces à urbaniser",
        "s3_1a": 'Population en zone inondable (estimation)',
        "s3_1f": 'Surfaces agricoles inondables',
        "s3_2b": "Capacités d\'hébergement",
        '''
        # Pour les indicateurs suivants, il ne s'agit que d'une simple mise à jour du texte du bouton
        if self.code_indic in ["logt_zx", "s1_2a", "s1_2b", "s2_2a_amc", "s2_6a", "s2_7a", "s3_1a", "s3_1f", "pop_agee_zx", "salaries_zx"]:
            for champ, valeur in self.valeurs.items():
                if champ == -2 or valeur == -9999:
                    self.setText("")
                elif champ == -1:
                    self.setText("\t...")
                else:
                    # Affiche la valeur de l'indicateur et ajoute en suffixe k pour > 100 000 ou M pour le million
                    val = f'{valeur:,.0f}'.replace(',', ' ') if valeur < 100000 else f'{valeur/1000:,.0f} k' if valeur < 1000000 else f'{valeur/1000000:.1f} M'.replace('.', ',')
                    self.setText(f"\t{val} {self.suffixe}")
        # Pour les indicateurs suivants, il s'agit d'une mise à jour du camembert
        elif self.code_indic in ["s3_2b"]:
            cap_acc_out = self.valeurs["cap_acc_out"] if "cap_acc_out" in self.valeurs else 0
            cap_acc_in = self.valeurs["cap_acc_in"] if "cap_acc_in" in self.valeurs else 0
            cap_acc_tot = cap_acc_in + cap_acc_out
            pct_in = cap_acc_in / cap_acc_tot if cap_acc_tot > 0 else 0
            pct_out = cap_acc_out / cap_acc_tot if cap_acc_tot > 0 else 0
            self.camembert.update_in_out(pct_in, pct_out)
        # Pour les indicateurs suivants, il s'agit d'une mise à jour du camembert
        elif self.code_indic in ["s2_14a"]:
            cap_acc_out = self.valeurs["surf_au_out"] if "surf_au_out" in self.valeurs else 0
            cap_acc_in = self.valeurs["surf_au_in"] if "surf_au_in" in self.valeurs else 0
            cap_acc_tot = cap_acc_in + cap_acc_out
            pct_in = cap_acc_in / cap_acc_tot if cap_acc_tot > 0 else 0
            pct_out = cap_acc_out / cap_acc_tot if cap_acc_tot > 0 else 0
            self.camembert.update_in_out(pct_in, pct_out)
        else:
            QgsMessageLog.logMessage(f"Code indicateur {self.code_indic} non reconnu - les champs récupérés sont : {self.valeurs}", "AgiRisk", Qgis.Warning)


    def select_indic(self):
        '''Méthode qui permet de visualiser la sélection d'un indicateur dans le dashboard et ouvre une box QGIS avec un graphe correspondant'''
        self.selectionne = not self.selectionne
        self.setStyleSheet('QPushButton {background-color: white; border:1px solid ' + self.couleurs_bordures[self.selectionne] + '; border-radius: 20px; margin: 0px; font: 22px "Arial"; font-weight: bold; color: rgba(41, 37, 116, 255); padding-left: 50px; padding-top: 25px;}')
        self.mt.change_visibilite_couches(self.libelle_indic, self.selectionne)
        self.dlg.maj_zoom(nveau_chargement=True)
        self.dlg.cbox_niv_synthese.currentIndexChanged.emit(self.dlg.cbox_niv_synthese.currentIndex())


class Camembert(QWidget):
    def __init__(self, parent):
        '''Initialisation des widgets des camemberts'''
        super(Camembert, self).__init__(parent)
        self.values = {"ZI": 340, "Hors ZI": 1500}
        self.setStyleSheet('QWidget {background-color: none; border:none; margin: 0px; padding: 0px;}')
        self.setVisible(True)
        self.setMinimumSize(100, 100)
        self.repaint()

        # self.couleurs = [QColor(41, 37, 116), QColor(176, 204, 78), QColor(239, 119, 87), QColor(253, 235, 125)] #[QColor(239, 120, 88), QColor(41, 37, 116), QColor(251, 212, 81), QColor(0, 0, 0)]
        # self.tranches = [0, 45, 225] #[0, 90, 180, 270]
        # self.valeurs = [45, 180, 135] #[45, 90, 30, 70]

        self.pies = []
                    # [{"couleur": QColor(41, 37, 116), "angle_deb": 0, "angle_val": 45},
                    #  {"couleur": QColor(176, 204, 78), "angle_deb": 90, "angle_val": 90},
                    #  {"couleur": QColor(239, 119, 87), "angle_deb": 180, "angle_val": 30},
                    #  {"couleur": QColor(253, 235, 125), "angle_deb": 270, "angle_val": 70}]


    def update_in_out(self, pct_in, pct_out):
        '''Calcul des angles des tranches de camembert avant tracé en fonction des valeurs'''
        angle_zi = (pct_in * 360)
        angle_hors_zi = (pct_out * 360)
        i = 1
        # précédente couleur verte : QColor(176, 204, 78)
        # remplacée par : QColor(239, 119, 87) - gris de code #bdbaba
        self.pies = [{"couleur": QColor(41, 37, 116), "angle_deb": math.floor(ang * (angle_zi / i)), "angle_val": math.ceil((angle_zi / i))} for ang in range(i)]
        self.pies += [{"couleur": QColor(189, 186, 186), "angle_deb": math.floor(angle_zi + ang * (angle_hors_zi / i)), "angle_val": math.ceil((angle_hors_zi / i))} for ang in range(i)]
        self.repaint()


    def paintEvent(self, event):
        '''Méthode qui dessine le graph en camembert'''
        rect = event.rect()
        painter = QPainter()
        painter.begin(self)
        painter.setRenderHint(QPainter.Antialiasing)
        painter.setPen(QPen(Qt.NoPen))

        for pie in self.pies:
            painter.setBrush(pie["couleur"])
            painter.drawPie(rect, int(conv_dep(pie["angle_deb"])), int(conv_tranche(pie["angle_val"])))

        painter.end()


def ang_e(angle):
    '''calcul initial de l'angle en fonction de la valeur de l'indicateur'''
    ang_ellipse = (math.atan2(math.sin(angle * 3.141592 / 180) * 100, math.cos(angle * 3.141592 / 180) * 100) * 180.0 / 3.141592) * 16
    return ang_ellipse


def conv_dep(angle):
    '''On transforme l'angle pour que les tranches tournent dans le sens horaires et commencent à 12h'''
    ang = angle + 90
    return int(ang_e(ang))


def conv_tranche(angle):
    '''Convertit les angles supérieur à 180° pour que le ArcTan de la méthode ang_e fonctionne'''
    ang = angle
    if angle < 180:
        return int(ang_e(ang))
    else:
        return int(2 * ang_e(ang / 2))
