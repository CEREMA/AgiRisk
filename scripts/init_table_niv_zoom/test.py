import psycopg2
import psycopg2.extras


''' Récupère les niveaux de zoom disponibles'''

conn = f"host='127.0.0.1' port=5436 dbname=demo_agirisk user='admin_agirisk' password='@giRisk!2022'"
db_conn = psycopg2.connect(conn)
cur = db_conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor)
cur.execute("SELECT distinct code_indic FROM r_ressources.niv_zoom;")
liste_indics = cur.fetchall()


dico = {}
for indic in liste_indics:
    dico[indic['code_indic']] = {}
    cur.execute(f"SELECT niv_zoom, type_result FROM r_ressources.niv_zoom WHERE code_indic = '{indic['code_indic']}';")
    res = cur.fetchall()
    for r in res:
        dico[indic['code_indic']][r['niv_zoom']] = r['type_result']
for indic in dico.keys():
    print(indic, dico[indic])

cur.close()
db_conn.close()