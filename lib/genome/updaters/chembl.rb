require 'pg'

module Genome
  module Updaters
    class Chembl
      def self.chembl_db_name
        'chembl_23'
      end

      def self.update
        self.remove_existing_source
        self.create_new_source
        self.load_interaction_claims
      end

      def self.reload_chembl_molecules
        Utils::Database.delete_drugs
        DataModel::ChemblMoleculeSynonym.delete_all
        DataModel::ChemblMolecule.delete_all
        init_molecules_from_db
        init_synonyms_from_db
        grouper = Grouper.new
        grouper.perform
        postgrouper = PostGrouper.new
        postgrouper.perform
      end

      def self.init_molecules_from_db # This is for an initial, non-incremental load into the chembl_molecule table
        new_records = []
        i = 0
        connection.exec( "SELECT * FROM molecule_dictionary").each do |record|
          new_records << get_params(record, mol_col_hash)
          if (i % 50000) == 0
            DataModel::ChemblMolecule.create(new_records)
            new_records = []
          end
          i += 1
        end

        DataModel::ChemblMolecule.create(new_records)
      end

      def self.init_synonyms_from_db # This is for an initial, non-incremental load into chembl_molecule_synonym table

        connection.exec("SELECT * FROM molecule_synonyms").each do |record|
          params = get_params(record, syn_col_hash)
          params[:synonym] = record['synonyms'].strip
          synonym = DataModel::ChemblMoleculeSynonym.create(params)
          DataModel::ChemblMolecule.where(molregno: params[:molregno]).first.chembl_molecule_synonyms << synonym
        end
      end

      private
      def self.get_params(record, col_hash)
        params = {}

        record.each do |k, v|
          ks = k.to_sym
          if col_hash[k].nil?
            next
          elsif col_hash[k].type == :boolean
            params[ks] = flag(v)
          else
            params[ks] = v&.strip
          end
        end
        params
      end

      def self.remove_existing_source
        Utils::Database.delete_source('ChemblInteractions')
      end

      def self.create_new_source
        @@source ||= DataModel::Source.create(
         {
           source_db_name: 'ChemblInteractions',
           source_db_version: self.chembl_db_name,
           base_url: 'https://www.ebi.ac.uk/chembldb/index.php/target/inspect/',
           site_url: 'https://www.ebi.ac.uk/chembl',
           citation: "The ChEMBL bioactivity database: an update. Bento AP, Gaulton A, Hersey A, Bellis LJ, Chambers J, Davies M, Kruger FA, Light Y, Mak L, McGlinchey S, Nowotka M, Papadatos G, Santos R, Overington JP. Nucleic Acids Res. 42(Database issue):D1083-90. PubMed ID: 24214965",
           source_type_id: DataModel::SourceType.INTERACTION,
           source_trust_level_id: DataModel::SourceTrustLevel.EXPERT_CURATED,
           full_name: 'The ChEMBL Bioactivity Database',
           license: 'Creative Commons Attribution-Share Alike 3.0 Unported License',
           license_url: 'https://chembl.gitbook.io/chembl-interface-documentation/about',
         }
        )
      end

      def self.source
        @@source ||= DataModel::Source.find_by(source_db_name: 'ChemblInteractions')
      end

      def self.flag(string)
        h = {
            '0'=>false,
            '1'=>true,
        }
        return h[string]
      end

      def self.mol_col_hash
        @@mol_col_hash ||= DataModel::ChemblMolecule.columns_hash
      end

      def self.syn_col_hash
        @@syn_col_hash ||= DataModel::ChemblMoleculeSynonym.columns_hash
      end

      def self.connection
        @@connection ||= PG.connect(dbname: chembl_db_name)
      end

      def self.add_ica(name, value, ic, to_yn=false)
        if to_yn
          value = ActiveRecord::Type::Boolean.new.cast(value) ? 'yes' : 'no'
        end
        DataModel::InteractionClaimAttribute.create(interaction_claim: ic, name: name.strip, value: value.strip)
      end

      def self.load_interaction_claims
        r = connection.exec('SELECT * FROM drug_mechanism')
        r.each do |interaction|
          molecule = DataModel::ChemblMolecule.find_by(molregno: interaction["molregno"])
          target = connection.exec('SELECT * FROM target_dictionary WHERE tid = $1 AND tax_id = 9606 LIMIT 1', [interaction['tid']]).first
          next if target.nil?

          sql = <<-SQL
            SELECT tc.component_id, cs.component_synonym, cs.syn_type
            FROM
              target_components tc,
              component_synonyms cs
            WHERE
              tc.tid = $1 and
              tc.component_id = cs.component_id
          SQL
          components = connection.exec(sql, [target['tid']]).group_by{|s| s['component_id']}
          components.each do |component, synonyms|
            gene_syn = synonyms.select{|s| s['syn_type'] == 'GENE_SYMBOL' && !s['component_synonym'].blank?}.first ||
                       synonyms.select{|s| s['syn_type'] == 'UNIPROT' && !s['component_synonym'].blank?}.first
            next if gene_syn.nil?
            gene_name = gene_syn['component_synonym'].strip
            gene_nomenclature = gene_syn['syn_type'].strip
            drug_claim = DataModel::DrugClaim.where(name: molecule.chembl_id.strip, nomenclature: 'ChEMBL ID',
                                                primary_name: molecule.pref_name.strip, source: source).first_or_create
            gene_claim = DataModel::GeneClaim.where(name: gene_name, nomenclature: gene_nomenclature, source: source)
                          .first_or_create do |gc|
              synonyms.each do |synonym|
                next unless synonym['syn_type'].in? %w(GENE_SYMBOL UNIPROT)
                next if synonym['component_synonym'].blank?
                DataModel::GeneClaimAlias.create(gene_claim: gc, alias: synonym['component_synonym'].strip,
                                                 nomenclature: synonym['syn_type'].strip)
              end
            end
            interaction_claim = DataModel::InteractionClaim.where(drug_claim: drug_claim,
                                  gene_claim: gene_claim, source: source).first_or_create do |ic|
              add_ica('Mechanism of Interaction', interaction['mechanism_of_action'], ic)
              add_ica('Direct Interaction', interaction['direct_interaction'], ic, true)
              begin
                type = DataModel::InteractionClaimType.find_by(type: interaction['action_type'].downcase.strip)
              rescue NoMethodError
                type = nil
              end
              ic.interaction_claim_types << type unless type.nil?
              Genome::OnlineUpdater.new.create_interaction_claim_link(ic, 'Drug Mechanisms', "https://www.ebi.ac.uk/chembl/compound_report_card/#{drug_claim.name}/#MechanismOfAction")
            end
          end
        end
      end
    end
  end
end
