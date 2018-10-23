-- Diff code generated with pgModeler (PostgreSQL Database Modeler)
-- pgModeler version: 0.9.2-alpha
-- Diff date: 2018-10-23 16:26:28
-- Source model: boneareadm
-- Database: boneareadm
-- PostgreSQL version: 9.6

-- [ Diff summary ]
-- Dropped objects: 5
-- Created objects: 11
-- Changed objects: 0
-- Truncated tables: 0

SET search_path=public,pg_catalog,boneareadm;
-- ddl-end --


-- [ Dropped objects ] --
ALTER TABLE boneareadm.order_transaction DROP CONSTRAINT IF EXISTS order_transaction_last_updated_by_user_id_fk CASCADE;
-- ddl-end --
ALTER TABLE boneareadm.order_product DROP CONSTRAINT IF EXISTS order_product_last_updated_by_user_id_fk CASCADE;
-- ddl-end --
ALTER TABLE boneareadm."order" DROP CONSTRAINT IF EXISTS order_last_updated_by_user_id_fk CASCADE;
-- ddl-end --
ALTER TABLE boneareadm.product DROP CONSTRAINT IF EXISTS product_last_updated_by_user_id_fk CASCADE;
-- ddl-end --
ALTER TABLE boneareadm.client DROP CONSTRAINT IF EXISTS client_last_updated_by_user_id_fk CASCADE;
-- ddl-end --
ALTER TABLE boneareadm.client DROP COLUMN IF EXISTS last_updated_by CASCADE;
-- ddl-end --
ALTER TABLE boneareadm.product DROP COLUMN IF EXISTS last_updated_date CASCADE;
-- ddl-end --
ALTER TABLE boneareadm.product DROP COLUMN IF EXISTS last_updated_by CASCADE;
-- ddl-end --
ALTER TABLE boneareadm."order" DROP COLUMN IF EXISTS last_updated_by CASCADE;
-- ddl-end --
ALTER TABLE boneareadm.order_product DROP COLUMN IF EXISTS last_updated_by CASCADE;
-- ddl-end --
ALTER TABLE boneareadm.order_transaction DROP COLUMN IF EXISTS last_updated_by CASCADE;
-- ddl-end --


-- [ Created objects ] --
-- object: last_update_by | type: COLUMN --
-- ALTER TABLE boneareadm.client DROP COLUMN IF EXISTS last_update_by CASCADE;
ALTER TABLE boneareadm.client ADD COLUMN last_update_by integer;
-- ddl-end --


-- object: last_update_by | type: COLUMN --
-- ALTER TABLE boneareadm.product DROP COLUMN IF EXISTS last_update_by CASCADE;
ALTER TABLE boneareadm.product ADD COLUMN last_update_by integer;
-- ddl-end --


-- object: last_update_date | type: COLUMN --
-- ALTER TABLE boneareadm.product DROP COLUMN IF EXISTS last_update_date CASCADE;
ALTER TABLE boneareadm.product ADD COLUMN last_update_date timestamp with time zone;
-- ddl-end --


-- object: last_update_by | type: COLUMN --
-- ALTER TABLE boneareadm."order" DROP COLUMN IF EXISTS last_update_by CASCADE;
ALTER TABLE boneareadm."order" ADD COLUMN last_update_by integer;
-- ddl-end --


-- object: last_update_by | type: COLUMN --
-- ALTER TABLE boneareadm.order_product DROP COLUMN IF EXISTS last_update_by CASCADE;
ALTER TABLE boneareadm.order_product ADD COLUMN last_update_by integer;
-- ddl-end --


-- object: last_update_by | type: COLUMN --
-- ALTER TABLE boneareadm.order_transaction DROP COLUMN IF EXISTS last_update_by CASCADE;
ALTER TABLE boneareadm.order_transaction ADD COLUMN last_update_by integer;
-- ddl-end --




-- [ Created foreign keys ] --
-- object: client_last_updated_by_user_id_fk | type: CONSTRAINT --
-- ALTER TABLE boneareadm.client DROP CONSTRAINT IF EXISTS client_last_updated_by_user_id_fk CASCADE;
ALTER TABLE boneareadm.client ADD CONSTRAINT client_last_updated_by_user_id_fk FOREIGN KEY (last_update_by)
REFERENCES boneareadm."user" (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: product_last_updated_by_user_id_fk | type: CONSTRAINT --
-- ALTER TABLE boneareadm.product DROP CONSTRAINT IF EXISTS product_last_updated_by_user_id_fk CASCADE;
ALTER TABLE boneareadm.product ADD CONSTRAINT product_last_updated_by_user_id_fk FOREIGN KEY (last_update_by)
REFERENCES boneareadm."user" (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: order_last_updated_by_user_id_fk | type: CONSTRAINT --
-- ALTER TABLE boneareadm."order" DROP CONSTRAINT IF EXISTS order_last_updated_by_user_id_fk CASCADE;
ALTER TABLE boneareadm."order" ADD CONSTRAINT order_last_updated_by_user_id_fk FOREIGN KEY (last_update_by)
REFERENCES boneareadm."user" (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: order_product_last_updated_by_user_id_fk | type: CONSTRAINT --
-- ALTER TABLE boneareadm.order_product DROP CONSTRAINT IF EXISTS order_product_last_updated_by_user_id_fk CASCADE;
ALTER TABLE boneareadm.order_product ADD CONSTRAINT order_product_last_updated_by_user_id_fk FOREIGN KEY (last_update_by)
REFERENCES boneareadm."user" (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: order_transaction_last_updated_by_user_id_fk | type: CONSTRAINT --
-- ALTER TABLE boneareadm.order_transaction DROP CONSTRAINT IF EXISTS order_transaction_last_updated_by_user_id_fk CASCADE;
ALTER TABLE boneareadm.order_transaction ADD CONSTRAINT order_transaction_last_updated_by_user_id_fk FOREIGN KEY (last_update_by)
REFERENCES boneareadm."user" (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

