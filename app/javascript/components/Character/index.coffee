import { Component } from 'react'
import View from './View'
import { Provider } from 'react-redux'
import { createStore } from 'redux'
import { Error } from 'Shared'
import PropTypes from 'prop-types'
import { get, put } from 'resource'
import _ from 'lodash'
import { changes } from 'object-utils'

export default class extends Component
  @propTypes:
    params: PropTypes.object

  constructor: (props) ->
    super props

    @state =
      character: null
      loading: true
      error: null

  componentDidMount: ->
    @fetch @props.params

  componentWillReceiveProps: (newProps) ->
    unless _.isEqual @props.params, newProps.params
      @fetch newProps.params

  componentWillUnmount: ->
    @request?.cancel()

  fetch: ({userId, characterId}) =>
    path = "/users/#{userId}/characters/#{characterId}.json"

    @setState loading: true, character: null

    get(path: path, request: (r) => @request = r)
      .then (character) => @setState { character, loading: false }
      .catch (error) =>
        throw error
        @setState { error, loading: false } if error

  update: (data) =>
    { character } = @state
    path = "/users/#{character.user_id}/characters/#{character.id}.json"
    changedData = changes character, data
    console.log { changedData }

    @setState backgroundLoading: true

    put(path: path, params: character: changedData, request: (r) => @request = r)
      .then (character) => @setState { character, backgroundLoading: false }
      .catch (error) =>
        console.error "ERROR CAUGHT: #{error}"
        return unless error
        Materialize.toast error.error || 'Unknown error.'
        @setState backgroundLoading: false

  render: ->
    if @state.loading
      `<Loading />`
    else if @state.error
      `<Error message={this.state.error.error} />`
    else
      `<View { ...this.state } { ...this.params } onChange={this.update} />`
