require 'genome/importers/delimited_row'
module Genome
    module Importers
        module FoundationOneInteractions
            class FoundationOneRow < Genome::Importers::DelimitedRow
                attribute :reported_gene_name
                attribute :entrez_gene_name
                attribute :entrez_gene_id
                attribute :reported_drug_name
                attribute :pubchem_drug_name
                attribute :primary_drug_name
                attribute :pubchem_drug_id
                attribute :pharmacogenic_loci_hg18
            end
        end
    end
end
