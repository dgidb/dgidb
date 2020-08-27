require 'genome/online_updater'

module Genome; module Importers; module HumanProteinAtlas;
  class HumanProteinAtlas < Genome::OnlineUpdater
    attr_reader :file_path, :source

    def initialize(file_path)
      @file_path = file_path
    end

    def import
      remove_existing_source
      create_new_source
      create_gene_claims
    end

    private
    def remove_existing_source
      Utils::Database.delete_source('HPA')
    end

    def create_new_source
      @source ||= DataModel::Source.create(
        {
            base_url: 'https://www.proteinatlas.org/search/protein_class%3APotential+drug+targets',
            site_url: 'https://www.proteinatlas.org/',
            citation: 'Uhlén M, Fagerberg L, Hallström BM, et al. Proteomics. Tissue-based map of the human proteome. Science. 2015;347(6220):1260419. doi:10.1126/science.1260419. PMID: 25613900',
            source_db_version:  '19.3',
            source_type_id: DataModel::SourceType.POTENTIALLY_DRUGGABLE,
            source_db_name: 'HPA',
            full_name: 'The Human Protein Atlas',
            license: 'Creative Commons Attribution-ShareAlike 3.0 International License',
            license_link: 'https://www.proteinatlas.org/about/licence',
        }
      )
    end

    def create_gene_claims
      CSV.foreach(file_path, :headers => true, :col_sep => "\t") do |row|
        gene_claim = create_gene_claim(row["Gene"], 'Gene Symbol')
        create_gene_claim_alias(gene_claim, row["Ensembl"], 'Ensembl Gene ID')
        unless row['Gene synonym'].nil?
          row['Gene synonym'].split(', ').each do |s|
            create_gene_claim_alias(gene_claim, s, 'Human Protein Atlas Gene Synonym')
          end
        end
        create_gene_claim_alias(gene_claim, row['Gene description'], 'Human Protein Atlas Gene Description')
        create_gene_claim_alias(gene_claim, row['Uniprot'], 'UniProt ID')

        row['Protein class'].split(', ').each do |c|
          if categories.has_key? c
            gene_category = DataModel::GeneClaimCategory.find_by(name: categories[c])
            gene_claim.gene_claim_categories << gene_category unless gene_claim.gene_claim_categories.include? gene_category
          end
        end
      end
    end

    def categories
      {
        'Enzymes' => 'ENZYME',
        'Transporters' => 'TRANSPORTER',
        'G-protein coupled receptors' => 'G PROTEIN COUPLED RECEPTOR',
        'CD markers' => 'CELL SURFACE',
        'Voltage-gated ion channels' => 'ION CHANNEL',
        'Nuclear receptors' => 'NUCLEAR HORMONE RECEPTOR',
      }
    end
  end
end; end; end;
