import React, { Component } from 'react'
import PropTypes from 'prop-types'
import compose from 'utils/compose'

class NewDiscussion extends Component {
  constructor(props) {
    super(props)

    this.state = { discussion: {} }
  }

  render() {
    return <h1>NewDiscussion</h1>
  }
}

NewDiscussion.propTypes = { forum: PropTypes.object.isRequired }

export default compose()(NewDiscussion)
// TODO: Add HOC bindings here
