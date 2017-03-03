--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.1
-- Dumped by pg_dump version 9.6.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

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
-- Name: drug_aliases; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE drug_aliases (
    id text NOT NULL,
    drug_id text NOT NULL,
    alias text NOT NULL,
    nomenclature text NOT NULL,
    source_id text NOT NULL
);


--
-- Name: drug_claim_aliases; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE drug_claim_aliases (
    id text NOT NULL,
    drug_claim_id text NOT NULL,
    alias text NOT NULL,
    nomenclature text NOT NULL
);


--
-- Name: drug_claim_attributes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE drug_claim_attributes (
    id text NOT NULL,
    drug_claim_id text NOT NULL,
    name text NOT NULL,
    value text NOT NULL,
    description text
);


--
-- Name: drug_claim_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE drug_claim_types (
    id character varying(255) NOT NULL,
    type character varying(255) NOT NULL
);


--
-- Name: drug_claim_types_drug_claims; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE drug_claim_types_drug_claims (
    drug_claim_id character varying(255) NOT NULL,
    drug_claim_type_id character varying(255) NOT NULL
);


--
-- Name: drug_claims; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE drug_claims (
    id text NOT NULL,
    name text NOT NULL,
    description text,
    nomenclature text NOT NULL,
    source_id text,
    primary_name character varying(255),
    drug_id text
);


--
-- Name: drugs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE drugs (
    id text NOT NULL,
    name text
);


--
-- Name: gene_claim_aliases; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE gene_claim_aliases (
    id text NOT NULL,
    gene_claim_id text NOT NULL,
    alias text NOT NULL,
    description text,
    nomenclature text NOT NULL
);


--
-- Name: gene_claim_attributes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE gene_claim_attributes (
    id text NOT NULL,
    gene_claim_id text NOT NULL,
    name text NOT NULL,
    value text NOT NULL,
    description text
);


--
-- Name: gene_claim_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE gene_claim_categories (
    id character varying(255) NOT NULL,
    name character varying(255) NOT NULL
);


--
-- Name: gene_claim_categories_gene_claims; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE gene_claim_categories_gene_claims (
    gene_claim_id character varying(255) NOT NULL,
    gene_claim_category_id character varying(255) NOT NULL
);


--
-- Name: gene_claims; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE gene_claims (
    id text NOT NULL,
    name text NOT NULL,
    description text,
    nomenclature text NOT NULL,
    source_id text,
    gene_id text
);


--
-- Name: gene_gene_interaction_claim_attributes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE gene_gene_interaction_claim_attributes (
    id character varying(255) NOT NULL,
    gene_gene_interaction_claim_id character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(255) NOT NULL
);


--
-- Name: gene_gene_interaction_claims; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE gene_gene_interaction_claims (
    id character varying(255) NOT NULL,
    gene_id character varying(255) NOT NULL,
    interacting_gene_id character varying(255) NOT NULL,
    source_id character varying(255) NOT NULL
);


--
-- Name: genes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE genes (
    id text NOT NULL,
    name text,
    long_name character varying(255)
);


--
-- Name: interaction_claim_attributes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE interaction_claim_attributes (
    id text NOT NULL,
    interaction_claim_id text NOT NULL,
    name text NOT NULL,
    value text NOT NULL
);


--
-- Name: interaction_claim_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE interaction_claim_types (
    id character varying(255) NOT NULL,
    type character varying(255)
);


--
-- Name: interaction_claim_types_interaction_claims; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE interaction_claim_types_interaction_claims (
    interaction_claim_type_id character varying(255) NOT NULL,
    interaction_claim_id character varying(255) NOT NULL
);


--
-- Name: interaction_claims; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE interaction_claims (
    id text NOT NULL,
    drug_claim_id text NOT NULL,
    gene_claim_id text NOT NULL,
    interaction_type text,
    description text,
    source_id text,
    known_action_type character varying(255),
    interaction_id text
);


--
-- Name: interaction_types_interactions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE interaction_types_interactions (
    interaction_claim_type_id text NOT NULL,
    interaction_id text NOT NULL
);


