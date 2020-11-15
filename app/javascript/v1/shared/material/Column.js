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
let Column
export default Column = function (props) {
  const classes = ['col']
  classes.push(props.className)
  if (!props['s']) {
    classes.push('s12')
  }

  for (let s of ['s', 'm', 'l', 'xl', 'offset-s', 'offset-m', 'offset-l']) {
    if (props[s]) {
      classes.push(`${s}${props[s]}`)
    }
  }

  return (
    <div className={classes.join(' ')} id={props.id} style={props.style}>
      {props.children}
    </div>
  )
}
