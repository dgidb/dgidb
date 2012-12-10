# bootstrap-tour.js v0.0.2
# Copyright 2012 Gild, Inc.
#
# Free to use under the MIT license.
# http://www.opensource.org/licenses/mit-license.php

# References jQuery
$ = jQuery

# based on jQuery Cookie plugin
# Copyright (c) 2010 Klaus Hartl (stilbuero.de)
# Dual licensed under the MIT and GPL licenses:
# http://www.opensource.org/licenses/mit-license.php
# http://www.gnu.org/licenses/gpl.html
cookie = (key, value, options) ->
  if arguments.length > 1 and String(value) isnt "[object Object]"
    options = jQuery.extend({}, options)
    options.expires = -1 unless value?
    if typeof options.expires is "number"
      days = options.expires
      t = options.expires = new Date()
      t.setDate t.getDate() + days
    value = String(value)
    return (document.cookie = [ encodeURIComponent(key), "=", (if options.raw then value else encodeURIComponent(value)), (if options.expires then "; expires=" + options.expires.toUTCString() else ""), (if options.path then "; path=" + options.path else ""), (if options.domain then "; domain=" + options.domain else ""), (if options.secure then "; secure" else "") ].join(""))
  options = value or {}
  result = undefined
  decode = (if options.raw then (s) ->
    s
  else decodeURIComponent)
  return (if (result = new RegExp("(?:^|; )" + encodeURIComponent(key) + "=([^;]*)").exec(document.cookie)) then decode(result[1]) else null)

# Adds plugin object to jQuery
$.fn.extend {}=

  featureTour: (options) ->
    # Default settings
    settings =
      tipContent: '#featureTourTipContent' # What is the ID of the <ol> you put the content in
      cookieMonster: false                 # true or false to control whether cookies are used
      cookieName: 'bootstrapFeatureTour'   # Name the cookie you'll use
      cookieDomain: false                  # Will this cookie be attached to a domain, ie. '.mydomain.com'
      postRideCallback: $.noop             # A method to call once the tour closes
      postStepCallback: $.noop             # A method to call after each step
      nextOnClose: false                   # If cookies are enabled, increment the current step on close
      debug: false
    # Merge default settings with options.
    settings = $.extend settings, options
    # Simple logger.
    log = (msg) ->
      console?.log('[bootstrap-tour]', msg) if settings.debug

    # returns current step stored in the cookie, or `1` if cookie disabled, no
    # cookie or invalid cookie value
    currentStep = ->
      return 1 unless settings.cookieMonster
      current_cookie = cookie(settings.cookieName)
      # start from step 1 if there's no cookie set
      return 1 unless current_cookie?
      try
        return parseInt(current_cookie)
      catch e
        # start from step 1 if there cookie is invalid
        return 1

    setCookieStep = (step) ->
      cookie(settings.cookieName, "#{step}", { expires: 365, domain: settings.cookieDomain }) if settings.cookieMonster

    return @each () ->

      $tipContent = $(settings.tipContent).first()
      unless $tipContent?
        log "can't find tipContent from selector: #{settings.tipContent}"

      $tips = $tipContent.find('li')

      first_step = currentStep()
      log "first step: #{first_step}"

      if first_step > $tips.length
        log 'tour already completed, skipping'
        return

      $tips.each (idx) ->
        # skip steps until we reach the first one
        if idx < (first_step - 1)
          log "skipping step: #{idx + 1}"
          return

        $li = $(@)
        tip_data = $li.data()
        return unless (target = tip_data['target'])?
        return unless ($target = $(target).first())?

        $target.popover
          trigger: 'manual'
          title: if tip_data['title']? then "#{tip_data['title']} <a class=\"tour-tip-close close\" data-touridx=\"#{idx + 1}\">&times;</a>" else null
          html: true
          content: "<p>#{$li.html()}</p><p style=\"text-align: right\"><a href=\"#\" class=\"tour-tip-next btn btn-success\" data-touridx=\"#{idx + 1}\">#{if (idx + 1) < $tips.length then 'Next <i class="icon-chevron-right icon-white"></i>' else '<i class="icon-ok icon-white"></i> Done'}</a></p>"
          placement: tip_data['placement'] || 'right'

        # save the target element in the tip node
        $li.data('target', $target)

        # show the first tip
        $target.popover('show') if idx == (first_step - 1)

      # handle the close button
      $('a.tour-tip-close').live 'click', ->
        current_step = $(@).data('touridx')
        $(settings.tipContent).first().find("li:nth-child(#{current_step})").data('target').popover('hide')
        setCookieStep(current_step + 1) if settings.nextOnClose

      # handle the next and done buttons
      $('a.tour-tip-next').live 'click', ->
        current_step = $(@).data('touridx')
        log "current step: #{current_step}"
        $(settings.tipContent).first().find("li:nth-child(#{current_step})").data('target').popover('hide')
        settings.postStepCallback($(@).data('touridx')) if settings.postStepCallback != $.noop
        next_tip = $(settings.tipContent).first().find("li:nth-child(#{current_step + 1})")?.data('target')
        setCookieStep(current_step + 1)
        if next_tip?
          next_tip.popover('show')
        else
          # last tip
          settings.postRideCallback() if settings.postRideCallback != $.noop
