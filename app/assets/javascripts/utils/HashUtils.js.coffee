@HashUtils =
  deepUpdateCollectionItem: (object, collectionPath, item, primaryKey='id') ->
    collection = ObjectPath.get object, collectionPath
    [old, index] = @_findItem collection, item, primaryKey

    if old
      collection[index] = item
    else
      collection.push collection

    @set object, collectionPath, collection

  deepSortCollectionItem: (object, collectionPath, item, position, primaryKey='id') ->
    collection = ObjectPath.get object, collectionPath
    [old, index] = @_findItem collection, item, primaryKey

    if old
      collection.splice index, 1
      collection.splice position, 0, old

    @set object, collectionPath, collection

  # An immutable variant of ObjectPath.set that saves the original object
  #
  set: (object, path, value) ->
    object = $.extend {}, object
    ObjectPath.set object, path, value
    object

  _findItem: (collection, item, primaryKey) ->
    old = (collection.filter (i) -> i[primaryKey] == item[primaryKey])[0]
    index = collection.indexOf(old) if old
    [old, index]
