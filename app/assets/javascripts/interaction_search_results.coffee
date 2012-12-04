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

  $("#interaction_tab").tab("show")

  #$("#search-again").on 'click', ->
    #gene_symbols = []
    #$("button.active").each -> gene_symbols.push $(this).val()
    #gene_symbols = [gene_symbols.join("\n"), $("#definite_results").val(), $("#no_results").val()].join("\n")
    #$.post(


