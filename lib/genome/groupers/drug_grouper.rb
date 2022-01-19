require 'net/https'
require "erb"
require 'json'
include ERB::Util

module Genome
  module Groupers
    class DrugGrouper
      attr_reader :term_to_matches_dict, :term_to_record_dict, :valid_chembl_ids, :invalid_chembl_ids, :chembl_source, :wikidata_source
      def initialize
        @term_to_matches_dict = {}
        @term_to_record_dict = {}
        @chembl_source = DataModel::Source.where(
          source_db_name: 'ChemblDrugs',
          source_db_version: 'ChEMBL_27',
          base_url: 'https://www.ebi.ac.uk/chembldb/index.php/target/inspect/',
          site_url: 'https://www.ebi.ac.uk/chembl',
          citation: "Mendez,D., Gaulton,A., Bento,A.P., Chambers,J., De Veij,M., Félix,E., Magariños,M.P., Mosquera,J.F., Mutowo,P., Nowotka,M., et al. (2019) ChEMBL: towards direct deposition of bioassay data. Nucleic Acids Res., 47, D930–D940. PMID: 30398643",
          source_trust_level_id: DataModel::SourceTrustLevel.EXPERT_CURATED,
          full_name: 'The ChEMBL Bioactivity Database',
          license: 'Creative Commons Attribution-Share Alike 3.0 Unported License',
          license_link: 'https://chembl.gitbook.io/chembl-interface-documentation/about',
        ).first_or_create
        drug_source_type = DataModel::SourceType.find_by(type: 'drug')
        unless @chembl_source.source_types.include? drug_source_type
          @chembl_source.source_types << drug_source_type
          @chembl_source.save
        end
        @wikidata_source = DataModel::Source.where(
          source_db_name: 'Wikidata',
          source_db_version: '12-August-2020',
          base_url: 'https://www.wikidata.org/wiki/',
          site_url: 'https://www.wikidata.org/',
          citation: "Denny Vrandečić and Markus Krötzsch. 2014. Wikidata: a free collaborative knowledgebase. Commun. ACM 57, 10 (October 2014), 78–85. DOI:https://doi.org/10.1145/2629489",
          full_name: 'Wikidata',
          license: 'Creative Commons Attribution-ShareAlike License',
          license_link: 'https://foundation.wikimedia.org/wiki/Terms_of_Use/en#7._Licensing_of_Content',
        ).first_or_create
        unless @wikidata_source.source_types.include? drug_source_type
          @wikidata_source.source_types << drug_source_type
          @wikidata_source.save
        end
      end

      def run(source_id: nil)
        claims = DataModel::DrugClaim.eager_load(:drug_claim_aliases, :drug_claim_attributes).where(drug_id: nil)
        unless source_id.nil?
          claims = claims.where(source_id: source_id)
        end
        claims.each do |drug_claim|
          record = find_normalized_record_for_term(drug_claim.primary_name)
          if record.nil?
            record = find_normalized_record_for_term(drug_claim.name)
            if record.nil?
              record = query_drug_claim_aliases(drug_claim.drug_claim_aliases)
            end
          end

          unless record.nil?
            if record.is_a?(DataModel::Drug)
              drug = record
            else
              if record['label'].nil?
                claim_label = record['concept_identifier']
                drug_label = record['concept_identifier'].gsub('chembl:', '')
              else
                claim_label = record['label']
                drug_label = record['label'].upcase
              end
              drug = DataModel::Drug.where(concept_id: record['concept_identifier'], name: drug_label).first_or_create
              if record['concept_identifier'].start_with?('chembl:')
                c = Genome::OnlineUpdater.new.create_drug_claim(record['concept_identifier'], claim_label, 'ChEMBL ID', source=chembl_source)
                c.drug_id = drug.id
                c.save
              elsif record['concept_identifier'].start_with?('wikidata:')
                c = Genome::OnlineUpdater.new.create_drug_claim(record['concept_identifier'], claim_label, 'Wikidata ID', source=wikidata_source)
                c.drug_id = drug.id
                c.save
              end
              record['aliases'].each do |a|
                if a.start_with? 'chembl:'
                  if valid_chembl_id?(a)
                    DataModel::DrugAlias.where(alias: a.upcase, drug_id: drug.id).first_or_create
                  end
                else
                  DataModel::DrugAlias.where(alias: a.upcase, drug_id: drug.id).first_or_create
                end
              end
              if record['withdrawn'] == false && record['max_phase'] == 4
                drug.approved = true
              end
              record['other_identifiers'].each do |i|
                if i.start_with? 'chembl:'
                  if valid_chembl_id?(i)
                    DataModel::DrugAlias.where(alias: i, drug_id: drug.id).first_or_create
                  end
                else
                  DataModel::DrugAlias.where(alias: i, drug_id: drug.id).first_or_create
                end
              end
            end
            drug_claim.drug_id = drug.id
            add_drug_claim_attributes_to_drug(drug_claim, drug)
            drug.save
            drug_claim.save
          end
        end
        Utils::Database.destroy_empty_groups
        Utils::Database.destroy_unsourced_attributes
        Utils::Database.destroy_unsourced_aliases
      end

      def query_drug_claim_aliases(drug_claim_aliases)
        record = nil
        drug_claim_aliases.each do |a|
          normalized_record = find_normalized_record_for_term(a.alias)
          unless normalized_record.nil?
            if record.nil?
              record = normalized_record
            else
              if record.is_a?(Hash) && normalized_record.is_a?(Hash)
                if record['concept_identifier'] != normalized_record['concept_identifier']
                  return nil
                end
              elsif record.is_a?(DataModel::Drug) && normalized_record.is_a?(DataModel::Drug)
                if record.id != normalized_record.id
                  return nil
                end
              else
                return nil
              end
            end
          end
        end
        return record
      end

      def add_drug_claim_attributes_to_drug(drug_claim, drug)
        drug_attributes = drug.drug_attributes.pluck(:name, :value)
                              .map { |drug_attribute| drug_attribute.map(&:upcase) }
                              .to_set
        drug_claim.drug_claim_attributes.each do |drug_claim_attribute|
          unless drug_attributes.member? [drug_claim_attribute.name.upcase, drug_claim_attribute.value.upcase]
            drug_attribute = DataModel::DrugAttribute.create(name: drug_claim_attribute.name,
                                                             value: drug_claim_attribute.value,
                                                             drug: drug
            )
            drug_attribute.sources << drug_claim.source
          else
            drug_attribute = DataModel::DrugAttribute.where('upper(name) = ? and upper(value) = ?',
                                                            drug_claim_attribute.name.upcase,
                                                            drug_claim_attribute.value.upcase
            ).first
            if drug_attribute.nil? # this can occur when a character (e.g. α) is treated differently by upper and upcase
              drug_attribute = DataModel::DrugAttribute.where('lower(name) = ? and lower(value) = ?',
                                                              drug_claim_attribute.name.downcase,
                                                              drug_claim_attribute.value.downcase
              ).first
            end
            unless drug_attribute.sources.member? drug_claim.source
              drug_attribute.sources << drug_claim.source
            end
          end
        end
      end

      def find_normalized_record_for_term(term)
        term = term.upcase
        if term_to_record_dict.has_key? term
          return term_to_record_dict[term]
        end
        normalized_record = normalizer_matches_for_term(term)
        term_to_record_dict[term] = normalized_record
        return normalized_record
      end

      def normalizer_matches_for_term(term)
        if term_to_matches_dict.has_key? term
          return term_to_matches_dict[term]
        end
        uri = URI.parse(normalizer_url).tap do |u|
          u.query = URI.encode_www_form( { q: ERB::Util.url_encode(term) } )
        end
        res = Net::HTTP.get_response(uri)
        if res.code != '200'
          raise StandardError.new("Request Failed!")
        end
        resp = JSON.parse(res.body)['therapy_descriptor']
        term_to_matches_dict[term] = resp
        return resp
      end

      def normalizer_url
        "https://normalize.cancervariants.org/therapy/normalize"
      end

    end
  end
end
