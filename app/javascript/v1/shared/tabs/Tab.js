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
let Tab
export default Tab = createReactClass({
  propTypes: {
    id: PropTypes.string.isRequired,
    name: PropTypes.string,
    icon: PropTypes.string,
    count: PropTypes.number,
    className: PropTypes.string,
  },

  render() {
    const classNames = ['tab-content']
    if (this.props.className) {
      classNames.push(this.props.className)
    }

    return (
      <div className={classNames.join(' ')} id={this.props.id}>
        {this.props.children}
      </div>
    )
  },
})
