class LookupFamilies
  class << self
    def find_gene_groups_for_families(family_names)
      families = Array(family_names)
      raise "Please specify at least one family name" unless families.size > 0

      results = families.inject({}) do |hash, family|
        hash[family] = DataModel::GeneAlternateName.includes(gene: [:gene_groups]).where{
          nomenclature.eq("Human Readable Name") & alternate_name.eq(family)
        }.flat_map{|gan| gan.gene.gene_groups }.uniq
        hash
      end

      [].tap do |structs|
        results.each do |key, val|
          structs.concat val.map{|x| OpenStruct.new(family: key, gene_group: x)}
        end
      end
    end

    def get_uniq_category_names_with_counts
      if Rails.cache.exist?("unique_category_names_with_counts")
        Rails.cache.fetch("unique_category_names_with_counts")
      else
        #map to structs is a hack to allow these objects to be cached.
        #you can't marshal a singleton instance of a model class which
        #is what this select creates
        category_names  = DataModel::GeneAlternateName.where{ nomenclature.eq("human_readable_name") }
          .joins{ gene.gene_groups }.joins{ gene.interactions }.group{ alternate_name }
          .select{ count(distinct(gene.gene_groups.id)).as(gene_count) }.select{ alternate_name }.select{ count(gene.interactions.id).as(interaction_count) }
          .map{|x| OpenStruct.new(alternate_name: x.alternate_name, gene_count: x.gene_count, interaction_count: x.interaction_count )}
        Rails.cache.write("unique_category_names_with_counts", category_names, expires_in: 3.hours)
        category_names
      end
    end
  end
end
