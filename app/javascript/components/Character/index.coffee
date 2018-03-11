import { Component } from 'react'
import View from './View'
import { Provider } from 'react-redux'
import { createStore } from 'redux'
import { Error } from 'Shared'
import PropTypes from 'prop-types'
import { get } from 'resource'
import _ from 'lodash'

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

  fetch: ({userId, characterId}) ->
    path = "/users/#{userId}/characters/#{characterId}.json"

    @setState loading: true, character: null

    get(path: path, request: (r) => @request = r)
      .then (character) => @setState { character, loading: false }
      .catch (error) => @setState { error, loading: false } if error

  render: ->
    if @state.loading
      `<Loading />`
    else if @state.error
      `<Error message={this.state.error.error} />`
    else
      `<View { ...this.state } { ...this.params } />`
