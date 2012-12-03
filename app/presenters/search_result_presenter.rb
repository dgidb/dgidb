
class SearchResultPresenter
  include Genome::Extensions

  @@class_to_partials = {}

  def initialize(result)
    @result = result
    class_name = @result.class.name

    unless @@class_to_partials.has_key? class_name
      @@class_to_partials[class_name] = class_name.split("::").last.underscore
    end

    @partial_name = "search/#{@@class_to_partials[class_name]}_search_result"
  end

  def render_result(context)
    context.render  partial: @partial_name, locals: {r: @result}
  end

end
