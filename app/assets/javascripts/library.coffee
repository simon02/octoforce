# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  checkProviderFunctions()
  $('body').on 'change', 'input.publish-on-twitter', ->
    enableTwitterFunctions($(this).prop 'checked');
  $('body').on 'change', 'input.publish-on-facebook', ->
    enableFacebookFunctions($(this).prop 'checked');

  $('.share-expand').click ->
    $(@).removeClass('reduced').addClass('expanded')

  $('.jquery-upload-form').each ->
    assets = $(@).find('.assets')
    asset_id_field = $(@).find('input[name="post[asset_id]"]')
    $(@).find('.remove-attachment').click ->
      assets.empty()
      asset_id_field.val('').trigger('change')

enableTwitterFunctions = (enabled = true) ->
  if enabled
    $('#twitter_text_counter').show()
    countTweetLength($('.twitter-text-counter').data('target'), $('.twitter-text-counter').val(), 0);
    $('.twitter-text-counter').on 'keyup', ->
      countTweetLength($(this).data('target'), $(this).val(), 0);
  else
    $('#twitter_text_counter').hide()

enableFacebookFunctions = (enabled = true) ->
  enabled = false
  if enabled
    scrapeLink($('.link-extractor').val(), $('#link_extraction'))
    $('.link-extractor').on 'keyup', ->
      scrapeLink($(this).val(), $('#link_extraction'))
  else
    $('#link_extraction').removeClass('has-result').html('')
    $('.link-extractor').off 'keyup'

window.checkProviderFunctions = ->
  enableTwitterFunctions($('input.publish-on-twitter').prop 'checked');
  enableFacebookFunctions($('input.publish-on-facebook').prop 'checked');
