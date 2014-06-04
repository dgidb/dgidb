module Genome
  module Normalizers
    class SourceTrustLevel

      def self.trust_levels
        ['Expert curated', 'Non-curated']
      end

      def self.trust_level_map
      {
        'Expert curated' =>
          [
            'MyCancerGenome',
            'MyCancerGenomeClinicalTrial',
            'TALC',
            'TEND',
            'dGene',
            'RussLampel',
            'HopkinsGroom',
            'CancerCommons',
            'ClearityFoundationBiomarker',
            'ClearityFoundationClinical',
            'Entrez',
          ],
        'Non-curated' =>
          [
            'PharmGKB',
            'TTD',
            'DrugBank',
            'GO',
            'Ensembl',
            'PubChem',
          ]
      }
      end

      def self.save_trust_levels
        source_map = {}
        trust_levels.each do |level|
          existing_trust_level = DataModel::SourceTrustLevel.where(level: level).first
          source_map[level] = existing_trust_level || DataModel::SourceTrustLevel.new.tap do |s|
            s.level = level
            s.id = SecureRandom.uuid
            s.save
          end
        end
        source_map
      end

      def self.assign_trust_levels(source_map)
        trust_level_map.each do |trust_level, sources|
          DataModel::Source.where(source_db_name: sources).each do |source|
            source.source_trust_level = source_map[trust_level]
            source.save
          end
        end
      end

      def self.populate_trust_levels
        ActiveRecord::Base.transaction do
          source_map = save_trust_levels
          assign_trust_levels(source_map)
        end
      end
    end
  end
end
