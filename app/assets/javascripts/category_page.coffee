$ ->
  $(".table").dataTable
    sPaginationType: "bootstrap"
    sDom: "<'row'<'span6'l><'span6'f>r>t<'row'<'span6'i><'span6'p>>"
    sWrapper: "dataTables_wrapper form-inline"
    aLengthMenu: [[50, 100, 250, -1], [50, 100, 250, "All"]]
    iDisplayLength: 50
    oLanguage:
      sSearch: 'Filter results:'
      sLengthMenu: "_MENU_ records per page"
