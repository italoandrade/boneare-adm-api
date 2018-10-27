-- Diff code generated with pgModeler (PostgreSQL Database Modeler)
-- pgModeler version: 0.9.2-alpha
-- Diff date: 2018-10-26 21:42:50
-- Source model: boneareadm
-- Database: boneareadm
-- PostgreSQL version: 9.6

-- [ Diff summary ]
-- Dropped objects: 0
-- Created objects: 1
-- Changed objects: 2
-- Truncated tables: 0

SET search_path=public,pg_catalog,boneareadm;
-- ddl-end --


-- [ Dropped objects ] --
ALTER TABLE boneareadm.order_transaction DROP COLUMN IF EXISTS value CASCADE;
-- ddl-end --


-- [ Created objects ] --
-- object: amount | type: COLUMN --
-- ALTER TABLE boneareadm.order_transaction DROP COLUMN IF EXISTS amount CASCADE;
ALTER TABLE boneareadm.order_transaction ADD COLUMN amount numeric(10,2) NOT NULL;
-- ddl-end --




-- [ Changed objects ] --
ALTER ROLE italo
	ENCRYPTED PASSWORD '123';
-- ddl-end --
ALTER TABLE boneareadm.order_transaction ALTER COLUMN date TYPE date;
-- ddl-end --


-- [ Created permissions ] --
-- object: grant_55cb4542ee | type: PERMISSION --
GRANT CREATE
   ON DATABASE boneareadm
   TO italo WITH GRANT OPTION;
-- ddl-end --

-- object: grant_00db51a51e | type: PERMISSION --
GRANT USAGE
   ON SEQUENCE boneareadm.product_id_seq
   TO italo;
-- ddl-end --

-- object: grant_a7affd46f8 | type: PERMISSION --
GRANT USAGE
   ON SEQUENCE boneareadm.client_phone_id_seq
   TO italo;
-- ddl-end --

-- object: grant_cd4b062ce7 | type: PERMISSION --
GRANT USAGE
   ON SEQUENCE boneareadm.order_product_id_seq
   TO italo;
-- ddl-end --

-- object: grant_819cd39e1f | type: PERMISSION --
GRANT USAGE
   ON SEQUENCE boneareadm.client_id_seq
   TO italo;
-- ddl-end --

-- object: grant_b2be677a69 | type: PERMISSION --
GRANT USAGE
   ON SEQUENCE boneareadm.order_transaction_id_seq
   TO italo;
-- ddl-end --

-- object: grant_0c466a9a2c | type: PERMISSION --
GRANT USAGE
   ON SEQUENCE boneareadm.order_id_seq
   TO italo;
-- ddl-end --

-- object: grant_45da76f7d4 | type: PERMISSION --
GRANT USAGE
   ON SEQUENCE boneareadm.client_email_id_seq
   TO italo;
-- ddl-end --

-- object: grant_3f28771413 | type: PERMISSION --
GRANT USAGE
   ON SEQUENCE boneareadm.user_id_seq
   TO italo;
-- ddl-end --

