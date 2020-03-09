/* eslint-disable
    no-undef,
    react/jsx-no-undef,
    react/no-deprecated,
    react/prop-types,
    react/react-in-jsx-scope,
*/
import React from 'react'
import createReactClass from 'create-react-class'
import PropTypes from 'prop-types'
// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * DS207: Consider shorter variations of null checks
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
namespace('Views.Account')

class Layout extends React.Component {
  static initClass() {
    this.contextTypes = { router: PropTypes.object.isRequired }
  }

  _findTitle(props) {
    let c
    if (props == null) {
      ;({ props } = this)
    }
    if (props.children && props.children.props) {
      c = this._findTitle(props.children.props)
    }
    return c || (props.route != null ? props.route.title : undefined)
  }

  componentWillReceiveProps(newProps) {
    if (!newProps.currentUser) {
      return this.context.router.history.push('/')
    }
  }

  render() {
    if (!this.props.currentUser) {
      return <span>Signed out, redirecting...</span>
    }

    return (
      <Main title={this._findTitle()} flex className="with-sidebar">
        <Container flex className="activity-feed">
          <div className="sidebar">
            <Views.Account.UserCard user={this.props.currentUser} />

            <Views.Account.SideNav />
          </div>

          <div className="content">{this.props.children}</div>

          <div className="sidebar aside transparent">
            {typeof Advertisement != 'undefined' && <Advertisement />}
            <Views.Account.Suggestions />
          </div>
        </Container>
      </Main>
    )
  }
}
Layout.initClass()

const mapStateToProps = state => ({ currentUser: state.session.currentUser })
this.Views.Account.Layout = connect(mapStateToProps)(Layout)
