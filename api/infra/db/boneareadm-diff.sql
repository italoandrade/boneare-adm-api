-- Diff code generated with pgModeler (PostgreSQL Database Modeler)
-- pgModeler version: 0.9.2-alpha
-- Diff date: 2018-10-27 12:02:14
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
-- object: date | type: COLUMN --
-- ALTER TABLE boneareadm."order" DROP COLUMN IF EXISTS date CASCADE;
ALTER TABLE boneareadm."order" ADD COLUMN date date;
-- ddl-end --




-- [ Changed objects ] --
ALTER ROLE italo
	NOINHERIT
	ENCRYPTED PASSWORD '123';
-- ddl-end --


-- [ Created permissions ] --
-- object: grant_004bcc19ae | type: PERMISSION --
GRANT CREATE
   ON DATABASE boneareadm
   TO italo WITH GRANT OPTION;
-- ddl-end --

-- object: grant_692dbc0735 | type: PERMISSION --
GRANT USAGE
   ON SEQUENCE boneareadm.product_id_seq
   TO italo;
-- ddl-end --

-- object: grant_dd227f71cb | type: PERMISSION --
GRANT USAGE
   ON SEQUENCE boneareadm.client_phone_id_seq
   TO italo;
-- ddl-end --

-- object: grant_55d665eb80 | type: PERMISSION --
GRANT USAGE
   ON SEQUENCE boneareadm.order_product_id_seq
   TO italo;
-- ddl-end --

-- object: grant_9bc4333fd0 | type: PERMISSION --
GRANT USAGE
   ON SEQUENCE boneareadm.client_id_seq
   TO italo;
-- ddl-end --

-- object: grant_36e654151e | type: PERMISSION --
GRANT USAGE
   ON SEQUENCE boneareadm.order_transaction_id_seq
   TO italo;
-- ddl-end --

-- object: grant_ec16d21681 | type: PERMISSION --
GRANT USAGE
   ON SEQUENCE boneareadm.order_id_seq
   TO italo;
-- ddl-end --

-- object: grant_b3a6e59c30 | type: PERMISSION --
GRANT USAGE
   ON SEQUENCE boneareadm.client_email_id_seq
   TO italo;
-- ddl-end --

-- object: grant_ff0d83b436 | type: PERMISSION --
GRANT USAGE
   ON SEQUENCE boneareadm.user_id_seq
   TO italo;
-- ddl-end --

