module Utils
  module Database

    def self.delete_genes
      sql = <<-SQL
        update gene_claims set gene_id = NULL;
        
        delete from gene_aliases_sources;
        delete from gene_aliases;
        delete from gene_attributes_sources;
        delete from gene_attributes;
        delete from gene_categories_genes;
        delete from genes;
      SQL

      ActiveRecord::Base.transaction do
        delete_interactions
        ActiveRecord::Base.connection.execute(sql)
      end
    end

    def self.delete_interactions
      sql = <<-SQL
        update interaction_claims set interaction_id = NULL;
        
        delete from interaction_attributes_sources;
        delete from interaction_attributes;
        delete from interactions_publications;
        delete from interaction_types_interactions;
        delete from interactions_publications;
        delete from interactions_sources;
        delete from interactions;
      SQL

      ActiveRecord::Base.connection.execute(sql)
    end

    def self.delete_drugs
      sql = <<-SQL
        update drug_claims set drug_id = NULL;
        
        delete from drug_aliases_sources;
        delete from drug_aliases;
        delete from drug_attributes_sources;
        delete from drug_attributes;
        delete from drugs;
      SQL

      ActiveRecord::Base.transaction do
        delete_interactions
        ActiveRecord::Base.connection.execute(sql)
      end
    end

    def self.delete_source(source_db_name)
      source_id = DataModel::Source.where('lower(sources.source_db_name) = ?',
        source_db_name.downcase).pluck(:id).first

      sql = <<-SQL
        delete from interaction_claims_publications where interaction_claim_id in (select id from interaction_claims where source_id = '#{source_id}');
        delete from interaction_claim_attributes where interaction_claim_id in (select id from interaction_claims where source_id = '#{source_id}');
        delete from interaction_claim_types_interaction_claims where interaction_claim_id in (select id from interaction_claims where source_id = '#{source_id}');
        update interaction_claims set interaction_id = NULL where source_id = '#{source_id}';
        delete from interaction_claims where source_id = '#{source_id}';

        delete from interactions_sources where source_id = '#{source_id}';

        delete from drug_claim_attributes where drug_claim_id in (select id from drug_claims where source_id = '#{source_id}');
        delete from drug_claim_aliases where drug_claim_id in (select id from drug_claims where source_id = '#{source_id}');
        delete from drug_claim_types_drug_claims where drug_claim_id in (select id from drug_claims where source_id = '#{source_id}');
        update drug_claims set drug_id = NULL where source_id = '#{source_id}';
        delete from drug_claims where source_id = '#{source_id}';

        delete from gene_gene_interaction_claim_attributes where gene_gene_interaction_claim_id in (select id from gene_gene_interaction_claims where source_id = '#{source_id}');
        delete from gene_gene_interaction_claims where source_id = '#{source_id}';

        delete from gene_claim_attributes where gene_claim_id in (select id from gene_claims where source_id = '#{source_id}');
        delete from gene_claim_aliases where gene_claim_id in (select id from gene_claims where source_id = '#{source_id}');
        delete from gene_claim_categories_gene_claims where gene_claim_id in (select id from gene_claims where source_id = '#{source_id}');
        update gene_claims set gene_id = NULL where source_id = '#{source_id}';
        delete from gene_claims where source_id = '#{source_id}';

        delete from drug_aliases_sources where source_id = '#{source_id}';
        delete from drug_attributes_sources where source_id = '#{source_id}';
        delete from gene_aliases_sources where source_id = '#{source_id}';
        delete from gene_attributes_sources where source_id = '#{source_id}';
        delete from interaction_attributes_sources where source_id = '#{source_id}';
        delete from interactions_sources where source_id = '#{source_id}';
        delete from sources where id = '#{source_id}';
      SQL

      ActiveRecord::Base.connection.execute(sql)
    end

    def self.destroy_common_aliases
      sql = <<-SQL
        DELETE FROM drug_claim_aliases
        WHERE alias in (
          select alias from (
            select * from (
              select count(distinct d.id), alias, length(alias)
              from drugs d, drug_claims_drugs dcd, drug_claim_aliases dca
              where d.id = dcd.drug_id and dcd.drug_claim_id = dca.drug_claim_id
              group by alias
            ) t
            where (count >= 5 and length <= 4) or length <= 2 or count >= 10
          ) t
        )
      SQL
      ActiveRecord::Base.transaction do
        ActiveRecord::Base.connection.execute(sql)
        destroy_empty_groups
      end
    end

    def self.destroy_empty_groups
      DataModel::Interaction.includes(:interaction_claims).where(interaction_claims: {id: nil}).destroy_all
      # Empty genes are expected
      # empty_genes = DataModel::Gene.includes(:gene_claims).where(gene_claims: {id: nil}).destroy_all
      # Empty drugs are okay to delete
      DataModel::Drug.includes(:drug_claims).where(drug_claims: {id: nil}).destroy_all
    end

    def self.destroy_na
      sql = <<-SQL
        delete from drug_claim_types_drug_claims d
        where
        d.drug_claim_id in
          (select id from drug_claims
          where upper(drug_claims.name) in ('NA','N/A')
          );

        delete from drug_claims_drugs d
        where
        d.drug_claim_id in
          (select id from drug_claims
          where upper(drug_claims.name) in ('NA','N/A')
          );

        delete from drug_claim_aliases d
        where
        d.drug_claim_id in
          (select id from drug_claims
          where upper(drug_claims.name) in ('NA','N/A')
          );

        delete from drug_claim_attributes d
        where
        d.drug_claim_id in
          (select id from drug_claims
          where upper(drug_claims.name) in ('NA','N/A')
          );

        delete from interaction_claim_types_interaction_claims i
        where
        i.interaction_claim_id in
          (select id from interaction_claims d
          where
          d.drug_claim_id in
            (select id from drug_claims
            where upper(drug_claims.name) in ('NA','N/A')
            )
          );

        delete from interaction_claim_attributes i
        where
        i.interaction_claim_id in
          (select id from interaction_claims d
          where
          d.drug_claim_id in
            (select id from drug_claims
            where upper(drug_claims.name) in ('NA','N/A')
            )
          );

        delete from interaction_claims d
        where
        d.drug_claim_id in
          (select id from drug_claims
          where upper(drug_claims.name) in ('NA','N/A')
          );

        delete from drug_claims d
        where
        upper(name) in ('NA','N/A');

        delete from drug_claim_aliases
        where upper(alias) in ('NA','N/A');

        delete from gene_claim_aliases g
        where
        g.gene_claim_id in
          (select id from gene_claims
          where upper(name) in ('NA','N/A')
          );

        delete from gene_claim_attributes g
        where
        g.gene_claim_id in
          (select id from gene_claims
          where upper(name) in ('NA','N/A')
          );

        delete from interaction_claim_types_interaction_claims i
        where
        i.interaction_claim_id in
          (select id from interaction_claims
          where
            interaction_claims.gene_claim_id in
            (select id from gene_claims
            where upper(name) in ('NA','N/A')
            )
          );

        delete from interaction_claim_attributes i
        where
        i.interaction_claim_id in
          (select id from interaction_claims
          where
            interaction_claims.gene_claim_id in
            (select id from gene_claims
            where upper(name) in ('NA','N/A')
            )
          );

        delete from interaction_claims g
        where
        g.gene_claim_id in
          (select id from gene_claims
          where upper(name) in ('NA','N/A')
          );

        delete from gene_claims
        where upper(name) in ('NA','N/A');

        delete from gene_claim_aliases
        where upper(alias) in ('NA', 'N/A');
      SQL

      ActiveRecord::Base.connection.execute(sql)
    end

    def self.model_to_tsv model
      CSV.generate(col_sep: "\t") do |tsv|
        tsv << model.column_names
        model.all.each do |m|
          values = model.column_names.map{ |f| m.send f.to_sym}
          tsv << values
        end
      end
    end
  end
end
