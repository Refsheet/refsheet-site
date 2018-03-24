import { request } from 'graphql-request'
import { buildQuery, client } from 'ApplicationService'

CharacterService =
  defaultFields: [
    'id', 'created_at', 'updated_at', 'name', 'slug', 'username', 'species'
  ]


  getCharacter: (variables, fields=@defaultFields) ->
    queryArgs =
      id: 'String!'

    query = buildQuery 'getCharacter',
      queryArgs,
      fields

    client().request query, variables


  getCharacterByUrl: (variables, fields=@defaultFields) ->
    queryArgs =
      username: 'String!'
      slug: 'String!'

    query = buildQuery 'getCharacterByUrl',
      queryArgs,
      fields

    client().request query, variables


  updateCharacter: (id, data) ->
    console.log { id, data }

export default CharacterService
