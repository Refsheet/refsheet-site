/* global Refsheet */
import React, { Component } from 'react'
import PropTypes from 'prop-types'
import c from 'classnames'

class GoogleAd extends Component {
  componentDidMount() {
    console.warn('A google ad was rendered here, but I am removing them.')
  }

  render() {
    return null
  }
}

GoogleAd.propTypes = {
  format: PropTypes.string,
  layoutKey: PropTypes.string,
  slot: PropTypes.string,
  className: PropTypes.string,
}

export default GoogleAd
