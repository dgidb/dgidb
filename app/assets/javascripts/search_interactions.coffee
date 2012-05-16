$('.tip').tooltip placement: 'right'

$.get '/gene_group_names.json', (data)->
  $('#geneInput').typeahead source: data, items: 20
  $('#loadingBar').hide()

$('#addGene').click ->
    $('#genes')[0].value += $('#geneInput')[0].value + "\n"
    $('#geneInput')[0].value = ''
