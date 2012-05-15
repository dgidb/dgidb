$('.tip').tooltip placement: 'right'
$.get '/gene_group_names.json', (data)-> $('#geneInput').typeahead source: data, items: 20
