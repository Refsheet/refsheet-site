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
let Jumbotron
export default Jumbotron = function (props) {
  const classNames = ['jumbotron']
  if (props.className) {
    classNames.push(props.className)
  }

  return (
    <div className={classNames.join(' ')}>
      <div className="jumbotron-background">
        <div className="container">{props.children}</div>
      </div>
    </div>
  )
}
