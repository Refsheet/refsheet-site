import React, { Component } from 'react'
import PropTypes from 'prop-types'
import Main from "../../Shared/Main";

class View extends Component {
  render() {
    const {
      artist: {
        name
      }
    } = this.props

    return (
      <Main title={['Artist', name]}>
        <pre>{ JSON.stringify(this.props, undefined, 2) }</pre>
      </Main>
    )
  }
}

View.propTypes = {
  artist: PropTypes.shape({
    name: PropTypes.string.isRequired
  })
}

export default View