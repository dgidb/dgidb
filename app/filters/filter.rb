module Filter
  def self.included(base)
    (@filters ||= []) << base.to_s.underscore
  end

  def self.all_filters
    @filters || []
  end

  #each filter instance should have a unique cache key
  #that allows it to be re-used
  def cache_key
    raise 'Filters must implement #cache_key'
  end

  #resolve should return a set, most likely of ids,
  #of items that pass the filter instance
  def resolve
    raise 'Filters must implement #resolve'
  end

  #interaction filtering happens on many simultaneous axes
  #filters on the same axis will be unioned first
  #the resulting sets (one per axis) will then be intersected
  def axis
    raise 'Filters must implement #axis'
  end
end

#TODO: This is a nasty hack to ensure that the filters are loaded and the
#"included" handler fires before all_filters can be used
#get rid of it.
Dir.glob(File.join(File.dirname(__FILE__), '*.rb' )).each do |file|
  require file unless file =~ /\/filter\.rb$/ || file =~ /\/filter_chain\.rb$/
end
