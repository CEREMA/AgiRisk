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
from PyQt5 import QtGui, QtWidgets
import json

# From https://stackoverflow.com/questions/60276513/how-to-add-another-column-in-a-qcolumnview-based-on-the-users-selection


def populateTree(children, parent):
    if isinstance(children, dict):
        for key in children.keys():
            child_item = QtGui.QStandardItem(children[key]["code"])
            parent.appendRow(child_item)
            if "enfants" in children[key].keys():
                populateTree(children[key]["enfants"], child_item)
    elif isinstance(children, list):
        for child in children:
            child_item = QtGui.QStandardItem(child["code"])
            parent.appendRow(child_item)
            if "enfants" in child.keys():
                populateTree(child["enfants"], child_item)


class Dialog(QtWidgets.QDialog):
    def __init__(self, parent=None):
        super().__init__(parent)

        self.frame = QtWidgets.QFrame()

        self.columnview = QtWidgets.QColumnView()

        grid_layout = QtWidgets.QGridLayout(self)
        grid_layout.addWidget(self.frame, 0, 0, 1, 2)

        lay = QtWidgets.QVBoxLayout(self.frame)
        lay.addWidget(self.columnview)
        
        with open("modeles_pts_vue.json", "r", encoding="utf-8") as in_file:
            data = json.load(in_file)

        self.model = QtGui.QStandardItemModel(self)
        self.columnview.setModel(self.model)
        populateTree(data, self.model.invisibleRootItem())

        self.resize(1280, 480)


def main():
    app = QtWidgets.QApplication(sys.argv)
    w = Dialog()
    w.show()
    sys.exit(app.exec_())


if __name__ == "__main__":
    main()