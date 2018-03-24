import { GraphQLClient } from 'graphql-request'

endpoint = 'http://localhost:5000/graphql'
defaultOptions = {}

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

export buildQuery = (query, objectType=undefined, variables, fields...) ->
  objectType ||= query.replace 'get', ''

  queryVariables = Object.keys(variables).map((k) -> "$#{k}: #{variables[k]}").join(', ')
  interpolatedVariables = Object.keys(variables).map((k) -> "#{k}: $#{k}").join(', ')

  structure = [
    "query #{query}(#{queryVariables})"
    "#{objectType}(#{interpolatedVariables})"
    buildFields(fields)
  ]

  structure.join(' { ') + Array(structure.length).join(' }')

export client = new GraphQLClient endpoint, defaultOptions
