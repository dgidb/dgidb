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
            citation: 'Tate,J.G., Bamford,S., Jubb,H.C., Sondka,Z., Beare,D.M., Bindal,N., Boutselakis,H., Cole,C.G., Creatore,C., Dawson,E., et al. (2019) COSMIC: the Catalogue Of Somatic Mutations In Cancer. Nucleic Acids Res., 47, D941–D947. PMID: 30371878',
            source_db_version:  '4-Sep-2020',
            source_db_name: 'COSMIC',
            full_name: 'Catalogue Of Somatic Mutations In Cancer',
            license: 'Free for academic use',
            license_link: 'https://cancer.sanger.ac.uk/cosmic/license',
        }
      )
      @source.source_types << DataModel::SourceType.find_by(type: 'interaction')
      @source.source_types << DataModel::SourceType.find_by(type: 'potentially_druggable')
      @source.save
    end

    def create_interaction_claims
      CSV.foreach(file_path, :headers => true, :col_sep => ",") do |row|
        drug_claim = create_drug_claim(row['Drug'], row['Drug'], 'COSMIC Drug Name')

        row['Genes'].split(', ').each do |gene|
          next if gene.blank?
          gene_name, rest = gene.split('_ENST')
          gene_claim = create_gene_claim(gene_name, 'Gene Symbol')
          create_gene_claim_category(gene_claim, 'DRUG RESISTANCE')
          interaction_claim = create_interaction_claim(gene_claim, drug_claim)
          gene_link, rest = gene.split('(GRC')
          gene_link = gene_link.strip
          create_interaction_claim_link(interaction_claim, "COSMIC #{gene_link} Gene Page", "https://cancer.sanger.ac.uk/cosmic/gene/analysis?ln=#{gene_link}#drug-resistance")
        end
      end
    end
  end
end; end; end;
