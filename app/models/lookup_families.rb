class LookupFamilies
  class << self
    def find_gene_groups_for_families(family_names)
      families = Array(family_names)
      raise "Please specify at least one family name" unless families.size > 0

      results =families.inject({}) do |hash, family|
        hash[family] = DataModel::GeneAlternateName.includes(gene: [:gene_groups]).where{
          nomenclature.eq("human_readable_name") & alternate_name.eq(family)
        }.map{|gan| gan.gene.gene_groups }.flatten.uniq
        hash
      end

      structs = []
      results.flatten.each_slice(2) do |family|
        structs += family[-1].map{|x| OpenStruct.new(family: family[0], gene_group: x)}
      end
      structs
    end

    def get_uniq_family_names
      if Rails.cache.exist?("unique_family_names")
        Rails.cache.fetch("unique_family_names")
      else
        family_names = DataModel::GeneAlternateName.where(nomenclature: "human_readable_name").uniq.pluck(:alternate_name).sort
        Rails.cache.write("unique_family_names", family_names, expires_in: 3.hours)
        family_names
      end
    end

  end
end
