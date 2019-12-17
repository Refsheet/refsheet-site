import React, { Component } from 'react'
import PropTypes from 'prop-types'
import { graphql } from 'react-apollo'
import getForums from './getForums.graphql'
import Error from '../Shared/Error'
import View from './index/View'

class Forums extends Component {
  render() {
    const { data } = this.props

    if (data.loading) {
      return <Loading />
    } else if (data.error) {
      const message = data.error.graphQLErrors.map(e => e.message).join(', ')
      return <Error message={message} />
    } else {
      return <View forums={data.getForums} {...this.state} />
    }
  }
}

export const forumType = PropTypes.shape({
  slug: PropTypes.string.isRequired,
  name: PropTypes.string.isRequired,
  description: PropTypes.string,
  system_owned: PropTypes.bool,
})

Forums.propTypes = {}

export default graphql(getForums, {
  options: props => ({
    variables: props.match.params,
  }),
})(Forums)
