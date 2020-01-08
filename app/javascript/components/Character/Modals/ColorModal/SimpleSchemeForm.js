import React, { Component } from 'react'
import PropTypes from 'prop-types'
import compose from 'utils/compose'

class SimpleSchemeForm extends Component {
  constructor(props) {
    super(props)

    this.state = {}
  }

  render() {
    return <h1>SimpleSchemeForm</h1>
  }
}

SimpleSchemeForm.propTypes = {}

export default compose()(SimpleSchemeForm)
// TODO: Add HOC bindings here
