class Identity
  include Filter

  attr_reader :axis

  def initialize(axis, *ids)
    @axis = axis
    @ids = Set.new(ids)
  end

  def cache_key
    "identity.#{@ids.to_a.join('-')}"
  end

  def resolve
    @ids
  end

end