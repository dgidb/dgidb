--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: addresses; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE addresses (
    id integer NOT NULL,
    address character varying(255),
    city character varying(255),
    state character varying(255),
    zip character varying(255),
    developer_id integer
);


--
-- Name: addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE addresses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE addresses_id_seq OWNED BY addresses.id;


--
-- Name: animals; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE animals (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    size character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: animals_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE animals_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: animals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE animals_id_seq OWNED BY animals.id;


--
-- Name: books; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE books (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    publisher character varying(255) DEFAULT 'Default Publisher'::character varying NOT NULL,
    author_name character varying(255) NOT NULL,
    created_at timestamp without time zone,
    created_on timestamp without time zone,
    updated_at timestamp without time zone,
    updated_on timestamp without time zone,
    publish_date date,
    topic_id integer,
    for_sale boolean DEFAULT true
);


--
-- Name: books_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE books_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: books_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE books_id_seq OWNED BY books.id;


--
-- Name: cart_items; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE cart_items (
    id integer NOT NULL,
    shopping_cart_id character varying(255) NOT NULL,
    book_id character varying(255) NOT NULL,
    copies integer DEFAULT 1,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: cart_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE cart_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cart_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE cart_items_id_seq OWNED BY cart_items.id;


--
-- Name: developers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE developers (
    id integer NOT NULL,
    name character varying(255),
    salary integer DEFAULT 70000,
    created_at timestamp without time zone,
    team_id integer,
    updated_at timestamp without time zone
);


--
-- Name: developers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE developers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: developers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE developers_id_seq OWNED BY developers.id;


--
-- Name: drug_claim_aliases; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE drug_claim_aliases (
    id text NOT NULL,
    drug_claim_id text NOT NULL,
    alias text NOT NULL,
    description text,
    nomenclature text NOT NULL
);


--
-- Name: drug_claim_attributes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE drug_claim_attributes (
    id text NOT NULL,
    drug_claim_id text NOT NULL,
    name text NOT NULL,
    value text NOT NULL,
    description text
);


--
-- Name: drug_claim_types; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE drug_claim_types (
    id character varying(255) NOT NULL,
    type character varying(255) NOT NULL
);


--
-- Name: drug_claim_types_drug_claims; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE drug_claim_types_drug_claims (
    drug_claim_id character varying(255) NOT NULL,
    drug_claim_type_id character varying(255) NOT NULL
);


--
-- Name: drug_claims; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE drug_claims (
    id text NOT NULL,
    name text NOT NULL,
    description text,
    nomenclature text NOT NULL,
    source_id text,
    primary_name character varying(255)
);


--
-- Name: drug_claims_drugs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE drug_claims_drugs (
    drug_id text NOT NULL,
    drug_claim_id text NOT NULL
);


--
-- Name: drugs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE drugs (
    id text NOT NULL,
    name text
);


--
-- Name: gene_claim_aliases; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE gene_claim_aliases (
    id text NOT NULL,
    gene_claim_id text NOT NULL,
    alias text NOT NULL,
    description text,
    nomenclature text NOT NULL
);


--
-- Name: gene_claim_attributes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE gene_claim_attributes (
    id text NOT NULL,
    gene_claim_id text NOT NULL,
    name text NOT NULL,
    value text NOT NULL,
    description text
);


--
-- Name: gene_claim_categories; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE gene_claim_categories (
    id character varying(255) NOT NULL,
    name character varying(255) NOT NULL
);


--
-- Name: gene_claim_categories_gene_claims; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE gene_claim_categories_gene_claims (
    gene_claim_id character varying(255) NOT NULL,
    gene_claim_category_id character varying(255) NOT NULL
);


--
-- Name: gene_claims; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE gene_claims (
    id text NOT NULL,
    name text NOT NULL,
    description text,
    nomenclature text NOT NULL,
    source_id text
);


--
-- Name: gene_claims_genes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE gene_claims_genes (
    gene_id text NOT NULL,
    gene_claim_id text NOT NULL
);


--
-- Name: genes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE genes (
    id text NOT NULL,
    name text,
    long_name character varying(255)
);


--
-- Name: group; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "group" (
    id integer NOT NULL,
    "order" character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: group_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE group_id_seq OWNED BY "group".id;


--
-- Name: interaction_claim_attributes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE interaction_claim_attributes (
    id text NOT NULL,
    interaction_claim_id text NOT NULL,
    name text NOT NULL,
    value text NOT NULL
);


--
-- Name: interaction_claim_types; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE interaction_claim_types (
    id character varying(255) NOT NULL,
    type character varying(255)
);


--
-- Name: interaction_claim_types_interaction_claims; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE interaction_claim_types_interaction_claims (
    interaction_claim_type_id character varying(255) NOT NULL,
    interaction_claim_id character varying(255) NOT NULL
);


--
-- Name: interaction_claims; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE interaction_claims (
    id text NOT NULL,
    drug_claim_id text NOT NULL,
    gene_claim_id text NOT NULL,
    interaction_type text,
    description text,
    source_id text,
    known_action_type character varying(255)
);


--
-- Name: languages; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE languages (
    id integer NOT NULL,
    name character varying(255),
    developer_id integer
);


--
-- Name: languages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE languages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: languages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE languages_id_seq OWNED BY languages.id;


--
-- Name: projects; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE projects (
    id integer NOT NULL,
    name character varying(255),
    type character varying(255)
);


--
-- Name: projects_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE projects_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: projects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE projects_id_seq OWNED BY projects.id;


--
-- Name: schema_info; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_info (
    id integer NOT NULL,
    version integer
);


--
-- Name: schema_info_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE schema_info_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: schema_info_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE schema_info_id_seq OWNED BY schema_info.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: shopping_carts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE shopping_carts (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: shopping_carts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE shopping_carts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: shopping_carts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE shopping_carts_id_seq OWNED BY shopping_carts.id;


--
-- Name: source_types; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE source_types (
    id character varying(255) NOT NULL,
    type character varying(255) NOT NULL
);


--
-- Name: sources; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sources (
    id text NOT NULL,
    source_db_name text NOT NULL,
    source_db_version text NOT NULL,
    citation text,
    base_url text,
    site_url text,
    full_name text,
    source_type_id character varying(255),
    gene_claims_count integer DEFAULT 0,
    drug_claims_count integer DEFAULT 0,
    interaction_claims_count integer DEFAULT 0,
    interaction_claims_in_groups_count integer DEFAULT 0,
    gene_claims_in_groups_count integer DEFAULT 0,
    drug_claims_in_groups_count integer DEFAULT 0
);


--
-- Name: teams; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE teams (
    id integer NOT NULL,
    name character varying(255)
);


--
-- Name: teams_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE teams_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: teams_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE teams_id_seq OWNED BY teams.id;


--
-- Name: topics; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE topics (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    author_name character varying(255),
    author_email_address character varying(255),
    written_on timestamp without time zone,
    bonus_time time without time zone,
    last_read timestamp without time zone,
    content text,
    approved boolean DEFAULT true,
    replies_count integer,
    parent_id integer,
    type character varying(255),
    created_at timestamp without time zone,
    created_on timestamp without time zone,
    updated_at timestamp without time zone,
    updated_on timestamp without time zone
);


--
-- Name: topics_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE topics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: topics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE topics_id_seq OWNED BY topics.id;


--
-- Name: widgets; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE widgets (
    w_id integer
);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY addresses ALTER COLUMN id SET DEFAULT nextval('addresses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY animals ALTER COLUMN id SET DEFAULT nextval('animals_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY books ALTER COLUMN id SET DEFAULT nextval('books_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY cart_items ALTER COLUMN id SET DEFAULT nextval('cart_items_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY developers ALTER COLUMN id SET DEFAULT nextval('developers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "group" ALTER COLUMN id SET DEFAULT nextval('group_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY languages ALTER COLUMN id SET DEFAULT nextval('languages_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY projects ALTER COLUMN id SET DEFAULT nextval('projects_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY schema_info ALTER COLUMN id SET DEFAULT nextval('schema_info_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY shopping_carts ALTER COLUMN id SET DEFAULT nextval('shopping_carts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY teams ALTER COLUMN id SET DEFAULT nextval('teams_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY topics ALTER COLUMN id SET DEFAULT nextval('topics_id_seq'::regclass);


--
-- Name: addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY addresses
    ADD CONSTRAINT addresses_pkey PRIMARY KEY (id);


--
-- Name: animals_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY animals
    ADD CONSTRAINT animals_pkey PRIMARY KEY (id);


--
-- Name: books_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY books
    ADD CONSTRAINT books_pkey PRIMARY KEY (id);


--
-- Name: cart_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY cart_items
    ADD CONSTRAINT cart_items_pkey PRIMARY KEY (id);


--
-- Name: developers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY developers
    ADD CONSTRAINT developers_pkey PRIMARY KEY (id);


--
-- Name: drug_claim_aliases_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY drug_claim_aliases
    ADD CONSTRAINT drug_claim_aliases_pkey PRIMARY KEY (id);


--
-- Name: drug_claim_attributes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY drug_claim_attributes
    ADD CONSTRAINT drug_claim_attributes_pkey PRIMARY KEY (id);


--
-- Name: drug_claim_types_drug_claims_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY drug_claim_types_drug_claims
    ADD CONSTRAINT drug_claim_types_drug_claims_pkey PRIMARY KEY (drug_claim_id, drug_claim_type_id);


--
-- Name: drug_claim_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY drug_claim_types
    ADD CONSTRAINT drug_claim_types_pkey PRIMARY KEY (id);


--
-- Name: drug_claims_drugs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY drug_claims_drugs
    ADD CONSTRAINT drug_claims_drugs_pkey PRIMARY KEY (drug_id, drug_claim_id);


--
-- Name: drug_claims_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY drug_claims
    ADD CONSTRAINT drug_claims_pkey PRIMARY KEY (id);


--
-- Name: drugs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY drugs
    ADD CONSTRAINT drugs_pkey PRIMARY KEY (id);


--
-- Name: gene_claim_aliases_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY gene_claim_aliases
    ADD CONSTRAINT gene_claim_aliases_pkey PRIMARY KEY (id);


--
-- Name: gene_claim_attributes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY gene_claim_attributes
    ADD CONSTRAINT gene_claim_attributes_pkey PRIMARY KEY (id);


--
-- Name: gene_claim_categories_gene_claims_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY gene_claim_categories_gene_claims
    ADD CONSTRAINT gene_claim_categories_gene_claims_pkey PRIMARY KEY (gene_claim_id, gene_claim_category_id);


--
-- Name: gene_claim_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY gene_claim_categories
    ADD CONSTRAINT gene_claim_categories_pkey PRIMARY KEY (id);


--
-- Name: gene_claims_genes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY gene_claims_genes
    ADD CONSTRAINT gene_claims_genes_pkey PRIMARY KEY (gene_id, gene_claim_id);


--
-- Name: gene_claims_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY gene_claims
    ADD CONSTRAINT gene_claims_pkey PRIMARY KEY (id);


--
-- Name: genes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY genes
    ADD CONSTRAINT genes_pkey PRIMARY KEY (id);


--
-- Name: group_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "group"
    ADD CONSTRAINT group_pkey PRIMARY KEY (id);


--
-- Name: interaction_claim_attributes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY interaction_claim_attributes
    ADD CONSTRAINT interaction_claim_attributes_pkey PRIMARY KEY (id);


--
-- Name: interaction_claim_types_interaction_claims_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY interaction_claim_types_interaction_claims
    ADD CONSTRAINT interaction_claim_types_interaction_claims_pkey PRIMARY KEY (interaction_claim_type_id, interaction_claim_id);


--
-- Name: interaction_claim_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY interaction_claim_types
    ADD CONSTRAINT interaction_claim_types_pkey PRIMARY KEY (id);


--
-- Name: interaction_claims_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY interaction_claims
    ADD CONSTRAINT interaction_claims_pkey PRIMARY KEY (id);


--
-- Name: languages_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY languages
    ADD CONSTRAINT languages_pkey PRIMARY KEY (id);


--
-- Name: projects_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (id);


--
-- Name: schema_info_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY schema_info
    ADD CONSTRAINT schema_info_pkey PRIMARY KEY (id);


--
-- Name: shopping_carts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY shopping_carts
    ADD CONSTRAINT shopping_carts_pkey PRIMARY KEY (id);


--
-- Name: source_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY source_types
    ADD CONSTRAINT source_types_pkey PRIMARY KEY (id);


--
-- Name: sources_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sources
    ADD CONSTRAINT sources_pkey PRIMARY KEY (id);


--
-- Name: teams_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY teams
    ADD CONSTRAINT teams_pkey PRIMARY KEY (id);


--
-- Name: topics_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY topics
    ADD CONSTRAINT topics_pkey PRIMARY KEY (id);


--
-- Name: drug_claim_aliases_drug_claim_id_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX drug_claim_aliases_drug_claim_id_idx ON drug_claim_aliases USING btree (drug_claim_id);


--
-- Name: drug_claim_aliases_full_text; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX drug_claim_aliases_full_text ON drug_claim_aliases USING gin (to_tsvector('english'::regconfig, alias));


--
-- Name: drug_claim_attributes_drug_claim_id_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX drug_claim_attributes_drug_claim_id_idx ON drug_claim_attributes USING btree (drug_claim_id);


--
-- Name: drug_claims_full_text; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX drug_claims_full_text ON drug_claims USING gin (to_tsvector('english'::regconfig, name));


--
-- Name: drug_claims_source_id_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX drug_claims_source_id_idx ON drug_claims USING btree (source_id);


--
-- Name: drugs_full_text; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX drugs_full_text ON drugs USING gin (to_tsvector('english'::regconfig, name));


--
-- Name: gene_claim_aliases_full_text; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX gene_claim_aliases_full_text ON gene_claim_aliases USING gin (to_tsvector('english'::regconfig, alias));


--
-- Name: gene_claim_aliases_gene_claim_id_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX gene_claim_aliases_gene_claim_id_idx ON gene_claim_aliases USING btree (gene_claim_id);


--
-- Name: gene_claim_attributes_gene_claim_id_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX gene_claim_attributes_gene_claim_id_idx ON gene_claim_attributes USING btree (gene_claim_id);


--
-- Name: gene_claims_full_text; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX gene_claims_full_text ON gene_claims USING gin (to_tsvector('english'::regconfig, name));


--
-- Name: gene_claims_source_id_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX gene_claims_source_id_idx ON gene_claims USING btree (source_id);


--
-- Name: genes_full_text; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX genes_full_text ON genes USING gin (to_tsvector('english'::regconfig, name));


--
-- Name: index_drug_claim_attributes_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_drug_claim_attributes_on_name ON drug_claim_attributes USING btree (name);


--
-- Name: index_drug_claim_attributes_on_value; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_drug_claim_attributes_on_value ON drug_claim_attributes USING btree (value);


--
-- Name: index_gene_claim_aliases_on_alias; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_gene_claim_aliases_on_alias ON gene_claim_aliases USING btree (alias);


--
-- Name: index_gene_claim_attributes_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_gene_claim_attributes_on_name ON gene_claim_attributes USING btree (name);


--
-- Name: index_gene_claim_attributes_on_value; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_gene_claim_attributes_on_value ON gene_claim_attributes USING btree (value);


--
-- Name: index_gene_claims_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_gene_claims_on_name ON gene_claims USING btree (name);


--
-- Name: index_genes_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_genes_on_name ON genes USING btree (name);


--
-- Name: index_interaction_claims_on_known_action_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_interaction_claims_on_known_action_type ON interaction_claims USING btree (known_action_type);


--
-- Name: interaction_claim_attributes_interaction_claim_id_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX interaction_claim_attributes_interaction_claim_id_idx ON interaction_claim_attributes USING btree (interaction_claim_id);


--
-- Name: interaction_claims_drug_claim_id_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX interaction_claims_drug_claim_id_idx ON interaction_claims USING btree (drug_claim_id);


--
-- Name: interaction_claims_gene_claim_id_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX interaction_claims_gene_claim_id_idx ON interaction_claims USING btree (gene_claim_id);


--
-- Name: interaction_claims_source_id_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX interaction_claims_source_id_idx ON interaction_claims USING btree (source_id);


--
-- Name: sources_source_type_id_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX sources_source_type_id_idx ON sources USING btree (source_type_id);


--
-- Name: uk_animals; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX uk_animals ON animals USING btree (name);


--
-- Name: uk_shopping_cart_books; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX uk_shopping_cart_books ON cart_items USING btree (shopping_cart_id, book_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: fk_drug_claim; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY drug_claim_types_drug_claims
    ADD CONSTRAINT fk_drug_claim FOREIGN KEY (drug_claim_id) REFERENCES drug_claims(id) MATCH FULL;


--
-- Name: fk_drug_claim_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY drug_claim_aliases
    ADD CONSTRAINT fk_drug_claim_id FOREIGN KEY (drug_claim_id) REFERENCES drug_claims(id) MATCH FULL;


--
-- Name: fk_drug_claim_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY drug_claim_attributes
    ADD CONSTRAINT fk_drug_claim_id FOREIGN KEY (drug_claim_id) REFERENCES drug_claims(id) MATCH FULL;


--
-- Name: fk_drug_claim_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY interaction_claims
    ADD CONSTRAINT fk_drug_claim_id FOREIGN KEY (drug_claim_id) REFERENCES drug_claims(id) MATCH FULL;


--
-- Name: fk_drug_claim_type; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY drug_claim_types_drug_claims
    ADD CONSTRAINT fk_drug_claim_type FOREIGN KEY (drug_claim_type_id) REFERENCES drug_claim_types(id) MATCH FULL;


--
-- Name: fk_gene_claim; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gene_claim_categories_gene_claims
    ADD CONSTRAINT fk_gene_claim FOREIGN KEY (gene_claim_id) REFERENCES gene_claims(id) MATCH FULL;


--
-- Name: fk_gene_claim_category; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gene_claim_categories_gene_claims
    ADD CONSTRAINT fk_gene_claim_category FOREIGN KEY (gene_claim_category_id) REFERENCES gene_claim_categories(id) MATCH FULL;


--
-- Name: fk_gene_claim_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gene_claim_aliases
    ADD CONSTRAINT fk_gene_claim_id FOREIGN KEY (gene_claim_id) REFERENCES gene_claims(id) MATCH FULL;


--
-- Name: fk_gene_claim_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gene_claim_attributes
    ADD CONSTRAINT fk_gene_claim_id FOREIGN KEY (gene_claim_id) REFERENCES gene_claims(id) MATCH FULL;


--
-- Name: fk_gene_claim_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY interaction_claims
    ADD CONSTRAINT fk_gene_claim_id FOREIGN KEY (gene_claim_id) REFERENCES gene_claims(id) MATCH FULL;


--
-- Name: fk_interaction_claim; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY interaction_claim_types_interaction_claims
    ADD CONSTRAINT fk_interaction_claim FOREIGN KEY (interaction_claim_id) REFERENCES interaction_claims(id) MATCH FULL;


--
-- Name: fk_interaction_claim_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY interaction_claim_attributes
    ADD CONSTRAINT fk_interaction_claim_id FOREIGN KEY (interaction_claim_id) REFERENCES interaction_claims(id) MATCH FULL;


--
-- Name: fk_interaction_claim_type; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY interaction_claim_types_interaction_claims
    ADD CONSTRAINT fk_interaction_claim_type FOREIGN KEY (interaction_claim_type_id) REFERENCES interaction_claim_types(id) MATCH FULL;


--
-- Name: fk_source_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY drug_claims
    ADD CONSTRAINT fk_source_id FOREIGN KEY (source_id) REFERENCES sources(id) MATCH FULL;


--
-- Name: fk_source_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gene_claims
    ADD CONSTRAINT fk_source_id FOREIGN KEY (source_id) REFERENCES sources(id) MATCH FULL;


--
-- Name: fk_source_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY interaction_claims
    ADD CONSTRAINT fk_source_id FOREIGN KEY (source_id) REFERENCES sources(id) MATCH FULL;


--
-- Name: fk_source_type; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sources
    ADD CONSTRAINT fk_source_type FOREIGN KEY (source_type_id) REFERENCES source_types(id) MATCH FULL;


--
-- PostgreSQL database dump complete
--

INSERT INTO schema_migrations (version) VALUES ('0');

INSERT INTO schema_migrations (version) VALUES ('20121212223401');

INSERT INTO schema_migrations (version) VALUES ('20121213151709');

INSERT INTO schema_migrations (version) VALUES ('20121214160809');

INSERT INTO schema_migrations (version) VALUES ('20121214161439');

INSERT INTO schema_migrations (version) VALUES ('20121214191000');

INSERT INTO schema_migrations (version) VALUES ('20121218184952');

INSERT INTO schema_migrations (version) VALUES ('20121218224238');

INSERT INTO schema_migrations (version) VALUES ('20130103214307');

INSERT INTO schema_migrations (version) VALUES ('20130214204650');