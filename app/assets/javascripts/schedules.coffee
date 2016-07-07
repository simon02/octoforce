# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('.add-timeslot').click ->
    form = $(($(@).data('target'))).find('form')
    day = $(@).data('day')
    time = $(@).data('time')
    form.find("select option[value='#{day}']").prop('selected','selected')
    form.find("input[id='timeslot_offset']").val(time || '')
    form.find("input[type='checkbox']").each ->
      $(this).prop('checked', true)
    form.removeClass('hidden').show()

