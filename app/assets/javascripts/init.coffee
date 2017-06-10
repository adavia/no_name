class Init
  constructor: (el) ->
    $('select.dropdown').dropdown()


$(document).on "turbolinks:load", ->
  init = new Init @