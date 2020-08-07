require 'genome/online_updater'
include ActionView::Helpers::SanitizeHelper

module Genome; module Importers; module GuideToPharmacologyInteractions;
  class NewGuideToPharmacology < Genome::OnlineUpdater
    attr_reader :file_path, :source
    def initialize(file_path)
      @file_path = file_path
    end

    def import
      remove_existing_source
      create_source
      import_claims
    end

    private
    def import_claims
      CSV.foreach(file_path, :headers => true) do |line|
        next unless valid_line?(line)

        drug_claim = create_drug_claim(line['ligand_pubchem_sid'], strip_tags(line['ligand']).upcase, 'PubChem Drug SID')
        create_drug_claim_aliases(drug_claim, line)
        create_drug_claim_attribute(drug_claim, 'Name of the Ligand Species (if a Peptide)', line['ligand_species']) unless blank?(line['ligand_species'])

        line['target_ensembl_gene_id'].split('|').each do |gene_id|
          gene_claim = create_gene_claim(gene_id, 'Ensembl Gene ID')
          create_gene_claim_aliases(gene_claim, line)

          interaction_claim = create_interaction_claim(gene_claim, drug_claim)
          type = line['type'].downcase
          create_interaction_claim_type(interaction_claim, type) unless type == 'none'
          unless blank?(line['pubmed_ids'])
            line['pubmed_ids'].split('|').each do |pmid|
              create_interaction_claim_publication(interaction_claim, pmid)
            end
          end
          create_interaction_claim_attributes(interaction_claim, line)
          create_interaction_claim_link(interaction_claim, "Ligand Biological Activity", "https://www.guidetopharmacology.org/GRAC/LigandDisplayForward?ligandId=#{line['ligand_id']}&tab=biology")
        end
      end
    end

    def valid_line?(line)
      line['target_species'] == 'Human' && blank?(line['target_ligand']) && !blank?(line['ligand_pubchem_sid']) && !blank?(line['target_ensembl_gene_id'])
    end

    def create_gene_claim_aliases(gene_claim, line)
      create_gene_claim_alias(gene_claim, line['target'], 'GuideToPharmacology Name') unless blank?(line['target'])
      unless blank?(line['target_gene_sybol'])
        line['target_gene_symbol'].split('|').each do |gene_symbol|
          create_gene_claim_alias(gene_claim, gene_symbol, 'Gene Symbol')
        end
      end
      unless blank?(line['target_uniprot'])
       line['target_uniprot'].split('|').each do |uniprot_id|
          create_gene_claim_alias(gene_claim, uniprot_id, 'UniProtKB ID')
        end
      end
    end

    def create_drug_claim_aliases(drug_claim, line)
      unless blank?(line['ligand_gene_symbol'])
        line['ligand_gene_symbol'].split('|').each do |gene_symbol|
          create_drug_claim_alias(drug_claim, gene_symbol, 'Gene Symbol (for Endogenous Peptides)')
        end
      end
      create_drug_claim_alias(drug_claim, strip_tags(line['ligand']).upcase, 'GuideToPharmacology Ligand Name')
    end

    def blank?(value)
      value.blank? || value == "''" || value == '""'
    end

    def create_interaction_claim_attributes(interaction_claim, line)
      attributes = {
        'Interaction Context': line['ligand_context'],
        'Specific Binding Site for Interaction': line['receptor_site'],
        'Details of the Assay for Interaction': line['assay_description'],
        'Specific Action of the Ligand': line['action'],
        'Details of Interaction': line['action_comment'],
        'Endogenous Drug?': line['endogenous'],
        'Direct Interaction?': line['primary_target'],
      }
      boolean_parser = {
        't' => 'True',
        'f' => 'False',
      }
      attributes.each do |name, value|
        next if blank?(value)
        parsed_value = boolean_parser[value] || value
        create_interaction_claim_attribute(interaction_claim, name, parsed_value)
      end
    end

    def remove_existing_source
      Utils::Database.delete_source('GuideToPharmacologyInteractions')
    end

    def create_source
      @source = DataModel::Source.where(
          base_url: 'http://www.guidetopharmacology.org/DATA/',
          site_url: 'http://www.guidetopharmacology.org/',
          citation: 'Pawson, Adam J., et al. "The IUPHAR/BPS Guide to PHARMACOLOGY: an expert-driven knowledgebase 
of drug targets and their ligands." Nucleic acids research 42.D1 (2014): D1098-D1106. PMID: 24234439.',
          source_type_id: DataModel::SourceType.INTERACTION,
          source_db_name: 'GuideToPharmacologyInteractions',
          full_name: 'Guide to Pharmacology Interactions',
          license: 'Creative Commons Attribution-ShareAlike 4.0 International License',
          license_url: 'https://www.guidetopharmacology.org/about.jsp',
      ).first_or_initialize
      source.source_db_version = Date.today.strftime("%d-%B-%Y")
      source.save
    end
  end
end; end; end;
