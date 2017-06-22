--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: chembl_molecule_synonyms; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE chembl_molecule_synonyms (
    id integer NOT NULL,
    molregno integer,
    synonym character varying(200),
    molsyn_id integer,
    chembl_molecule_id integer,
    syn_type character varying(50)
);


--
-- Name: chembl_molecule_synonyms_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE chembl_molecule_synonyms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: chembl_molecule_synonyms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE chembl_molecule_synonyms_id_seq OWNED BY chembl_molecule_synonyms.id;


--
-- Name: chembl_molecules; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE chembl_molecules (
    id integer NOT NULL,
    molregno integer,
    pref_name character varying(255),
    chembl_id character varying(20),
    max_phase integer,
    therapeutic_flag boolean,
    dosed_ingredient boolean,
    structure_type character varying(10),
    chebi_par_id integer,
    molecule_type character varying(30),
    first_approval integer,
    oral boolean,
    parenteral boolean,
    topical boolean,
    black_box_warning boolean,
    natural_product boolean,
    first_in_class boolean,
    chirality integer,
    prodrug boolean,
    inorganic_flag boolean,
    usan_year integer,
    availability_type integer,
    usan_stem character varying(50),
    polymer_flag boolean,
    usan_substem character varying(50),
    usan_stem_definition text,
    indication_class text,
    withdrawn_flag boolean,
    withdrawn_year integer,
    withdrawn_country text,
    withdrawn_reason text,
    drug_id integer
);


--
-- Name: chembl_molecules_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE chembl_molecules_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: chembl_molecules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE chembl_molecules_id_seq OWNED BY chembl_molecules.id;


--
-- Name: drug_aliases; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE drug_aliases (
    id text NOT NULL,
    drug_id text NOT NULL,
    alias text NOT NULL
);


--
-- Name: drug_aliases_sources; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE drug_aliases_sources (
    drug_alias_id text NOT NULL,
    source_id text NOT NULL
);


--
-- Name: drug_attributes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE drug_attributes (
    id text NOT NULL,
    drug_id text NOT NULL,
    name text NOT NULL,
    value text NOT NULL
);


--
-- Name: drug_attributes_sources; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE drug_attributes_sources (
    drug_attribute_id text NOT NULL,
    source_id text NOT NULL
);


--
-- Name: drug_claim_aliases; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE drug_claim_aliases (
    id text NOT NULL,
    drug_claim_id text NOT NULL,
    alias text NOT NULL,
    nomenclature text NOT NULL
);


--
-- Name: drug_claim_attributes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE drug_claim_attributes (
    id text NOT NULL,
    drug_claim_id text NOT NULL,
    name text NOT NULL,
    value text NOT NULL
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
    nomenclature text NOT NULL,
    source_id text,
    primary_name character varying(255),
    drug_id text
);


--
-- Name: drugs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE drugs (
    id text NOT NULL,
    name text,
    fda_approved boolean,
    immunotherapy boolean,
    anti_neoplastic boolean,
    chembl_id character varying(255)
);


--
-- Name: gene_aliases; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE gene_aliases (
    id text NOT NULL,
    gene_id text NOT NULL,
    alias text NOT NULL
);


--
-- Name: gene_aliases_sources; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE gene_aliases_sources (
    gene_alias_id text NOT NULL,
    source_id text NOT NULL
);


--
-- Name: gene_attributes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE gene_attributes (
    id text NOT NULL,
    gene_id text NOT NULL,
    name text NOT NULL,
    value text NOT NULL
);


--
-- Name: gene_attributes_sources; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE gene_attributes_sources (
    gene_attribute_id text NOT NULL,
    source_id text NOT NULL
);


--
-- Name: gene_categories_genes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE gene_categories_genes (
    gene_claim_category_id text NOT NULL,
    gene_id text NOT NULL
);


--
-- Name: gene_claim_aliases; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE gene_claim_aliases (
    id text NOT NULL,
    gene_claim_id text NOT NULL,
    alias text NOT NULL,
    nomenclature text NOT NULL
);


