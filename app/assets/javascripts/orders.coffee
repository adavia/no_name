class Order
  constructor: (el) ->
    @el = $(el)

  add_fields: ->
    time = new Date().getTime()
    regexp = new RegExp(@el.data('id'), 'g')
    $('tbody').append(@el.data('fields').replace(regexp, time))
    $('select.dropdown').dropdown()

  remove_fields: ->
    @el.prev('input[type=hidden]').val('1')
    @el.closest('tr').hide()

  change_state: ->
    @el.closest('form').submit()

$(document).on "change", "[data-behavior='order-state-select']", (event) ->
  event.preventDefault()
  order = new Order @
  order.change_state()

$(document).on "click", "[data-behavior='order-add-fields']", (event) ->
  event.preventDefault()
  order = new Order @
  order.add_fields()

$(document).on "click", "[data-behavior='order-remove-fields']", (event) ->
  event.preventDefault()
  order = new Order @
  order.remove_fields()
