$ ->
  $("#table-by-source").dataTable
    sPaginationType: "bootstrap"
    iDisplayLength: "50"
    sDom: "<'row'<'span6'l><'span6'f>r>t<'row'<'span6'i><'span6'p>>"
    sWrapper: "dataTables_wrapper form-inline"
    oLanguage:
      sSearch: 'Filter results:'
      sLengthMenu: "_MENU_ records per page"
