# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  checkProviderFunctions()
  #$('body').on 'change', 'input.publish-on-twitter', ->
  #  enableTwitterFunctions($(this).prop 'checked');
  #$('body').on 'change', 'input.publish-on-facebook', ->
  #  enableFacebookFunctions($(this).prop 'checked');

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
    countTweetLength($('.twitter-text-counter').data('target'), $('.twitter-text-counter').val(), $('#assets .preview').length);
    $('.twitter-text-counter').on 'keyup', ->
      countTweetLength($(this).data('target'), $(this).val(), $('#assets .preview').length);
      return
  else
    $('#twitter_text_counter').hide()
  return

enableFacebookFunctions = (enabled = true) ->
  if enabled
    scrapeLink($('.link-extractor').val(), $('#link_extraction'))
    $('.link-extractor').on 'keyup', ->
      scrapeLink($(this).val(), $('#link_extraction'))
      return
  else
    $('#link_extraction').removeClass('has-result').html('')
    # this also removes the twitter handle function - soooo - recheck this dude!
    $('.link-extractor').off 'keyup'

window.checkProviderFunctions = ->
  enableTwitterFunctions(true);
