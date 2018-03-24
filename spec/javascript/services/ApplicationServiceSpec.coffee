import { expect } from 'chai'
import { buildQuery, client } from 'ApplicationService'
import nock from 'nock'

describe 'ApplicationService', ->
  describe 'buildQuery', ->
    def('queryName', -> 'getCharacter')
    def('objectType', -> 'Character')
    def('queryVars', -> id: 'String!')
    def('queryFields', -> 'id name')

    subject(-> buildQuery $queryName, $objectType, $queryVars, $queryFields)

    it 'builds basic query', ->
      expect($subject).to.equal 'query getCharacter($id: String!) { Character(id: $id) { id name } }'

    context 'with complicated query', ->
      def('queryFields', -> ['id', {image: ['name', 'caption']}])

      it 'generates correct query', ->
        expect($subject).to.equal 'query getCharacter($id: String!) { Character(id: $id) { id image { name caption } } }'

    it 'makes valid request', ->
      nock('http://localhost').get(/graphql/).reply(200, 'foo')
      r = client.request $subject, id: 9

      r.then (data) ->
        expect(data).to.eq 'foo'
