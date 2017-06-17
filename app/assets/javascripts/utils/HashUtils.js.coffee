@HashUtils =
  deepUpdateCollectionItem: (object, collectionPath, item, primaryKey='id') ->
    object = $.extend {}, object
    collection = ObjectPath.get(object, collectionPath)

    old = (collection.filter (i) -> i[primaryKey] == item[primaryKey])[0]

    if old
      collection[collection.indexOf(old)] = item
    else
      collection.push collection

    ObjectPath.set(object, collectionPath, collection)
    object
