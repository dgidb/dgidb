class LookupCategories
  class << self
    def find_gene_groups_for_categories(category_names)
      categories = Array(category_names)
      raise "Please specify at least one category name" unless categories.size > 0

      results = categories.inject({}) do |hash, category|
        hash[category] = DataModel::GeneCategory.includes(gene: [:gene_groups, :citation]).where{
          category_name.eq("Human Readable Name") & category_value.eq(category)
        }
        hash
      end
    end

    def get_uniq_category_names_with_counts
      if Rails.cache.exist?("unique_category_names_with_counts")
        Rails.cache.fetch("unique_category_names_with_counts")
      else
        #map to structs is a hack to allow these objects to be cached.
        #you can't marshal a singleton instance of a model class which
        #is what this select creates
        category_names = DataModel::GeneCategory.where{ category_name.eq("Human Readable Name") }
          .joins{ gene.gene_groups }.group{ category_value }
          .select{ count(distinct(gene.gene_groups.id)).as(count) }.select{ category_value }.order("category_value")
          .map{|x| OpenStruct.new(category_value: x.category_value,count: x.count )}
        Rails.cache.write("unique_category_names_with_counts", category_names, expires_in: 3.hours)
        category_names
      end
    end
  end
end
