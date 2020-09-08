require 'genome/online_updater'

module Genome; module Importers; module Cosmic;
  class Cosmic < Genome::OnlineUpdater
    attr_reader :file_path, :source

    def initialize(file_path)
      @file_path = file_path
    end

    def import
      remove_existing_source
      create_new_source
      create_interaction_claims
    end

    private
    def remove_existing_source
      Utils::Database.delete_source('COSMIC')
    end

    def create_new_source
      @source ||= DataModel::Source.create(
        {
            base_url: 'https://cancer.sanger.ac.uk/cosmic/drug_resistance',
            site_url: 'https://cancer.sanger.ac.uk/cosmic',
            citation: 'Forbes SA, Bhamra G, Bamford S, et al. The Catalogue of Somatic Mutations in Cancer (COSMIC). Curr Protoc Hum Genet. 2008;Chapter 10:Unit-10.11. doi:10.1002/0471142905.hg1011s57. PMID: 18428421',
            source_db_version:  '4-Sep-2020',
            source_type_id: DataModel::SourceType.INTERACTION,
            source_db_name: 'COSMIC',
            full_name: 'Catalogue Of Somatic Mutations In Cancer',
            license: 'Free for academic use',
            license_link: 'https://cancer.sanger.ac.uk/cosmic/license',
        }
      )
    end

    def create_interaction_claims
      CSV.foreach(file_path, :headers => true, :col_sep => ",") do |row|
        drug_claim = create_drug_claim(row['Drug'], row['Drug'], 'COSMIC Drug Name')

        row['Genes'].split(', ').each do |gene|
          next if gene.blank?
          gene_name, rest = gene.split('_ENST')
          gene_claim = create_gene_claim(gene_name, 'Gene Symbol')
          interaction_claim = create_interaction_claim(gene_claim, drug_claim)
          gene_link, rest = gene.split('(GRC')
          gene_link = gene_link.strip
          create_interaction_claim_link(interaction_claim, "COSMIC #{gene_link} Gene Page", "https://cancer.sanger.ac.uk/cosmic/gene/analysis?ln=#{gene_link}#drug-resistance")
        end
      end
    end
  end
end; end; end;
