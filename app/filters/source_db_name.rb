class SourceDbName
  include Filter

  def initialize(source_db_name)
    @source_db_name = source_db_name.downcase
  end

  def cache_key
    "source.db_name.#{@source_db_name}"
  end

  def axis
    :sources
  end

  def resolve
    Set.new DataModel::Source
      .where('lower(source_db_name) = ?', @source_db_name)
      .joins(interaction_claims: :interaction)
      .pluck('interactions.id')
  end
end