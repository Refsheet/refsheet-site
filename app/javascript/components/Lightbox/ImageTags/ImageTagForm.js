import React, { Component } from 'react'
import PropTypes from 'prop-types'
import compose from 'utils/compose'

class ImageTagForm extends Component {
  constructor(props) {
    super(props)

    this.state = {}
  }

  render() {
    return <h1>ImageTagForm</h1>
  }
}

ImageTagForm.propTypes = {
  image: PropTypes.object.isRequired,
  onSave: PropTypes.func,
  onCancel: PropTypes.func,
}

export default compose()(ImageTagForm)
// TODO: Add HOC bindings here
