-- Diff code generated with pgModeler (PostgreSQL Database Modeler)
-- pgModeler version: 0.9.2-alpha
-- Diff date: 2018-10-19 17:38:03
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


-- [ Created objects ] --
-- object: entry | type: COLUMN --
-- ALTER TABLE boneareadm.order_product DROP COLUMN IF EXISTS entry CASCADE;
ALTER TABLE boneareadm.order_product ADD COLUMN entry boolean NOT NULL DEFAULT false;
-- ddl-end --




-- [ Changed objects ] --
ALTER ROLE italo
	ENCRYPTED PASSWORD 'Aspr1ll4**';
-- ddl-end --
