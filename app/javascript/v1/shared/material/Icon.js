import React from 'react'
import createReactClass from 'create-react-class'
import PropTypes from 'prop-types'

// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
let Icon
export default Icon = function (props) {
  const { children, title, className, style } = props
  const classNames = ['material-icons']
  if (className) {
    classNames.push(className)
  }

  return (
    <i className={classNames.join(' ')} title={title} style={style}>
      {children}
    </i>
  )
}
