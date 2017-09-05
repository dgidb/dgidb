require 'genome/online_updater'

module Genome; module OnlineUpdaters; module Go;
  class Updater < Genome::OnlineUpdater
    attr_reader :new_version
    def initialize(source_db_version = Date.today.strftime("%d-%B-%Y"))
      @new_version = source_db_version
    end

    def update
      remove_existing_source
      create_new_source
      create_gene_claims
    end

    private
    def remove_existing_source
      Utils::Database.delete_source('GO')
    end

    def create_new_source
      @source ||= DataModel::Source.create(
        {
          base_url:           'http://golr.geneontology.org/select?defType=edismax&qt=standard&indent=on&wt=csv&rows=100000&start=0&fl=bioentity_label,bioentity,source,synonym&facet=true&facet.mincount=1&facet.sort=count&json.nl=arrarr&facet.limit=25&hl=true&hl.simple.pre=%3Cem%20class=%22hilite%22%3E&csv.encapsulator=&csv.separator=%09&csv.header=false&csv.mv.separator=%7C&fq=document_category:%22bioentity%22&fq=taxon_subset_closure_label:%22Homo%20sapiens%22&facet.field=source&facet.field=taxon_subset_closure_label&facet.field=type&facet.field=panther_family_label&facet.field=annotation_class_list_label&facet.field=regulates_closure_label&q=GO:#{id}&qf=bioentity%5E2&qf=bioentity_label_searchable%5E2&qf=bioentity_name_searchable%5E1&qf=bioentity_internal_id%5E1&qf=synonym%5E1&qf=isa_partof_closure_label_searchable%5E1&qf=regulates_closure%5E1&qf=regulates_closure_label_searchable%5E1&qf=panther_family_searchable%5E1&qf=panther_family_label_searchable%5E1&qf=taxon_label_searchable%5E',
          site_url:           'http://www.geneontology.org/',
          citation:           'Gene ontology: tool for the unification of biology. The unification of biology. The Gene Ontology Consortium. Ashburner M, Ball CA, ..., Rubin GM, Sherlock G. Nat Genet. 2000 May;25(1):25-9. PMID: 10802651.',
          source_db_version:  @new_version,
          source_type_id:     DataModel::SourceType.POTENTIALLY_DRUGGABLE,
          source_db_name:     'GO',
          full_name:          'The Gene Ontology',
        }
      )
    end

    def create_gene_claims
      api_client = ApiClient.new
      categories.each do |category, go_id|
        api_client.genes_for_go_id(go_id).each do |gene|
          gene_claim = create_gene_claim(gene['gene_name'], 'Gene Symbol')
          id = gene['id'].gsub("#{gene['nomenclature']}:", "")
          nomenclature = "#{gene['nomenclature']} ID"
          create_gene_claim_alias(gene_claim, id, nomenclature)
          unless gene['synonyms'].nil?
            gene['synonyms'].split('|').each do |synonym|
              create_gene_claim_alias(gene_claim, synonym, 'GO Gene Synonym')
            end
          end
          gene_category = DataModel::GeneClaimCategory.where(name: category).first
          gene_claim.gene_claim_categories << gene_category unless gene_claim.gene_claim_categories.include? gene_category
        end
      end
    end

    def categories
      {
        "KINASE" => "0016301",
        "TYROSINE KINASE" => "0004713",
        "SERINE THREONINE KINASE" => "0004674",
        "PROTEIN PHOSPHATASE" => "0004721",
        "G PROTEIN COUPLED RECEPTOR" => "0004930",
        "NEUTRAL ZINC METALLOPEPTIDASE" => "0008237",
        "ABC TRANSPORTER" => "0042626",
        "RNA DIRECTED DNA POLYMERASE" => "0003964",
        "TRANSPORTER" => "0005215",
        "ION CHANNEL" => "0005216",
        "NUCLEAR HORMONE RECEPTOR" => "0004879",
        "LIPID KINASE" => "0001727",
        "PHOSPHOLIPASE" => "0004620",
        "PROTEASE INHIBITOR" => "0030414",
        "DNA REPAIR" => "0006281",
        "CELL SURFACE" => "0009986",
        "EXTERNAL SIDE OF PLASMA MEMBRANE" => "0009897",
        "GROWTH FACTOR" => "0008083",
        "HORMONE ACTIVITY" => "0005179",
        "TUMOR SUPPRESSOR" => "0051726",
        "TRANSCRIPTION FACTOR BINDING" => "0008134",
        "TRANSCRIPTION FACTOR COMPLEX" => "0005667",
        "HISTONE MODIFICATION" => "0016570",
        "DRUG METABOLISM" => "0017144",
        "DRUG RESISTANCE" => "0042493",
        "PROTEASE" => "0008233",
      }
    end
  end
end; end; end;
