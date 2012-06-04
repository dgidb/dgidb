$('.tip').tooltip placement: 'right'

$('#loadingBar').show()
$.get '/gene_group_names.json', (data)->
  $('#geneInput').typeahead source: data, items: 20
  $('#loadingBar').hide()

$('#addGene').click ->
    $('#genes')[0].value += $('#geneInput')[0].value + "\n"
    $('#geneInput')[0].value = ''

$('#defaultGenes').click ->
    $('#genes')[0].value = ['FLT1','FLT2','FLT3','STK1','MM1','LOC100508755','FAKE1'].join "\n"
    $('#genes')[0].value += "\n"
