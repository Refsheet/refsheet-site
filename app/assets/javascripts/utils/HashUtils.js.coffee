@HashUtils =
  deepUpdateCollectionItem: (object, collectionPath, item, primaryKey) ->
    collection = ObjectPath.get object, collectionPath
    [old, index] = @_findItem collection, item, primaryKey

    if old
      collection[index] = item
    else
      collection.push item

    @set object, collectionPath, collection

  deepSortCollectionItem: (object, collectionPath, item, position, primaryKey) ->
    collection = ObjectPath.get object, collectionPath
    [old, index] = @_findItem collection, item, primaryKey

    if old
      collection.splice index, 1
      collection.splice position, 0, old

    @set object, collectionPath, collection

  deepRemoveCollectionItem: (object, collectionPath, item, primaryKey) ->
    collection = ObjectPath.get object, collectionPath
    [old, index] = @_findItem collection, item, primaryKey

    if old
      collection.splice index, 1

    @set object, collectionPath, collection

  # An immutable variant of ObjectPath.set that saves the original object
  #
  set: (object, path, value) ->
    object = $.extend {}, object
    ObjectPath.set object, path, value
    object

  _findItem: (collection, item, primaryKey='id') ->
    targetKey = if typeof item is 'object' then item[primaryKey] else item
    console.log "===TARGET KEY", targetKey, primaryKey, collection, collection.map (i) -> i[primaryKey]
    old = (collection.filter (i) -> i[primaryKey] == targetKey)[0]
    console.log "===FOUND", old
    index = collection.indexOf(old) if old
    [old, index]
