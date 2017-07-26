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

      def self.init_records_from_db # This is for an initial, non-incremental load into the chembl_molecule table
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
          params[:synonym] = record['synonyms']
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
            params[ks] = v
          end
        end
        params
      end

      def self.remove_existing_source
        Utils::Database.delete_source('ChEMBL')
      end

      def self.create_new_source
        @@source ||= DataModel::Source.create(
         {
           source_db_name: 'ChEMBL',
           source_db_version: self.chembl_db_name,
           base_url: 'https://www.ebi.ac.uk/chembldb/index.php/target/inspect/',
           site_url: 'https://www.ebi.ac.uk/chembl',
           citation: "The ChEMBL bioactivity database: an update. Bento AP, Gaulton A, Hersey A, Bellis LJ, Chambers J, Davies M, Kruger FA, Light Y, Mak L, McGlinchey S, Nowotka M, Papadatos G, Santos R, Overington JP. Nucleic Acids Res. 42(Database issue):D1083-90. PubMed ID: 24214965",
           source_type_id: DataModel::SourceType.INTERACTION,
           source_trust_level_id: DataModel::SourceTrustLevel.EXPERT_CURATED,
           full_name: 'The ChEMBL Bioactivity Database'
         }
        )
      end

      def self.source
        @@source ||= DataModel::Source.find_by(source_db_name: 'ChEMBL')
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

      def add_ica(name, value, ic, to_yn=false)
        if to_yn
          value = ActiveRecord::Type::Boolean.new.cast(value) ? 'yes' : 'no'
        end
        DataModel::InteractionClaimAttribute.create(interaction_claim: ic, name: name, value: value)
      end

      def self.load_interaction_claims
        r = connection.exec('SELECT * FROM drug_mechanism')
        r.each do |interaction|
          molecule = DataModel::ChemblMolecule.find_by(molregno: interaction["molregno"])
          target = chembl.connection.exec('SELECT * FROM target_dictionary WHERE tid = $1 AND tax_id = 9606 LIMIT 1', [i['tid']]).first
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
          components = chembl.connection.exec(sql, [target['tid']]).group_by{|s| s['component_id']}
          components.each do |component, synonyms|
            gene_syn = synonyms.select{|s| s['syn_type'] == 'GENE_SYMBOL'}.first ||
                       synonyms.select{|s| s['syn_type'] == 'UNIPROT'}.first
            next if gene_syn.nil?
            gene_name = gene_syn['component_synonym']
            gene_nomenclature = gene_syn['syn_type']
            ActiveRecord::Base.transaction do
              drug_claim = DataModel::DrugClaim.first_or_create(name: molecule.chembl_id, nomenclature: 'ChEMBL ID',
                                                  primary_name: molecule.pref_name, source: self.source)
              gene_claim = DataModel::GeneClaim.first_or_create(name: gene_name, nomenclature: gene_nomenclature, source: self.source) do |gene_claim|
                synonyms.each do |synonym|
                  next unless synonym['syn_type'].in? %w(GENE_SYMBOL UNIPROT)
                  DataModel::GeneClaimAlias.create(gene_claim: gene_claim, alias: synonym['component_synonym'],
                                                   nomenclature: synonym['syn_type'])
                end
              end
              interaction_claim = DataModel::InteractionClaim.create(drug_claim: drug_claim,
                                                                     gene_claim: gene_claim, source: self.source)
              add_ica('Mechanism of Interaction', interaction['mechanism_of_action'], interaction_claim)
              add_ica('Direct Interaction', interaction['direct_interaction'], interaction_claim, true)
              type = DataModel::InteractionClaimType.find_by(type: interaction['action_type'].downcase)
              interaction_claim << type unless type.nil?
            end
          end
        end
      end
    end
  end
end