CREATE OR REPLACE FUNCTION public.__var_pop1(nom_ter text, an_ff text, an_pop text)
 RETURNS void
 LANGUAGE plpgsql
AS $function$

DECLARE
    dep text; -- variable qui prend pour valeur chaque département concerné par le territoire d'étude (utilisée dans une boucle FOR)
    liste_dep text; -- variable qui liste tous les départements concernés par le territoire d'étude

BEGIN

-- nom_ter = nom du territoire test
-- an_ff = millésime des FF
-- an_pop = millésime de la couche population insee

    -- 0. Préalables

    -- Définition des schémas de travail
    SET SEARCH_PATH TO c_occupation_sol, c_general, c_phenomenes, r_ign_bdtopo, r_insee_pop, public;

    RAISE NOTICE '';
    RAISE NOTICE '======    RAPPORT     ======';

    -- Test de l'existence du territoire dans la table des territoires
    IF NOT EXISTS (
        SELECT *
        FROM territoires t 
        WHERE territoire = nom_ter
    )
    THEN
        RAISE EXCEPTION 'Il n''y a pas de territoire "%" dans la table c_general.territoires. Fin de l''exécution.', nom_ter;
    END IF;

    -- 1. Calcul de la surface développée des résidences secondaires (RS) par TUP

    /* On calcule le pourcentage de locaux de type RS par TUP en nombre (pct_nb_rs) et en surface (pct_s_rs)
    On considère donc ici que la surface développée d'un local de type habitation = au champ stoth des FF

    Avant toute chose, il est nécessaire de vérifier les conditions suivantes pour s'assurer qu'il s'agit bien d'une RS, car le champ proba_rprs des FF pas toujours fiable :
    SI locprop = '1' (la commune du local = la commune du propriétaire)
    Ne considérer que c'est une RS que s'il y a plusieurs locaux rattachés au compte propriétaire (si le propriétaire ne possède qu'un local d'habitation sur la commune et qu'il habite sur cette même commune, c'est forcément sa résidence principale !) et si le local considéré n'est pas celui de plus grande surface habitable.
    */

    EXECUTE 'DROP TABLE IF EXISTS local CASCADE;
    CREATE TEMP TABLE local AS
    SELECT loc.*
    FROM ff'||an_ff||'.fftp_'||an_ff||'_pb0010_local as loc
    JOIN territoires as ter
    ON ST_Intersects(loc.geomloc,ter.geom)
    WHERE ter.territoire = '''||nom_ter||'''
    ';

    EXECUTE 'CREATE INDEX ON local USING btree(stoth)';
    EXECUTE 'CREATE INDEX ON local USING btree(idprocpte)';
    EXECUTE 'CREATE INDEX ON local USING btree(proba_rprs)';
    EXECUTE 'CREATE INDEX ON local USING btree(locprop)';

    EXECUTE 'DROP TABLE IF EXISTS tup CASCADE;
    CREATE TEMP TABLE tup AS
    SELECT tup.*
    FROM ff'||an_ff||'.ffta_'||an_ff||'_tup as tup
    JOIN territoires as ter
    ON ST_Intersects(tup.geomloc,ter.geom)
    WHERE ter.territoire = '''||nom_ter||'''
    ';

    EXECUTE 'CREATE INDEX ON tup USING gist(geomtup)';
    EXECUTE 'CREATE INDEX ON tup USING gist(geomloc)';
    EXECUTE 'CREATE INDEX ON tup USING btree(idtup)';

    EXECUTE 'ALTER TABLE local
    DROP COLUMN IF EXISTS rs_corr,
    ADD COLUMN rs_corr varchar(20)';

    EXECUTE 'WITH loc AS
    (
        SELECT *,
        MAX(stoth) OVER (PARTITION BY idprocpte) as stothmax
        FROM local
    ),
    rs_correct AS
    (
        SELECT *,
            CASE
                WHEN proba_rprs = ''RS'' AND (locprop <> ''1'' OR (locprop = ''1'' AND stoth < stothmax)) THEN ''RS''
                ELSE proba_rprs
            END AS typheb
        FROM loc
    )
    UPDATE local
    SET rs_corr = rs_correct.typheb
    FROM rs_correct
    WHERE local.idlocal = rs_correct.idlocal';

    EXECUTE 'CREATE INDEX ON local USING btree(rs_corr)';

    EXECUTE 'DROP TABLE IF EXISTS tup_local CASCADE;
    CREATE TEMP TABLE tup_local AS
    SELECT tup.idtup, tup.geomtup,

    -- liste des idlocal par parcelle TUP
    ARRAY_AGG(loc.idlocal)::varchar[] as idlocal_l,

    -- surface d''habitation totale par parcelle TUP
    COALESCE((SUM(loc.stoth) FILTER (WHERE loc.logh = ''t'')),0)::numeric as s_logh,

    -- surface totale des locaux de type RS ou vacants par parcelle TUP
    COALESCE((SUM(loc.stoth) FILTER (WHERE loc.rs_corr = ''RS'' OR loc.ccthp = ''V'')),0)::numeric as s_rs

    FROM tup as tup
    JOIN local as loc
    ON loc.idtup = tup.idtup
    GROUP BY tup.idtup, tup.geomtup
    ';

    EXECUTE 'CREATE INDEX ON tup_local USING btree(s_logh)';
    EXECUTE 'CREATE INDEX ON tup_local USING btree(s_rs)';

    EXECUTE 'ALTER TABLE tup_local
    DROP COLUMN IF EXISTS pct_s_rs,
    ADD COLUMN pct_s_rs double precision DEFAULT 0';

    EXECUTE 'UPDATE tup_local
    SET pct_s_rs = (s_rs::numeric / s_logh)
    WHERE s_logh > 0';

    EXECUTE 'CREATE INDEX ON tup_local USING btree(pct_s_rs)';

    -- 2. Croisement des bâtiments BDTOPO® avec les TUP des FF

    EXECUTE 'UPDATE oc1
    SET idtup = tup.idtup
    FROM tup
    WHERE ST_Intersects(oc1.geomloc,tup.geomtup)
    AND oc1.territoire = '''||nom_ter||'''';

    EXECUTE 'COMMENT ON COLUMN oc1.idtup IS ''Identifiant de la parcelle TUP à laquelle appartient le bâtiment.''';
    EXECUTE 'CREATE INDEX ON oc1 USING btree(idtup)';

    -- 3. Ventilation nombre de RS et surfaces développées de RS entre les bâtiments de chaque TUP

    -- 3.1 Calcul du volume de chaque bâtiment oc1

    EXECUTE 'UPDATE oc1
    SET haut_modif =
    CASE
        WHEN (hauteur < 5 OR hauteur IS NULL) AND oc2 IS FALSE THEN 5
        WHEN (hauteur < 3 OR hauteur IS NULL) AND oc2 IS TRUE THEN 3
        ELSE hauteur
    END
    WHERE territoire = '''||nom_ter||'''';

    EXECUTE 'COMMENT ON COLUMN oc1.haut_modif IS ''Hauteur issue du champ hauteur de la BDTOPO® ramenée à 5m quand elle est < 5m et qu''''il ne s''''agit pas d''''un logement, à 3m quand elle est < 3m et qu''''il s''''agit d''''un logement, à hauteur BDTOPO pour le reste.''';
    EXECUTE 'CREATE INDEX ON oc1 USING btree(haut_modif)';

    -- 3.2 Mise à jour du champ nombre_d_etages dans oc1 (car le champ nb_etages de la BDTOPO est mal renseigné)

    EXECUTE 'UPDATE oc1
    SET nombre_d_etages =
    CASE
        WHEN nb_etages > 0 THEN nb_etages
        WHEN oc2 IS FALSE THEN ceil(haut_modif :: numeric / 5)
        WHEN oc2 IS TRUE THEN ceil(haut_modif :: numeric / 3)
        ELSE 1
    END
    WHERE territoire = '''||nom_ter||'''';

    EXECUTE 'COMMENT ON COLUMN oc1.nombre_d_etages IS ''Nombre de niveaux à l''''intérieur du bâtiment. Vaut nb_etages si nb_etages > 0, haut_modif /5 pour les bâtiments autres que logements, haut_modif / 3 pour les bâtiments d''''habitation.''';
    EXECUTE 'CREATE INDEX ON oc1 USING btree(nombre_d_etages)';

    -- 3.3 On affecte à chaque bâtiment de logement le pourcentage en nombre et en surface développée de locaux inoccupés de sa parcelle TUP

    -- 3.3.1 Création d'une copie d'Oc1 pour ne pas avoir trop de champs inutiles (= champs utiles uniquement pour les calculs) dans la table d'origine Oc1

    EXECUTE 'DROP TABLE IF EXISTS temp_oc1 CASCADE;
    CREATE TEMP TABLE temp_oc1 (LIKE oc1 INCLUDING constraints INCLUDING indexes)';
    EXECUTE 'INSERT INTO temp_oc1
    SELECT *
    FROM oc1
    WHERE territoire = '''||nom_ter||'''';

    -- 3.3.1 Mise à jour des champs de pourcentage locaux inoccupés dans la table temporaire temp_oc1

    EXECUTE 'ALTER TABLE temp_oc1
    DROP COLUMN IF EXISTS pct_s_rs,
    ADD COLUMN pct_s_rs double precision DEFAULT 0';

    EXECUTE 'UPDATE temp_oc1
    SET
    pct_s_rs = tup.pct_s_rs
    FROM tup_local as tup
    WHERE territoire = '''||nom_ter||'''
        AND temp_oc1.oc2 IS TRUE
        AND temp_oc1.idtup = tup.idtup';

    EXECUTE 'CREATE INDEX ON temp_oc1 USING btree(pct_s_rs)';

    -- 4. Calcul de la surface développée totale (sedvtot) des bâtiments

    EXECUTE 'ALTER TABLE temp_oc1
    DROP COLUMN IF EXISTS sdevtot,
    DROP COLUMN IF EXISTS sdevrps,
    ADD COLUMN sdevtot double precision DEFAULT 0,
    ADD COLUMN sdevrps double precision DEFAULT 0';

    EXECUTE 'UPDATE temp_oc1
    SET sdevtot = ST_Area(geom) * nombre_d_etages
    WHERE oc2 IS TRUE
        AND territoire = '''||nom_ter||'''';

    -- 5. Calcul de la surface développée des résidences permanentes (RP)

    EXECUTE 'UPDATE temp_oc1
    SET
    sdevrps = sdevtot - (pct_s_rs * sdevtot)
    WHERE oc2 IS TRUE
        AND territoire = '''||nom_ter||'''';

    EXECUTE 'CREATE INDEX ON temp_oc1 USING btree(sdevtot)';
    EXECUTE 'CREATE INDEX ON temp_oc1 USING btree(sdevrps)';

    -- 6. Calcul de la population permanente à l'intérieur des bâtiments

    -- 6.1 Ajout de champs dans la couche temporaire temp_oc1

    EXECUTE 'ALTER TABLE temp_oc1
    DROP COLUMN IF EXISTS id_popref,
    DROP COLUMN IF EXISTS nb_popref,
    DROP COLUMN IF EXISTS pop1_s,
    ADD COLUMN id_popref varchar(50),
    ADD COLUMN nb_popref double precision DEFAULT 0,
    ADD COLUMN pop1_s double precision DEFAULT 0';

    -- 6.2 Création d'une variable qui liste les départements concernés par le territoire

    EXECUTE 'DROP TABLE IF EXISTS departement CASCADE;
    CREATE TEMP TABLE departement AS
    SELECT DISTINCT id_dpt
    FROM zt
    WHERE territoire = '''||nom_ter||'''
    ';

    EXECUTE 'DROP TABLE IF EXISTS liste CASCADE;
    CREATE TEMP TABLE liste (arr) AS VALUES (array[]::varchar[])';

    FOR dep IN SELECT * FROM departement

    LOOP

    EXECUTE'
    WITH tempa as
    (
    SELECT array_append(arr, quote_literal('''||dep||''')) as arr
    FROM liste
    )
    UPDATE liste
    SET arr = tempa.arr
    FROM tempa';

    END LOOP;

    EXECUTE 'SELECT array_to_string(arr, '','')
    FROM liste'
    INTO liste_dep;

    -- 6.3 Croisement carroyage INSEE avec le centroïde des bâtiments

    -- !!! ATTENTION, TOUS LES BÂTIMENTS NE CROISENT PAS FORCÉMENT LE CARROYAGE DE L'INSEE!!!

    EXECUTE 'UPDATE temp_oc1
    SET id_popref = i.idinspire, nb_popref = i.ind
    FROM filosofi'||an_pop||'_carreaux_200m_metropole as i
    WHERE left(i.depcom,2) IN ('||liste_dep||')
        AND temp_oc1.territoire = '''||nom_ter||'''
        AND ST_Intersects(temp_oc1.geomloc, i.geom)';

    EXECUTE 'CREATE INDEX ON temp_oc1 USING btree(id_popref)';
    EXECUTE 'CREATE INDEX ON temp_oc1 USING btree(nb_popref)';

    -- 6.4 Affectation du nombre d'habitants par bâtiment

    -- Contrairement à ce qui aurait pu être fait précédemment, on ne cherche pas à tout prix à obtenir un Pop1 entier (suppression de la fonction ceil() qui permettait d'affecter l'entier supérieur le plus proche).

    EXECUTE 'WITH tempa AS
    -- requête qui permet de sommer les clés de répartition de la population (en surface) par carreau pop
    (
        SELECT id_popref, sum(sdevrps) as sbatcars
        FROM temp_oc1
        WHERE territoire = '''||nom_ter||'''
        GROUP BY id_popref
        HAVING sum(sdevrps) > 0
    ),
    tempb AS
    -- requête qui permet de calculer la population par bâtiment (calcul de proportionnalité)
    (
        SELECT temp_oc1.id,
        (temp_oc1.nb_popref * temp_oc1.sdevrps)::numeric / tempa.sbatcars as pop1_s
        FROM tempa
        JOIN temp_oc1
        ON tempa.id_popref = temp_oc1.id_popref
        WHERE temp_oc1.territoire = '''||nom_ter||'''
    )
    -- requête de mise à jour de la couche du bâti
    UPDATE temp_oc1
    SET pop1_s = round(tempb.pop1_s::numeric,2)
    FROM tempb
    WHERE temp_oc1.id = tempb.id
        AND temp_oc1.territoire = '''||nom_ter||'''
        AND oc2 IS TRUE';

    EXECUTE 'CREATE INDEX ON temp_oc1 USING btree(pop1_s)';

    -- 7. Mise à jour de la couche d'origine Oc1

    EXECUTE 'UPDATE oc1
    SET pop1 = temp_oc1.pop1_s
    FROM temp_oc1
    WHERE oc1.id = temp_oc1.id';

END;
$function$
;

SELECT public.__var_pop1('Jura', '2021', '2015');