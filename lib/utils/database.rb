module Utils
  module Database
    def self.delete_source(source_db_name)
      source_id = DataModel::Source.where(source_db_name: source_db_name)
        .pluck(:id).first

      sql = <<-SQL
        delete from interaction_claim_attributes where interaction_claim_id in (select id from interaction_claims where source_id = '#{source_id}');
        delete from interaction_claim_types_interaction_claims where interaction_claim_id in (select id from interaction_claims where source_id = '#{source_id}');
        delete from interaction_claims where source_id =  '#{source_id}';

        delete from drug_claim_attributes where drug_claim_id in (select id from drug_claims where source_id = '#{source_id}');
        delete from drug_claim_aliases where drug_claim_id in (select id from drug_claims where source_id = '#{source_id}');
        delete from drug_claim_types_drug_claims where drug_claim_id in (select id from drug_claims where source_id = '#{source_id}');
        delete from drug_claims_drugs where drug_claim_id in (select id from drug_claims where source_id = '#{source_id}');
        delete from drug_claims where source_id = '#{source_id}';

        delete from gene_claim_attributes where gene_claim_id in (select id from gene_claims where source_id = '#{source_id}');
        delete from gene_claim_aliases where gene_claim_id in (select id from gene_claims where source_id = '#{source_id}');
        delete from gene_claims_genes where gene_claim_id in (select id from gene_claims where source_id = '#{source_id}');
        delete from gene_claim_categories_gene_claims where gene_claim_id in (select id from gene_claims where source_id = '#{source_id}');
        delete from gene_claims where source_id = '#{source_id}';

        delete from sources where id = '#{source_id}';
      SQL

      ActiveRecord::Base.connection.execute(sql)
    end
  end
end
