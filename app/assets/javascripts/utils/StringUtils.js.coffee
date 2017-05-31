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
