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

      if source_id
        sql = <<-SQL
          delete from interaction_claims_publications where interaction_claim_id in (select id from interaction_claims where source_id = '#{source_id}');
          delete from interaction_claim_attributes where interaction_claim_id in (select id from interaction_claims where source_id = '#{source_id}');
          delete from interaction_claim_links where interaction_claim_id in (select id from interaction_claims where source_id = '#{source_id}');
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
          delete from source_types_sources where source_id = '#{source_id}';
          delete from sources where id = '#{source_id}';
        SQL

        ActiveRecord::Base.connection.execute(sql)
      end
      destroy_empty_groups
      destroy_unsourced_attributes
      destroy_unsourced_aliases
      destroy_unsourced_gene_categories
    end

    def self.destroy_common_aliases
      DataModel::DrugAlias
          .includes(:drug)
          .group('clean(alias)')
          .having('count(clean(alias)) > 3')
          .pluck('clean(alias)')
          .to_set
          .each do |dup_alias|
        DataModel::DrugAliasBlacklist.find_or_create_by(alias: dup_alias)
        DataModel::DrugAlias.where('clean(alias) = ?', dup_alias).destroy_all
        DataModel::DrugClaimAlias.where('clean(alias) = ?', dup_alias).destroy_all
      end
    end

    def self.destroy_empty_groups
      DataModel::Interaction.includes(:interaction_claims).where(interaction_claims: {id: nil}).destroy_all
      # Empty genes are expected
      # empty_genes = DataModel::Gene.includes(:gene_claims).where(gene_claims: {id: nil}).destroy_all
      # Empty drugs are okay to delete
      DataModel::Drug.includes(:drug_claims).where(drug_claims: {id: nil}).destroy_all
    end

    def self.destroy_unsourced_attributes
      DataModel::InteractionAttribute.includes(:sources).where(sources: {id: nil}).destroy_all
      DataModel::GeneAttribute.includes(:sources).where(sources: {id: nil}).destroy_all
      DataModel::DrugAttribute.includes(:sources).where(sources: {id: nil}).destroy_all
    end

    def self.destroy_unsourced_aliases
      DataModel::GeneAlias.includes(:sources).where(sources: {id: nil}).destroy_all
      #Drug aliases are currently imported directly from the therapy
      #normalizer but not attributed to ChEMBL or Wikidata (outstanding issue #485)
      #Therefore, none of the drug aliases currently have a source
      #DataModel::DrugAlias.includes(:sources).where(sources: {id: nil}).destroy_all
    end

    def self.destroy_unsourced_gene_categories
      DataModel::Gene.joins(:gene_categories).includes(:gene_categories, gene_claims: [:gene_claim_categories]).each do |g|
        gene_claim_categories = g.gene_claims.flat_map{|c| c.gene_claim_categories}
        g.gene_categories.each do |c|
          unless gene_claim_categories.include? c
            g.gene_categories.delete(c)
          end
        end
      end
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

    def self.cleanup_whitespaces
      DataModel::InteractionClaimType.where("type LIKE ' %' or type LIKE '% '").all.each do |t|
        t.value = t.value.strip
        t.save!
      end
      DataModel::InteractionClaimAttribute.where("name LIKE ' %' or name LIKE '% '").all.each do |a|
        a.name = a.name.strip
        a.save!
      end
      DataModel::InteractionClaimAttribute.where("value LIKE ' %' or value LIKE '% '").all.each do |a|
        a.value = a.value.strip
        a.save!
      end
      DataModel::InteractionAttribute.where("name LIKE ' %' or name LIKE '% '").all.each do |a|
        a.name = a.name.strip
        a.save!
      end
      DataModel::InteractionAttribute.where("value LIKE ' %' or value LIKE '% '").all.each do |a|
        a.value = a.value.strip
        a.save!
      end

      DataModel::GeneClaimAlias.where("alias LIKE ' %' or alias LIKE '% '").all.each do |a|
        a.alias = a.alias.strip
        a.save!
      end
      DataModel::GeneClaimAttribute.where("name LIKE ' %' or name LIKE '% '").all.each do |a|
        a.name = a.name.strip
        a.save!
      end
      DataModel::GeneClaimAttribute.where("value LIKE ' %' or value LIKE '% '").all.each do |a|
        a.value = a.value.strip
        a.save!
      end
      DataModel::GeneAlias.where("alias LIKE ' %' or alias LIKE '% '").all.each do |a|
        clean_alias = a.alias.strip
        if (clean_gene_alias = DataModel::GeneAlias.where('upper(alias) = ? and gene_id = ?', clean_alias.upcase, a.gene_id)).one?
          a.sources.each do |source|
            clean_gene_alias.first.sources << source unless clean_gene_alias.first.sources.include? source
            a.sources.delete(source)
          end
          a.delete
        else
          a.alias = clean_alias
          a.save!
        end
      end
      DataModel::GeneAttribute.where("name LIKE ' %' or name LIKE '% '").all.each do |a|
        clean_attribute = DataModel::GeneAttribute.where(name: a.name.strip, value: a.value.strip, gene_id: a.gene_id).first_or_create
        a.sources.each do |source|
          clean_attribute.sources << source unless clean_attribute.sources.include? source
          a.sources.delete(source)
        end
        a.delete
      end
      DataModel::GeneAttribute.where("value LIKE ' %' or value LIKE '% '").all.each do |a|
        clean_attribute = DataModel::GeneAttribute.where(name: a.name.strip, value: a.value.strip, gene_id: a.gene_id).first_or_create
        a.sources.each do |source|
          clean_attribute.sources << source unless clean_attribute.sources.include? source
          a.sources.delete(source)
        end
        a.delete
      end
      DataModel::GeneClaim.where("name LIKE ' %' or name LIKE '% '").all.each do |c|
        clean_name = c.name.strip
        clean_claim = DataModel::GeneClaim.where(name: clean_name, nomenclature: c.nomenclature, source_id: c.source_id).first_or_create
        c.gene_claim_aliases.each do |synonym|
          DataModel::GeneClaimAlias.where(alias: synonym.alias, nomenclature: synonym.nomenclature, gene_claim_id: clean_claim.id).first_or_create
          synonym.delete
        end
        c.gene_claim_attributes.each do |attribute|
          DataModel::GeneClaimAttribute.where(name: attribute.name, value: attribute.value, gene_claim_id: clean_claim.if).first_or_create
          attribute.delete
        end
        c.interaction_claims.each do |interaction|
          clean_interaction = DataModel::InteractionClaim.where(drug_claim_id: interaction.drug_claim_id, gene_claim_id: clean_claim.id, source_id: interaction.source_id).first_or_create
          interaction.interaction_claim_attributes.each do |attribute|
            DataModel::InteractionClaimAttribute.where(name: attribute.name, value: attribute.value, interaction_claim_id: clean_interaction.id).first_or_create
            attribute.delete
          end
          interaction.interaction_claim_types.each do |type|
            clean_interaction.interaction_claim_types << type unless clean_interaction.interaction_claim_types.include? type
            interaction.interaction_claim_types.delete(type)
          end
          interaction.delete
        end
        c.delete
      end

      DataModel::DrugClaimAlias.where("alias LIKE ' %' or alias LIKE '% '").all.each do |a|
        clean_alias = a.alias.strip
        DataModel::DrugClaimAlias.where(alias: clean_alias, nomenclature: a.nomenclature, drug_claim_id: a.drug_claim_id).first_or_create
        a.delete
      end
      DataModel::DrugClaimAttribute.where("name LIKE ' %' or name LIKE '% '").all.each do |a|
        a.name = a.name.strip
        a.save!
      end
      DataModel::DrugClaimAttribute.where("value LIKE ' %' or value LIKE '% '").all.each do |a|
        a.value = a.value.strip
        a.save!
      end
      DataModel::DrugAlias.where("alias LIKE ' %' or alias LIKE '% '").all.each do |a|
        clean_alias = a.alias.strip
        if (clean_drug_alias = DataModel::DrugAlias.where('alias ILIKE ? and drug_id = ?', clean_alias, a.drug_id)).one?
          a.sources.each do |source|
            clean_drug_alias.first.sources << source unless clean_drug_alias.first.sources.include? source
            a.sources.delete(source)
          end
          a.delete
        else
          a.alias = clean_alias
          a.save!
        end
      end
      DataModel::DrugAttribute.where("name LIKE ' %' or name LIKE '% '").all.each do |a|
        a.name = a.name.strip
        a.save!
      end
      DataModel::DrugAttribute.where("value LIKE ' %' or value LIKE '% '").all.each do |a|
        a.value = a.value.strip
        a.save!
      end
      DataModel::DrugClaim.where("name LIKE ' %' or name LIKE '% ' or primary_name LIKE ' %' or primary_name LIKE '% '").all.each do |c|
        clean_name = c.name.strip
        clean_primary_name = c.primary_name.strip
        clean_claim = DataModel::DrugClaim.where(name: clean_name, primary_name: clean_primary_name, nomenclature: c.nomenclature, source_id: c.source_id).first_or_create
        c.drug_claim_aliases.each do |synonym|
          DataModel::DrugClaimAlias.where(alias: synonym.alias, nomenclature: synonym.nomenclature, drug_claim_id: clean_claim.id).first_or_create
          synonym.delete
        end
        c.drug_claim_attributes.each do |attribute|
          DataModel::DrugClaimAttribute.where(name: attribute.name, value: attribute.value, drug_claim_id: clean_claim.if).first_or_create
          attribute.delete
        end
        c.interaction_claims.each do |interaction|
          clean_interaction = DataModel::InteractionClaim.where(gene_claim_id: interaction.gene_claim_id, drug_claim_id: clean_claim.id, source_id: interaction.source_id).first_or_create
          interaction.interaction_claim_attributes.each do |attribute|
            DataModel::InteractionClaimAttribute.where(name: attribute.name, value: attribute.value, interaction_claim_id: clean_interaction.id).first_or_create
            attribute.delete
          end
          interaction.interaction_claim_types.each do |type|
            clean_interaction.interaction_claim_types << type unless clean_interaction.interaction_claim_types.include? type
            interaction.interaction_claim_types.delete(type)
          end
          interaction.delete
        end
        c.delete
      end
    end
  end
end
