$('.tip').tooltip placement: 'right'
$.get '/gene_groups/names.json', (data)-> $('#geneInput').typeahead source: data, items: 20
