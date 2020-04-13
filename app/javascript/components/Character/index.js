/* do-not-disable-eslint
    constructor-super,
    no-constant-condition,
    no-this-before-super,
    no-unused-vars,
    react/jsx-no-undef,
    react/prop-types,
*/
// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS001: Remove Babel/TypeScript constructor workaround
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import React, { Component } from 'react'
import View from './View'
import { Error } from 'Shared'
import PropTypes from 'prop-types'
import { graphql } from 'react-apollo'
import { getCharacterProfile } from 'queries/getCharacterProfile.graphql'
import { connect } from 'react-redux'
import Loading from '../Shared/views/Loading'

class Character extends Component {
  constructor(props) {
    super(props)
    this.refetch = this.refetch.bind(this)

    this.state = { editable: false }
  }

  refetch() {
    return this.props.data.refetch()
  }

  render() {
    const { data } = this.props

    if (data.loading) {
      return <Loading />
    } else if (data.error) {
      const message = data.error.graphQLErrors.map(e => e.message).join(', ')
      return <Error message={message} />
    } else {
      return (
        <View
          refetch={this.refetch}
          character={data.getCharacterByUrl}
          {...this.state}
        />
      )
    }
  }
}

const mapStateToProps = ({ uploads }) => ({
  files: uploads.files,
})

const Connected = connect(mapStateToProps)(Character)

export default graphql(getCharacterProfile, {
  options(props) {
    return { variables: props.match.params }
  },
})(Connected)
