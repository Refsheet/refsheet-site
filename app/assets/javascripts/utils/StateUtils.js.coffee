@StateUtils =
  load: (context, path, props=context.props) ->
    { dataPath, paramMap } = context
    eagerLoad = context.context.eagerLoad
    state = $.extend {}, context.state
    fetch = true

    if elItem = ObjectPath.get eagerLoad, path
      for k, p of paramMap
        a = ObjectPath.get props.params, k
        b = ObjectPath.get elItem, p
        console.debug '[StateUtils] Comparing:', a, b
        fetch = false if a and b and a.toUpperCase() is b.toUpperCase()

      unless fetch
        console.debug '[StateUtils] Eager Loading:', elItem
        ObjectPath.set state, path, elItem
        context.setState state

    if fetch
      fetchUrl = dataPath.replace /(:[a-zA-Z]+)/, (m) ->
        ObjectPath.get props.params, m.substring(1)

      Model.get fetchUrl, (data) ->
        ObjectPath.set state, path, data
        context.setState state

      , (error) ->
        context.setState error: error

      $(window).scrollTop 0

  reload: (context, path, newProps, oldProps=context.props) ->
    fetch = false

    for k, p of context.paramMap
      a = ObjectPath.get oldProps.params, k
      b = ObjectPath.get newProps.params, k

      if a and b and a.toUpperCase() isnt b.toUpperCase()
        fetch = true
        break

    if fetch
      StateUtils.load context, path, newProps
      $(window).scrollTop 0


  updateItem: (context, path, item, primaryKey, callback) ->
    context.setState HashUtils.deepUpdateCollectionItem(context.state, path, item, primaryKey), callback

  sortItem: (context, path, item, position, primaryKey, callback) ->
    context.setState HashUtils.deepSortCollectionItem(context.state, path, item, position, primaryKey), callback

  removeItem: (context, path, item, primaryKey, callback) ->
    context.setState HashUtils.deepRemoveCollectionItem(context.state, path, item, primaryKey), callback
