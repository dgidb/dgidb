require 'digest/md5'

class FilterChain
  def initialize
    @all_include = []
    @all_exclude = []
  end

  #TODO it will now recalculate if you modify the filter after calcuating it
  #but once something is excluded, it can't be added back in
  #is that an acceptable limitation?

  # this is what defines the "include_" methods

  Filter.all_filters.each do |filter|
    ['include', 'exclude'].each do |filter_type|
      define_method "#{filter_type}_#{filter}" do |*filter_criteria|
        instance_variable_get("@all_#{filter_type}") << filter.classify.constantize.new(*filter_criteria)
        instance_variable_set("@computed_#{filter_type}", nil)
        instance_variable_set("@computed_final", nil)
        self
      end
    end
  end

  def filter_rel(rel)
    if empty?
      rel
    else
      rel.where(interactions: { id: evaluate_all_filters.to_a })
    end
  end

  def include?(id)
    empty? || evaluate_all_filters.include?(id)
  end

  private
  def empty?
    @all_include.empty? && @all_exclude.empty?
  end

  def evaluate_all_filters
    @computed_include ||= evaluate_filter(@all_include)
    @computed_exclude ||= evaluate_filter(@all_exclude)
    @computed_final ||= @computed_include - @computed_exclude
    @computed_final
  end

  def evaluate_filter(filter)
    Rails.cache.fetch(composite_key(filter)) do
      computed = nil
      filter.group_by(&:axis).each do |_, value|
        if computed
          computed = computed & evaluate_axis(value)
        else
          computed = evaluate_axis(value)
        end
      end
      computed || Set.new
    end
  end

  def composite_key(filters)
    Digest::MD5.hexdigest(
      filters.sort_by { |filter| filter.cache_key }
        .map { |filter| filter.cache_key }
        .join('.'))
  end

  def evaluate_axis(filters)
    key = composite_key(filters)
    Rails.cache.fetch(key) do
      current_filter = filters.pop
      current_resolved = Rails.cache.fetch(Digest::MD5.hexdigest(current_filter.cache_key)) do
        current_filter.resolve
      end
      if filters.empty?
        current_resolved
      else
        results = evaluate_axis(filters)
        results + current_resolved
      end
    end
  end

  def store(filter, key)
    Rails.cache.write(key, filter)
    filter
  end
end
