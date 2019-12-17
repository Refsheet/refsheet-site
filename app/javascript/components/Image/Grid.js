import React, { Component } from 'react'
import { PropTypes } from 'prop-types'
import JustifiedLayout from 'react-justified-layout'
import { withContentRect } from 'react-measure'

const Grid = ({ children, measureRef, contentRect }) => {
  const width = contentRect.bounds.width || 300

  return (
    <JustifiedLayout containerWidth={width} containerPadding={0}>
      {children}
    </JustifiedLayout>
  )
}

export default withContentRect('bounds')(Grid)
