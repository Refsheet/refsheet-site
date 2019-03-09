import React, { Component } from 'react'
import View from './View'
import { Error } from 'Shared'
import PropTypes from 'prop-types'
import { graphql } from 'react-apollo'
import { getCharacterProfile } from 'queries/getCharacterProfile.graphql'
import {connect} from "react-redux"

class Character extends Component
  constructor: (props) ->
    super props

    @state =
      editable: false
      uploadOpen: false

  handleUploadModalOpen: () =>
    @setState uploadOpen: true

  handleUploadModalClose: () =>
    @setState uploadOpen: false

  componentWillReceiveProps: (newProps) =>
    console.log({newProps})
    if newProps.files.length > @props.files.length
      @setState uploadOpen: true

  refetch: () =>
    @props.data.refetch()

  render: ->
    { data } = @props

    if data.loading
      `<Loading />`
    else if data.error
      message = data.error.graphQLErrors.map((e) -> e.message).join(', ')
      `<Error message={message} />`
    else
      `<View onUploadModalOpen={this.handleUploadModalOpen}
             onUploadModalClose={this.handleUploadModalClose}
             onChange={this.refetch}
             character={data.getCharacterByUrl}
             {...this.state}
      />`

mapStateToProps = ({uploads}) ->
  files: uploads.files

Connected = connect(mapStateToProps)(Character)

export default graphql(
  getCharacterProfile
  options: (props) ->
    variables: props.match.params
)(Connected)
