SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: clean(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.clean(text) RETURNS text
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
            declare cleaned text;
            BEGIN
              select upper(regexp_replace($1, '[^[:alnum:]]+', '', 'g')) into cleaned;
              return cleaned;
            END
            $_$;


SET default_tablespace = '';

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: chembl_molecule_synonyms; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.chembl_molecule_synonyms (
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

CREATE SEQUENCE public.chembl_molecule_synonyms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: chembl_molecule_synonyms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.chembl_molecule_synonyms_id_seq OWNED BY public.chembl_molecule_synonyms.id;


--
-- Name: chembl_molecules; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.chembl_molecules (
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
    withdrawn_reason text
);


--
-- Name: chembl_molecules_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.chembl_molecules_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: chembl_molecules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.chembl_molecules_id_seq OWNED BY public.chembl_molecules.id;


--
-- Name: delayed_jobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.delayed_jobs (
    id bigint NOT NULL,
    priority integer DEFAULT 0 NOT NULL,
    attempts integer DEFAULT 0 NOT NULL,
    handler text NOT NULL,
    last_error text,
    run_at timestamp without time zone,
    locked_at timestamp without time zone,
    failed_at timestamp without time zone,
    locked_by character varying,
    queue character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: delayed_jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.delayed_jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: delayed_jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.delayed_jobs_id_seq OWNED BY public.delayed_jobs.id;


--
-- Name: drug_alias_blacklists; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.drug_alias_blacklists (
    id bigint NOT NULL,
    alias text
);


--
-- Name: drug_alias_blacklists_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.drug_alias_blacklists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: drug_alias_blacklists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.drug_alias_blacklists_id_seq OWNED BY public.drug_alias_blacklists.id;


--
-- Name: drug_aliases; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.drug_aliases (
    id text NOT NULL,
    drug_id text NOT NULL,
    alias text NOT NULL
);


--
-- Name: drug_aliases_sources; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.drug_aliases_sources (
    drug_alias_id text NOT NULL,
    source_id text NOT NULL
);


--
-- Name: drug_attributes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.drug_attributes (
    id text NOT NULL,
    drug_id text NOT NULL,
    name text NOT NULL,
    value text NOT NULL
);


--
-- Name: drug_attributes_sources; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.drug_attributes_sources (
    drug_attribute_id text NOT NULL,
    source_id text NOT NULL
);


--
-- Name: drug_claim_aliases; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.drug_claim_aliases (
    id text NOT NULL,
    drug_claim_id text NOT NULL,
    alias text NOT NULL,
    nomenclature text NOT NULL
);


--
-- Name: drug_claim_attributes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.drug_claim_attributes (
    id text NOT NULL,
    drug_claim_id text NOT NULL,
    name text NOT NULL,
    value text NOT NULL
);


--
-- Name: drug_claim_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.drug_claim_types (
    id character varying(255) NOT NULL,
    type character varying(255) NOT NULL
);


--
-- Name: drug_claim_types_drug_claims; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.drug_claim_types_drug_claims (
    drug_claim_id character varying(255) NOT NULL,
    drug_claim_type_id character varying(255) NOT NULL
);


--
-- Name: drug_claims; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.drug_claims (
    id text NOT NULL,
    name text NOT NULL,
    nomenclature text NOT NULL,
    source_id text,
    primary_name character varying(255),
    drug_id text
);


--
-- Name: drugs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.drugs (
    id text NOT NULL,
    name text NOT NULL,
    fda_approved boolean,
    immunotherapy boolean,
    anti_neoplastic boolean,
    chembl_id character varying NOT NULL,
    chembl_molecule_id integer
);


--
-- Name: gene_aliases; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.gene_aliases (
    id text NOT NULL,
    gene_id text NOT NULL,
    alias text NOT NULL
);


--
-- Name: gene_aliases_sources; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.gene_aliases_sources (
    gene_alias_id text NOT NULL,
    source_id text NOT NULL
);


--
-- Name: gene_attributes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.gene_attributes (
    id text NOT NULL,
    gene_id text NOT NULL,
    name text NOT NULL,
    value text NOT NULL
);


--
-- Name: gene_attributes_sources; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.gene_attributes_sources (
    gene_attribute_id text NOT NULL,
    source_id text NOT NULL
);


--
-- Name: gene_categories_genes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.gene_categories_genes (
    gene_claim_category_id text NOT NULL,
    gene_id text NOT NULL
);


--
-- Name: gene_claim_aliases; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.gene_claim_aliases (
    id text NOT NULL,
    gene_claim_id text NOT NULL,
    alias text NOT NULL,
    nomenclature text NOT NULL
);


--
-- Name: gene_claim_attributes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.gene_claim_attributes (
    id text NOT NULL,
    gene_claim_id text NOT NULL,
    name text NOT NULL,
    value text NOT NULL
);


--
-- Name: gene_claim_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.gene_claim_categories (
    id character varying(255) NOT NULL,
    name character varying(255) NOT NULL
);


--
-- Name: gene_claim_categories_gene_claims; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.gene_claim_categories_gene_claims (
    gene_claim_id character varying(255) NOT NULL,
    gene_claim_category_id character varying(255) NOT NULL
);


--
-- Name: gene_claims; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.gene_claims (
    id text NOT NULL,
    name text NOT NULL,
    nomenclature text NOT NULL,
    source_id text,
    gene_id text
);


--
-- Name: gene_gene_interaction_claim_attributes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.gene_gene_interaction_claim_attributes (
    id character varying(255) NOT NULL,
    gene_gene_interaction_claim_id character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(255) NOT NULL
);


--
-- Name: gene_gene_interaction_claims; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.gene_gene_interaction_claims (
    id character varying(255) NOT NULL,
    gene_id character varying(255) NOT NULL,
    interacting_gene_id character varying(255) NOT NULL,
    source_id character varying(255) NOT NULL
);


--
-- Name: genes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.genes (
    id text NOT NULL,
    name text,
    long_name character varying(255),
    entrez_id integer
);


--
-- Name: interaction_attributes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.interaction_attributes (
    id text NOT NULL,
    interaction_id text NOT NULL,
    name text NOT NULL,
    value text NOT NULL
);


--
-- Name: interaction_attributes_sources; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.interaction_attributes_sources (
    interaction_attribute_id text NOT NULL,
    source_id text NOT NULL
);


--
-- Name: interaction_claim_attributes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.interaction_claim_attributes (
    id text NOT NULL,
    interaction_claim_id text NOT NULL,
    name text NOT NULL,
    value text NOT NULL
);


--
-- Name: interaction_claim_links; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.interaction_claim_links (
    id text NOT NULL,
    interaction_claim_id text NOT NULL,
    link_text character varying NOT NULL,
    link_url character varying NOT NULL
);


--
-- Name: interaction_claim_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.interaction_claim_types (
    id character varying(255) NOT NULL,
    type character varying(255),
    directionality integer,
    definition text
);


--
-- Name: interaction_claim_types_interaction_claims; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.interaction_claim_types_interaction_claims (
    interaction_claim_type_id character varying(255) NOT NULL,
    interaction_claim_id character varying(255) NOT NULL
);


--
-- Name: interaction_claims; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.interaction_claims (
    id text NOT NULL,
    drug_claim_id text NOT NULL,
    gene_claim_id text NOT NULL,
    source_id text,
    interaction_id text
);


--
-- Name: interaction_claims_publications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.interaction_claims_publications (
    interaction_claim_id text NOT NULL,
    publication_id text NOT NULL
);


--
-- Name: interaction_types_interactions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.interaction_types_interactions (
    interaction_claim_type_id text NOT NULL,
    interaction_id text NOT NULL
);


--
-- Name: interactions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.interactions (
    id text NOT NULL,
    drug_id text NOT NULL,
    gene_id text NOT NULL
);


--
-- Name: interactions_publications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.interactions_publications (
    interaction_id text NOT NULL,
    publication_id text NOT NULL
);


--
-- Name: interactions_sources; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.interactions_sources (
    interaction_id text NOT NULL,
    source_id text NOT NULL
);


--
-- Name: publications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.publications (
    id text NOT NULL,
    pmid integer NOT NULL,
    citation text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: source_trust_levels; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.source_trust_levels (
    id character varying(255) NOT NULL,
    level character varying(255) NOT NULL
);


--
-- Name: source_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.source_types (
    id character varying(255) NOT NULL,
    type character varying(255) NOT NULL,
    display_name character varying(255)
);


--
-- Name: sources; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sources (
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
    gene_gene_interaction_claims_count integer DEFAULT 0,
    license character varying,
    license_link character varying
);


--
-- Name: chembl_molecule_synonyms id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chembl_molecule_synonyms ALTER COLUMN id SET DEFAULT nextval('public.chembl_molecule_synonyms_id_seq'::regclass);


--
-- Name: chembl_molecules id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chembl_molecules ALTER COLUMN id SET DEFAULT nextval('public.chembl_molecules_id_seq'::regclass);


--
-- Name: delayed_jobs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.delayed_jobs ALTER COLUMN id SET DEFAULT nextval('public.delayed_jobs_id_seq'::regclass);


--
-- Name: drug_alias_blacklists id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.drug_alias_blacklists ALTER COLUMN id SET DEFAULT nextval('public.drug_alias_blacklists_id_seq'::regclass);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: chembl_molecule_synonyms chembl_molecule_synonyms_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chembl_molecule_synonyms
    ADD CONSTRAINT chembl_molecule_synonyms_pkey PRIMARY KEY (id);


--
-- Name: chembl_molecules chembl_molecules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chembl_molecules
    ADD CONSTRAINT chembl_molecules_pkey PRIMARY KEY (id);


--
-- Name: delayed_jobs delayed_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.delayed_jobs
    ADD CONSTRAINT delayed_jobs_pkey PRIMARY KEY (id);


--
-- Name: drug_alias_blacklists drug_alias_blacklists_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.drug_alias_blacklists
    ADD CONSTRAINT drug_alias_blacklists_pkey PRIMARY KEY (id);


--
-- Name: drug_aliases drug_aliases_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.drug_aliases
    ADD CONSTRAINT drug_aliases_pkey PRIMARY KEY (id);


--
-- Name: drug_aliases_sources drug_aliases_sources_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.drug_aliases_sources
    ADD CONSTRAINT drug_aliases_sources_pkey PRIMARY KEY (drug_alias_id, source_id);


--
-- Name: drug_attributes drug_attributes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.drug_attributes
    ADD CONSTRAINT drug_attributes_pkey PRIMARY KEY (id);


--
-- Name: drug_attributes_sources drug_attributes_sources_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.drug_attributes_sources
    ADD CONSTRAINT drug_attributes_sources_pkey PRIMARY KEY (drug_attribute_id, source_id);


--
-- Name: drug_claim_aliases drug_claim_aliases_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.drug_claim_aliases
    ADD CONSTRAINT drug_claim_aliases_pkey PRIMARY KEY (id);


--
-- Name: drug_claim_attributes drug_claim_attributes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.drug_claim_attributes
    ADD CONSTRAINT drug_claim_attributes_pkey PRIMARY KEY (id);


--
-- Name: drug_claim_types_drug_claims drug_claim_types_drug_claims_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.drug_claim_types_drug_claims
    ADD CONSTRAINT drug_claim_types_drug_claims_pkey PRIMARY KEY (drug_claim_id, drug_claim_type_id);


--
-- Name: drug_claim_types drug_claim_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.drug_claim_types
    ADD CONSTRAINT drug_claim_types_pkey PRIMARY KEY (id);


--
-- Name: drug_claims drug_claims_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.drug_claims
    ADD CONSTRAINT drug_claims_pkey PRIMARY KEY (id);


--
-- Name: drugs drugs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.drugs
    ADD CONSTRAINT drugs_pkey PRIMARY KEY (id);


--
-- Name: gene_aliases gene_aliases_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gene_aliases
    ADD CONSTRAINT gene_aliases_pkey PRIMARY KEY (id);


--
-- Name: gene_aliases_sources gene_aliases_sources_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gene_aliases_sources
    ADD CONSTRAINT gene_aliases_sources_pkey PRIMARY KEY (gene_alias_id, source_id);


--
-- Name: gene_attributes gene_attributes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gene_attributes
    ADD CONSTRAINT gene_attributes_pkey PRIMARY KEY (id);


--
-- Name: gene_attributes_sources gene_attributes_sources_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gene_attributes_sources
    ADD CONSTRAINT gene_attributes_sources_pkey PRIMARY KEY (gene_attribute_id, source_id);


--
-- Name: gene_categories_genes gene_categories_genes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gene_categories_genes
    ADD CONSTRAINT gene_categories_genes_pkey PRIMARY KEY (gene_claim_category_id, gene_id);


--
-- Name: gene_claim_aliases gene_claim_aliases_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gene_claim_aliases
    ADD CONSTRAINT gene_claim_aliases_pkey PRIMARY KEY (id);


--
-- Name: gene_claim_attributes gene_claim_attributes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gene_claim_attributes
    ADD CONSTRAINT gene_claim_attributes_pkey PRIMARY KEY (id);


--
-- Name: gene_claim_categories_gene_claims gene_claim_categories_gene_claims_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gene_claim_categories_gene_claims
    ADD CONSTRAINT gene_claim_categories_gene_claims_pkey PRIMARY KEY (gene_claim_id, gene_claim_category_id);


--
-- Name: gene_claim_categories gene_claim_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gene_claim_categories
    ADD CONSTRAINT gene_claim_categories_pkey PRIMARY KEY (id);


--
-- Name: gene_claims gene_claims_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gene_claims
    ADD CONSTRAINT gene_claims_pkey PRIMARY KEY (id);


--
-- Name: gene_gene_interaction_claim_attributes gene_gene_interaction_claim_attributes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gene_gene_interaction_claim_attributes
    ADD CONSTRAINT gene_gene_interaction_claim_attributes_pkey PRIMARY KEY (gene_gene_interaction_claim_id);


--
-- Name: gene_gene_interaction_claims gene_gene_interaction_claims_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gene_gene_interaction_claims
    ADD CONSTRAINT gene_gene_interaction_claims_pkey PRIMARY KEY (id);


--
-- Name: genes genes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.genes
    ADD CONSTRAINT genes_pkey PRIMARY KEY (id);


--
-- Name: interaction_attributes interaction_attributes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.interaction_attributes
    ADD CONSTRAINT interaction_attributes_pkey PRIMARY KEY (id);


--
-- Name: interaction_attributes_sources interaction_attributes_sources_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.interaction_attributes_sources
    ADD CONSTRAINT interaction_attributes_sources_pkey PRIMARY KEY (interaction_attribute_id, source_id);


--
-- Name: interaction_claim_attributes interaction_claim_attributes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.interaction_claim_attributes
    ADD CONSTRAINT interaction_claim_attributes_pkey PRIMARY KEY (id);


--
-- Name: interaction_claim_links interaction_claim_links_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.interaction_claim_links
    ADD CONSTRAINT interaction_claim_links_pkey PRIMARY KEY (id);


--
-- Name: interaction_claim_types_interaction_claims interaction_claim_types_interaction_claims_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.interaction_claim_types_interaction_claims
    ADD CONSTRAINT interaction_claim_types_interaction_claims_pkey PRIMARY KEY (interaction_claim_type_id, interaction_claim_id);


--
-- Name: interaction_claim_types interaction_claim_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.interaction_claim_types
    ADD CONSTRAINT interaction_claim_types_pkey PRIMARY KEY (id);


--
-- Name: interaction_claims interaction_claims_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.interaction_claims
    ADD CONSTRAINT interaction_claims_pkey PRIMARY KEY (id);


--
-- Name: interaction_claims_publications interaction_claims_publications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.interaction_claims_publications
    ADD CONSTRAINT interaction_claims_publications_pkey PRIMARY KEY (interaction_claim_id, publication_id);


--
-- Name: interaction_types_interactions interaction_types_interactions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.interaction_types_interactions
    ADD CONSTRAINT interaction_types_interactions_pkey PRIMARY KEY (interaction_claim_type_id, interaction_id);


--
-- Name: interactions interactions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.interactions
    ADD CONSTRAINT interactions_pkey PRIMARY KEY (id);


--
-- Name: interactions_publications interactions_publications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.interactions_publications
    ADD CONSTRAINT interactions_publications_pkey PRIMARY KEY (interaction_id, publication_id);


--
-- Name: interactions_sources interactions_sources_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.interactions_sources
    ADD CONSTRAINT interactions_sources_pkey PRIMARY KEY (interaction_id, source_id);


--
-- Name: publications publications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.publications
    ADD CONSTRAINT publications_pkey PRIMARY KEY (id);


--
-- Name: source_trust_levels source_trust_levels_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.source_trust_levels
    ADD CONSTRAINT source_trust_levels_pkey PRIMARY KEY (id);


--
-- Name: source_types source_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.source_types
    ADD CONSTRAINT source_types_pkey PRIMARY KEY (id);


--
-- Name: sources sources_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sources
    ADD CONSTRAINT sources_pkey PRIMARY KEY (id);


--
-- Name: chembl_molecule_synonyms_index_on_clean_synonym; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX chembl_molecule_synonyms_index_on_clean_synonym ON public.chembl_molecule_synonyms USING btree (public.clean((synonym)::text));


--
-- Name: chembl_molecule_synonyms_index_on_upper_alphanumeric_synonym; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX chembl_molecule_synonyms_index_on_upper_alphanumeric_synonym ON public.chembl_molecule_synonyms USING btree (upper(regexp_replace((synonym)::text, '[^\w]+|_'::text, ''::text)));


--
-- Name: chembl_molecule_synonyms_index_on_upper_synonym; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX chembl_molecule_synonyms_index_on_upper_synonym ON public.chembl_molecule_synonyms USING btree (upper((synonym)::text));


--
-- Name: chembl_molecules_index_on_clean_pref_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX chembl_molecules_index_on_clean_pref_name ON public.chembl_molecules USING btree (public.clean((pref_name)::text));


--
-- Name: chembl_molecules_index_on_upper_alphanumeric_pref_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX chembl_molecules_index_on_upper_alphanumeric_pref_name ON public.chembl_molecules USING btree (upper(regexp_replace((pref_name)::text, '[^\w]+|_'::text, ''::text)));


--
-- Name: chembl_molecules_index_on_upper_pref_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX chembl_molecules_index_on_upper_pref_name ON public.chembl_molecules USING btree (upper((pref_name)::text));


--
-- Name: delayed_jobs_priority; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX delayed_jobs_priority ON public.delayed_jobs USING btree (priority, run_at);


--
-- Name: drug_alias_index_on_upper_alphanumeric_alias; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX drug_alias_index_on_upper_alphanumeric_alias ON public.drug_aliases USING btree (upper(regexp_replace(alias, '[^\w]+|_'::text, ''::text)));


--
-- Name: drug_aliases_index_on_clean_alias; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX drug_aliases_index_on_clean_alias ON public.drug_aliases USING btree (public.clean(alias));


--
-- Name: drug_aliases_index_on_upper_alias; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX drug_aliases_index_on_upper_alias ON public.drug_aliases USING btree (upper(alias));


--
-- Name: drug_attributes_index_on_upper_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX drug_attributes_index_on_upper_name ON public.drug_attributes USING btree (upper(name));


--
-- Name: drug_attributes_index_on_upper_value; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX drug_attributes_index_on_upper_value ON public.drug_attributes USING btree (upper(value));


--
-- Name: drug_claim_aliases_drug_claim_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX drug_claim_aliases_drug_claim_id_idx ON public.drug_claim_aliases USING btree (drug_claim_id);


--
-- Name: drug_claim_aliases_full_text; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX drug_claim_aliases_full_text ON public.drug_claim_aliases USING gin (to_tsvector('english'::regconfig, alias));


--
-- Name: drug_claim_aliases_index_on_clean_alias; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX drug_claim_aliases_index_on_clean_alias ON public.drug_claim_aliases USING btree (public.clean(alias));


--
-- Name: drug_claim_attributes_drug_claim_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX drug_claim_attributes_drug_claim_id_idx ON public.drug_claim_attributes USING btree (drug_claim_id);


--
-- Name: drug_claim_types_lower_type_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX drug_claim_types_lower_type_idx ON public.drug_claim_types USING btree (lower((type)::text));


--
-- Name: drug_claims_full_text; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX drug_claims_full_text ON public.drug_claims USING gin (to_tsvector('english'::regconfig, name));


--
-- Name: drug_claims_source_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX drug_claims_source_id_idx ON public.drug_claims USING btree (source_id);


--
-- Name: drugs_full_text; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX drugs_full_text ON public.drugs USING gin (to_tsvector('english'::regconfig, name));


--
-- Name: drugs_index_on_upper_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX drugs_index_on_upper_name ON public.drugs USING btree (upper(name));


--
-- Name: drugs_lower_name_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX drugs_lower_name_idx ON public.drugs USING btree (lower(name));


--
-- Name: gene_aliases_index_on_upper_alias; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gene_aliases_index_on_upper_alias ON public.gene_aliases USING btree (upper(alias));


--
-- Name: gene_claim_aliases_full_text; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gene_claim_aliases_full_text ON public.gene_claim_aliases USING gin (to_tsvector('english'::regconfig, alias));


--
-- Name: gene_claim_aliases_gene_claim_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gene_claim_aliases_gene_claim_id_idx ON public.gene_claim_aliases USING btree (gene_claim_id);


--
-- Name: gene_claim_aliases_lower_alias_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gene_claim_aliases_lower_alias_idx ON public.gene_claim_aliases USING btree (lower(alias));


--
-- Name: gene_claim_attributes_gene_claim_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gene_claim_attributes_gene_claim_id_idx ON public.gene_claim_attributes USING btree (gene_claim_id);


--
-- Name: gene_claim_categories_lower_name_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gene_claim_categories_lower_name_idx ON public.gene_claim_categories USING btree (lower((name)::text));


--
-- Name: gene_claims_full_text; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gene_claims_full_text ON public.gene_claims USING gin (to_tsvector('english'::regconfig, name));


--
-- Name: gene_claims_source_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gene_claims_source_id_idx ON public.gene_claims USING btree (source_id);


--
-- Name: genes_full_text; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX genes_full_text ON public.genes USING gin (to_tsvector('english'::regconfig, name));


--
-- Name: genes_index_on_upper_long_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX genes_index_on_upper_long_name ON public.genes USING btree (upper((long_name)::text));


--
-- Name: genes_index_on_upper_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX genes_index_on_upper_name ON public.genes USING btree (upper(name));


--
-- Name: index_chembl_molecule_synonyms_on_chembl_molecule_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_chembl_molecule_synonyms_on_chembl_molecule_id ON public.chembl_molecule_synonyms USING btree (chembl_molecule_id);


--
-- Name: index_chembl_molecules_on_chembl_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_chembl_molecules_on_chembl_id ON public.chembl_molecules USING btree (chembl_id);


--
-- Name: index_chembl_molecules_on_molregno; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_chembl_molecules_on_molregno ON public.chembl_molecules USING btree (molregno);


--
-- Name: index_drug_alias_blacklists_on_alias; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_drug_alias_blacklists_on_alias ON public.drug_alias_blacklists USING btree (alias);


--
-- Name: index_drug_aliases_on_drug_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_drug_aliases_on_drug_id ON public.drug_aliases USING btree (drug_id);


--
-- Name: index_drug_attributes_on_drug_id_and_name_and_value; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_drug_attributes_on_drug_id_and_name_and_value ON public.drug_attributes USING btree (drug_id, name, value);


--
-- Name: index_drug_claim_attributes_on_drug_claim_id_and_name_and_value; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_drug_claim_attributes_on_drug_claim_id_and_name_and_value ON public.drug_claim_attributes USING btree (drug_claim_id, name, value);


--
-- Name: index_drug_claim_attributes_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_drug_claim_attributes_on_name ON public.drug_claim_attributes USING btree (name);


--
-- Name: index_drug_claim_attributes_on_value; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_drug_claim_attributes_on_value ON public.drug_claim_attributes USING btree (value);


--
-- Name: index_drug_claims_on_name_and_nomenclature_and_source_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_drug_claims_on_name_and_nomenclature_and_source_id ON public.drug_claims USING btree (name, nomenclature, source_id);


--
-- Name: index_drugs_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_drugs_on_name ON public.drugs USING btree (name);


--
-- Name: index_gene_attributes_on_gene_id_and_name_and_value; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_gene_attributes_on_gene_id_and_name_and_value ON public.gene_attributes USING btree (gene_id, name, value);


--
-- Name: index_gene_claim_aliases_on_alias; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_gene_claim_aliases_on_alias ON public.gene_claim_aliases USING btree (alias);


--
-- Name: index_gene_claim_attributes_on_gene_claim_id_and_name_and_value; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_gene_claim_attributes_on_gene_claim_id_and_name_and_value ON public.gene_claim_attributes USING btree (gene_claim_id, name, value);


--
-- Name: index_gene_claim_attributes_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_gene_claim_attributes_on_name ON public.gene_claim_attributes USING btree (name);


--
-- Name: index_gene_claim_attributes_on_value; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_gene_claim_attributes_on_value ON public.gene_claim_attributes USING btree (value);


--
-- Name: index_gene_claims_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_gene_claims_on_name ON public.gene_claims USING btree (name);


--
-- Name: index_gene_claims_on_name_and_nomenclature_and_source_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_gene_claims_on_name_and_nomenclature_and_source_id ON public.gene_claims USING btree (name, nomenclature, source_id);


--
-- Name: index_gene_gene_interaction_claims_on_gene_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_gene_gene_interaction_claims_on_gene_id ON public.gene_gene_interaction_claims USING btree (gene_id);


--
-- Name: index_gene_gene_interaction_claims_on_interacting_gene_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_gene_gene_interaction_claims_on_interacting_gene_id ON public.gene_gene_interaction_claims USING btree (interacting_gene_id);


--
-- Name: index_genes_on_entrez_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_genes_on_entrez_id ON public.genes USING btree (entrez_id);


--
-- Name: index_interactions_on_drug_id_and_gene_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_interactions_on_drug_id_and_gene_id ON public.interactions USING btree (drug_id, gene_id);


--
-- Name: index_publications_on_pmid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_publications_on_pmid ON public.publications USING btree (pmid);


--
-- Name: interaction_claim_attributes_interaction_claim_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX interaction_claim_attributes_interaction_claim_id_idx ON public.interaction_claim_attributes USING btree (interaction_claim_id);


--
-- Name: interaction_claim_types_lower_type_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX interaction_claim_types_lower_type_idx ON public.interaction_claim_types USING btree (lower((type)::text));


--
-- Name: interaction_claims_drug_claim_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX interaction_claims_drug_claim_id_idx ON public.interaction_claims USING btree (drug_claim_id);


--
-- Name: interaction_claims_gene_claim_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX interaction_claims_gene_claim_id_idx ON public.interaction_claims USING btree (gene_claim_id);


--
-- Name: interaction_claims_source_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX interaction_claims_source_id_idx ON public.interaction_claims USING btree (source_id);


--
-- Name: left_and_interacting_gene_interaction_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX left_and_interacting_gene_interaction_index ON public.gene_gene_interaction_claims USING btree (gene_id, interacting_gene_id);


--
-- Name: source_trust_levels_lower_level_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX source_trust_levels_lower_level_idx ON public.source_trust_levels USING btree (lower((level)::text));


--
-- Name: sources_lower_source_db_name_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sources_lower_source_db_name_idx ON public.sources USING btree (lower(source_db_name));


--
-- Name: sources_source_trust_level_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sources_source_trust_level_id_idx ON public.sources USING btree (source_trust_level_id);


--
-- Name: sources_source_type_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sources_source_type_id_idx ON public.sources USING btree (source_type_id);


--
-- Name: unique_drug_claim_aliases; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_drug_claim_aliases ON public.drug_claim_aliases USING btree (drug_claim_id, alias, nomenclature);


--
-- Name: unique_drug_id_alias; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_drug_id_alias ON public.drug_aliases USING btree (drug_id, upper(alias));


--
-- Name: unique_gene_claim_aliases; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_gene_claim_aliases ON public.gene_claim_aliases USING btree (gene_claim_id, alias, nomenclature);


--
-- Name: unique_gene_id_alias; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_gene_id_alias ON public.gene_aliases USING btree (gene_id, upper(alias));


--
-- Name: unique_interaction_attributes; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_interaction_attributes ON public.interaction_attributes USING btree (interaction_id, name, value);


--
-- Name: unique_interaction_claim_attributes; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_interaction_claim_attributes ON public.interaction_claim_attributes USING btree (interaction_claim_id, name, value);


--
-- Name: unique_interaction_claims; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_interaction_claims ON public.interaction_claims USING btree (drug_claim_id, gene_claim_id, source_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_schema_migrations ON public.schema_migrations USING btree (version);


--
-- Name: gene_gene_interaction_claim_attributes fk_attributes_gene_interaction_claim; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gene_gene_interaction_claim_attributes
    ADD CONSTRAINT fk_attributes_gene_interaction_claim FOREIGN KEY (gene_gene_interaction_claim_id) REFERENCES public.gene_gene_interaction_claims(id) MATCH FULL;


--
-- Name: drug_claims fk_drug; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.drug_claims
    ADD CONSTRAINT fk_drug FOREIGN KEY (drug_id) REFERENCES public.drugs(id) MATCH FULL;


--
-- Name: interactions fk_drug; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.interactions
    ADD CONSTRAINT fk_drug FOREIGN KEY (drug_id) REFERENCES public.drugs(id);


--
-- Name: drug_attributes fk_drug; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.drug_attributes
    ADD CONSTRAINT fk_drug FOREIGN KEY (drug_id) REFERENCES public.drugs(id);


--
-- Name: drug_aliases_sources fk_drug_alias; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.drug_aliases_sources
    ADD CONSTRAINT fk_drug_alias FOREIGN KEY (drug_alias_id) REFERENCES public.drug_aliases(id);


--
-- Name: drug_attributes_sources fk_drug_attribute; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.drug_attributes_sources
    ADD CONSTRAINT fk_drug_attribute FOREIGN KEY (drug_attribute_id) REFERENCES public.drug_attributes(id);


--
-- Name: drug_claim_types_drug_claims fk_drug_claim; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.drug_claim_types_drug_claims
    ADD CONSTRAINT fk_drug_claim FOREIGN KEY (drug_claim_id) REFERENCES public.drug_claims(id) MATCH FULL;


--
-- Name: drug_claim_aliases fk_drug_claim_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.drug_claim_aliases
    ADD CONSTRAINT fk_drug_claim_id FOREIGN KEY (drug_claim_id) REFERENCES public.drug_claims(id) MATCH FULL;


--
-- Name: drug_claim_attributes fk_drug_claim_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.drug_claim_attributes
    ADD CONSTRAINT fk_drug_claim_id FOREIGN KEY (drug_claim_id) REFERENCES public.drug_claims(id) MATCH FULL;


--
-- Name: interaction_claims fk_drug_claim_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.interaction_claims
    ADD CONSTRAINT fk_drug_claim_id FOREIGN KEY (drug_claim_id) REFERENCES public.drug_claims(id) MATCH FULL;


--
-- Name: drug_claim_types_drug_claims fk_drug_claim_type; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.drug_claim_types_drug_claims
    ADD CONSTRAINT fk_drug_claim_type FOREIGN KEY (drug_claim_type_id) REFERENCES public.drug_claim_types(id) MATCH FULL;


--
-- Name: gene_claims fk_gene; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gene_claims
    ADD CONSTRAINT fk_gene FOREIGN KEY (gene_id) REFERENCES public.genes(id) MATCH FULL;


--
-- Name: interactions fk_gene; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.interactions
    ADD CONSTRAINT fk_gene FOREIGN KEY (gene_id) REFERENCES public.genes(id);


--
-- Name: gene_aliases fk_gene; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gene_aliases
    ADD CONSTRAINT fk_gene FOREIGN KEY (gene_id) REFERENCES public.genes(id);


--
-- Name: gene_attributes fk_gene; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gene_attributes
    ADD CONSTRAINT fk_gene FOREIGN KEY (gene_id) REFERENCES public.genes(id);


--
-- Name: gene_categories_genes fk_gene; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gene_categories_genes
    ADD CONSTRAINT fk_gene FOREIGN KEY (gene_id) REFERENCES public.genes(id);


--
-- Name: gene_aliases_sources fk_gene_alias; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gene_aliases_sources
    ADD CONSTRAINT fk_gene_alias FOREIGN KEY (gene_alias_id) REFERENCES public.gene_aliases(id);


--
-- Name: gene_attributes_sources fk_gene_attribute; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gene_attributes_sources
    ADD CONSTRAINT fk_gene_attribute FOREIGN KEY (gene_attribute_id) REFERENCES public.gene_attributes(id);


--
-- Name: gene_claim_categories_gene_claims fk_gene_claim; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gene_claim_categories_gene_claims
    ADD CONSTRAINT fk_gene_claim FOREIGN KEY (gene_claim_id) REFERENCES public.gene_claims(id) MATCH FULL;


--
-- Name: gene_claim_categories_gene_claims fk_gene_claim_category; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gene_claim_categories_gene_claims
    ADD CONSTRAINT fk_gene_claim_category FOREIGN KEY (gene_claim_category_id) REFERENCES public.gene_claim_categories(id) MATCH FULL;


--
-- Name: gene_categories_genes fk_gene_claim_category; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gene_categories_genes
    ADD CONSTRAINT fk_gene_claim_category FOREIGN KEY (gene_claim_category_id) REFERENCES public.gene_claim_categories(id);


--
-- Name: gene_claim_aliases fk_gene_claim_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gene_claim_aliases
    ADD CONSTRAINT fk_gene_claim_id FOREIGN KEY (gene_claim_id) REFERENCES public.gene_claims(id) MATCH FULL;


--
-- Name: gene_claim_attributes fk_gene_claim_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gene_claim_attributes
    ADD CONSTRAINT fk_gene_claim_id FOREIGN KEY (gene_claim_id) REFERENCES public.gene_claims(id) MATCH FULL;


--
-- Name: interaction_claims fk_gene_claim_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.interaction_claims
    ADD CONSTRAINT fk_gene_claim_id FOREIGN KEY (gene_claim_id) REFERENCES public.gene_claims(id) MATCH FULL;


--
-- Name: gene_gene_interaction_claims fk_gene_interaction_claims_gene; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gene_gene_interaction_claims
    ADD CONSTRAINT fk_gene_interaction_claims_gene FOREIGN KEY (gene_id) REFERENCES public.genes(id) MATCH FULL;


--
-- Name: gene_gene_interaction_claims fk_gene_interaction_claims_interacting_gene; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gene_gene_interaction_claims
    ADD CONSTRAINT fk_gene_interaction_claims_interacting_gene FOREIGN KEY (interacting_gene_id) REFERENCES public.genes(id) MATCH FULL;


--
-- Name: gene_gene_interaction_claims fk_gene_interaction_claims_sources; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gene_gene_interaction_claims
    ADD CONSTRAINT fk_gene_interaction_claims_sources FOREIGN KEY (source_id) REFERENCES public.sources(id) MATCH FULL;


--
-- Name: interaction_claims fk_interaction; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.interaction_claims
    ADD CONSTRAINT fk_interaction FOREIGN KEY (interaction_id) REFERENCES public.interactions(id);


--
-- Name: interaction_types_interactions fk_interaction; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.interaction_types_interactions
    ADD CONSTRAINT fk_interaction FOREIGN KEY (interaction_id) REFERENCES public.interactions(id);


--
-- Name: interactions_publications fk_interaction; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.interactions_publications
    ADD CONSTRAINT fk_interaction FOREIGN KEY (interaction_id) REFERENCES public.interactions(id);


--
-- Name: interactions_sources fk_interaction; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.interactions_sources
    ADD CONSTRAINT fk_interaction FOREIGN KEY (interaction_id) REFERENCES public.interactions(id);


--
-- Name: interaction_attributes_sources fk_interaction_attribute; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.interaction_attributes_sources
    ADD CONSTRAINT fk_interaction_attribute FOREIGN KEY (interaction_attribute_id) REFERENCES public.interaction_attributes(id);


--
-- Name: interaction_claim_types_interaction_claims fk_interaction_claim; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.interaction_claim_types_interaction_claims
    ADD CONSTRAINT fk_interaction_claim FOREIGN KEY (interaction_claim_id) REFERENCES public.interaction_claims(id) MATCH FULL;


--
-- Name: interaction_claims_publications fk_interaction_claim; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.interaction_claims_publications
    ADD CONSTRAINT fk_interaction_claim FOREIGN KEY (interaction_claim_id) REFERENCES public.interaction_claims(id);


--
-- Name: interaction_claim_attributes fk_interaction_claim_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.interaction_claim_attributes
    ADD CONSTRAINT fk_interaction_claim_id FOREIGN KEY (interaction_claim_id) REFERENCES public.interaction_claims(id) MATCH FULL;


--
-- Name: interaction_claim_types_interaction_claims fk_interaction_claim_type; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.interaction_claim_types_interaction_claims
    ADD CONSTRAINT fk_interaction_claim_type FOREIGN KEY (interaction_claim_type_id) REFERENCES public.interaction_claim_types(id) MATCH FULL;


--
-- Name: interaction_types_interactions fk_interaction_type; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.interaction_types_interactions
    ADD CONSTRAINT fk_interaction_type FOREIGN KEY (interaction_claim_type_id) REFERENCES public.interaction_claim_types(id);


--
-- Name: interactions_publications fk_publication; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.interactions_publications
    ADD CONSTRAINT fk_publication FOREIGN KEY (publication_id) REFERENCES public.publications(id);


--
-- Name: interaction_claims_publications fk_publication; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.interaction_claims_publications
    ADD CONSTRAINT fk_publication FOREIGN KEY (publication_id) REFERENCES public.publications(id);


--
-- Name: interaction_attributes fk_rails_01f96ac9ee; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.interaction_attributes
    ADD CONSTRAINT fk_rails_01f96ac9ee FOREIGN KEY (interaction_id) REFERENCES public.interactions(id) ON DELETE CASCADE;


--
-- Name: drug_aliases fk_rails_4d255ac147; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.drug_aliases
    ADD CONSTRAINT fk_rails_4d255ac147 FOREIGN KEY (drug_id) REFERENCES public.drugs(id) ON DELETE CASCADE;


--
-- Name: interaction_claim_links fk_rails_af235a7f08; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.interaction_claim_links
    ADD CONSTRAINT fk_rails_af235a7f08 FOREIGN KEY (interaction_claim_id) REFERENCES public.interaction_claims(id);


--
-- Name: drugs fk_rails_de0c74dec1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.drugs
    ADD CONSTRAINT fk_rails_de0c74dec1 FOREIGN KEY (chembl_molecule_id) REFERENCES public.chembl_molecules(id);


--
-- Name: drug_aliases_sources fk_source; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.drug_aliases_sources
    ADD CONSTRAINT fk_source FOREIGN KEY (source_id) REFERENCES public.sources(id);


--
-- Name: drug_attributes_sources fk_source; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.drug_attributes_sources
    ADD CONSTRAINT fk_source FOREIGN KEY (source_id) REFERENCES public.sources(id);


--
-- Name: gene_aliases_sources fk_source; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gene_aliases_sources
    ADD CONSTRAINT fk_source FOREIGN KEY (source_id) REFERENCES public.sources(id);


--
-- Name: gene_attributes_sources fk_source; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gene_attributes_sources
    ADD CONSTRAINT fk_source FOREIGN KEY (source_id) REFERENCES public.sources(id);


--
-- Name: interaction_attributes_sources fk_source; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.interaction_attributes_sources
    ADD CONSTRAINT fk_source FOREIGN KEY (source_id) REFERENCES public.sources(id);


--
-- Name: interactions_sources fk_source; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.interactions_sources
    ADD CONSTRAINT fk_source FOREIGN KEY (source_id) REFERENCES public.sources(id);


--
-- Name: drug_claims fk_source_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.drug_claims
    ADD CONSTRAINT fk_source_id FOREIGN KEY (source_id) REFERENCES public.sources(id) MATCH FULL;


--
-- Name: gene_claims fk_source_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gene_claims
    ADD CONSTRAINT fk_source_id FOREIGN KEY (source_id) REFERENCES public.sources(id) MATCH FULL;


--
-- Name: interaction_claims fk_source_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.interaction_claims
    ADD CONSTRAINT fk_source_id FOREIGN KEY (source_id) REFERENCES public.sources(id) MATCH FULL;


--
-- Name: sources fk_source_trust_level; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sources
    ADD CONSTRAINT fk_source_trust_level FOREIGN KEY (source_trust_level_id) REFERENCES public.source_trust_levels(id);


--
-- Name: sources fk_source_type; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sources
    ADD CONSTRAINT fk_source_type FOREIGN KEY (source_type_id) REFERENCES public.source_types(id) MATCH FULL;


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('0'),
('20121212223401'),
('20121213151709'),
('20121214160809'),
('20121214161439'),
('20121214191000'),
('20121218184952'),
('20121218224238'),
('20130103214307'),
('20130214204650'),
('20130305165700'),
('20130307160126'),
('20130424183200'),
('20130712222803'),
('20130712225648'),
('20130906013631'),
('20170216144343'),
('20170216165933'),
('20170217172327'),
('20170217184303'),
('20170222165433'),
('20170302155212'),
('20170303162418'),
('20170314140736'),
('20170314161924'),
('20170315152806'),
('20170317143034'),
('20170317175150'),
('20170414213904'),
('20170417192246'),
('20170417192258'),
('20170424175208'),
('20170503192632'),
('20170512141234'),
('20170512150855'),
('20170605204001'),
('20170616211809'),
('20170619174047'),
('20170619191811'),
('20170619204652'),
('20170619205542'),
('20170622142108'),
('20170628044755'),
('20170629024912'),
('20170630203634'),
('20170705222429'),
('20170706215825'),
('20170727025111'),
('20170727192237'),
('20170728015708'),
('20170728023124'),
('20170729004221'),
('20170808210937'),
('20170824182356'),
('20170913042301'),
('20170913202927'),
('20170914145053'),
('20191016180948'),
('20191107152512'),
('20200608185423'),
('20200615173440');


