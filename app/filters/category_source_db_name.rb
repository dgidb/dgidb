class CategorySourceDbName
  include Filter

  def initialize(source_db_name)
    @source_db_name = source_db_name.downcase
  end

  def cache_key
    "category_source_db_name.#{@source_db_name}"
  end

  def axis
    :source
  end

  def resolve
    Set.new DataModel::GeneClaim
      .joins(:source)
      .where('lower(sources.source_db_name) = ?', @source_db_name)
      .pluck('gene_claims.id')
      .uniq
  end
end

