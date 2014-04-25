describe "Observable array", ->
  it "removes multiple elements safely", ->
    observable = ko.observableArray [{id:1}, {id:2}]
    observable.refresh []
    expect(observable()).toEqual []

  it "never removes elements that don't have IDs", ->
    observable = ko.observableArray [{a:1}]
    observable.refresh []
    expect(observable()).toEqual [{a:1}]

  it "updates existing observables already attached", ->
    attachedObservable = ko.observable("old value")
    observable = ko.observableArray [{id:1, updatedAt: "2014-04-18T17:37:04.213Z", attachedObservable:attachedObservable}]
    observable.refresh [{id:1, updatedAt: "2014-04-18T17:38:04.213Z", attachedObservable:ko.observable("new value")}]

    expect(observable()[0].attachedObservable).toBe attachedObservable
    expect(observable()[0].attachedObservable()).toEqual "new value"

  it "updates an item from an observable array if the updatedAt timestamp has changed", ->
    observable = ko.observableArray [{id:1, updatedAt: "2014-04-18T17:37:04.213Z", a:1}]
    observable.refresh [{id:1, updatedAt: "2014-04-18T17:37:04.213Z", a:2}]
    expect(observable()).toEqual [{id:1, updatedAt: "2014-04-18T17:37:04.213Z", a:1}]
    observable.refresh [{id:1, updatedAt: "2014-04-18T17:38:04.213Z", a:2}]
    expect(observable()).toEqual [{id:1, updatedAt: "2014-04-18T17:38:04.213Z", a:2}]

  it "merges an array of items into an observable array and removes items not found", ->
    observable = ko.observableArray [{id:1, a:1}, {id:2, a:2}, {id:3, a:3}]
    refresh    = [{id:1, a:4}, {id:2, a:5}]
    observable.refresh refresh
    expect(observable()).toEqual refresh

  it "merges an array of items into an observable array with same item ids", ->
    observable = ko.observableArray [{id:1, a:1}, {id:2, a:2}, {id:3, a:3}]
    refresh    = [{id:1, a:4}, {id:2, a:5}, {id:3, a:6}]
    observable.refresh refresh
    expect(observable()).toEqual refresh

  it "merges an array of items into empty observable array", ->
    observable = ko.observableArray []
    refresh = [{a:1},{a:2},{a:3}]
    observable.refresh refresh
    expect(observable()).toEqual refresh