--
-- Name: interactions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE interactions (
    id text NOT NULL,
    drug_id text NOT NULL,
    gene_id text NOT NULL
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: source_trust_levels; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE source_trust_levels (
    id character varying(255) NOT NULL,
    level character varying(255) NOT NULL
);


--
-- Name: source_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE source_types (
    id character varying(255) NOT NULL,
    type character varying(255) NOT NULL,
    display_name character varying(255)
);


--
-- Name: sources; Type: TABLE; Schema: public; Owner: -
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
-- Name: drug_aliases drug_aliases_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY drug_aliases
    ADD CONSTRAINT drug_aliases_pkey PRIMARY KEY (id);


--
-- Name: drug_claim_aliases drug_claim_aliases_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY drug_claim_aliases
    ADD CONSTRAINT drug_claim_aliases_pkey PRIMARY KEY (id);


--
-- Name: drug_claim_attributes drug_claim_attributes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY drug_claim_attributes
    ADD CONSTRAINT drug_claim_attributes_pkey PRIMARY KEY (id);


--
-- Name: drug_claim_types_drug_claims drug_claim_types_drug_claims_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY drug_claim_types_drug_claims
    ADD CONSTRAINT drug_claim_types_drug_claims_pkey PRIMARY KEY (drug_claim_id, drug_claim_type_id);


--
-- Name: drug_claim_types drug_claim_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY drug_claim_types
    ADD CONSTRAINT drug_claim_types_pkey PRIMARY KEY (id);


--
-- Name: drug_claims drug_claims_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY drug_claims
    ADD CONSTRAINT drug_claims_pkey PRIMARY KEY (id);


--
-- Name: drugs drugs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY drugs
    ADD CONSTRAINT drugs_pkey PRIMARY KEY (id);


--
-- Name: gene_claim_aliases gene_claim_aliases_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gene_claim_aliases
    ADD CONSTRAINT gene_claim_aliases_pkey PRIMARY KEY (id);


--
-- Name: gene_claim_attributes gene_claim_attributes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gene_claim_attributes
    ADD CONSTRAINT gene_claim_attributes_pkey PRIMARY KEY (id);


--
-- Name: gene_claim_categories_gene_claims gene_claim_categories_gene_claims_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gene_claim_categories_gene_claims
    ADD CONSTRAINT gene_claim_categories_gene_claims_pkey PRIMARY KEY (gene_claim_id, gene_claim_category_id);


--
-- Name: gene_claim_categories gene_claim_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gene_claim_categories
    ADD CONSTRAINT gene_claim_categories_pkey PRIMARY KEY (id);


--
-- Name: gene_claims gene_claims_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gene_claims
    ADD CONSTRAINT gene_claims_pkey PRIMARY KEY (id);


--
-- Name: gene_gene_interaction_claim_attributes gene_gene_interaction_claim_attributes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gene_gene_interaction_claim_attributes
    ADD CONSTRAINT gene_gene_interaction_claim_attributes_pkey PRIMARY KEY (gene_gene_interaction_claim_id);


--
-- Name: gene_gene_interaction_claims gene_gene_interaction_claims_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gene_gene_interaction_claims
    ADD CONSTRAINT gene_gene_interaction_claims_pkey PRIMARY KEY (id);


--
-- Name: genes genes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY genes
    ADD CONSTRAINT genes_pkey PRIMARY KEY (id);


--
-- Name: interaction_claim_attributes interaction_claim_attributes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY interaction_claim_attributes
    ADD CONSTRAINT interaction_claim_attributes_pkey PRIMARY KEY (id);


--
-- Name: interaction_claim_types_interaction_claims interaction_claim_types_interaction_claims_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY interaction_claim_types_interaction_claims
    ADD CONSTRAINT interaction_claim_types_interaction_claims_pkey PRIMARY KEY (interaction_claim_type_id, interaction_claim_id);


--
-- Name: interaction_claim_types interaction_claim_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY interaction_claim_types
    ADD CONSTRAINT interaction_claim_types_pkey PRIMARY KEY (id);


--
-- Name: interaction_claims interaction_claims_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY interaction_claims
    ADD CONSTRAINT interaction_claims_pkey PRIMARY KEY (id);


--
-- Name: interaction_types_interactions interaction_types_interactions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY interaction_types_interactions
    ADD CONSTRAINT interaction_types_interactions_pkey PRIMARY KEY (interaction_claim_type_id, interaction_id);


--
-- Name: interactions interactions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY interactions
    ADD CONSTRAINT interactions_pkey PRIMARY KEY (id);


--
-- Name: source_trust_levels source_trust_levels_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY source_trust_levels
    ADD CONSTRAINT source_trust_levels_pkey PRIMARY KEY (id);


--
-- Name: source_types source_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY source_types
    ADD CONSTRAINT source_types_pkey PRIMARY KEY (id);


--
-- Name: sources sources_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sources
    ADD CONSTRAINT sources_pkey PRIMARY KEY (id);


--
-- Name: drug_claim_aliases_drug_claim_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX drug_claim_aliases_drug_claim_id_idx ON drug_claim_aliases USING btree (drug_claim_id);


--
-- Name: drug_claim_aliases_full_text; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX drug_claim_aliases_full_text ON drug_claim_aliases USING gin (to_tsvector('english'::regconfig, alias));


--
-- Name: drug_claim_attributes_drug_claim_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX drug_claim_attributes_drug_claim_id_idx ON drug_claim_attributes USING btree (drug_claim_id);


--
-- Name: drug_claim_types_lower_type_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX drug_claim_types_lower_type_idx ON drug_claim_types USING btree (lower((type)::text));


--
-- Name: drug_claims_full_text; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX drug_claims_full_text ON drug_claims USING gin (to_tsvector('english'::regconfig, name));


--
-- Name: drug_claims_source_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX drug_claims_source_id_idx ON drug_claims USING btree (source_id);


--
-- Name: drugs_full_text; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX drugs_full_text ON drugs USING gin (to_tsvector('english'::regconfig, name));


--
-- Name: drugs_lower_name_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX drugs_lower_name_idx ON drugs USING btree (lower(name));


--
-- Name: gene_claim_aliases_full_text; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gene_claim_aliases_full_text ON gene_claim_aliases USING gin (to_tsvector('english'::regconfig, alias));


--
-- Name: gene_claim_aliases_gene_claim_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gene_claim_aliases_gene_claim_id_idx ON gene_claim_aliases USING btree (gene_claim_id);


--
-- Name: gene_claim_aliases_lower_alias_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gene_claim_aliases_lower_alias_idx ON gene_claim_aliases USING btree (lower(alias));


--
-- Name: gene_claim_attributes_gene_claim_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gene_claim_attributes_gene_claim_id_idx ON gene_claim_attributes USING btree (gene_claim_id);


--
-- Name: gene_claim_categories_lower_name_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gene_claim_categories_lower_name_idx ON gene_claim_categories USING btree (lower((name)::text));


--
-- Name: gene_claims_full_text; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gene_claims_full_text ON gene_claims USING gin (to_tsvector('english'::regconfig, name));


--
-- Name: gene_claims_source_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gene_claims_source_id_idx ON gene_claims USING btree (source_id);


--
-- Name: genes_full_text; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX genes_full_text ON genes USING gin (to_tsvector('english'::regconfig, name));


--
-- Name: genes_lower_name_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX genes_lower_name_idx ON genes USING btree (lower(name));


--
-- Name: index_drug_claim_attributes_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_drug_claim_attributes_on_name ON drug_claim_attributes USING btree (name);


--
-- Name: index_drug_claim_attributes_on_value; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_drug_claim_attributes_on_value ON drug_claim_attributes USING btree (value);


--
-- Name: index_gene_claim_aliases_on_alias; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_gene_claim_aliases_on_alias ON gene_claim_aliases USING btree (alias);


--
-- Name: index_gene_claim_attributes_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_gene_claim_attributes_on_name ON gene_claim_attributes USING btree (name);


--
-- Name: index_gene_claim_attributes_on_value; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_gene_claim_attributes_on_value ON gene_claim_attributes USING btree (value);


--
-- Name: index_gene_claims_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_gene_claims_on_name ON gene_claims USING btree (name);


--
-- Name: index_gene_gene_interaction_claims_on_gene_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_gene_gene_interaction_claims_on_gene_id ON gene_gene_interaction_claims USING btree (gene_id);


--
-- Name: index_gene_gene_interaction_claims_on_interacting_gene_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_gene_gene_interaction_claims_on_interacting_gene_id ON gene_gene_interaction_claims USING btree (interacting_gene_id);


--
-- Name: index_genes_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_genes_on_name ON genes USING btree (name);


--
-- Name: index_interaction_claims_on_known_action_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_interaction_claims_on_known_action_type ON interaction_claims USING btree (known_action_type);


--
-- Name: interaction_claim_attributes_interaction_claim_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX interaction_claim_attributes_interaction_claim_id_idx ON interaction_claim_attributes USING btree (interaction_claim_id);


--
-- Name: interaction_claim_types_lower_type_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX interaction_claim_types_lower_type_idx ON interaction_claim_types USING btree (lower((type)::text));


--
-- Name: interaction_claims_drug_claim_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX interaction_claims_drug_claim_id_idx ON interaction_claims USING btree (drug_claim_id);


--
-- Name: interaction_claims_gene_claim_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX interaction_claims_gene_claim_id_idx ON interaction_claims USING btree (gene_claim_id);


--
-- Name: interaction_claims_source_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX interaction_claims_source_id_idx ON interaction_claims USING btree (source_id);


--
-- Name: left_and_interacting_gene_interaction_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX left_and_interacting_gene_interaction_index ON gene_gene_interaction_claims USING btree (gene_id, interacting_gene_id);


--
-- Name: source_trust_levels_lower_level_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX source_trust_levels_lower_level_idx ON source_trust_levels USING btree (lower((level)::text));


--
-- Name: sources_lower_source_db_name_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sources_lower_source_db_name_idx ON sources USING btree (lower(source_db_name));


--
-- Name: sources_source_trust_level_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sources_source_trust_level_id_idx ON sources USING btree (source_trust_level_id);


--
-- Name: sources_source_type_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sources_source_type_id_idx ON sources USING btree (source_type_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: gene_gene_interaction_claim_attributes fk_attributes_gene_interaction_claim; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gene_gene_interaction_claim_attributes
    ADD CONSTRAINT fk_attributes_gene_interaction_claim FOREIGN KEY (gene_gene_interaction_claim_id) REFERENCES gene_gene_interaction_claims(id) MATCH FULL;


--
-- Name: drug_claims fk_drug; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY drug_claims
    ADD CONSTRAINT fk_drug FOREIGN KEY (drug_id) REFERENCES drugs(id) MATCH FULL;


--
-- Name: interactions fk_drug; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY interactions
    ADD CONSTRAINT fk_drug FOREIGN KEY (drug_id) REFERENCES drugs(id);


--
-- Name: drug_aliases fk_drug; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY drug_aliases
    ADD CONSTRAINT fk_drug FOREIGN KEY (drug_id) REFERENCES drugs(id);


--
-- Name: drug_claim_types_drug_claims fk_drug_claim; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY drug_claim_types_drug_claims
    ADD CONSTRAINT fk_drug_claim FOREIGN KEY (drug_claim_id) REFERENCES drug_claims(id) MATCH FULL;


--
-- Name: drug_claim_aliases fk_drug_claim_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY drug_claim_aliases
    ADD CONSTRAINT fk_drug_claim_id FOREIGN KEY (drug_claim_id) REFERENCES drug_claims(id) MATCH FULL;


--
-- Name: drug_claim_attributes fk_drug_claim_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY drug_claim_attributes
    ADD CONSTRAINT fk_drug_claim_id FOREIGN KEY (drug_claim_id) REFERENCES drug_claims(id) MATCH FULL;


--
-- Name: interaction_claims fk_drug_claim_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY interaction_claims
    ADD CONSTRAINT fk_drug_claim_id FOREIGN KEY (drug_claim_id) REFERENCES drug_claims(id) MATCH FULL;


--
-- Name: drug_claim_types_drug_claims fk_drug_claim_type; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY drug_claim_types_drug_claims
    ADD CONSTRAINT fk_drug_claim_type FOREIGN KEY (drug_claim_type_id) REFERENCES drug_claim_types(id) MATCH FULL;


--
-- Name: gene_claims fk_gene; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gene_claims
    ADD CONSTRAINT fk_gene FOREIGN KEY (gene_id) REFERENCES genes(id) MATCH FULL;


--
-- Name: interactions fk_gene; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY interactions
    ADD CONSTRAINT fk_gene FOREIGN KEY (gene_id) REFERENCES genes(id);


--
-- Name: gene_claim_categories_gene_claims fk_gene_claim; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gene_claim_categories_gene_claims
    ADD CONSTRAINT fk_gene_claim FOREIGN KEY (gene_claim_id) REFERENCES gene_claims(id) MATCH FULL;


--
-- Name: gene_claim_categories_gene_claims fk_gene_claim_category; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gene_claim_categories_gene_claims
    ADD CONSTRAINT fk_gene_claim_category FOREIGN KEY (gene_claim_category_id) REFERENCES gene_claim_categories(id) MATCH FULL;


--
-- Name: gene_claim_aliases fk_gene_claim_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gene_claim_aliases
    ADD CONSTRAINT fk_gene_claim_id FOREIGN KEY (gene_claim_id) REFERENCES gene_claims(id) MATCH FULL;


--
-- Name: gene_claim_attributes fk_gene_claim_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gene_claim_attributes
    ADD CONSTRAINT fk_gene_claim_id FOREIGN KEY (gene_claim_id) REFERENCES gene_claims(id) MATCH FULL;


--
-- Name: interaction_claims fk_gene_claim_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY interaction_claims
    ADD CONSTRAINT fk_gene_claim_id FOREIGN KEY (gene_claim_id) REFERENCES gene_claims(id) MATCH FULL;


--
-- Name: gene_gene_interaction_claims fk_gene_interaction_claims_gene; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gene_gene_interaction_claims
    ADD CONSTRAINT fk_gene_interaction_claims_gene FOREIGN KEY (gene_id) REFERENCES genes(id) MATCH FULL;


--
-- Name: gene_gene_interaction_claims fk_gene_interaction_claims_interacting_gene; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gene_gene_interaction_claims
    ADD CONSTRAINT fk_gene_interaction_claims_interacting_gene FOREIGN KEY (interacting_gene_id) REFERENCES genes(id) MATCH FULL;


--
-- Name: gene_gene_interaction_claims fk_gene_interaction_claims_sources; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gene_gene_interaction_claims
    ADD CONSTRAINT fk_gene_interaction_claims_sources FOREIGN KEY (source_id) REFERENCES sources(id) MATCH FULL;


--
-- Name: interaction_claims fk_interaction; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY interaction_claims
    ADD CONSTRAINT fk_interaction FOREIGN KEY (interaction_id) REFERENCES interactions(id);


--
-- Name: interaction_types_interactions fk_interaction; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY interaction_types_interactions
    ADD CONSTRAINT fk_interaction FOREIGN KEY (interaction_id) REFERENCES interactions(id);


--
-- Name: interaction_claim_types_interaction_claims fk_interaction_claim; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY interaction_claim_types_interaction_claims
    ADD CONSTRAINT fk_interaction_claim FOREIGN KEY (interaction_claim_id) REFERENCES interaction_claims(id) MATCH FULL;


--
-- Name: interaction_claim_attributes fk_interaction_claim_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY interaction_claim_attributes
    ADD CONSTRAINT fk_interaction_claim_id FOREIGN KEY (interaction_claim_id) REFERENCES interaction_claims(id) MATCH FULL;


--
-- Name: interaction_claim_types_interaction_claims fk_interaction_claim_type; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY interaction_claim_types_interaction_claims
    ADD CONSTRAINT fk_interaction_claim_type FOREIGN KEY (interaction_claim_type_id) REFERENCES interaction_claim_types(id) MATCH FULL;


--
-- Name: interaction_types_interactions fk_interaction_type; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY interaction_types_interactions
    ADD CONSTRAINT fk_interaction_type FOREIGN KEY (interaction_claim_type_id) REFERENCES interaction_claim_types(id);


--
-- Name: drug_aliases fk_source; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY drug_aliases
    ADD CONSTRAINT fk_source FOREIGN KEY (source_id) REFERENCES sources(id);


--
-- Name: drug_claims fk_source_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY drug_claims
    ADD CONSTRAINT fk_source_id FOREIGN KEY (source_id) REFERENCES sources(id) MATCH FULL;


--
-- Name: gene_claims fk_source_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gene_claims
    ADD CONSTRAINT fk_source_id FOREIGN KEY (source_id) REFERENCES sources(id) MATCH FULL;


--
-- Name: interaction_claims fk_source_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY interaction_claims
    ADD CONSTRAINT fk_source_id FOREIGN KEY (source_id) REFERENCES sources(id) MATCH FULL;


--
-- Name: sources fk_source_trust_level; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sources
    ADD CONSTRAINT fk_source_trust_level FOREIGN KEY (source_trust_level_id) REFERENCES source_trust_levels(id);


--
-- Name: sources fk_source_type; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sources
    ADD CONSTRAINT fk_source_type FOREIGN KEY (source_type_id) REFERENCES source_types(id) MATCH FULL;


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

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