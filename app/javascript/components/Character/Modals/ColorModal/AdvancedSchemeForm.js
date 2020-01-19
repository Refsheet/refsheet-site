import React, { Component } from 'react'
import PropTypes from 'prop-types'
import compose from 'utils/compose'

class AdvancedSchemeForm extends Component {
  constructor(props) {
    super(props)

    this.state = {}
  }

  render() {
    return <h1>AdvancedSchemeForm</h1>
  }
}

AdvancedSchemeForm.propTypes = {}

export default compose()(AdvancedSchemeForm)
// TODO: Add HOC bindings here
