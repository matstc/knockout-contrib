ko.bindingHandlers.currency = {
  update: (element, valueAccessor, allBindingsAccessor) ->
    return ko.bindingHandlers.text.update element, ->
      value = +(ko.utils.unwrapObservable(valueAccessor()) || 0)
      symbol = ko.utils.unwrapObservable(
        if allBindingsAccessor().symbol == undefined then '€' else allBindingsAccessor().symbol
      )
      return value.toFixed(2) + ' ' + symbol
}

ko.bindingHandlers.ellipsis = {
  update: (element, valueAccessor, allBindingsAccessor) ->

    jElement = $(element)
    string = ko.utils.unwrapObservable(valueAccessor())
    jElement.text string

    width = jElement.width() || jElement.parent("[width!='']").width()
    length = width / 8
    if length < 6 then length = 6

    if string.length < length or string.length < 4 then return

    ellipsis = string.substr(0, length - 3) + '...'

    if !allBindingsAccessor? or !allBindingsAccessor().ellipsisClick? then return jElement.text(ellipsis)

    jElement.text("")
    anchor = $('<a>' + ellipsis + '</a>')
    anchor.click allBindingsAccessor().ellipsisClick
    anchor.appendTo element

    undefined
}

ko.bindingHandlers.ellipsis.init = (element, valueAccessor, allBindingsAccessor) ->
  $(window).on 'resize', ->
    ko.bindingHandlers.ellipsis.update(element, valueAccessor, allBindingsAccessor)

ko.bindingHandlers.delayed = {
  init: (element, valueAccessor, allBindings, viewModel, bindingContext) ->
    delay = ko.unwrap(allBindings().delay || 500)
    ko.virtualElements.childNodes(element).forEach (node) ->
      node.style.display = 'none' if node.style?

    loader = $("<img src='" + ko.unwrap(allBindings().src) + "'>")[0]
    ko.virtualElements.insertAfter(element, loader)

    setTimeout ->
      ko.applyBindingsToDescendants(bindingContext, element)
      ko.virtualElements.childNodes(element).forEach (node) ->
        node.style.display = '' if node.style?

      ko.removeNode loader
    , delay

    { controlsDescendantBindings: true }
}

ko.virtualElements.allowedBindings.delayed = true
