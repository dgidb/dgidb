window.export_table = (table_selector) ->
  loading = $('#loadingBar-' + table_selector)
  export_link = $('#exportLink-' + table_selector)
  export_link.hide()
  loading.show()
  dt = $("#" + table_selector).dataTable()
  row_data = dt.fnSettings().aoData
  tsv = row_data.map (row) ->
    row._aData.map (cell) ->
      try
       $(cell).text().replace(/\s{2,}/g , ' ') || cell
      catch err
        cell
    .join("%09")
  .join("%0A")
  loading.hide()
  export_link.html('<small><a href="data:text/tsv;charset=utf8,' + tsv + '">Download TSV</a></small>')
  export_link.show()
  false
