$ ->
  $('#container').masonry
    itemSelector: '.item',
    columnWidth: (containerWidth)-> containerWidth/3
