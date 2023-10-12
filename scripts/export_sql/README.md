# Export des fonctions SQL

## Script en standalone

Le script `export_sql_to_repo.py` permet d'exporter dans les répertoires `__*` les fonctions SQL permettant d'alimenter la base de données **demo_agirisk** et de pusher les modifications sur le dépôt.

## Exécution du script

Pour installer les librairies nécessaires au bon fonctionnement du script, lancer la commande suivante :

`pip install -r requirements.txt`

Pour exécuter le script, lancer la commande suivante :

`python export_sql_to_repo.py`

## Création de la documentation automatique

La commande `python -m pydoc -w export_sql_to_repo` génère la documentation du script dans le fichier html `export_sql_to_repo.html`.
