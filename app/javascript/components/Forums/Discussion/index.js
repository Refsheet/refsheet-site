import React, { Component } from 'react'
import PropTypes from 'prop-types'
import { graphql } from 'react-apollo'
import getDiscussion from './getDiscussion.graphql'
import Error from '../../Shared/Error'
import View from './View'

class Discussion extends Component {
  render() {
    const { data } = this.props

    if (data.loading) {
      return <Loading />
    } else if (data.error) {
      const message = data.error.graphQLErrors.map(e => e.message).join(', ')
      return <Error message={message} />
    } else {
      return <View discussion={data.getDiscussion} {...this.state} />
    }
  }
}

Discussion.propTypes = {}

export default graphql(getDiscussion, {
  options: props => ({
    variables: props.match.params,
    errorPolicy: 'all',
  }),
})(Discussion)
