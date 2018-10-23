-- Diff code generated with pgModeler (PostgreSQL Database Modeler)
-- pgModeler version: 0.9.2-alpha
-- Diff date: 2018-10-23 15:04:54
-- Source model: boneareadm
-- Database: boneareadm
-- PostgreSQL version: 9.6

-- [ Diff summary ]
-- Dropped objects: 1
-- Created objects: 1
-- Changed objects: 0
-- Truncated tables: 0

SET search_path=public,pg_catalog,boneareadm;
-- ddl-end --


-- [ Dropped objects ] --
ALTER TABLE boneareadm.client DROP CONSTRAINT IF EXISTS client_created_by_user_id_fk CASCADE;
-- ddl-end --


-- [ Created foreign keys ] --
-- object: client_created_by_user_id_fk | type: CONSTRAINT --
-- ALTER TABLE boneareadm.client DROP CONSTRAINT IF EXISTS client_created_by_user_id_fk CASCADE;
ALTER TABLE boneareadm.client ADD CONSTRAINT client_created_by_user_id_fk FOREIGN KEY (created_by)
REFERENCES boneareadm."user" (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

