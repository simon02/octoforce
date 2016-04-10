# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('#add_content').click ->
    $('#add_content_panel').show()


  $('.share-expand').click ->
    $(@).removeClass('reduced').addClass('expanded')

  $('.jquery-upload-form').each ->
    assets = $(@).find('.assets')
    asset_id_field = $(@).find('input[name="post[asset_id]"]')
    $(@).find('.remove-attachment').click ->
      assets.empty()
      asset_id_field.val('').trigger('change')
