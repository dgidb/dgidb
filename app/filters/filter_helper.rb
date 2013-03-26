module FilterHelper
  def construct_filter(filter, items, filter_name)
    filter.tap do |f|
      Array(items).each do |item|
        f.send(filter_name, item)
      end
    end
  end
end
