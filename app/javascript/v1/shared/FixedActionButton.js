import React from 'react'
import createReactClass from 'create-react-class'
import PropTypes from 'prop-types'

import ActionButton from 'v1/shared/ActionButton'
import * as Materialize from 'materialize-css'
// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
let FixedActionButton
export default FixedActionButton = createReactClass({
  componentDidMount(e) {
    Materialize.FloatingActionButton.init(this.fab)
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
      <div className={className} ref={r => (this.fab = r)}>
        <ActionButton large={true} {...this.props} />
        <ul>{children}</ul>
      </div>
    )
  },
})
