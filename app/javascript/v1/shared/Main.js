import React from 'react'
import createReactClass from 'create-react-class'
import PropTypes from 'prop-types'
import $ from 'jquery'
// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
let Main
export default Main = createReactClass({
  propTypes: {
    style: PropTypes.object,
    className: PropTypes.string,
    bodyClassName: PropTypes.string,
    fadeEffect: PropTypes.bool,
    slideEffect: PropTypes.bool,
    id: PropTypes.string,
    title: PropTypes.oneOfType([PropTypes.string, PropTypes.array]),
  },

  _updateTitle(title) {
    const titles = []
    titles.push(title)
    titles.push('Refsheet.net')
    return (document.title = [].concat.apply([], titles).join(' - '))
  },

  UNSAFE_componentWillReceiveProps(newProps) {
    if (newProps.title && this._updateTitle) {
      this._updateTitle(newProps.title)
    }

    if (newProps.bodyClassName !== this.props.bodyClassName) {
      $('body').removeClass(this.props.bodyClassName)
      $('body').addClass(newProps.bodyClassName)
    }
  },

  componentDidMount() {
    if (this.props.fadeEffect) {
      $(this.refs.main).fadeIn()
    }

    if (this.props.slideEffect) {
      $(this.refs.main).slideDown()
    }

    if (this.props.title && this._updateTitle) {
      this._updateTitle(this.props.title)
    }

    $('body').addClass(this.props.bodyClassName)
  },

  componentWillUnmount() {
    return $('body').removeClass(this.props.bodyClassName)
  },

  render() {
    const style = this.props.style || {}
    const classNames = [this.props.className]
    if (this.props.flex) {
      classNames.push('main-flex')
    }

    if (this.props.fadeEffect || this.props.slideEffect) {
      style.display = 'none'
    }

    return (
      <main
        style={this.props.style}
        id={this.props.id}
        className={classNames.join(' ')}
        ref="main"
      >
        {this.props.children}
      </main>
    )
  },
})
