$(".multiselect").multiselect
  noneSelectedText: 'Select gene families'
  selectedText: '# of #'
.multiselectfilter

$('.tip').tooltip placement: 'right'

$('#loadingBar').show()
$.get '/gene_group_names.json', (data)->
  $('#geneInput').typeahead source: data, items: 20
  $('#loadingBar').hide()

$('#addGene').click ->
    $('#genes')[0].value += $('#geneInput')[0].value + "\n"
    $('#geneInput')[0].value = ''

$('#defaultGenes').click ->
    $('#genes')[0].value = ['STK1','FLT','FLT3','ASDF','QWER','HER2','ERBB2','LOC100508755'].join "\n"
    $('#genes')[0].value += "\n"

$(".btn-primary").click ->
  $("#loading").modal("show")
