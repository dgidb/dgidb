class FilterChain
  def initialize
    @all_inclusions = []
  end

  Filter.all_filters.each do |filter|
    define_method "include_#{filter}" do |*filter_criteria|
      @all_inclusions << filter.classify.constantize.new(*filter_criteria)
      self
    end
  end

  def include?(id)
    evaluate_all_filters.include?(id)
  end

  private
  def evaluate_all_filters
    return @computed if @computed
    @all_inclusions.group_by(&:axis).each do |_, value|
      if @computed
        @computed = @computed & evaluate_axis(value)
      else
        @computed = evaluate_axis(value)
      end
    end
    @computed
  end

  def composite_key(inclusions)
    inclusions.sort_by { |filter| filter.cache_key }
    .map { |filter| filter.cache_key }
    .join('.')
  end

  def evaluate_axis(inclusions)
    key = composite_key(inclusions)
    if Rails.cache.exist?(key)
      Rails.cache.fetch(key)
    else
      current_filter = inclusions.pop
      if inclusions.empty?
        store(current_filter.resolve, key)
      else
        results = evaluate_axis(inclusions)
        store(results + current_filter.resolve, key)
      end
    end
  end

  def store(filter, key)
    Rails.cache.write(key, filter)
    filter
  end
end