--
-- Name: gene_claim_attributes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE gene_claim_attributes (
    id text NOT NULL,
    gene_claim_id text NOT NULL,
    name text NOT NULL,
    value text NOT NULL
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
    nomenclature text NOT NULL,
    source_id text,
    gene_id text
);


--
-- Name: gene_gene_interaction_claim_attributes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE gene_gene_interaction_claim_attributes (
    id character varying(255) NOT NULL,
    gene_gene_interaction_claim_id character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(255) NOT NULL
);


--
-- Name: gene_gene_interaction_claims; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE gene_gene_interaction_claims (
    id character varying(255) NOT NULL,
    gene_id character varying(255) NOT NULL,
    interacting_gene_id character varying(255) NOT NULL,
    source_id character varying(255) NOT NULL
);


--
-- Name: genes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE genes (
    id text NOT NULL,
    name text,
    long_name character varying(255),
    entrez_id integer
);


--
-- Name: interaction_attributes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE interaction_attributes (
    id text NOT NULL,
    interaction_id text NOT NULL,
    name text NOT NULL,
    value text NOT NULL
);


--
-- Name: interaction_attributes_sources; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE interaction_attributes_sources (
    interaction_attribute_id text NOT NULL,
    source_id text NOT NULL
);


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
    source_id text,
    known_action_type character varying(255),
    interaction_id text
);


--
-- Name: interaction_claims_publications; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE interaction_claims_publications (
    interaction_claim_id text NOT NULL,
    publication_id text NOT NULL
);


--
-- Name: interaction_types_interactions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE interaction_types_interactions (
    interaction_claim_type_id text NOT NULL,
    interaction_id text NOT NULL
);


--
-- Name: interactions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE interactions (
    id text NOT NULL,
    drug_id text NOT NULL,
    gene_id text NOT NULL
);


--
-- Name: interactions_publications; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE interactions_publications (
    interaction_id text NOT NULL,
    publication_id text NOT NULL
);


