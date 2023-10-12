SET client_encoding = 'UTF8';

CREATE SEQUENCE IF NOT EXISTS c_general.territoires_id_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 2147483647
    CACHE 1;
    --OWNED BY territoires.id;

ALTER SEQUENCE c_general.territoires_id_seq
    OWNER TO g_admin;

GRANT ALL ON SEQUENCE c_general.territoires_id_seq TO g_admin;

GRANT SELECT ON SEQUENCE c_general.territoires_id_seq TO g_consult;

-- Table: c_general.territoires

-- DROP TABLE IF EXISTS c_general.territoires;

CREATE TABLE IF NOT EXISTS c_general.territoires
(
    geom geometry(MultiPolygon,2154),
    territoire character varying(200) COLLATE pg_catalog."default",
    id integer NOT NULL DEFAULT nextval('c_general.territoires_id_seq'::regclass),
    insee_dep character varying[] COLLATE pg_catalog."default",
    CONSTRAINT territoires_pkey PRIMARY KEY (id)
)
;
ALTER TABLE IF EXISTS c_general.territoires
    OWNER to g_admin;

REVOKE ALL ON TABLE c_general.territoires FROM g_consult;

GRANT ALL ON TABLE c_general.territoires TO g_admin;

GRANT SELECT ON TABLE c_general.territoires TO g_consult;

COMMENT ON TABLE c_general.territoires
    IS 'Couche des territoires-tests pour AgiRisk';
-- Index: sidx_territoires_geom

-- DROP INDEX IF EXISTS c_general.sidx_territoires_geom;

CREATE INDEX IF NOT EXISTS sidx_territoires_geom
    ON c_general.territoires USING gist
    (geom);
-- Index: territoires_territoire_idx

-- DROP INDEX IF EXISTS c_general.territoires_territoire_idx;

CREATE INDEX IF NOT EXISTS territoires_territoire_idx
    ON c_general.territoires USING btree
    (territoire COLLATE pg_catalog."default" ASC NULLS LAST);

-- Trigger: alim_numdept_terr

DROP TRIGGER IF EXISTS alim_numdept_terr ON c_general.territoires;
CREATE TRIGGER alim_numdept_terr
    BEFORE INSERT
    ON c_general.territoires
    FOR EACH ROW
    EXECUTE FUNCTION public.__util_alim_numdept_terr();
