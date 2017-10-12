class PaginatedCollectionPresenter
  attr_reader :collection, :request, :item_presenter_type, :pagination_presenter_type, :additional_meta, :page_state_param_names

  def initialize(collection, request, item_presenter_type, pagination_presenter_type, additional_meta = {}, page_state_param_names = [])
    @collection = collection
    @request = request
    @item_presenter_type = item_presenter_type
    @pagination_presenter_type = pagination_presenter_type
    @additional_meta = additional_meta
    @page_state_param_names = page_state_param_names
  end

  def as_json(options = {})
    {
      _meta: pagination_presenter_type.new(collection, page_state_param_names, request).as_json.merge(additional_meta),
      records: collection.map { |item| item_presenter_type.new(item) }
    }
  end
end
