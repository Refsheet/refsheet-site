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
let Stats
export default Stats = createReactClass({
  propTypes: {
    className: PropTypes.string,
  },

  render() {
    const classNames = ['stats']
    if (this.props.className) {
      classNames.push(this.props.className)
    }

    return <ul className={classNames.join(' ')}>{this.props.children}</ul>
  },
})

export const Item = createReactClass({
  propTypes: {
    label: PropTypes.string.isRequired,
  },

  render() {
    return (
      <li>
        <div className="label">{this.props.label}</div>
        <div className="value">{this.props.children}</div>
      </li>
    )
  },
})
