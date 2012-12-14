--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
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
-- Name: drug_claims; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE drug_claims (
    id text NOT NULL,
    name text NOT NULL,
    description text,
    nomenclature text NOT NULL,
    source_id text
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
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


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
    source_type_id character varying(255)
);


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
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


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