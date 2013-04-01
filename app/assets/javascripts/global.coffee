$ ->
  $('.tip').tooltip placement: 'right'
  $('a.dropdown-toggle, .dropdown-menu a').on 'touchstart', (e) ->
    e.stopPropagation()

  unless $.cookie('disclaimer_viewed')
    $('#disclaimer-modal').modal()
    $.cookie('disclaimer_viewed', 'true')

