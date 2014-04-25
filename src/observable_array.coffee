(->
  predicate = (one, other) -> one.id? and one.id == other.id

  persistedItemsWithoutAMatch = (array1, array2) ->
    items = []
    for one in array1
      match = _.find array2, (other) -> predicate(one, other)
      items.push(one) unless match or not one.id?
    items

  copyProperties = (destination, source) ->
    for key in Object.keys source
      if ko.isObservable(destination[key])
        destination[key] ko.unwrap source[key]
      else
        destination[key] = source[key]

  ko.observableArray.fn.refresh = (array) ->
    @removeAll persistedItemsWithoutAMatch @(), array

    for item in array
      observed = _.find @(), (observed) -> predicate(observed, item)
      (@push item; continue) if not observed?
      copyProperties(observed, item) if not item.updatedAt? or item.updatedAt > observed.updatedAt
)()
