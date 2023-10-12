from PyQt5.QtWidgets import QMessageBox
    
def avertissement(texte, info):
    msg = QMessageBox()
    msg.setIcon(QMessageBox.Warning)
    msg.setText(texte)
    msg.setInformativeText(info)
    msg.setWindowTitle(u"Avertissement")
    return msg.exec()