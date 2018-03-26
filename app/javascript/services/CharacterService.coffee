import { client } from 'ApplicationService'
import { getCharacterProfile, getCharacterProfileById } from 'queries/getCharacterProfile.graphql'

CharacterService =
  getCharacter: (variables, fields=null) ->
    client.query query: getCharacterProfileById, variables: variables

  getCharacterByUrl: (variables, fields=null) ->
    client.query query: getCharacterProfile, variables: variables

  updateCharacter: (id, data) ->
    console.log { id, data }

export default CharacterService
