-- Diff code generated with pgModeler (PostgreSQL Database Modeler)
-- pgModeler version: 0.9.2-alpha
-- Diff date: 2018-10-26 17:24:29
-- Source model: boneareadm
-- Database: boneareadm
-- PostgreSQL version: 9.6

-- [ Diff summary ]
-- Dropped objects: 0
-- Created objects: 0
-- Changed objects: 2
-- Truncated tables: 0

SET search_path=public,pg_catalog,boneareadm;
-- ddl-end --


-- [ Changed objects ] --
ALTER ROLE italo
	ENCRYPTED PASSWORD '123';
-- ddl-end --
ALTER TABLE boneareadm.order_transaction ALTER COLUMN date TYPE date;
-- ddl-end --


-- [ Created permissions ] --
-- object: grant_95411eed89 | type: PERMISSION --
GRANT USAGE
   ON SEQUENCE boneareadm.product_id_seq
   TO italo;
-- ddl-end --

-- object: grant_9b3043055b | type: PERMISSION --
GRANT USAGE
   ON SEQUENCE boneareadm.client_phone_id_seq
   TO italo;
-- ddl-end --

-- object: grant_aaff4d8c81 | type: PERMISSION --
GRANT USAGE
   ON SEQUENCE boneareadm.order_product_id_seq
   TO italo;
-- ddl-end --

-- object: grant_756f700fbd | type: PERMISSION --
GRANT USAGE
   ON SEQUENCE boneareadm.client_id_seq
   TO italo;
-- ddl-end --

-- object: grant_0305c1d5d2 | type: PERMISSION --
GRANT USAGE
   ON SEQUENCE boneareadm.order_transaction_id_seq
   TO italo;
-- ddl-end --

-- object: grant_337bf4937a | type: PERMISSION --
GRANT USAGE
   ON SEQUENCE boneareadm.order_id_seq
   TO italo;
-- ddl-end --

-- object: grant_141530c39b | type: PERMISSION --
GRANT USAGE
   ON SEQUENCE boneareadm.client_email_id_seq
   TO italo;
-- ddl-end --

-- object: grant_549be1a700 | type: PERMISSION --
GRANT USAGE
   ON SEQUENCE boneareadm.user_id_seq
   TO italo;
-- ddl-end --

