$ ->
  $(".table[id!='table-by-source'][id!='refine-results-table']").dataTable
    sPaginationType: "bootstrap"
    sDom: "<'row'<'span6'l><'span6'f>r>t<'row'<'span6'i><'span6'p>>"
    sWrapper: "dataTables_wrapper form-inline"
    oLanguage:
      sSearch: 'Filter results:'
      sLengthMenu: "_MENU_ records per page"

  lastCol = $('#table-by-source th').size()-1
  $("#table-by-source").dataTable
    aaSorting: [[lastCol, "desc"], [0, "asc"]]
    sPaginationType: "bootstrap"
    iDisplayLength: "50"
    sDom: "<'row'<'span6'l><'span6'f>r>t<'row'<'span6'i><'span6'p>>"
    sWrapper: "dataTables_wrapper form-inline"
    oLanguage:
      sSearch: 'Filter results:'
      sLengthMenu: "_MENU_ records per page"

#  $("#summary").tab("show")

# Following snippet from: http://stackoverflow.com/a/19015027
  $('#myTab a').click (e) ->
    e.preventDefault()
    $(this).tab 'show'
    return
# store the currently selected tab in the hash value
  $('ul.nav-tabs > li > a').on 'shown.bs.tab', (e) ->
    id = $(e.target).attr('href').substr(1)
    window.location.hash = id
    return
# on load of the page: switch to the currently selected tab
  hash = window.location.hash
  $('#myTab a[href="' + hash + '"]').tab 'show'


#truncate long gene names
  $(".truncate").trunk8()
  #activate on window resize too
  $(window).smartresize (event) -> $('.truncate').trunk8()

  #$("#search-again").on 'click', ->
    #gene_symbols = []
    #$("button.active").each -> gene_symbols.push $(this).val()
    #gene_symbols = [gene_symbols.join("\n"), $("#definite_results").val(), $("#no_results").val()].join("\n")
    #$.post(


