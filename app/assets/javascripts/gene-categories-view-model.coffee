class GeneCategoriesViewModel
  constructor: (initial_sources) ->
    @sources = ko.observableArray(initial_sources)
    @categories = ko.observableArray()

    ko.computed () =>
      $.get '/api/v1/gene_categories_for_sources.json', { sources: @sources }, (data) =>
        mapped_categories = $.map(data, (item) =>
          {
            text: item.name + " (" + item.gene_count + ")"
            link: '/druggable_gene_categories/' + item.name + '?sources=' + @sources().join()
          }
        )
        @categories(mapped_categories)
    .extend({ throttle: 250 })

$ ->
  ko.applyBindings(new GeneCategoriesViewModel($('#source-list').data('sources')))
