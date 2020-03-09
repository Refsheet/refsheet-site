class @StringUtils
  @camelize: (string) =>
    #
    # by http://stackoverflo.com/users/140811/scott
    # at http://stackoverflow.com/a/2970588/6776673

    return string
      .toLowerCase()
      .replace /_(.)/g, ($1) => $1.toUpperCase()
      .replace /_/g, ''

  @camelizeKeys: (object) =>
    out = {}

    for k,v of object
      out[@camelize(k)] = v

    return out

  @unCamelize: (string) =>
    return string
      .replace /([a-z])([A-Z])/g, (a, $0, $1) =>  $0 + "_" + $1.toLowerCase()

  @unCamelizeKeys: (object) =>
    out = {}

    for k,v of object
      out[@unCamelize(k)] = v

    return out

  @indifferentKeys: (object) =>
    out = {}

    for k,v of object
      out[k] = v
      out[@camelize(k)] = v

    return out
