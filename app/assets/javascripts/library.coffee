# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('#add_content').click ->
    $('#add_content_panel').show()


  $('.share-expand').click ->
    $(@).removeClass('reduced').addClass('expanded')
