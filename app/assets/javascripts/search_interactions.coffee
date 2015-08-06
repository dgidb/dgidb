$(".multiselect").multiselect
  noneSelectedText: 'Select included items'
  selectedText: '# of #'
  minWidth: 400
.multiselectfilter()
$(".multiselect").multiselect("checkAll")



# testing this from http://goo.gl/69VtL2  perhaps updating $ta will serve purpose?
ta = $('#identifiers').typeahead
  items: 20
  updater: (item)->
    oldval = this.$element[0]?.value?.split("\n")[0..-2].join("\n")
    (if oldval then oldval + "\n" else ""  ) + item + "\n"

$('#loadingBar').show()
$.get '/gene_names.json', (data)->
  ta.data('typeahead').source = data
  $('#loadingBar').hide()

$('#geneSearch').click ->
  $('#loadingBar').show()
  $.get '/gene_names.json', (data)->
    ta.data('typeahead').source = data
    $('#loadingBar').hide()

$('#drugSearch').click ->
  $('#loadingBar').show()
  $.get '/drug_names.json', (data)->
    ta.data('typeahead').source = data
    $('#loadingBar').hide()

$('#defaultGenes').click ->
    $('#genes')[0].value = ['FLT1','FLT2','FLT3','STK1','MM1','AQP9','LOC100508755','FAKE1'].join "\n"
    $('#genes')[0].value += "\n"

$('#clear').click ->
    $('#identifiers')[0].value = []

$(".btn-success").click ->
  $("#loading").modal("show")

$(window).unload ->
  $("#loading").modal("hide")

$.valHooks.textarea =
    get: (elem) ->
      if elem.id.indexOf('feedback') != -1
        elem.value
      else
        elem.value.replace(/(\n|\r)+$/,"").split("\n").splice(-1,1)[0]

$("#genes").focus()

