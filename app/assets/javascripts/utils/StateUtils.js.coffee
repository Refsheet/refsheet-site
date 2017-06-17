@StateUtils =
  updateItem: (context, path, item, primaryKey) ->
    context.setState HashUtils.deepUpdateCollectionItem context.state, path, item, primaryKey

  sortItem: (context, path, item, position, primaryKey) ->
    context.setState HashUtils.deepSortCollectionItem context.state, path, item, position, primaryKey
