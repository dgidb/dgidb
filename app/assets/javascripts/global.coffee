$ ->
  $('.tip').tooltip placement: 'right'
  $('a.dropdown-toggle, .dropdown-menu a').on 'touchstart', (e) ->
    e.stopPropagation()
