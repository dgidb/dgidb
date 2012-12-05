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
-- Name: citation; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE citation (
    id text NOT NULL,
    source_db_name text NOT NULL,
    source_db_version text NOT NULL,
    citation text,
    base_url text,
    site_url text,
    full_name text
);


--
-- Name: drug_gene_interaction_report; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE drug_gene_interaction_report (
    id text NOT NULL,
    drug_name_report_id text NOT NULL,
    gene_name_report_id text NOT NULL,
    interaction_type text,
    description text,
    citation_id text
);


--
-- Name: drug_gene_interaction_report_attribute; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE drug_gene_interaction_report_attribute (
    id text NOT NULL,
    interaction_id text NOT NULL,
    name text NOT NULL,
    value text NOT NULL
);


--
-- Name: drug_name_group; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE drug_name_group (
    id text NOT NULL,
    name text
);


--
-- Name: drug_name_group_bridge; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE drug_name_group_bridge (
    drug_name_group_id text NOT NULL,
    drug_name_report_id text NOT NULL
);


--
-- Name: drug_name_report; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE drug_name_report (
    id text NOT NULL,
    name text NOT NULL,
    description text,
    nomenclature text NOT NULL,
    citation_id text
);


--
-- Name: drug_name_report_association; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE drug_name_report_association (
    id text NOT NULL,
    drug_name_report_id text NOT NULL,
    alternate_name text NOT NULL,
    description text,
    nomenclature text NOT NULL
);


--
-- Name: drug_name_report_category_association; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE drug_name_report_category_association (
    id text NOT NULL,
    drug_name_report_id text NOT NULL,
    category_name text NOT NULL,
    category_value text NOT NULL,
    description text
);


--
-- Name: gene_name_group; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE gene_name_group (
    id text NOT NULL,
    name text
);


--
-- Name: gene_name_group_bridge; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE gene_name_group_bridge (
    gene_name_group_id text NOT NULL,
    gene_name_report_id text NOT NULL
);


--
-- Name: gene_name_report; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE gene_name_report (
    id text NOT NULL,
    name text NOT NULL,
    description text,
    nomenclature text NOT NULL,
    citation_id text
);


--
-- Name: gene_name_report_association; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE gene_name_report_association (
    id text NOT NULL,
    gene_name_report_id text NOT NULL,
    alternate_name text NOT NULL,
    description text,
    nomenclature text NOT NULL
);


--
-- Name: gene_name_report_category_association; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE gene_name_report_category_association (
    id text NOT NULL,
    gene_name_report_id text NOT NULL,
    category_name text NOT NULL,
    category_value text NOT NULL,
    description text
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: alternate_name_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX alternate_name_index ON gene_name_report_association USING btree (alternate_name);


--
-- Name: category_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX category_name ON gene_name_report_category_association USING btree (category_name);


--
-- Name: category_name_and_value_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX category_name_and_value_idx ON gene_name_report_category_association USING btree (category_name, category_value);


--
-- Name: category_value_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX category_value_idx ON gene_name_report_category_association USING btree (category_value);


--
-- Name: drug_gene_interaction_report_drug_name_report_id_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX drug_gene_interaction_report_drug_name_report_id_key ON drug_gene_interaction_report USING btree (drug_name_report_id, gene_name_report_id, interaction_type);


--
-- Name: drug_name_group_to_tsvector_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX drug_name_group_to_tsvector_idx ON drug_name_group USING gin (to_tsvector('english'::regconfig, name));


--
-- Name: drug_name_report_association_to_tsvector_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX drug_name_report_association_to_tsvector_idx ON drug_name_report_association USING gin (to_tsvector('english'::regconfig, alternate_name));


--
-- Name: drug_name_report_id_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX drug_name_report_id_index ON drug_name_report_association USING btree (drug_name_report_id);


--
-- Name: drug_name_report_name_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX drug_name_report_name_index ON drug_name_report USING btree (name);


--
-- Name: drug_name_report_to_tsvector_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX drug_name_report_to_tsvector_idx ON drug_name_report USING gin (to_tsvector('english'::regconfig, name));


--
-- Name: gene_name_group_to_tsvector_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX gene_name_group_to_tsvector_idx ON gene_name_group USING gin (to_tsvector('english'::regconfig, name));


--
-- Name: gene_name_report_association_to_tsvector_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX gene_name_report_association_to_tsvector_idx ON gene_name_report_association USING gin (to_tsvector('english'::regconfig, alternate_name));


--
-- Name: gene_name_report_id_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX gene_name_report_id_idx ON drug_gene_interaction_report USING btree (gene_name_report_id);


--
-- Name: gene_name_report_id_ix; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX gene_name_report_id_ix ON gene_name_group_bridge USING btree (gene_name_report_id);


--
-- Name: gene_name_report_name_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX gene_name_report_name_index ON gene_name_report USING btree (name);


--
-- Name: gene_name_report_to_tsvector_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX gene_name_report_to_tsvector_idx ON gene_name_report USING gin (to_tsvector('english'::regconfig, name));


--
-- Name: name_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX name_idx ON gene_name_group USING btree (name);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

INSERT INTO schema_migrations (version) VALUES ('20121205010322');