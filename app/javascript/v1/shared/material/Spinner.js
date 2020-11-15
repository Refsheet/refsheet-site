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
let Spinner
export default Spinner = function (props) {
  const classNames = ['preloader-wrapper']
  if (!props.inactive) {
    classNames.push('active')
  }
  if (!props.small) {
    classNames.push('big')
  }
  if (props.center) {
    classNames.push('center-by-margin')
  }
  if (props.className) {
    classNames.push(props.className)
  }

  return (
    <div className={classNames.join(' ')}>
      <div className="spinner-layer spinner-teal">
        <div className="circle-clipper left">
          <div className="circle"></div>
        </div>
        <div className="gap-patch">
          <div className="circle"></div>
        </div>
        <div className="circle-clipper right">
          <div className="circle"></div>
        </div>
      </div>
    </div>
  )
}
