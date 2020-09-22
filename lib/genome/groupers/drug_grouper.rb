require 'net/https'

module Genome
  module Groupers
    class DrugGrouper
      attr_reader :term_to_matches_dict, :term_to_record_dict, :valid_chembl_ids, :invalid_chembl_ids, :chembl_source, :wikidata_source
      def initialize
        @term_to_matches_dict = {}
        @term_to_record_dict = {}
        @valid_chembl_ids = []
        @invalid_chembl_ids = []
        @chembl_source = DataModel::Source.where(
          source_db_name: 'ChemblDrugs',
          source_db_version: 'ChEMBL_27',
          base_url: 'https://www.ebi.ac.uk/chembldb/index.php/target/inspect/',
          site_url: 'https://www.ebi.ac.uk/chembl',
          citation: "The ChEMBL bioactivity database: an update. Bento AP, Gaulton A, Hersey A, Bellis LJ, Chambers J, Davies M, Kruger FA, Light Y, Mak L, McGlinchey S, Nowotka M, Papadatos G, Santos R, Overington JP. Nucleic Acids Res. 42(Database issue):D1083-90. PubMed ID: 24214965",
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
                drug_label = record['concept_identifier']
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
        matches = normalizer_matches_for_term(term)
        normalized_record = get_normalized_record_from_matches(matches)
        term_to_record_dict[term] = normalized_record
        return normalized_record
      end

      def normalizer_matches_for_term(term)
        if term.start_with? 'chembl:'
          term = term.gsub('chembl:', '')
        end
        if term_to_matches_dict.has_key? term
          return term_to_matches_dict[term]
        end
        uri = URI.parse(normalizer_url).tap do |u|
          u.query = URI.encode_www_form( { q: ERB::Util.url_encode(term) } )
          u.port = 8000
        end
        res = Net::HTTP.get_response(uri)
        if res.code != '200'
          raise StandardError.new("Request Failed!")
        end
        resp = JSON.parse(res.body)['normalizer_matches']
        term_to_matches_dict[term] = resp
        return resp
      end

      def normalizer_url
        "http://127.0.0.1/search"
      end

      def get_normalized_record_from_matches(matches)
        if matches['ChEMBL']['match_type'] >=80
          return get_normalized_record_for_chembl_match(matches['ChEMBL'])
        end

        other_matches = matches.select{|t, m| m['match_type'] > 0}
        if other_matches.size > 0
          best_match_type = other_matches.map{|t, m| m['match_type']}.max
          best_matches = other_matches.select{|t, m| m['match_type'] == best_match_type}
          return get_normalized_record_for_multi_matches(best_matches)
        end

        return nil
      end

      def get_normalized_record_for_chembl_match(chembl_match)
        records = chembl_match['records']
        if records.size == 1
          return get_normalized_record_or_drug_for_chembl_id(records.first['concept_identifier'])
        else
          chembl_ids = records.map{|r| r['concept_identifier']}.uniq
          if chembl_ids.size == 1
            return get_normalized_record_or_drug_for_chembl_id(chembl_ids.first)
          else
            records_with_highest_max_phase = select_records_with_highest_max_phase(records)
            if records_with_highest_max_phase.size == 1
              return get_normalized_record_or_drug_for_chembl_id(records_with_highest_max_phase.first['concept_identifier'])
            else
              records_with_trade_name = records_with_highest_max_phase.select{|r| !r['trade_name'].nil?}
              if records_with_trade_name.size == 1
                return get_normalized_record_or_drug_for_chembl_id(records_with_trade_name.first['concept_identifier'])
              elsif records_with_trade_name.size == 0
                return get_normalized_record_or_drug_for_chembl_id(get_min_chembl_id(chembl_ids_for_records(records_with_highest_max_phase)))
              else
                return get_normalized_record_or_drug_for_chembl_id(get_min_chembl_id(chembl_ids_for_records(records_with_trade_name)))
              end
            end
          end
        end
      end

      def get_normalized_record_or_drug_for_chembl_id(chembl_id)
        drug = DataModel::Drug.find_by(concept_id: chembl_id)
        if drug.nil?
          return get_normalized_record_for_chembl_id(chembl_id)
        else
          return drug
        end
      end

      def get_normalized_record_for_chembl_id(chembl_id)
        if term_to_record_dict.has_key? chembl_id
          return term_to_record_dict[chembl_id]
        end
        matches = normalizer_matches_for_term(chembl_id)
        good_matches = matches.select{|t, m| m['match_type'] >= 80}
        if good_matches.has_key? 'ChEMBL'
          best_match = good_matches['ChEMBL']
          best_record = best_match['records'].first
          best_match['records'][1..-1] do |r|
            best_record['aliases'].concat(r['aliases'])
            best_record['other_identifiers'].concat(r['other_identifiers'])
          end
          good_matches.delete('ChEMBL')
          good_matches.each do |t, m|
            m['records'].each do |r|
              best_record['aliases'].concat(r['aliases'])
              best_record['other_identifiers'].concat(r['other_identifiers'])
            end
          end
          term_to_record_dict[best_record['concept_identifier']] = best_record
          return best_record
        else
          return nil
        end
      end

      def get_normalized_record_for_multi_matches(matches)
        #2. a.
        matches_with_chembl_id = matches.select{|t, m| chembl_ids_for_records(m['records']).size > 0}
        if matches_with_chembl_id.size == 0
          matches_with_chembl_id = matches
        end

        #2. b.
        highest_priority_normalizer, highest_priority_match = select_match_with_highest_priority(matches_with_chembl_id)
        #2. b. i.
        if highest_priority_normalizer == 'ChEMBL'
          return get_normalized_record_for_chembl_match(highest_priority_match)
        else
          #2. b. ii.
          if highest_priority_match['records'].size == 1
            chembl_ids = chembl_ids_for_records(highest_priority_match['records'])
            #2. b. ii. 1.
            if chembl_ids.size == 1
              return get_normalized_record_or_drug_for_chembl_id(chembl_ids.first)
            #2. b. ii. 2.
            elsif chembl_ids.size == 0
              return highest_priority_match['records'].first
            else
              #this shouldn't happen (record has conflicting chembl ids)
            end
          #2. b. iii.
          elsif highest_priority_match['records'].size > 1
            chembl_ids = chembl_ids_for_records(highest_priority_match['records'])

            #2. b. iii. 1. a 
            if chembl_ids.size == 1
              return get_normalized_record_or_drug_for_chembl_id(chembl_ids.first)
            #2. b. iii. 1. b.
            elsif chembl_ids.size > 1
              normalized_records = chembl_ids.each_with_object([]) do |chembl_id, a|
                a << get_normalized_record_for_chembl_id(chembl_id)
              end
              records_with_highest_max_phase = select_records_with_highest_max_phase(normalized_records)
              if records_with_highest_max_phase.size == 1
                return records_with_highest_max_phase.first
              else
                if highest_priority_match['match_type'] >= 40
                  records_with_trade_name = records_with_highest_max_phase.select{|r| !r['trade_name'].nil?}
                  if records_with_trade_name.size == 1
                    return records_with_trade_name.first
                  elsif records_with_trade_name.size == 0
                    return get_normalized_record_or_drug_for_chembl_id(get_min_chembl_id(chembl_ids_for_records(records_with_highest_max_phase)))
                  else
                    return get_normalized_record_or_drug_for_chembl_id(get_min_chembl_id(chembl_ids_for_records(records_with_trade_name)))
                  end
                else
                  return nil
                end
              end
            else
              #2. b. iii. 2.
              return nil
            end
          else
            #this shouldn't happen (normalizer has no records)
          end
        end
      end

      def valid_chembl_id?(chembl_id)
        if chembl_id.start_with? 'chembl:'
          chembl_id = chembl_id.gsub('chembl:', '')
        end
        if valid_chembl_ids.include? chembl_id
          return true
        end
        if invalid_chembl_ids.include? chembl_id
          return false
        end
        matches = normalizer_matches_for_term(chembl_id)
        if matches['ChEMBL']['match_type'] == 100
          valid_chembl_ids << chembl_id
          return true
        else
          invalid_chembl_ids << chembl_id
          return false
        end
      end

      def select_records_with_highest_max_phase(records)
        highest_max_phase = records.sort_by{|r| r['max_phase']}.reverse.first['max_phase']
        return records.select{|r| r['max_phase'] == highest_max_phase}
      end

      def get_min_chembl_id(chembl_ids)
        min_chembl_id = chembl_ids.map{|i| i.gsub('chembl:CHEMBL', '').to_i}.min
        return chembl_ids.select{|i| i == "chembl:CHEMBL#{min_chembl_id}"}.first
      end

      def select_match_with_highest_priority(matches)
        priority.each do |p|
          if matches.keys.include? p
            return p, matches[p]
          end
        end
      end

      def priority
        return ['ChEMBL', 'Wikidata']
      end

      def chembl_ids_for_records(records)
        chembl_ids = records.each_with_object([]) do |r, ids|
          if r['concept_identifier'].start_with?('chembl:') && valid_chembl_id?(r['concept_identifier'])
            ids << r['concept_identifier']
          end
          r['other_identifiers'].each do |i|
            if i.start_with?('chembl:') && valid_chembl_id?(i)
              ids << i
            end
          end
        end
        return chembl_ids.uniq
      end
    end
  end
end
