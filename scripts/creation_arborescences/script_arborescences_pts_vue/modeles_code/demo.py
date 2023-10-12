import sys
from PyQt6.QtWidgets import QApplication, QMainWindow, QTreeView
from PyQt6.QtGui import QFont, QColor, QStandardItemModel, QStandardItem
from pip import main
from shiboken6 import getAllValidWrappers

class StandardItem(QStandardItem):
    def __init_(self, txt='', font_size=12, set_bold=False, color=QColor(0, 0, 0)):
        super().__init__()

        fnt = QFont("Open Sans", font_size)
        fnt.setBold(set_bold)

        self.setEditable(False)
        self.setForeground(color)
        self.setFont(fnt)
        self.setText(txt)

class AppDemo(QMainWindow):
    def __init__(self) -> None:
        super().__init__()
        self.setWindowTitle('Diagramme exemple')
        self.resize(500,700)

        treeView = QTreeView()
        treeView.setHeaderHidden(False)

        treeModel = QStandardItemModel()
        rootNode = treeModel.invisibleRootItem()

        '-------------------------'

        objectifs = [
            StandardItem('Augmenter la sécurité des personnes'), 
            StandardItem('Raccourcir le délai de retour à la normale'),
            StandardItem('Réduire le coût des dommages')
        ]

        axes = [
            StandardItem('Mise en danger des personnes au sein des bâtiments'), 
            StandardItem('Manque de préparation à la crise'), 
            StandardItem('Dommages aux bâtiments')
        ]

        pt_vue_sngri = StandardItem('SNGRI')

        pt_vue_sngri.appendRows(objectifs)
        objectifs[0].appendRows(axes)

        rootNode.appendRow(pt_vue_sngri)
        treeView.setModel(treeModel)
        treeView.expandAll()

        treeView.doubleClicked.connect(self.getValue)

        self.setCentralWidget(treeView)

    def getValue(self, val):
        print(val.data(), val.row(), val.column())

if __name__ == "__main__":
    app = QApplication(sys.argv)

    demo = AppDemo()
    demo.show()

    sys.exit(app.exec())