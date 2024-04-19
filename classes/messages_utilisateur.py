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

from PyQt5.QtWidgets import QMessageBox
    
def avertissement(texte, info):
    msg = QMessageBox()
    msg.setIcon(QMessageBox.Warning)
    msg.setText(texte)
    msg.setInformativeText(info)
    msg.setWindowTitle(u"Avertissement")
    return msg.exec()