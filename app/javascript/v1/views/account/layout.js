import React from 'react'
import createReactClass from 'create-react-class'
import PropTypes from 'prop-types'
import { connect } from 'react-redux'
import Main from '../../shared/Main'
import Container from '../../shared/material/Container'
import UserCard from './_user_card'
import SideNav from './_side_nav'
import Advertisement from '../../shared/advertisement'
import Suggestions from './_suggestions'
import compose, { withCurrentUser } from '../../../utils/compose'
import { withRouter } from 'react-router'

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

class Layout extends React.Component {
  _findTitle(inProps) {
    let c, props
    props = inProps

    if (!props) {
      props = this.props
    }

    if (props.children && props.children.props) {
      c = this._findTitle(props.children.props)
    }

    return c || (props.route != null ? props.route.title : undefined)
  }

  componentDidMount() {
    if (!this.props.currentUser) {
      console.log('bye')
      this.props.history.push('/')
    }
  }

  UNSAFE_componentWillReceiveProps(newProps) {
    if (!newProps.currentUser) {
      return this.props.history.push('/')
    }
  }

  render() {
    if (!this.props.currentUser) {
      return <span>Signed out, redirecting...</span>
    }

    return (
      <Main
        title={this._findTitle() || 'Refsheet.net: Your Characters, Organized.'}
        flex
        className="with-sidebar"
      >
        <Container flex className="activity-feed">
          <div className="sidebar">
            <UserCard user={this.props.currentUser} />

            <SideNav />
          </div>

          <div className="content">{this.props.children}</div>

          <div className="sidebar aside transparent">
            <Advertisement />
            <Suggestions />
          </div>
        </Container>
      </Main>
    )
  }
}

export default compose(withCurrentUser(), withRouter)(Layout)
