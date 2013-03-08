window.export_table = (table_selector) ->
  loading = $('#loadingBar-' + table_selector)
  export_link = $('#exportLink-' + table_selector)
  export_link.hide()
  loading.show()
  dt = $("#" + table_selector).dataTable()
  row_data = dt.fnSettings().aoData
  headers = dt.fnSettings().aoHeader[0].map (c) ->
    $(c.cell).text().trim()
  .join("%09")
  tsv = row_data.map (row) ->
    row._aData.map (cell) ->
      try
       $(cell).text().replace(/\s{2,}/g , ' ') || cell
      catch err
        cell
    .join("%09")
  .join("%0A")
  data = headers + "%0A" + tsv
  $('<form action="/download_table" method="POST"/>')
    .append($('<input type="hidden" name="file_contents" value="' + data + '">'))
    .appendTo($(document.body))
    .submit()
  loading.hide()
  export_link.show()
  false
