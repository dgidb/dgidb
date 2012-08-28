--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'SQL_ASCII';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

--
-- Name: dgidb; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA dgidb;


SET search_path = dgidb, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: citation; Type: TABLE; Schema: dgidb; Owner: -; Tablespace: 
--

CREATE TABLE citation (
    id uuid NOT NULL,
    source_db_name character varying NOT NULL,
    source_db_version character varying NOT NULL,
    citation text,
    base_url character varying,
    site_url character varying,
    full_name character varying
);


--
-- Name: drug_gene_interaction_report; Type: TABLE; Schema: dgidb; Owner: -; Tablespace: 
--

CREATE TABLE drug_gene_interaction_report (
    id uuid NOT NULL,
    drug_name_report_id uuid NOT NULL,
    gene_name_report_id uuid NOT NULL,
    interaction_type character varying,
    description text,
    citation_id uuid
);


--
-- Name: drug_gene_interaction_report_attribute; Type: TABLE; Schema: dgidb; Owner: -; Tablespace: 
--

CREATE TABLE drug_gene_interaction_report_attribute (
    id uuid NOT NULL,
    interaction_id uuid NOT NULL,
    name character varying NOT NULL,
    value character varying NOT NULL
);


--
-- Name: drug_name_group; Type: TABLE; Schema: dgidb; Owner: -; Tablespace: 
--

CREATE TABLE drug_name_group (
    id uuid NOT NULL,
    name text
);


--
-- Name: drug_name_group_bridge; Type: TABLE; Schema: dgidb; Owner: -; Tablespace: 
--

CREATE TABLE drug_name_group_bridge (
    drug_name_group_id uuid NOT NULL,
    drug_name_report_id uuid NOT NULL
);


--
-- Name: drug_name_report; Type: TABLE; Schema: dgidb; Owner: -; Tablespace: 
--

CREATE TABLE drug_name_report (
    id uuid NOT NULL,
    name character varying NOT NULL,
    description text,
    nomenclature character varying NOT NULL,
    citation_id uuid
);


--
-- Name: drug_name_report_association; Type: TABLE; Schema: dgidb; Owner: -; Tablespace: 
--

CREATE TABLE drug_name_report_association (
    id uuid NOT NULL,
    drug_name_report_id uuid NOT NULL,
    alternate_name character varying NOT NULL,
    description text,
    nomenclature character varying NOT NULL
);


--
-- Name: drug_name_report_category_association; Type: TABLE; Schema: dgidb; Owner: -; Tablespace: 
--

CREATE TABLE drug_name_report_category_association (
    id uuid NOT NULL,
    drug_name_report_id uuid NOT NULL,
    category_name character varying NOT NULL,
    category_value character varying NOT NULL,
    description text
);


--
-- Name: gene_name_group; Type: TABLE; Schema: dgidb; Owner: -; Tablespace: 
--

CREATE TABLE gene_name_group (
    id uuid NOT NULL,
    name text
);


--
-- Name: gene_name_group_bridge; Type: TABLE; Schema: dgidb; Owner: -; Tablespace: 
--

CREATE TABLE gene_name_group_bridge (
    gene_name_group_id uuid NOT NULL,
    gene_name_report_id uuid NOT NULL
);


--
-- Name: gene_name_report; Type: TABLE; Schema: dgidb; Owner: -; Tablespace: 
--

CREATE TABLE gene_name_report (
    id uuid NOT NULL,
    name character varying NOT NULL,
    description text,
    nomenclature character varying NOT NULL,
    citation_id uuid
);


--
-- Name: gene_name_report_association; Type: TABLE; Schema: dgidb; Owner: -; Tablespace: 
--

CREATE TABLE gene_name_report_association (
    id uuid NOT NULL,
    gene_name_report_id uuid NOT NULL,
    alternate_name character varying NOT NULL,
    description text,
    nomenclature character varying NOT NULL
);


--
-- Name: gene_name_report_category_association; Type: TABLE; Schema: dgidb; Owner: -; Tablespace: 
--

CREATE TABLE gene_name_report_category_association (
    id uuid NOT NULL,
    gene_name_report_id uuid NOT NULL,
    category_name character varying NOT NULL,
    category_value character varying NOT NULL,
    description text
);


--
-- Name: citation_pkey; Type: CONSTRAINT; Schema: dgidb; Owner: -; Tablespace: 
--

ALTER TABLE ONLY citation
    ADD CONSTRAINT citation_pkey PRIMARY KEY (id);


--
-- Name: drug_gene_interaction_report_attribute_pkey; Type: CONSTRAINT; Schema: dgidb; Owner: -; Tablespace: 
--

ALTER TABLE ONLY drug_gene_interaction_report_attribute
    ADD CONSTRAINT drug_gene_interaction_report_attribute_pkey PRIMARY KEY (id);


--
-- Name: drug_gene_interaction_report_drug_name_report_id_key; Type: CONSTRAINT; Schema: dgidb; Owner: -; Tablespace: 
--

