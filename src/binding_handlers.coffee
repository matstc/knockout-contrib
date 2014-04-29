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

    if allBindingsAccessor? and allBindingsAccessor().length?
      length = allBindingsAccessor().length
    else
      width = parseInt(jElement.css('width') || jElement.parent("[width!='']").css('width'), 10)
      length = width / 6

    if length < 6 then length = 6

    string = ko.utils.unwrapObservable(valueAccessor())
    
    if string.length < length or string.length < 4 then return jElement.text(string)

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
