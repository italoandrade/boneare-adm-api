-- Diff code generated with pgModeler (PostgreSQL Database Modeler)
-- pgModeler version: 0.9.2-alpha
-- Diff date: 2018-10-22 13:50:23
-- Source model: boneareadm
-- Database: boneareadm
-- PostgreSQL version: 9.6

-- [ Diff summary ]
-- Dropped objects: 0
-- Created objects: 1
-- Changed objects: 1
-- Truncated tables: 0

SET search_path=public,pg_catalog,boneareadm;
-- ddl-end --


-- [ Dropped objects ] --
ALTER TABLE boneareadm.client_address DROP COLUMN IF EXISTS zipcode CASCADE;
-- ddl-end --


-- [ Created objects ] --
-- object: zip_code | type: COLUMN --
-- ALTER TABLE boneareadm.client_address DROP COLUMN IF EXISTS zip_code CASCADE;
ALTER TABLE boneareadm.client_address ADD COLUMN zip_code varchar(8);
-- ddl-end --




-- [ Changed objects ] --
ALTER ROLE italo
	ENCRYPTED PASSWORD 'Aspr1ll4**';
-- ddl-end --
