@ObjectPath =
  get: (obj, path) ->
    path = path.split('.')
    parent = obj

    if path.length > 1
      parent = parent[path[i]] for i in [0..path.length - 2]

    parent?[path[path.length - 1]]

  set: (obj, path, value) ->
    path = path.split('.')
    parent = obj

    if path.length > 1
      parent = (parent[path[i]] ||= {}) for i in [0..path.length - 2]

    parent[path[path.length - 1]] = value
