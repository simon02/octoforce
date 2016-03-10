# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('.add-timeslot').click ->
    form = $(($(@).data('add-timeslot')))
    day = $(@).data('day')
    form.find("select option[value='#{day}']").prop('selected','selected')
    form.removeClass('hidden').show().find('input[type!="hidden"]:first').focus()

  $('#share_expand').click ->
    $(@).addClass('expanded')
    $(@).find('textarea').attr('rows', '3')
    $(@).find('.hidden').removeClass('hidden')

  $('.fileinput-button').fileupload({
      add: (e,data) ->
        $(e.target).find('.text').text('image ready')
        console.log data
    })
