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

from qgis.core import QgsRasterLayer
from PyQt5.QtCore import QVariant
import json, os

class Ressources(object):
    def __init__(self, parent):
        '''La méthode associe les légendes aux indicateurs. Elle définit aussi les classes de zoom et les codes champs des indicateurs. La méthode stocke les noms de style dans un json. La méthode initialise enfin les couches de ref et charge les paramètres d'import du plugin.'''
        self.charger_pts_vue()
        self.dlg = parent

        self.niv_synthese = {0: "IRIS", 1: "Commune", 2: "EPCI"}
        self.niv_zoom_code = {"Entite": 0, "Hexag_1ha": 1, "Hexag_5ha": 2, "Hexag_10ha": 3, "Hexag_50ha": 4, "Hexag_100ha": 5, "IRIS": 6, "Commune": 7, "EPCI": 8}
        self.code_niv_zoom = {0: "Entite", 1: "Hexag_1ha", 2: "Hexag_5ha", 3: "Hexag_10ha", 4: "Hexag_50ha", 5: "Hexag_100ha", 6: "IRIS", 7: "Commune", 8: "EPCI"}
        self.legendes_couches = {
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
            "terr_etude": "Territoire d'étude",
            "zx": 'Emprise de la zone inondable',
            "zq": 'Niveaux d\'aléas',
            "zh": 'Hauteurs d\'eau',
            "pop_agee_zx": 'Population âgée en zone inondable',
            "salaries_zx": 'Nombre de salariés en zone inondable',
            "osm": 'OSM'
        }
        self.classes_zoom = [
            {'min': 1, 'max': 8000, 'zoom': 0},             # Entité
            {'min': 8000, 'max': 18000, 'zoom': 1},         # Hexag_1ha
            {'min': 18000, 'max': 35000, 'zoom': 2},        # Hexag_5ha
            {'min': 35000, 'max': 55000, 'zoom': 3},        # Hexag_10ha
            {'min': 55000, 'max': 75000, 'zoom': 4},        # Hexag_50ha
            {'min': 75000, 'max': 80000, 'zoom': 5},        # Hexag_100ha
            {'min': 80000, 'max': 100000, 'zoom': 6},       # IRIS
            {'min': 100000, 'max': 250000, 'zoom': 7},      # Commune
            {'min': 250000, 'max': 1000000000, 'zoom': 8},  # EPCI
        ]
        self.codes_champs = {
            "s3_1a": ["pop6_haut_in"],
            "s1_2a": ["pop6_pp_in_fort_tresfort"],
            "s1_2b": ["pop6_rdc_in_fort_tresfort"],
            "s3_2b": ["cap_acc_out", "cap_acc_in"],
            "s3_1f": ["surf_in"],
            "logt_zx": ["nb_logts_in"],
            "s2_14a": ["surf_au_in", "surf_au_out"],
            "s2_2a_amc": ["cout_max_dmg_tot"], #, "date_actu_cout_dmg"
            "s2_6a": ["cout_domm_ann"],
            "pop_agee_zx": ["pop1_agee_in"],
            "salaries_zx": ["pop2_haut_in"]
        }
        self.correspondances_types_sql = {
            "_float8" : QVariant.List,
            "_varchar": QVariant.StringList,
            "bool" : QVariant.Bool,
            "box2df" : QVariant.String,
            "date" : QVariant.Date,
            "float4" : QVariant.Double,
            "float8" : QVariant.Double,
            "int2" : QVariant.Int,
            "int4" : QVariant.Int,
            "int8" : QVariant.Int,
            "numeric" : QVariant.Double,
            "text" : QVariant.String,
            "timestamp" : QVariant.Date,
            "timestamptz" : QVariant.Date,
            "varchar" : QVariant.String,
        }

        self.css_bt_calcul_indic = {
            'non_lance': 'background-color: #f2f2f2; border-radius: 3px; border:2px outset #f2f2f2; color: #969696; font: 11px "Arial"; font-weight: bold; margin-left: 20px; margin-right: 20px;',
            'calcule': 'background-color: rgb(96, 180, 103); border-radius: 3px; border:2px outset rgb(96, 180, 103); color: white; font: 11px "Arial"; font-weight: bold; margin-left: 20px; margin-right: 20px;'}
        
        # Les noms de styles pour chaque combinaison (point de vue, indicateur, niveau de zoom) sont stockés dans le json styles_affichage.json
        self.fic_styles = {}
        self.rep_styles = os.path.join(os.path.abspath(os.path.join(os.path.dirname(__file__), os.pardir)), 'ressources', 'styles_affichage')
        fichier_styles = os.path.join(os.path.dirname(__file__), "../ressources/styles_affichage.json")
        with open(fichier_styles, "r") as f:
            self.fic_styles = json.load(f)

        # Initialisation de la ou des couches référentiel
        self.basemaps = {}
        urlWithParams = 'type=xyz&url=https://a.tile.openstreetmap.org/%7Bz%7D/%7Bx%7D/%7By%7D.png&zmax=19&zmin=0&crs=EPSG3857'
        self.basemaps['osm'] = QgsRasterLayer(urlWithParams, 'OpenStreetMap', 'wms')
        fichier_style = os.path.join(self.rep_styles, 'osm.qml')
        self.basemaps['osm'].loadNamedStyle(fichier_style)

        # Chargement des paramètre supportés par le plugin :
        # - Types de fichiers géographiques supportés pour l'import de nouvelles couches
        # - Couleurs de bouton en fonction du statut
        conf_file = os.path.join(os.path.dirname(__file__), "../ressources/config.json")
        with open(conf_file, "r") as f:
            self._config = json.load(f)


    def get(self, property_name):
        '''La méthode permet de charger des config !!! la méthode n'est pas rappelé dans le reste du code'''
        if property_name not in self._config.keys():
            return None
        return self._config[property_name]


    def charger_pts_vue(self):
        '''La méthode charge la liste des points de vue disponibles à partir d'un json.'''
        with open(os.path.join(os.path.dirname(__file__), "../ressources/modeles_pt_vue_assises.json"), "r", encoding = "utf-8") as in_file:
            self.data = json.load(in_file)
            self.liste_pts_vue = [pt_vue['code'] for pt_vue in self.data]


    def get_niv_zoom(self):
        ''' Récupère les correspondances entre codes indicateurs, niveaux de zoom et types result
        Le résultat dans self.niv_zoom est un dictionnaire de la forme :
        {'code_indic1': {'niv_zoom1': 'type_result1', 'niv_zoom2': 'type_result2', ...},
         'code_indic2': {'niv_zoom1': 'type_result1', 'niv_zoom2': 'type_result2', ...}, ...}

        Le résultat dans self.lst_niv_zoom est une liste des niveaux de zoom
        '''
        self.niv_zoom = self.dlg.bdd.get_niv_zoom()
        self.lst_niv_zoom = self.dlg.bdd.get_lst_niv_zoom()


def chgt_classe_zoom(classes_zoom, echelle_prec, echelle_act):
    '''La méthode permet de modifier les échelles en suivant la classe de zoom dans laquelle on se trouve.
    Cette fonction calcule la classe de zoom correspondant à l'échelle actuelle ainsi qu'à l'échelle précédente
    Elle renvoie True si ces deux classes sont différentes, False sinon'''

    zoom_prec = 0
    zoom_act = 0
    for classe in classes_zoom:
        if classe['min'] <= echelle_prec and echelle_prec < classe['max']:
            zoom_prec += classe['zoom']
        if classe['min'] <= echelle_act and echelle_act < classe['max']:
            zoom_act += classe['zoom']
    return not(zoom_prec == zoom_act), zoom_act