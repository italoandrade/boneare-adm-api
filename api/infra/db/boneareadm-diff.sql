-- Diff code generated with pgModeler (PostgreSQL Database Modeler)
-- pgModeler version: 0.9.2-alpha
-- Diff date: 2018-10-27 18:51:50
-- Source model: boneareadm
-- Database: boneareadm
-- PostgreSQL version: 9.6

-- [ Diff summary ]
-- Dropped objects: 0
-- Created objects: 52
-- Changed objects: 1
-- Truncated tables: 0

SET search_path=public,pg_catalog,boneareadm;
-- ddl-end --


-- [ Created objects ] --
-- object: boneareadm | type: SCHEMA --
-- DROP SCHEMA IF EXISTS boneareadm CASCADE;
CREATE SCHEMA boneareadm;
-- ddl-end --
ALTER SCHEMA boneareadm OWNER TO postgres;
-- ddl-end --

-- object: boneareadm.user_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS boneareadm.user_id_seq CASCADE;
CREATE SEQUENCE boneareadm.user_id_seq
	INCREMENT BY 1
	MINVALUE -2147483648
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --

-- object: boneareadm."user" | type: TABLE --
-- DROP TABLE IF EXISTS boneareadm."user" CASCADE;
CREATE TABLE boneareadm."user"(
	id integer NOT NULL DEFAULT nextval('boneareadm.user_id_seq'::regclass),
	email varchar(255) NOT NULL,
	password varchar(64) NOT NULL,
	password_hash varchar(64) NOT NULL,
	name varchar(60) NOT NULL,
	picture varchar(50),
	created_by integer,
	creation_date timestamp with time zone NOT NULL DEFAULT now(),
	last_update_by integer,
	last_update_date timestamp with time zone,
	CONSTRAINT user_pk PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE boneareadm."user" OWNER TO postgres;
-- ddl-end --

-- object: boneareadm.client_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS boneareadm.client_id_seq CASCADE;
CREATE SEQUENCE boneareadm.client_id_seq
	INCREMENT BY 1
	MINVALUE -2147483648
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --

-- object: boneareadm.client | type: TABLE --
-- DROP TABLE IF EXISTS boneareadm.client CASCADE;
CREATE TABLE boneareadm.client(
	id integer NOT NULL DEFAULT nextval('boneareadm.client_id_seq'::regclass),
	name varchar(100) NOT NULL,
	document varchar(20),
	description varchar(200),
	created_by integer NOT NULL,
	creation_date timestamp with time zone NOT NULL DEFAULT now(),
	last_update_by integer,
	last_update_date timestamp with time zone,
	CONSTRAINT client_pk PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE boneareadm.client OWNER TO postgres;
-- ddl-end --

-- object: boneareadm.product_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS boneareadm.product_id_seq CASCADE;
CREATE SEQUENCE boneareadm.product_id_seq
	INCREMENT BY 1
	MINVALUE -2147483648
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --

-- object: boneareadm.product | type: TABLE --
-- DROP TABLE IF EXISTS boneareadm.product CASCADE;
CREATE TABLE boneareadm.product(
	id integer NOT NULL DEFAULT nextval('boneareadm.product_id_seq'::regclass),
	name varchar(100) NOT NULL,
	weight numeric(10,2) NOT NULL,
	price numeric(10,2) NOT NULL,
	created_by integer NOT NULL,
	creation_date timestamp with time zone NOT NULL DEFAULT now(),
	last_update_by integer,
	last_update_date timestamp with time zone,
	CONSTRAINT product_pk PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE boneareadm.product OWNER TO postgres;
-- ddl-end --

-- object: boneareadm.client_address | type: TABLE --
-- DROP TABLE IF EXISTS boneareadm.client_address CASCADE;
CREATE TABLE boneareadm.client_address(
	client_id integer NOT NULL,
	zip_code varchar(8),
	street varchar(200),
	number varchar(20),
	complement varchar(200),
	district varchar(50),
	city varchar(50),
	state varchar(2),
	CONSTRAINT client_address_pk PRIMARY KEY (client_id)

);
-- ddl-end --
ALTER TABLE boneareadm.client_address OWNER TO postgres;
-- ddl-end --

-- object: client_address_client_id_idx | type: INDEX --
-- DROP INDEX IF EXISTS boneareadm.client_address_client_id_idx CASCADE;
CREATE INDEX client_address_client_id_idx ON boneareadm.client_address
	USING btree
	(
	  client_id
	);
-- ddl-end --

-- object: boneareadm.order_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS boneareadm.order_id_seq CASCADE;
CREATE SEQUENCE boneareadm.order_id_seq
	INCREMENT BY 1
	MINVALUE -2147483648
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --

-- object: boneareadm."order" | type: TABLE --
-- DROP TABLE IF EXISTS boneareadm."order" CASCADE;
CREATE TABLE boneareadm."order"(
	id integer NOT NULL DEFAULT nextval('boneareadm.order_id_seq'::regclass),
	description varchar(100),
	date date,
	client_id integer,
	created_by integer NOT NULL,
	creation_date timestamp with time zone NOT NULL DEFAULT now(),
	last_update_by integer,
	last_update_date timestamp with time zone,
	CONSTRAINT order_pk PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE boneareadm."order" OWNER TO postgres;
-- ddl-end --

-- object: boneareadm.settings | type: TABLE --
-- DROP TABLE IF EXISTS boneareadm.settings CASCADE;
CREATE TABLE boneareadm.settings(
	s3bucket varchar(200) NOT NULL
);
-- ddl-end --
ALTER TABLE boneareadm.settings OWNER TO postgres;
-- ddl-end --

-- object: boneareadm.order_product_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS boneareadm.order_product_id_seq CASCADE;
CREATE SEQUENCE boneareadm.order_product_id_seq
	INCREMENT BY 1
	MINVALUE -2147483648
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --

-- object: boneareadm.order_product | type: TABLE --
-- DROP TABLE IF EXISTS boneareadm.order_product CASCADE;
CREATE TABLE boneareadm.order_product(
	id integer NOT NULL DEFAULT nextval('boneareadm.order_product_id_seq'::regclass),
	order_id integer NOT NULL,
	product_id integer NOT NULL,
	quantity smallint NOT NULL,
	entry boolean NOT NULL DEFAULT false,
	created_by integer NOT NULL,
	creation_date timestamp with time zone NOT NULL DEFAULT now(),
	last_update_by integer,
	last_update_date timestamp with time zone,
	CONSTRAINT order_product_pk PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE boneareadm.order_product OWNER TO postgres;
-- ddl-end --

-- object: boneareadm.transaction_type | type: TABLE --
-- DROP TABLE IF EXISTS boneareadm.transaction_type CASCADE;
CREATE TABLE boneareadm.transaction_type(
	id smallint NOT NULL,
	name varchar(10) NOT NULL,
	CONSTRAINT transaction_type_pk PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE boneareadm.transaction_type OWNER TO postgres;
-- ddl-end --

INSERT INTO boneareadm.transaction_type (id, name) VALUES (E'1', E'Receita');
-- ddl-end --
INSERT INTO boneareadm.transaction_type (id, name) VALUES (E'2', E'Despesa');
-- ddl-end --

-- object: transaction_type_id_idx | type: INDEX --
-- DROP INDEX IF EXISTS boneareadm.transaction_type_id_idx CASCADE;
CREATE INDEX transaction_type_id_idx ON boneareadm.transaction_type
	USING btree
	(
	  id
	);
-- ddl-end --

-- object: boneareadm.order_transaction_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS boneareadm.order_transaction_id_seq CASCADE;
CREATE SEQUENCE boneareadm.order_transaction_id_seq
	INCREMENT BY 1
	MINVALUE -2147483648
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --

-- object: boneareadm.order_transaction | type: TABLE --
-- DROP TABLE IF EXISTS boneareadm.order_transaction CASCADE;
CREATE TABLE boneareadm.order_transaction(
	id integer NOT NULL DEFAULT nextval('boneareadm.order_transaction_id_seq'::regclass),
	order_id integer NOT NULL,
	type smallint NOT NULL,
	amount numeric(10,2) NOT NULL,
	date date NOT NULL,
	created_by integer NOT NULL,
	creation_date timestamp with time zone NOT NULL DEFAULT now(),
	last_update_by integer,
	last_update_date timestamp with time zone,
	CONSTRAINT order_transaction_pk PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE boneareadm.order_transaction OWNER TO postgres;
-- ddl-end --

-- object: user_id_idx | type: INDEX --
-- DROP INDEX IF EXISTS boneareadm.user_id_idx CASCADE;
CREATE INDEX user_id_idx ON boneareadm."user"
	USING btree
	(
	  id
	);
-- ddl-end --

-- object: user_email_idx | type: INDEX --
-- DROP INDEX IF EXISTS boneareadm.user_email_idx CASCADE;
CREATE INDEX user_email_idx ON boneareadm."user"
	USING btree
	(
	  email
	);
-- ddl-end --

-- object: client_id_idx | type: INDEX --
-- DROP INDEX IF EXISTS boneareadm.client_id_idx CASCADE;
CREATE INDEX client_id_idx ON boneareadm.client
	USING btree
	(
	  id
	);
-- ddl-end --

-- object: product_id_idx | type: INDEX --
-- DROP INDEX IF EXISTS boneareadm.product_id_idx CASCADE;
CREATE INDEX product_id_idx ON boneareadm.product
	USING btree
	(
	  id
	);
-- ddl-end --

-- object: order_id_idx | type: INDEX --
-- DROP INDEX IF EXISTS boneareadm.order_id_idx CASCADE;
CREATE INDEX order_id_idx ON boneareadm."order"
	USING btree
	(
	  id
	);
-- ddl-end --

-- object: order_client_id_idx | type: INDEX --
-- DROP INDEX IF EXISTS boneareadm.order_client_id_idx CASCADE;
CREATE INDEX order_client_id_idx ON boneareadm."order"
	USING btree
	(
	  id
	);
-- ddl-end --

-- object: order_product_order_id_idx | type: INDEX --
-- DROP INDEX IF EXISTS boneareadm.order_product_order_id_idx CASCADE;
CREATE INDEX order_product_order_id_idx ON boneareadm.order_product
	USING btree
	(
	  order_id
	);
-- ddl-end --

-- object: order_transaction_order_id_idx | type: INDEX --
-- DROP INDEX IF EXISTS boneareadm.order_transaction_order_id_idx CASCADE;
CREATE INDEX order_transaction_order_id_idx ON boneareadm.order_transaction
	USING btree
	(
	  order_id
	);
-- ddl-end --

-- object: boneareadm.client_phone_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS boneareadm.client_phone_id_seq CASCADE;
CREATE SEQUENCE boneareadm.client_phone_id_seq
	INCREMENT BY 1
	MINVALUE -2147483648
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --

-- object: boneareadm.client_phone | type: TABLE --
-- DROP TABLE IF EXISTS boneareadm.client_phone CASCADE;
CREATE TABLE boneareadm.client_phone(
	id integer NOT NULL DEFAULT nextval('boneareadm.client_phone_id_seq'::regclass),
	client_id integer NOT NULL,
	number bigint NOT NULL,
	CONSTRAINT client_phone_pk PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE boneareadm.client_phone OWNER TO postgres;
-- ddl-end --

-- object: client_phone_client_id_idx | type: INDEX --
-- DROP INDEX IF EXISTS boneareadm.client_phone_client_id_idx CASCADE;
CREATE INDEX client_phone_client_id_idx ON boneareadm.client_phone
	USING btree
	(
	  number
	);
-- ddl-end --

-- object: boneareadm.client_email_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS boneareadm.client_email_id_seq CASCADE;
CREATE SEQUENCE boneareadm.client_email_id_seq
	INCREMENT BY 1
	MINVALUE -2147483648
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --

-- object: boneareadm.client_email | type: TABLE --
-- DROP TABLE IF EXISTS boneareadm.client_email CASCADE;
CREATE TABLE boneareadm.client_email(
	id integer NOT NULL DEFAULT nextval('boneareadm.client_email_id_seq'::regclass),
	client_id integer NOT NULL,
	email varchar(255) NOT NULL,
	CONSTRAINT client_email_pk PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE boneareadm.client_email OWNER TO postgres;
-- ddl-end --

-- object: client_email_client_id_idx | type: INDEX --
-- DROP INDEX IF EXISTS boneareadm.client_email_client_id_idx CASCADE;
CREATE INDEX client_email_client_id_idx ON boneareadm.client_email
	USING btree
	(
	  id
	);
-- ddl-end --



-- [ Changed objects ] --
ALTER ROLE italo
	ENCRYPTED PASSWORD '123';
-- ddl-end --


-- [ Created foreign keys ] --
-- object: user_created_by_user_id_fk | type: CONSTRAINT --
-- ALTER TABLE boneareadm."user" DROP CONSTRAINT IF EXISTS user_created_by_user_id_fk CASCADE;
ALTER TABLE boneareadm."user" ADD CONSTRAINT user_created_by_user_id_fk FOREIGN KEY (created_by)
REFERENCES boneareadm."user" (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: user_last_updated_by_user_id_fk | type: CONSTRAINT --
-- ALTER TABLE boneareadm."user" DROP CONSTRAINT IF EXISTS user_last_updated_by_user_id_fk CASCADE;
ALTER TABLE boneareadm."user" ADD CONSTRAINT user_last_updated_by_user_id_fk FOREIGN KEY (last_update_by)
REFERENCES boneareadm."user" (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: client_created_by_user_id_fk | type: CONSTRAINT --
-- ALTER TABLE boneareadm.client DROP CONSTRAINT IF EXISTS client_created_by_user_id_fk CASCADE;
ALTER TABLE boneareadm.client ADD CONSTRAINT client_created_by_user_id_fk FOREIGN KEY (created_by)
REFERENCES boneareadm."user" (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: client_last_updated_by_user_id_fk | type: CONSTRAINT --
-- ALTER TABLE boneareadm.client DROP CONSTRAINT IF EXISTS client_last_updated_by_user_id_fk CASCADE;
ALTER TABLE boneareadm.client ADD CONSTRAINT client_last_updated_by_user_id_fk FOREIGN KEY (last_update_by)
REFERENCES boneareadm."user" (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: product_created_by_user_id_fk | type: CONSTRAINT --
-- ALTER TABLE boneareadm.product DROP CONSTRAINT IF EXISTS product_created_by_user_id_fk CASCADE;
ALTER TABLE boneareadm.product ADD CONSTRAINT product_created_by_user_id_fk FOREIGN KEY (created_by)
REFERENCES boneareadm."user" (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: product_last_updated_by_user_id_fk | type: CONSTRAINT --
-- ALTER TABLE boneareadm.product DROP CONSTRAINT IF EXISTS product_last_updated_by_user_id_fk CASCADE;
ALTER TABLE boneareadm.product ADD CONSTRAINT product_last_updated_by_user_id_fk FOREIGN KEY (last_update_by)
REFERENCES boneareadm."user" (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: client_address_client_id_client_id_fk | type: CONSTRAINT --
-- ALTER TABLE boneareadm.client_address DROP CONSTRAINT IF EXISTS client_address_client_id_client_id_fk CASCADE;
ALTER TABLE boneareadm.client_address ADD CONSTRAINT client_address_client_id_client_id_fk FOREIGN KEY (client_id)
REFERENCES boneareadm.client (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: order_client_id_client_id_fk | type: CONSTRAINT --
-- ALTER TABLE boneareadm."order" DROP CONSTRAINT IF EXISTS order_client_id_client_id_fk CASCADE;
ALTER TABLE boneareadm."order" ADD CONSTRAINT order_client_id_client_id_fk FOREIGN KEY (client_id)
REFERENCES boneareadm.client (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: order_created_by_user_id_fk | type: CONSTRAINT --
-- ALTER TABLE boneareadm."order" DROP CONSTRAINT IF EXISTS order_created_by_user_id_fk CASCADE;
ALTER TABLE boneareadm."order" ADD CONSTRAINT order_created_by_user_id_fk FOREIGN KEY (created_by)
REFERENCES boneareadm."user" (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: order_last_updated_by_user_id_fk | type: CONSTRAINT --
-- ALTER TABLE boneareadm."order" DROP CONSTRAINT IF EXISTS order_last_updated_by_user_id_fk CASCADE;
ALTER TABLE boneareadm."order" ADD CONSTRAINT order_last_updated_by_user_id_fk FOREIGN KEY (last_update_by)
REFERENCES boneareadm."user" (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: order_product_order_id_order_id_fk | type: CONSTRAINT --
-- ALTER TABLE boneareadm.order_product DROP CONSTRAINT IF EXISTS order_product_order_id_order_id_fk CASCADE;
ALTER TABLE boneareadm.order_product ADD CONSTRAINT order_product_order_id_order_id_fk FOREIGN KEY (order_id)
REFERENCES boneareadm."order" (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: order_product_product_id_product_id_fk | type: CONSTRAINT --
-- ALTER TABLE boneareadm.order_product DROP CONSTRAINT IF EXISTS order_product_product_id_product_id_fk CASCADE;
ALTER TABLE boneareadm.order_product ADD CONSTRAINT order_product_product_id_product_id_fk FOREIGN KEY (product_id)
REFERENCES boneareadm.product (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: order_product_created_by_user_id_fk | type: CONSTRAINT --
-- ALTER TABLE boneareadm.order_product DROP CONSTRAINT IF EXISTS order_product_created_by_user_id_fk CASCADE;
ALTER TABLE boneareadm.order_product ADD CONSTRAINT order_product_created_by_user_id_fk FOREIGN KEY (created_by)
REFERENCES boneareadm."user" (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: order_product_last_updated_by_user_id_fk | type: CONSTRAINT --
-- ALTER TABLE boneareadm.order_product DROP CONSTRAINT IF EXISTS order_product_last_updated_by_user_id_fk CASCADE;
ALTER TABLE boneareadm.order_product ADD CONSTRAINT order_product_last_updated_by_user_id_fk FOREIGN KEY (last_update_by)
REFERENCES boneareadm."user" (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: order_transaction_order_id_order_id_fk | type: CONSTRAINT --
-- ALTER TABLE boneareadm.order_transaction DROP CONSTRAINT IF EXISTS order_transaction_order_id_order_id_fk CASCADE;
ALTER TABLE boneareadm.order_transaction ADD CONSTRAINT order_transaction_order_id_order_id_fk FOREIGN KEY (order_id)
REFERENCES boneareadm."order" (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: order_transaction_type_transaction_type_id_fk | type: CONSTRAINT --
-- ALTER TABLE boneareadm.order_transaction DROP CONSTRAINT IF EXISTS order_transaction_type_transaction_type_id_fk CASCADE;
ALTER TABLE boneareadm.order_transaction ADD CONSTRAINT order_transaction_type_transaction_type_id_fk FOREIGN KEY (type)
REFERENCES boneareadm.transaction_type (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: order_transaction_created_by_user_id_fk | type: CONSTRAINT --
-- ALTER TABLE boneareadm.order_transaction DROP CONSTRAINT IF EXISTS order_transaction_created_by_user_id_fk CASCADE;
ALTER TABLE boneareadm.order_transaction ADD CONSTRAINT order_transaction_created_by_user_id_fk FOREIGN KEY (created_by)
REFERENCES boneareadm."user" (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: order_transaction_last_updated_by_user_id_fk | type: CONSTRAINT --
-- ALTER TABLE boneareadm.order_transaction DROP CONSTRAINT IF EXISTS order_transaction_last_updated_by_user_id_fk CASCADE;
ALTER TABLE boneareadm.order_transaction ADD CONSTRAINT order_transaction_last_updated_by_user_id_fk FOREIGN KEY (last_update_by)
REFERENCES boneareadm."user" (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: client_phone_client_id_client_id_fk | type: CONSTRAINT --
-- ALTER TABLE boneareadm.client_phone DROP CONSTRAINT IF EXISTS client_phone_client_id_client_id_fk CASCADE;
ALTER TABLE boneareadm.client_phone ADD CONSTRAINT client_phone_client_id_client_id_fk FOREIGN KEY (client_id)
REFERENCES boneareadm.client (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: client_email_client_id_client_id_fk | type: CONSTRAINT --
-- ALTER TABLE boneareadm.client_email DROP CONSTRAINT IF EXISTS client_email_client_id_client_id_fk CASCADE;
ALTER TABLE boneareadm.client_email ADD CONSTRAINT client_email_client_id_client_id_fk FOREIGN KEY (client_id)
REFERENCES boneareadm.client (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --



-- [ Created permissions ] --
-- object: grant_3dfd3a8cb0 | type: PERMISSION --
GRANT CREATE
   ON DATABASE boneareadm
   TO italo WITH GRANT OPTION;
-- ddl-end --

-- object: grant_001ef6bd77 | type: PERMISSION --
GRANT USAGE
   ON SCHEMA boneareadm
   TO italo;
-- ddl-end --

-- object: grant_b990256fb8 | type: PERMISSION --
GRANT SELECT
   ON TABLE boneareadm.settings
   TO italo;
-- ddl-end --

-- object: grant_185dd58bda | type: PERMISSION --
GRANT SELECT,INSERT,UPDATE,DELETE
   ON TABLE boneareadm."user"
   TO italo;
-- ddl-end --

-- object: grant_9cf51d6003 | type: PERMISSION --
GRANT SELECT,INSERT,UPDATE,DELETE
   ON TABLE boneareadm.client
   TO italo;
-- ddl-end --

-- object: grant_ad3fe0aca8 | type: PERMISSION --
GRANT SELECT,INSERT,UPDATE,DELETE
   ON TABLE boneareadm.client_phone
   TO italo;
-- ddl-end --

-- object: grant_e93510b52d | type: PERMISSION --
GRANT SELECT,INSERT,UPDATE,DELETE
   ON TABLE boneareadm.client_email
   TO italo;
-- ddl-end --

-- object: grant_47bd672e44 | type: PERMISSION --
GRANT SELECT,INSERT,UPDATE,DELETE
   ON TABLE boneareadm.client_address
   TO italo;
-- ddl-end --

-- object: grant_f4ea7be5ae | type: PERMISSION --
GRANT SELECT,INSERT,UPDATE,DELETE
   ON TABLE boneareadm.product
   TO italo;
-- ddl-end --

-- object: grant_5107778acd | type: PERMISSION --
GRANT SELECT,INSERT,UPDATE,DELETE
   ON TABLE boneareadm."order"
   TO italo;
-- ddl-end --

-- object: grant_db624d3b5c | type: PERMISSION --
GRANT SELECT
   ON TABLE boneareadm.transaction_type
   TO italo;
-- ddl-end --

-- object: grant_484255061b | type: PERMISSION --
GRANT SELECT,INSERT,UPDATE,DELETE
   ON TABLE boneareadm.order_product
   TO italo;
-- ddl-end --

-- object: grant_c485708bcb | type: PERMISSION --
GRANT SELECT,INSERT,UPDATE,DELETE
   ON TABLE boneareadm.order_transaction
   TO italo;
-- ddl-end --

-- object: grant_69ec48ff13 | type: PERMISSION --
GRANT USAGE
   ON SEQUENCE boneareadm.product_id_seq
   TO italo;
-- ddl-end --

-- object: grant_b11d08dfd4 | type: PERMISSION --
GRANT USAGE
   ON SEQUENCE boneareadm.client_phone_id_seq
   TO italo;
-- ddl-end --

-- object: grant_02c54fb0a4 | type: PERMISSION --
GRANT USAGE
   ON SEQUENCE boneareadm.order_product_id_seq
   TO italo;
-- ddl-end --

-- object: grant_68035af3ec | type: PERMISSION --
GRANT USAGE
   ON SEQUENCE boneareadm.client_id_seq
   TO italo;
-- ddl-end --

-- object: grant_b8e982aceb | type: PERMISSION --
GRANT USAGE
   ON SEQUENCE boneareadm.order_transaction_id_seq
   TO italo;
-- ddl-end --

-- object: grant_a5440cf23e | type: PERMISSION --
GRANT USAGE
   ON SEQUENCE boneareadm.order_id_seq
   TO italo;
-- ddl-end --

-- object: grant_5304eca841 | type: PERMISSION --
GRANT USAGE
   ON SEQUENCE boneareadm.client_email_id_seq
   TO italo;
-- ddl-end --

-- object: grant_115a0b1876 | type: PERMISSION --
GRANT USAGE
   ON SEQUENCE boneareadm.user_id_seq
   TO italo;
-- ddl-end --

