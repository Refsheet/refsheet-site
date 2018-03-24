import { request } from 'graphql-request'
import { buildQuery, client } from 'ApplicationService'

CharacterService =
  getCharacter: (id) ->
    variables =
      characterId: id

    query = buildQuery 'getCharacter', { characterId: 'String!' }, 'id name'

    client.request query, variables

  updateCharacter: (id, data) ->
    console.log { id, data }

export default CharacterService
