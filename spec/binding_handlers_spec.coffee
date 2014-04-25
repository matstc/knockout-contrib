describe "Ellipsis binding handler", ->
  it "abbreviates a long string", ->
    element = $("<div style='width:60px'></div>")
    ko.bindingHandlers.ellipsis.update(element[0], -> "this is a long sentence")
    expect(element.text()).toBe "this is..."

  it "keeps at least three characters from the initial string", ->
    element = $("<div style='width:1px'></div>")
    ko.bindingHandlers.ellipsis.update(element[0], -> "this is a long sentence")
    expect(element.text()).toBe "thi..."

  it "sets up an anchor with the specified click handler", ->
    parent = $("<div style='width:1px'></div>")
    element = $("<span></span>")
    element.appendTo parent

    handler = ->
    ko.bindingHandlers.ellipsis.update(element[0], ( -> "this is a long sentence" ), -> {ellipsisClick: handler})
    expect($._data(element.find("a")[0], "events").click[0].handler).toBe handler

describe "Currency binding handler", ->
  it "rounds to two decimals and adds a euro sign", ->
    element = $("<span></span>")[0]
    ko.bindingHandlers.currency.update element, (-> "1.234"), (-> {})

    expect(element.innerText).toEqual '1.23 €'
