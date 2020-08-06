require 'genome/online_updater'

module Genome; module OnlineUpdaters; module Docm
  class Updater < Genome::OnlineUpdater
    attr_reader :new_version
    def initialize(source_db_version = Date.today.strftime("%d-%B-%Y"))
      @new_version = source_db_version
    end

    def update
      remove_existing_source
      create_new_source
      create_interaction_claims
    end

    private
    def create_interaction_claims
      api_client = ApiClient.new
      api_client.variants.each do |variant|
        interaction_information = parse_interaction_information(variant)
        interaction_information.each do |interaction_info|
          gc = create_gene_claim(variant['gene'], 'DoCM Entrez Gene Symbol')
          dc = create_drug_claim(interaction_info['Therapeutic Context'].upcase,
                                 interaction_info['Therapeutic Context'].upcase,
                                 'DoCM Drug Name')
          ic = create_interaction_claim(gc, dc)
          create_interaction_claim_attributes(ic, interaction_info)
          create_interaction_claim_publications(ic, variant['diseases'])
          create_interaction_claim_link(ic, "DoCM Website", 'http://docm.info')
        end
      end
    end

    def parse_interaction_information(variant)
      return [] unless variant.include?('meta')
      drug_data = variant['meta'].find { |table| table.include?('Drug Interaction Data') }
      return [] unless drug_data.present?
      fields = drug_data['Drug Interaction Data']['fields']
      rows = drug_data['Drug Interaction Data']['rows']
      Set.new.tap do |interaction_information|
        rows.each do |row|
          row_hash = {}
          fields.zip(row).each do |name, value|
            row_hash[name] = value
          end
          row_hash['Therapeutic Context'].split(/,|\+|plus/).each do |drug|
            info = row_hash.dup
            info['Therapeutic Context'] = drug
            if valid_drug?(drug)
              interaction_information.add(info)
            end
          end
        end
      end
    end

    def valid_drug?(drug_name)
      ['inhib', 'HER3', 'TKI', 'anti', 'BRAF', 'radio', 'BH3'].none? { |name| drug_name.include?(name) }
    end

    def create_interaction_claim_attributes(interaction_claim, interaction_info)
      {
        'Clinical Status' => 'Status',
        'Pathway' => 'Pathway',
        'Variant Effect' => 'Effect',
      }.each do |name, interaction_info_key|
        create_interaction_claim_attribute(interaction_claim, name, interaction_info[interaction_info_key])
      end
    end

    def create_interaction_claim_publications(interaction_claim, diseases)
      diseases.each do |disease|
        create_interaction_claim_publication(interaction_claim, disease['source_pubmed_id'])
      end
    end

    def remove_existing_source
      Utils::Database.delete_source('DoCM')
    end

    def create_new_source
      @source ||= DataModel::Source.create(
        {
            base_url: 'http://docm.genome.wustl.edu/',
            citation: 'DoCM: a database of curated mutations in cancer. Ainscough BJ, Griffith M, Coffman AC, Wagner AH, Kunisaki J, Choudhary MN, McMichael JF, Fulton RS, Wilson RK, Griffith OL, Mardis ER. Nat Methods. 2016;13(10):806-7. PMID: 27684579',
            source_db_version: new_version,
            source_type_id: DataModel::SourceType.INTERACTION,
            source_trust_level_id: DataModel::SourceTrustLevel.EXPERT_CURATED,
            source_db_name: 'DoCM',
            full_name: 'Database of Curated Mutations',
            license: 'Creative Commons Attribution 4.0 International License',
            license_url: 'http://www.docm.info/about',
        }
      )
    end
  end
end; end; end
