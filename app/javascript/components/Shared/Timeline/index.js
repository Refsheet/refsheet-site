import React from 'react'
import PropTypes from 'prop-types'

const Timeline = ({ children }) => {
  return <ul className={'timeline'}>{children}</ul>
}

Timeline.propTypes = {}

export default Timeline
