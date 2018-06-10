import _ from 'lodash'

export changes = (a, b) ->
  changedData = {}
  for k, v of b
    changedData[k] = v if a[k] isnt v
  changedData

export camelize = (obj) ->
  return obj unless _.isObject obj
  out = {}
  for k, v of obj
    out[_.camelCase k] = camelize v
  out
