import { GraphQLClient } from 'graphql-request'

endpoint = 'http://dev.refsheet.net:5000/graphql'

defaultOptions = ->
  headers: {
    'X-CSRF-Token': document.getElementsByName('csrf-token')[0].content
    'Content-Type': 'application/json'
    'Accept': 'application/json'
    'X-Requested-With': 'XMLHttpRequest'
  }
  credentials: 'same-origin'

export client = ->
  new GraphQLClient endpoint, defaultOptions()

export buildFields = (fields) ->
  fieldList = []

  if Array.isArray fields
    for f in fields
      fieldList.push buildFields(f)
  else if typeof fields is 'object'
    for k, v of fields
      fieldList.push "#{k} { #{buildFields(v)} }"
  else
    fieldList.push fields

  fieldList.join(' ')

export buildQuery = (query, variables, fields...) ->
  queryVariables = Object.keys(variables).map((k) -> "$#{k}: #{variables[k]}").join(', ')
  interpolatedVariables = Object.keys(variables).map((k) -> "#{k}: $#{k}").join(', ')

  structure = [
    "query #{query}(#{queryVariables})"
    "#{query}(#{interpolatedVariables})"
    buildFields(fields)
  ]

  structure.join(' { ') + Array(structure.length).join(' }')
