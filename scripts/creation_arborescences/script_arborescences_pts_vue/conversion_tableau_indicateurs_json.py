# -*- coding: utf-8 -*-
"""
Created on Thu May 19 11:26:17 2022

@author: manuel.collongues
Cerema / Laboratoire de Nancy / ERTD
"""

import os, json

liste_thematiques = ["gestion_crise", "aménagement", "activité économique", "environnement"]
liste_colonnes = []
dependances_variables = {"S1/2b": ["Zt", "Ap2", "Oc1", "Oc5", "Zh", "Za"], 
                         "S1/2a": ["Zt", "Ap2", "Oc1", "Zh", "Za"],
                         "S2/2a": ["Zt", "Zx", "Zf", "Oc2"],
                         "S2/6a": ["Zt", "Zx", "Zf", "Oc7"],
                         "S2/14a": ["Zt", "Zx", "Oc0"],
                         "S3/1a": ["Zt", "Zx", "Oc1"],
                         "S3/1f": ["Zt", "Zx", "Oc7"],}

def dic_dep_var(code_indic, dep_var):
    # Cette fonction transforme le couple code_indic/dep_var en un dictionnaire contenant les variables dont l'indicateur dépend
    liste_dep = []
    for var in dep_var:
        liste_dep.append({"code_variable": var.lower(), "moda_calcul": {"nom_fct_pgsql": f"__{var.lower()}"}})
    return liste_dep

parametres_var = {  "oc0":[["nom_ter","an_gpu"],["text","text"]],
                    "oc1":[["nom_ter","an_bdtopo"],["text","text"]],
                    "oc2":[["nom_ter","an_ff","an_bdtopo"],["text","text","text"]],
                    "oc3":[["nom_ter","an_lien","an_bdtopo","an_siren"],["text","text","text","text"]],
                    "oc7":[["nom_ter","an_bdtopo","an_iris","an_rpg","an_inao"],["text","text","text","text","text"]],
                    "pop1":[["nom_ter","an_ff","an_pop","chp_pop"],["text","text","text","text"]],
                    "pop5":[["nom_ter","an_ff"],["text","text"]],
                    "zt":[["nom_ter","an_bdtopo","an_iris","an_carthage","an_topage"],["text","text","text","text","text"]]}

parametres_indic = {"s1_2b":[["nom_ter","an_bdtopo","code_occ"],["text", "text", "text"]], 
                    "s2_14a":[["nom_ter","an_bdtopo","code_occ"],["text", "text", "text"]], 
                    "s3_1f_seb_old":[["nom_ter"],["text"]]}

def dic_param(code_indic, parametres):
    # Cette fonction transforme le couple code_indic/parametres en un dictionnaire contenant les paramètres de l'indicateur
    liste_param = []
    for param in parametres:
        liste_param.append({"code_parametre": param.lower(), "moda_calcul": {"nom_fct_pgsql": f"__{param.lower()}"}})
    return liste_param

def codes_them(l_thematiques, liste_thematiques):
    liste = []
    for i, val_them in enumerate(liste_thematiques):
        if l_thematiques[i] == "X":
            liste.append(val_them)
    return liste

pts_vue = []
# Récupération des informations relatives au point de vue SNGRI
with open("SelectionAssises.csv", "r", encoding="utf-8") as f:
    pt_vue_ref = {"code": "SNGRI", "enfants" : {}}
    premiere_ligne = True
    for ligne in f:
        if not premiere_ligne:
            num_objectif, nom_objectif, num_axe, nom_axe, num_source, nom_source, num_indicateur, nom_indicateur_original, nom_indicateur_reformule, axe_point_de_vue_porteur_papi, gestion_crise, amenagement_territoire, activite_economique, environnement, culture_risque, dispositifs_reglementaires, cout_dommages, reseaux, patrimoine = ligne.split("\t")
            colonnes = ligne.split("\t")
            # Niveau objectif
            if not ("objectif " + num_objectif) in pt_vue_ref["enfants"].keys():
                pt_vue_ref["enfants"]["objectif " + num_objectif] = {
                    "nom": nom_objectif, 
                    "code": "obj_" + num_objectif,
                    "enfants": {}}

            # Niveau axe
            if not ("axe " + num_axe) in pt_vue_ref["enfants"]["objectif " + num_objectif]["enfants"].keys():
                pt_vue_ref["enfants"]["objectif " + num_objectif]["enfants"]["axe " + num_axe] = {
                    "nom": nom_axe, 
                    "code": "axe " + num_axe, 
                    "enfants": {}}

            # Niveau source
            if not ("source " + num_source) in pt_vue_ref["enfants"]["objectif " + num_objectif]["enfants"]["axe " + num_axe]["enfants"].keys():
                pt_vue_ref["enfants"]["objectif " + num_objectif]["enfants"]["axe " + num_axe]["enfants"]["source " + num_source] = {
                    "nom": nom_source, 
                    "code": num_source,
                    "enfants": {}}  

            # Niveau indicateur
            if not (num_indicateur) in pt_vue_ref["enfants"]["objectif " + num_objectif]["enfants"]["axe " + num_axe]["enfants"]["source " + num_source]["enfants"].keys():
                pt_vue_ref["enfants"]["objectif " + num_objectif]["enfants"]["axe " + num_axe]["enfants"]["source " + num_source]["enfants"][num_indicateur] = {
                    "nom_original": nom_indicateur_original, 
                    "nom_reformule": nom_indicateur_reformule, 
                    "code": nom_indicateur_reformule, 
                    "thematiques": codes_them([gestion_crise, amenagement_territoire, activite_economique, environnement], liste_thematiques)}

        premiere_ligne = False
    pts_vue.append(pt_vue_ref)


# Sauvegarde du json correspondant
with open("modeles_pts_vue_assises.json", "w", encoding="utf-8") as out_file:
    json.dump(pts_vue, out_file, indent = 4)
        

