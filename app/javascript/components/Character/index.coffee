import React, { Component } from 'react'
import View from './View'
import { Error } from 'Shared'
import PropTypes from 'prop-types'
import { graphql } from 'react-apollo'
import { getCharacterProfile } from 'queries/getCharacterProfile.graphql'

class Character extends Component
  constructor: (props) ->
    super props

    @state =
      editable: false

  render: ->
    { data } = @props

    if data.loading
      `<Loading />`
    else if data.error
      message = data.error.graphQLErrors.map((e) -> e.message).join(', ')
      `<Error message={message} />`
    else
      `<View character={data.getCharacterByUrl} {...this.state} />`

export default graphql(
  getCharacterProfile
  options: (props) ->
    variables: props.match.params
)(Character)
