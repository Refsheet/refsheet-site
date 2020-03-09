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
let FixedActionButton; export default FixedActionButton = createReactClass({
  componentDidMount(e) {
    return $('.fixed-action-btn').floatingActionButton()
  },

  render() {
    const children = React.Children.map(this.props.children, child => {
      return <li>{React.cloneElement(child)}</li>
    })

    let className = 'fixed-action-btn'
    if (this.props.clickToToggle) {
      className += ' click-to-toggle'
    }

    return (
      <div className={className}>
        <ActionButton large={true} {...this.props} />
        <ul>{children}</ul>
      </div>
    )
  },
})
