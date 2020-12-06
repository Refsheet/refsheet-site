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
let PageHeader
export default PageHeader = createReactClass({
  componentDidMount() {
    return $(window).scroll(function () {
      const offset = $(window).scrollTop() * 0.8
      return $('.page-header-backdrop').css({
        backgroundPosition: `50% ${offset}px`,
      })
    })
  },

  componentWillUnmount() {
    return $(window).off('scroll')
  },

  render() {
    return (
      <section className="page-header">
        <div
          className="page-header-backdrop"
          style={{ backgroundImage: 'url(' + this.props.backgroundImage + ')' }}
        >
          {this.props.onHeaderImageEdit && (
            <a
              className="image-edit-overlay for-header"
              onClick={this.props.onHeaderImageEdit}
            >
              <div className="content">
                <i className="material-icons">photo_camera</i>
                Change Cover Image
              </div>
            </a>
          )}
        </div>

        <div className="page-header-content">
          <div className="container">{this.props.children}</div>
        </div>
      </section>
    )
  },
})
