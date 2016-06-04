swapNodes = (a, b) ->
  return if a == null || b == null
  a = $(a); b = $(b)
  tmp = $('<span>').hide()
  a.before(tmp)
  b.before(a)
  tmp.replaceWith(b)

$ ->
  $('.move-up').click (e) ->
    e.preventDefault()
    target = $($(this).data('target'))
    selector = $(this).data('selector')
    swap = $(this).data('swappables')
    swapA = target.find(swap)
    console.log(swapA)
    previous = null
    $(selector).find(swap).each ->
      if $(this).is(swapA)
        console.log('match found')
        return false
      previous = $(this)
    console.log(previous)
    swapNodes(swapA, previous)
    swapA.parents(selector).highlight()
    previous.parents(selector).highlight()
    false
  $('.move-to-top2').click (e) ->
    e.preventDefault()
    target = $($(this).data('target'))
    selector = $(this).data('selector')
    swap = $(this).data('swappables')
    swapA = $(target.find(swap))
    $(selector).each (el) ->
      # swapNodes(swapA, $(el).find(swap))
      b = $($(el).find(swap))
      $(el).find(swap).replaceWith(swapA).highlight()
      return if b == swapA
      swapA = b
