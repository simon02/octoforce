# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('#add_category').click ->
    $('#add_category_form').removeClass('hidden').show()
    $("#add_category_form input[type='text'").focus()