ALTER TABLE ONLY drug_gene_interaction_report
    ADD CONSTRAINT drug_gene_interaction_report_drug_name_report_id_key UNIQUE (drug_name_report_id, gene_name_report_id, interaction_type);


--
-- Name: drug_gene_interaction_report_pkey; Type: CONSTRAINT; Schema: dgidb; Owner: -; Tablespace: 
--

ALTER TABLE ONLY drug_gene_interaction_report
    ADD CONSTRAINT drug_gene_interaction_report_pkey PRIMARY KEY (id);


--
-- Name: drug_name_group_bridge_pkey; Type: CONSTRAINT; Schema: dgidb; Owner: -; Tablespace: 
--

ALTER TABLE ONLY drug_name_group_bridge
    ADD CONSTRAINT drug_name_group_bridge_pkey PRIMARY KEY (drug_name_group_id, drug_name_report_id);


--
-- Name: drug_name_group_pkey; Type: CONSTRAINT; Schema: dgidb; Owner: -; Tablespace: 
--

ALTER TABLE ONLY drug_name_group
    ADD CONSTRAINT drug_name_group_pkey PRIMARY KEY (id);


--
-- Name: drug_name_report_association_pkey; Type: CONSTRAINT; Schema: dgidb; Owner: -; Tablespace: 
--

ALTER TABLE ONLY drug_name_report_association
    ADD CONSTRAINT drug_name_report_association_pkey PRIMARY KEY (id);


--
-- Name: drug_name_report_category_association_pkey; Type: CONSTRAINT; Schema: dgidb; Owner: -; Tablespace: 
--

ALTER TABLE ONLY drug_name_report_category_association
    ADD CONSTRAINT drug_name_report_category_association_pkey PRIMARY KEY (id);


--
-- Name: drug_name_report_pkey; Type: CONSTRAINT; Schema: dgidb; Owner: -; Tablespace: 
--

ALTER TABLE ONLY drug_name_report
    ADD CONSTRAINT drug_name_report_pkey PRIMARY KEY (id);


--
-- Name: gene_name_group_bridge_pkey; Type: CONSTRAINT; Schema: dgidb; Owner: -; Tablespace: 
--

ALTER TABLE ONLY gene_name_group_bridge
    ADD CONSTRAINT gene_name_group_bridge_pkey PRIMARY KEY (gene_name_group_id, gene_name_report_id);


--
-- Name: gene_name_group_pkey; Type: CONSTRAINT; Schema: dgidb; Owner: -; Tablespace: 
--

ALTER TABLE ONLY gene_name_group
    ADD CONSTRAINT gene_name_group_pkey PRIMARY KEY (id);


--
-- Name: gene_name_report_association_pkey; Type: CONSTRAINT; Schema: dgidb; Owner: -; Tablespace: 
--

ALTER TABLE ONLY gene_name_report_association
    ADD CONSTRAINT gene_name_report_association_pkey PRIMARY KEY (id);


--
-- Name: gene_name_report_category_association_pkey; Type: CONSTRAINT; Schema: dgidb; Owner: -; Tablespace: 
--

ALTER TABLE ONLY gene_name_report_category_association
    ADD CONSTRAINT gene_name_report_category_association_pkey PRIMARY KEY (id);


--
-- Name: gene_name_report_pkey; Type: CONSTRAINT; Schema: dgidb; Owner: -; Tablespace: 
--

ALTER TABLE ONLY gene_name_report
    ADD CONSTRAINT gene_name_report_pkey PRIMARY KEY (id);


--
-- Name: alternate_name_index; Type: INDEX; Schema: dgidb; Owner: -; Tablespace: 
--

CREATE INDEX alternate_name_index ON gene_name_report_association USING btree (alternate_name);


--
-- Name: category_name; Type: INDEX; Schema: dgidb; Owner: -; Tablespace: 
--

CREATE INDEX category_name ON gene_name_report_category_association USING btree (category_name);


--
-- Name: category_name_and_value_idx; Type: INDEX; Schema: dgidb; Owner: -; Tablespace: 
--

CREATE INDEX category_name_and_value_idx ON gene_name_report_category_association USING btree (category_name, category_value);


--
-- Name: category_value_idx; Type: INDEX; Schema: dgidb; Owner: -; Tablespace: 
--

CREATE INDEX category_value_idx ON gene_name_report_category_association USING btree (category_value);


--
-- Name: drug_alt_name_text; Type: INDEX; Schema: dgidb; Owner: -; Tablespace: 
--

CREATE INDEX drug_alt_name_text ON drug_name_report_association USING gin (to_tsvector('english'::regconfig, (alternate_name)::text));


--
-- Name: drug_name_group_name_text; Type: INDEX; Schema: dgidb; Owner: -; Tablespace: 
--

CREATE INDEX drug_name_group_name_text ON drug_name_group USING gin (to_tsvector('english'::regconfig, name));


--
-- Name: drug_name_report_id_index; Type: INDEX; Schema: dgidb; Owner: -; Tablespace: 
--

