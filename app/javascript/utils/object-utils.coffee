import _ from 'lodash'

export changes = (a, b) ->
  changedData = {}
  for k, v of b
    changedData[k] = v if a[k] isnt v
  changedData
