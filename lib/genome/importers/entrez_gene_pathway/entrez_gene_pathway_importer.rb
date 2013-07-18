module Genome
  module Importers
    module EntrezGenePathway
      class EntrezGenePathwayImporter
        def initialize(tsv_path)
          @tsv_path = tsv_path
          @entrez_id_hash = {}
          @importer = Genome::Importers::Importer.new(nil, source)
          preload_genes
        end

        def import!
          File.open(@tsv_path).each_with_index do |line, index|
            next if (line.blank? || index == 0)
            process_row(EntrezGenePathwayRow.new(line))
          end
          @importer.store
        end

        private
        def process_row(row)
          left_gene = @entrez_id_hash[row.entrez_gene_id]
          right_gene = @entrez_id_hash[row.interactant_gene_id]

          unless left_gene && right_gene
            puts "Unable to find entrez genes for #{row.entrez_gene_id} and #{row.interactant_gene_id}"
            return
          end

          if left_gene != right_gene
            record_interaction(left_gene, right_gene) 
          end
        end

        def record_interaction(left_gene, right_gene)
          [
            { gene_id: left_gene.id, interacting_gene_id: right_gene.id },
            { gene_id: right_gene.id, interacting_gene_id: left_gene.id }
          ].each { |attrs| @importer.create_gene_gene_interaction_claim(attrs) }
        end

        def preload_genes
          entrez_genes = DataModel::GeneClaim.joins(:genes).includes(:genes)
          .where(nomenclature: 'Entrez Gene Id')

          entrez_genes.each do |gene_claim|
            @entrez_id_hash[gene_claim.name] = gene_claim.genes.first
          end
        end

        def source
          @source ||= DataModel::Source.where(source_db_name: 'Entrez').first
        end
      end
    end
  end
end
