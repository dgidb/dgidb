class FilterChain
  def initialize
    @inclusions = []
  end

  ['interaction_claim_type', 'dummy'].each do |filter|
    define_method "include_#{filter}" do |filter_criteria|
      @inclusions << "#{filter}_filter".classify.constantize.new(filter_criteria)
      self
    end
  end

  def include?(id)
    filter.include?(id)
  end

  private
  def filter
    @computed ||= combine_filters(@inclusions)
  end

  def composite_key( inclusions )
    inclusions.sort_by { |filter| filter.cache_key }
    .map { |filter| filter.cache_key }
    .join('.')
  end

  def combine_filters(inclusions)
    key = composite_key(inclusions)
    if Rails.cache.exist?(key)
      Rails.cache.fetch(key)
    else
      current_filter = inclusions.pop
      if inclusions.empty?
        store(current_filter.resolve, key)
      else
        results = combine_filters(inclusions)
        store(results + current_filter.resolve, key)
      end
    end
  end

  def store(filter, key)
    Rails.cache.write(key, filter)
    filter
  end
end
