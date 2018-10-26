-- Diff code generated with pgModeler (PostgreSQL Database Modeler)
-- pgModeler version: 0.9.2-alpha
-- Diff date: 2018-10-26 20:54:05
-- Source model: boneareadm
-- Database: boneareadm
-- PostgreSQL version: 9.6

-- [ Diff summary ]
-- Dropped objects: 0
-- Created objects: 0
-- Changed objects: 1
-- Truncated tables: 0

SET search_path=public,pg_catalog,boneareadm;
-- ddl-end --


-- [ Changed objects ] --
ALTER ROLE italo
	ENCRYPTED PASSWORD '123';
-- ddl-end --


-- [ Created permissions ] --
-- object: grant_14661280e6 | type: PERMISSION --
GRANT CREATE
   ON DATABASE boneareadm
   TO italo WITH GRANT OPTION;
-- ddl-end --

-- object: grant_208bd489b4 | type: PERMISSION --
GRANT USAGE
   ON SEQUENCE boneareadm.product_id_seq
   TO italo;
-- ddl-end --

-- object: grant_9475f9eddb | type: PERMISSION --
GRANT USAGE
   ON SEQUENCE boneareadm.client_phone_id_seq
   TO italo;
-- ddl-end --

-- object: grant_c161421265 | type: PERMISSION --
GRANT USAGE
   ON SEQUENCE boneareadm.order_product_id_seq
   TO italo;
-- ddl-end --

-- object: grant_74d8214fc5 | type: PERMISSION --
GRANT USAGE
   ON SEQUENCE boneareadm.client_id_seq
   TO italo;
-- ddl-end --

-- object: grant_1ff712beb2 | type: PERMISSION --
GRANT USAGE
   ON SEQUENCE boneareadm.order_transaction_id_seq
   TO italo;
-- ddl-end --

-- object: grant_08cb5c2760 | type: PERMISSION --
GRANT USAGE
   ON SEQUENCE boneareadm.order_id_seq
   TO italo;
-- ddl-end --

-- object: grant_d0b0ae83ad | type: PERMISSION --
GRANT USAGE
   ON SEQUENCE boneareadm.client_email_id_seq
   TO italo;
-- ddl-end --

-- object: grant_4829ded440 | type: PERMISSION --
GRANT USAGE
   ON SEQUENCE boneareadm.user_id_seq
   TO italo;
-- ddl-end --

