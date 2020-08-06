module Genome
  module Importers
    module TdgClinicalTrial
      
      def self.source_info
        {
          base_url:          'https://clinicaltrials.gov/ct2/results?Search=Search&term=',
          site_url:          'http://www.ncbi.nlm.nih.gov/pubmed/24016212',
          citation:          "The druggable genome: Evaluation of drug targets in clinical trials suggests major shifts in molecular class and indication. Rask-Andersen M, Masuram S, Schioth HB. Annu Rev Pharmacol Toxicol. 2014;54:9-26. doi: 10.1146/annurev-pharmtox-011613-135943. PMID: 24016212",
          source_db_version:  'Jan-2014',
          source_type_id:    DataModel::SourceType.INTERACTION,
          source_db_name:    'TdgClinicalTrial',
          full_name:         'The Druggable Genome: Evaluation of Drug Targets in Clinical Trials Suggests Major Shifts in Molecular Class and Indication (Rask-Andersen, Masuram, Schioth 2014)',
          license: 'Supplementary table from Annual Reviews copyright publication',
          license_link: 'https://www.annualreviews.org/doi/10.1146/annurev-pharmtox-011613-135943?url_ver=Z39.88-2003&rfr_id=ori%3Arid%3Acrossref.org&rfr_dat=cr_pub++0pubmed',
        }
      end

      def self.run(tsv_path)
        blank_filter = ->(x) { x.blank? || x == "''" || x == '""' }
        upcase = ->(x) {x.upcase}
        downcase = ->(x) {x.downcase}
        TSVImporter.import tsv_path, TdgClinicalTrialRow, source_info do
          interaction known_action_type: 'unknown' do
            gene :uniprot_id, nomenclature: 'Uniprot Accession' do
              name :gene_symbol, nomenclature: 'Gene Symbol', unless: blank_filter
              attribute :target_main_class, name: 'Target Class', unless: blank_filter
              attributes :target_subclass, name: 'Target Subclass', unless: blank_filter
            end

            drug :drug_name, nomenclature: 'Drug Name', primary_name: :drug_name, transform: upcase do
              attributes :indication, name: 'Drug Indications', unless: blank_filter
              attribute :drug_class, name: 'Drug Class', unless: blank_filter
              attribute :fda_approval, name: 'FDA Approval', unless: blank_filter
            end
            
            attribute :trial_name, name: 'Trial Name', unless: blank_filter
            attribute :target_novelty, name: 'Novel drug target', unless: blank_filter
          end
        end.save!
        s = DataModel::Source.where(source_db_name: source_info['source_db_name'])
        s.interaction_claims.each do |ic|
          Genome::OnlineUpdater.new.create_interaction_claim_link(ic, s.citation, "https://www.annualreviews.org/doi/10.1146/annurev-pharmtox-011613-135943")
        end
      end
    end
  end
end
