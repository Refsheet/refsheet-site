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
let Button
export default Button = function (props) {
  const {
    children,
    href,
    onClick,
    block,
    large,
    noWaves,
    className,
    target,
    ...others
  } = props

  const classNames = ['btn']
  if (className) {
    classNames.push(className)
  }
  if (!noWaves) {
    classNames.push('waves-effect waves-light')
  }
  if (block) {
    classNames.push('btn-block')
  }
  if (large) {
    classNames.push('btn-large')
  }

  return (
    <a
      className={classNames.join(' ')}
      href={href}
      onClick={onClick}
      target={target}
      {...others}
    >
      {children}
    </a>
  )
}
