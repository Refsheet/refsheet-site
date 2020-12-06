import React from 'react'
import createReactClass from 'create-react-class'
import PropTypes from 'prop-types'

import Column from 'v1/shared/material/Column'
import $ from 'jquery'
// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
let Row
export default Row = createReactClass({
  propTypes: {
    hidden: PropTypes.bool,
    oneColumn: PropTypes.bool,
  },

  UNSAFE_componentWillReceiveProps(newProps) {
    if (newProps.hidden !== this.props.hidden) {
      if (newProps.hidden) {
        return $(this.refs.row).hide(0).addClass('hidden')
      } else {
        return $(this.refs.row).fadeIn(300).removeClass('hidden')
      }
    }
  },

  render() {
    let children
    let className = this.props.className || ''
    if (this.props.noMargin) {
      className += ' no-margin'
    }
    if (this.props.hidden) {
      className += ' hidden'
    }
    if (this.props.noGutter) {
      className += ' no-gutter'
    }
    if (this.props.tinyGutter) {
      className += ' tiny-gutter'
    }

    if (this.props.oneColumn) {
      children = <Column>{this.props.children}</Column>
    } else {
      ;({ children } = this.props)
    }

    return (
      <div ref="row" className={'row ' + className}>
        {children}
      </div>
    )
  },
})