--
-- Name: publications; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE publications (
    id text NOT NULL,
    pmid integer NOT NULL,
    citation text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: source_trust_levels; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE source_trust_levels (
    id character varying(255) NOT NULL,
    level character varying(255) NOT NULL
);


--
-- Name: source_types; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE source_types (
    id character varying(255) NOT NULL,
    type character varying(255) NOT NULL,
    display_name character varying(255)
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
    drug_claims_in_groups_count integer DEFAULT 0,
    source_trust_level_id character varying(255),
    gene_gene_interaction_claims_count integer DEFAULT 0
);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY chembl_molecule_synonyms ALTER COLUMN id SET DEFAULT nextval('chembl_molecule_synonyms_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY chembl_molecules ALTER COLUMN id SET DEFAULT nextval('chembl_molecules_id_seq'::regclass);


--
-- Name: ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: chembl_molecule_synonyms_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY chembl_molecule_synonyms
    ADD CONSTRAINT chembl_molecule_synonyms_pkey PRIMARY KEY (id);


--
-- Name: chembl_molecules_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY chembl_molecules
    ADD CONSTRAINT chembl_molecules_pkey PRIMARY KEY (id);


--
-- Name: drug_aliases_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY drug_aliases
    ADD CONSTRAINT drug_aliases_pkey PRIMARY KEY (id);


--
-- Name: drug_aliases_sources_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY drug_aliases_sources
    ADD CONSTRAINT drug_aliases_sources_pkey PRIMARY KEY (drug_alias_id, source_id);


--
-- Name: drug_attributes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY drug_attributes
    ADD CONSTRAINT drug_attributes_pkey PRIMARY KEY (id);


--
-- Name: drug_attributes_sources_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY drug_attributes_sources
    ADD CONSTRAINT drug_attributes_sources_pkey PRIMARY KEY (drug_attribute_id, source_id);


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
-- Name: gene_aliases_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY gene_aliases
    ADD CONSTRAINT gene_aliases_pkey PRIMARY KEY (id);


--
-- Name: gene_aliases_sources_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY gene_aliases_sources
    ADD CONSTRAINT gene_aliases_sources_pkey PRIMARY KEY (gene_alias_id, source_id);


--
-- Name: gene_attributes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY gene_attributes
    ADD CONSTRAINT gene_attributes_pkey PRIMARY KEY (id);


--
-- Name: gene_attributes_sources_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY gene_attributes_sources
    ADD CONSTRAINT gene_attributes_sources_pkey PRIMARY KEY (gene_attribute_id, source_id);


--
-- Name: gene_categories_genes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY gene_categories_genes
    ADD CONSTRAINT gene_categories_genes_pkey PRIMARY KEY (gene_claim_category_id, gene_id);


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
-- Name: gene_claims_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY gene_claims
    ADD CONSTRAINT gene_claims_pkey PRIMARY KEY (id);


--
-- Name: gene_gene_interaction_claim_attributes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY gene_gene_interaction_claim_attributes
    ADD CONSTRAINT gene_gene_interaction_claim_attributes_pkey PRIMARY KEY (gene_gene_interaction_claim_id);


--
-- Name: gene_gene_interaction_claims_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY gene_gene_interaction_claims
    ADD CONSTRAINT gene_gene_interaction_claims_pkey PRIMARY KEY (id);


--
-- Name: genes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY genes
    ADD CONSTRAINT genes_pkey PRIMARY KEY (id);


--
-- Name: interaction_attributes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY interaction_attributes
    ADD CONSTRAINT interaction_attributes_pkey PRIMARY KEY (id);


--
-- Name: interaction_attributes_sources_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY interaction_attributes_sources
    ADD CONSTRAINT interaction_attributes_sources_pkey PRIMARY KEY (interaction_attribute_id, source_id);


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
-- Name: interaction_claims_publications_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY interaction_claims_publications
    ADD CONSTRAINT interaction_claims_publications_pkey PRIMARY KEY (interaction_claim_id, publication_id);


--
-- Name: interaction_types_interactions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY interaction_types_interactions
    ADD CONSTRAINT interaction_types_interactions_pkey PRIMARY KEY (interaction_claim_type_id, interaction_id);


--
-- Name: interactions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY interactions
    ADD CONSTRAINT interactions_pkey PRIMARY KEY (id);


--
-- Name: interactions_publications_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY interactions_publications
    ADD CONSTRAINT interactions_publications_pkey PRIMARY KEY (interaction_id, publication_id);


--
-- Name: publications_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY publications
    ADD CONSTRAINT publications_pkey PRIMARY KEY (id);


--
-- Name: source_trust_levels_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY source_trust_levels
    ADD CONSTRAINT source_trust_levels_pkey PRIMARY KEY (id);


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
-- Name: chembl_molecule_synonyms_molregno_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX chembl_molecule_synonyms_molregno_idx ON chembl_molecule_synonyms USING btree (molregno);


--
-- Name: chembl_molecule_synonyms_upper_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX chembl_molecule_synonyms_upper_idx ON chembl_molecule_synonyms USING btree (upper((synonym)::text));


--
-- Name: chembl_molecules_chembl_id_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX chembl_molecules_chembl_id_idx ON chembl_molecules USING btree (chembl_id);


--
-- Name: chembl_molecules_molregno_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX chembl_molecules_molregno_idx ON chembl_molecules USING btree (molregno);


--
-- Name: chembl_molecules_upper_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX chembl_molecules_upper_idx ON chembl_molecules USING btree (upper((pref_name)::text));


--
-- Name: chembl_molecules_upper_idx1; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX chembl_molecules_upper_idx1 ON chembl_molecules USING btree (upper((chembl_id)::text));


--
-- Name: drug_aliases_upper_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX drug_aliases_upper_idx ON drug_aliases USING btree (upper(alias));


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
-- Name: drug_claim_types_lower_type_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX drug_claim_types_lower_type_idx ON drug_claim_types USING btree (lower((type)::text));


--
-- Name: drug_claims_full_text; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX drug_claims_full_text ON drug_claims USING gin (to_tsvector('english'::regconfig, name));


--
-- Name: drug_claims_source_id_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX drug_claims_source_id_idx ON drug_claims USING btree (source_id);


--
-- Name: drugs_chembl_id_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX drugs_chembl_id_idx ON drugs USING btree (chembl_id);


--
-- Name: drugs_full_text; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX drugs_full_text ON drugs USING gin (to_tsvector('english'::regconfig, name));


--
-- Name: drugs_lower_name_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX drugs_lower_name_idx ON drugs USING btree (lower(name));


--
-- Name: drugs_upper_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX drugs_upper_idx ON drugs USING btree (upper(name));


--
-- Name: gene_claim_aliases_full_text; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX gene_claim_aliases_full_text ON gene_claim_aliases USING gin (to_tsvector('english'::regconfig, alias));


--
-- Name: gene_claim_aliases_gene_claim_id_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX gene_claim_aliases_gene_claim_id_idx ON gene_claim_aliases USING btree (gene_claim_id);


--
-- Name: gene_claim_aliases_lower_alias_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX gene_claim_aliases_lower_alias_idx ON gene_claim_aliases USING btree (lower(alias));


--
-- Name: gene_claim_attributes_gene_claim_id_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX gene_claim_attributes_gene_claim_id_idx ON gene_claim_attributes USING btree (gene_claim_id);


--
-- Name: gene_claim_categories_lower_name_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX gene_claim_categories_lower_name_idx ON gene_claim_categories USING btree (lower((name)::text));


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
-- Name: genes_lower_name_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX genes_lower_name_idx ON genes USING btree (lower(name));


--
-- Name: index_chembl_molecules_on_drug_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_chembl_molecules_on_drug_id ON chembl_molecules USING btree (drug_id);


--
-- Name: index_drug_attributes_on_drug_id_and_name_and_value; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_drug_attributes_on_drug_id_and_name_and_value ON drug_attributes USING btree (drug_id, name, value);


--
-- Name: index_drug_claim_attributes_on_drug_claim_id_and_name_and_value; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_drug_claim_attributes_on_drug_claim_id_and_name_and_value ON drug_claim_attributes USING btree (drug_claim_id, name, value);


--
-- Name: index_drug_claim_attributes_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_drug_claim_attributes_on_name ON drug_claim_attributes USING btree (name);


--
-- Name: index_drug_claim_attributes_on_value; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_drug_claim_attributes_on_value ON drug_claim_attributes USING btree (value);


--
-- Name: index_drug_claims_on_name_and_nomenclature_and_source_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_drug_claims_on_name_and_nomenclature_and_source_id ON drug_claims USING btree (name, nomenclature, source_id);


--
-- Name: index_drugs_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_drugs_on_name ON drugs USING btree (name);


--
-- Name: index_gene_aliases_on_alias; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_gene_aliases_on_alias ON gene_aliases USING btree (alias);


--
-- Name: index_gene_attributes_on_gene_id_and_name_and_value; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_gene_attributes_on_gene_id_and_name_and_value ON gene_attributes USING btree (gene_id, name, value);


--
-- Name: index_gene_claim_aliases_on_alias; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_gene_claim_aliases_on_alias ON gene_claim_aliases USING btree (alias);


--
-- Name: index_gene_claim_attributes_on_gene_claim_id_and_name_and_value; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_gene_claim_attributes_on_gene_claim_id_and_name_and_value ON gene_claim_attributes USING btree (gene_claim_id, name, value);


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
-- Name: index_gene_claims_on_name_and_nomenclature_and_source_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_gene_claims_on_name_and_nomenclature_and_source_id ON gene_claims USING btree (name, nomenclature, source_id);


--
-- Name: index_gene_gene_interaction_claims_on_gene_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_gene_gene_interaction_claims_on_gene_id ON gene_gene_interaction_claims USING btree (gene_id);


--
-- Name: index_gene_gene_interaction_claims_on_interacting_gene_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_gene_gene_interaction_claims_on_interacting_gene_id ON gene_gene_interaction_claims USING btree (interacting_gene_id);


--
-- Name: index_genes_on_entrez_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_genes_on_entrez_id ON genes USING btree (entrez_id);


--
-- Name: index_genes_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_genes_on_name ON genes USING btree (name);


--
-- Name: index_interaction_claims_on_known_action_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_interaction_claims_on_known_action_type ON interaction_claims USING btree (known_action_type);


--
-- Name: index_interactions_on_drug_id_and_gene_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_interactions_on_drug_id_and_gene_id ON interactions USING btree (drug_id, gene_id);


--
-- Name: index_publications_on_pmid; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_publications_on_pmid ON publications USING btree (pmid);


--
-- Name: interaction_claim_attributes_interaction_claim_id_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX interaction_claim_attributes_interaction_claim_id_idx ON interaction_claim_attributes USING btree (interaction_claim_id);


--
-- Name: interaction_claim_types_lower_type_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX interaction_claim_types_lower_type_idx ON interaction_claim_types USING btree (lower((type)::text));


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
-- Name: left_and_interacting_gene_interaction_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX left_and_interacting_gene_interaction_index ON gene_gene_interaction_claims USING btree (gene_id, interacting_gene_id);


--
-- Name: source_trust_levels_lower_level_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX source_trust_levels_lower_level_idx ON source_trust_levels USING btree (lower((level)::text));


--
-- Name: sources_lower_source_db_name_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX sources_lower_source_db_name_idx ON sources USING btree (lower(source_db_name));


--
-- Name: sources_source_trust_level_id_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX sources_source_trust_level_id_idx ON sources USING btree (source_trust_level_id);


--
-- Name: sources_source_type_id_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX sources_source_type_id_idx ON sources USING btree (source_type_id);


--
-- Name: unique_drug_claim_aliases; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_drug_claim_aliases ON drug_claim_aliases USING btree (drug_claim_id, alias, nomenclature);


--
-- Name: unique_drug_id_alias; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_drug_id_alias ON drug_aliases USING btree (drug_id, upper(alias));


--
-- Name: unique_gene_claim_aliases; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_gene_claim_aliases ON gene_claim_aliases USING btree (gene_claim_id, alias, nomenclature);


--
-- Name: unique_gene_id_alias; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_gene_id_alias ON gene_aliases USING btree (gene_id, upper(alias));


--
-- Name: unique_interaction_attributes; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_interaction_attributes ON interaction_attributes USING btree (interaction_id, name, value);


--
-- Name: unique_interaction_claim_attributes; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_interaction_claim_attributes ON interaction_claim_attributes USING btree (interaction_claim_id, name, value);


--
-- Name: unique_interaction_claims; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_interaction_claims ON interaction_claims USING btree (drug_claim_id, gene_claim_id, source_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: fk_attributes_gene_interaction_claim; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gene_gene_interaction_claim_attributes
    ADD CONSTRAINT fk_attributes_gene_interaction_claim FOREIGN KEY (gene_gene_interaction_claim_id) REFERENCES gene_gene_interaction_claims(id) MATCH FULL;


--
-- Name: fk_drug; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY drug_claims
    ADD CONSTRAINT fk_drug FOREIGN KEY (drug_id) REFERENCES drugs(id) MATCH FULL;


--
-- Name: fk_drug; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY interactions
    ADD CONSTRAINT fk_drug FOREIGN KEY (drug_id) REFERENCES drugs(id);


--
-- Name: fk_drug; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY drug_aliases
    ADD CONSTRAINT fk_drug FOREIGN KEY (drug_id) REFERENCES drugs(id);


--
-- Name: fk_drug; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY drug_attributes
    ADD CONSTRAINT fk_drug FOREIGN KEY (drug_id) REFERENCES drugs(id);


--
-- Name: fk_drug_alias; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY drug_aliases_sources
    ADD CONSTRAINT fk_drug_alias FOREIGN KEY (drug_alias_id) REFERENCES drug_aliases(id);


--
-- Name: fk_drug_attribute; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY drug_attributes_sources
    ADD CONSTRAINT fk_drug_attribute FOREIGN KEY (drug_attribute_id) REFERENCES drug_attributes(id);


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
-- Name: fk_gene; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gene_claims
    ADD CONSTRAINT fk_gene FOREIGN KEY (gene_id) REFERENCES genes(id) MATCH FULL;


--
-- Name: fk_gene; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY interactions
    ADD CONSTRAINT fk_gene FOREIGN KEY (gene_id) REFERENCES genes(id);


--
-- Name: fk_gene; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gene_aliases
    ADD CONSTRAINT fk_gene FOREIGN KEY (gene_id) REFERENCES genes(id);


--
-- Name: fk_gene; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gene_attributes
    ADD CONSTRAINT fk_gene FOREIGN KEY (gene_id) REFERENCES genes(id);


--
-- Name: fk_gene; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gene_categories_genes
    ADD CONSTRAINT fk_gene FOREIGN KEY (gene_id) REFERENCES genes(id);


--
-- Name: fk_gene_alias; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gene_aliases_sources
    ADD CONSTRAINT fk_gene_alias FOREIGN KEY (gene_alias_id) REFERENCES gene_aliases(id);


--
-- Name: fk_gene_attribute; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gene_attributes_sources
    ADD CONSTRAINT fk_gene_attribute FOREIGN KEY (gene_attribute_id) REFERENCES gene_attributes(id);


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
-- Name: fk_gene_claim_category; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gene_categories_genes
    ADD CONSTRAINT fk_gene_claim_category FOREIGN KEY (gene_claim_category_id) REFERENCES gene_claim_categories(id);


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
-- Name: fk_gene_interaction_claims_gene; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gene_gene_interaction_claims
    ADD CONSTRAINT fk_gene_interaction_claims_gene FOREIGN KEY (gene_id) REFERENCES genes(id) MATCH FULL;


--
-- Name: fk_gene_interaction_claims_interacting_gene; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gene_gene_interaction_claims
    ADD CONSTRAINT fk_gene_interaction_claims_interacting_gene FOREIGN KEY (interacting_gene_id) REFERENCES genes(id) MATCH FULL;


--
-- Name: fk_gene_interaction_claims_sources; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gene_gene_interaction_claims
    ADD CONSTRAINT fk_gene_interaction_claims_sources FOREIGN KEY (source_id) REFERENCES sources(id) MATCH FULL;


--
-- Name: fk_interaction; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY interaction_claims
    ADD CONSTRAINT fk_interaction FOREIGN KEY (interaction_id) REFERENCES interactions(id);


--
-- Name: fk_interaction; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY interaction_types_interactions
    ADD CONSTRAINT fk_interaction FOREIGN KEY (interaction_id) REFERENCES interactions(id);


--
-- Name: fk_interaction; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY interaction_attributes
    ADD CONSTRAINT fk_interaction FOREIGN KEY (interaction_id) REFERENCES interactions(id);


--
-- Name: fk_interaction; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY interactions_publications
    ADD CONSTRAINT fk_interaction FOREIGN KEY (interaction_id) REFERENCES interactions(id);


--
-- Name: fk_interaction_attribute; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY interaction_attributes_sources
    ADD CONSTRAINT fk_interaction_attribute FOREIGN KEY (interaction_attribute_id) REFERENCES interaction_attributes(id);


--
-- Name: fk_interaction_claim; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY interaction_claim_types_interaction_claims
    ADD CONSTRAINT fk_interaction_claim FOREIGN KEY (interaction_claim_id) REFERENCES interaction_claims(id) MATCH FULL;


--
-- Name: fk_interaction_claim; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY interaction_claims_publications
    ADD CONSTRAINT fk_interaction_claim FOREIGN KEY (interaction_claim_id) REFERENCES interaction_claims(id);


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
-- Name: fk_interaction_type; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY interaction_types_interactions
    ADD CONSTRAINT fk_interaction_type FOREIGN KEY (interaction_claim_type_id) REFERENCES interaction_claim_types(id);


--
-- Name: fk_publication; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY interactions_publications
    ADD CONSTRAINT fk_publication FOREIGN KEY (publication_id) REFERENCES publications(id);


--
-- Name: fk_publication; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY interaction_claims_publications
    ADD CONSTRAINT fk_publication FOREIGN KEY (publication_id) REFERENCES publications(id);


--
-- Name: fk_source; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY drug_aliases_sources
    ADD CONSTRAINT fk_source FOREIGN KEY (source_id) REFERENCES sources(id);


--
-- Name: fk_source; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY drug_attributes_sources
    ADD CONSTRAINT fk_source FOREIGN KEY (source_id) REFERENCES sources(id);


--
-- Name: fk_source; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gene_aliases_sources
    ADD CONSTRAINT fk_source FOREIGN KEY (source_id) REFERENCES sources(id);


--
-- Name: fk_source; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gene_attributes_sources
    ADD CONSTRAINT fk_source FOREIGN KEY (source_id) REFERENCES sources(id);


--
-- Name: fk_source; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY interaction_attributes_sources
    ADD CONSTRAINT fk_source FOREIGN KEY (source_id) REFERENCES sources(id);


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
-- Name: fk_source_trust_level; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sources
    ADD CONSTRAINT fk_source_trust_level FOREIGN KEY (source_trust_level_id) REFERENCES source_trust_levels(id);


--
-- Name: fk_source_type; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sources
    ADD CONSTRAINT fk_source_type FOREIGN KEY (source_type_id) REFERENCES source_types(id) MATCH FULL;


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

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

INSERT INTO schema_migrations (version) VALUES ('20130305165700');

INSERT INTO schema_migrations (version) VALUES ('20130307160126');

INSERT INTO schema_migrations (version) VALUES ('20130424183200');

INSERT INTO schema_migrations (version) VALUES ('20130712222803');

INSERT INTO schema_migrations (version) VALUES ('20130712225648');

INSERT INTO schema_migrations (version) VALUES ('20130906013631');

INSERT INTO schema_migrations (version) VALUES ('20170216144343');

INSERT INTO schema_migrations (version) VALUES ('20170216165933');

INSERT INTO schema_migrations (version) VALUES ('20170217172327');

INSERT INTO schema_migrations (version) VALUES ('20170217184303');

INSERT INTO schema_migrations (version) VALUES ('20170222165433');

INSERT INTO schema_migrations (version) VALUES ('20170302155212');

INSERT INTO schema_migrations (version) VALUES ('20170303162418');

INSERT INTO schema_migrations (version) VALUES ('20170314140736');

INSERT INTO schema_migrations (version) VALUES ('20170314161924');

INSERT INTO schema_migrations (version) VALUES ('20170315152806');

INSERT INTO schema_migrations (version) VALUES ('20170317143034');

INSERT INTO schema_migrations (version) VALUES ('20170317175150');

INSERT INTO schema_migrations (version) VALUES ('20170414213904');

INSERT INTO schema_migrations (version) VALUES ('20170417192246');

INSERT INTO schema_migrations (version) VALUES ('20170417192258');

INSERT INTO schema_migrations (version) VALUES ('20170424175208');

INSERT INTO schema_migrations (version) VALUES ('20170503192632');

INSERT INTO schema_migrations (version) VALUES ('20170512141234');

INSERT INTO schema_migrations (version) VALUES ('20170512150855');

INSERT INTO schema_migrations (version) VALUES ('20170605204001');

INSERT INTO schema_migrations (version) VALUES ('20170619164047');

INSERT INTO schema_migrations (version) VALUES ('20170619191811');

INSERT INTO schema_migrations (version) VALUES ('20170619204652');

INSERT INTO schema_migrations (version) VALUES ('20170619205542');

INSERT INTO schema_migrations (version) VALUES ('20170622142108');