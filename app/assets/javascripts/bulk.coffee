doOnAllElements = (elements, fnc, fncSelector) ->
  elements.each ->
    fnc.call(fncSelector.call(this))

doOnAllSelected = (fnc, fncSelector) ->
  doOnAllElements($('.row-selector:checked'), fnc, fncSelector)

window.removeSelected = ->
  doOnAllSelected deleteElement, ->
    $(this).parents('tr')

window.highlightSelected = ->
  doOnAllSelected highlight, ->
    $(this).parents('tr')

window.setCategorySelected = (value) ->
  doOnAllSelected changeCategory, ->
    $(this).parents('tr').find('select')

window.selectAllSelected = (selector, value) ->
  doOnAllSelected ->
    selectCheckbox.call this, value
  , ->
    $(this).parents('tr').find(selector)

selectCheckbox = (checked) ->
  $(this).prop('checked', checked)
changeCategory = (value) ->
  $(this).val(value);
deleteElement = ->
  $(this).fadeOut 500, ->
    $(this).remove()
highlight = ->
  $(this).highlight()
