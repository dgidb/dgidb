require 'genome/importers/delimited_row'
module Genome
  module Importers
    module GuideToPharmacologyInteractions
      class GuideToPharmacologyInteractionsRow < Genome::Importers::DelimitedRow
        target_parser = ->(x) { if x.blank? 
                                  return x
                                elsif (x.in? ['t','f']) 
                                  return (x == 't' ? 'True' : 'False')
                                else
                                  return ""
                                end
                              }
        types = ['Activator', 'Agonist', 'Allosteric', 'Antagonist', 'Antibody',
                 'Channel', 'Gating', 'Inhibitor', 'Subunit-specific']
        attribute :target
        attribute :target_id
        attribute :target_gene_symbol, Array, delimiter: '|'
        attribute :target_uniprot, Array, delimiter: '|'
        attribute :target_ligand, Array, delimiter: '|'
        attribute :target_ligand_id
        attribute :target_ligand_gene_symbol
        attribute :target_ligand_uniprot
        attribute :target_ligand_pubchem_sid
        attribute :target_species
        attribute :ligand
        attribute :ligand_id
        attribute :ligand_gene_symbol
        attribute :ligand_species
        attribute :ligand_pubchem_sid
        attribute :type, String, parser: ->(x) {(x.in? types) ? x.downcase : 'unknown'}
        attribute :action
        attribute :action_comment
        attribute :endogenous, String, parser: ->(x) {x == 't' ? 'True' : 'False'}
        attribute :primary_target, String, parser: target_parser
        attribute :concentration_range
        attribute :affinity_units
        attribute :affinity_high
        attribute :affinity_median
        attribute :affinity_low
        attribute :original_affinity_units
        attribute :original_affinity_low_nm
        attribute :original_affinity_median_nm
        attribute :original_affinity_high_nm
        attribute :original_affinity_relation
        attribute :assay_description
        attribute :receptor_site
        attribute :ligand_context
        attribute :pubmed_id, Array, delimiter: '|'

        def valid?(opts = {})
          tests = [target_species == 'Human', target_ligand.blank?]
          tests.all?
        end
      end
    end
  end
end