CREATE INDEX drug_name_report_id_index ON drug_name_report_association USING btree (drug_name_report_id);


--
-- Name: drug_name_report_name_index; Type: INDEX; Schema: dgidb; Owner: -; Tablespace: 
--

CREATE INDEX drug_name_report_name_index ON drug_name_report USING btree (name);


--
-- Name: drug_name_report_name_text; Type: INDEX; Schema: dgidb; Owner: -; Tablespace: 
--

CREATE INDEX drug_name_report_name_text ON drug_name_report USING gin (to_tsvector('english'::regconfig, (name)::text));


--
-- Name: gene_name_report_id_idx; Type: INDEX; Schema: dgidb; Owner: -; Tablespace: 
--

CREATE INDEX gene_name_report_id_idx ON drug_gene_interaction_report USING btree (gene_name_report_id);


--
-- Name: gene_name_report_id_ix; Type: INDEX; Schema: dgidb; Owner: -; Tablespace: 
--

CREATE INDEX gene_name_report_id_ix ON gene_name_group_bridge USING btree (gene_name_report_id);


--
-- Name: gene_name_report_name_index; Type: INDEX; Schema: dgidb; Owner: -; Tablespace: 
--

CREATE INDEX gene_name_report_name_index ON gene_name_report USING btree (name);


--
-- Name: name_idx; Type: INDEX; Schema: dgidb; Owner: -; Tablespace: 
--

CREATE INDEX name_idx ON gene_name_group USING btree (name);


--
-- Name: drug_gene_interaction_report_attribute_interaction_id_fkey; Type: FK CONSTRAINT; Schema: dgidb; Owner: -
--

ALTER TABLE ONLY drug_gene_interaction_report_attribute
    ADD CONSTRAINT drug_gene_interaction_report_attribute_interaction_id_fkey FOREIGN KEY (interaction_id) REFERENCES drug_gene_interaction_report(id);


--
-- Name: drug_gene_interaction_report_drug_name_report_id_fkey; Type: FK CONSTRAINT; Schema: dgidb; Owner: -
--

ALTER TABLE ONLY drug_gene_interaction_report
    ADD CONSTRAINT drug_gene_interaction_report_drug_name_report_id_fkey FOREIGN KEY (drug_name_report_id) REFERENCES drug_name_report(id);


--
-- Name: drug_gene_interaction_report_gene_name_report_id_fkey; Type: FK CONSTRAINT; Schema: dgidb; Owner: -
--

ALTER TABLE ONLY drug_gene_interaction_report
    ADD CONSTRAINT drug_gene_interaction_report_gene_name_report_id_fkey FOREIGN KEY (gene_name_report_id) REFERENCES gene_name_report(id);


--
-- Name: drug_name_group_bridge_drug_name_group_id_fkey; Type: FK CONSTRAINT; Schema: dgidb; Owner: -
--

ALTER TABLE ONLY drug_name_group_bridge
    ADD CONSTRAINT drug_name_group_bridge_drug_name_group_id_fkey FOREIGN KEY (drug_name_group_id) REFERENCES drug_name_group(id);


--
-- Name: drug_name_group_bridge_drug_name_report_id_fkey; Type: FK CONSTRAINT; Schema: dgidb; Owner: -
--

ALTER TABLE ONLY drug_name_group_bridge
    ADD CONSTRAINT drug_name_group_bridge_drug_name_report_id_fkey FOREIGN KEY (drug_name_report_id) REFERENCES drug_name_report(id);


--
-- Name: drug_name_report_association_drug_name_report_id_fkey; Type: FK CONSTRAINT; Schema: dgidb; Owner: -
--

ALTER TABLE ONLY drug_name_report_association
    ADD CONSTRAINT drug_name_report_association_drug_name_report_id_fkey FOREIGN KEY (drug_name_report_id) REFERENCES drug_name_report(id);


--
-- Name: drug_name_report_category_association_drug_name_report_id_fkey; Type: FK CONSTRAINT; Schema: dgidb; Owner: -
--

ALTER TABLE ONLY drug_name_report_category_association
    ADD CONSTRAINT drug_name_report_category_association_drug_name_report_id_fkey FOREIGN KEY (drug_name_report_id) REFERENCES drug_name_report(id);


--
-- Name: gene_name_report_association_gene_name_report_id_fkey; Type: FK CONSTRAINT; Schema: dgidb; Owner: -
--

ALTER TABLE ONLY gene_name_report_association
    ADD CONSTRAINT gene_name_report_association_gene_name_report_id_fkey FOREIGN KEY (gene_name_report_id) REFERENCES gene_name_report(id);


--
-- Name: gene_name_report_category_association_gene_name_report_id_fkey; Type: FK CONSTRAINT; Schema: dgidb; Owner: -
--

ALTER TABLE ONLY gene_name_report_category_association
    ADD CONSTRAINT gene_name_report_category_association_gene_name_report_id_fkey FOREIGN KEY (gene_name_report_id) REFERENCES gene_name_report(id);


--
-- PostgreSQL database dump complete
--

