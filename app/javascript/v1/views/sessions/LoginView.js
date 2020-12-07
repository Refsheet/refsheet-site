/* do-not-disable-eslint
    no-undef,
    no-unused-vars,
    react/jsx-no-undef,
    react/no-deprecated,
    react/react-in-jsx-scope,
*/
import React from 'react'
import PropTypes from 'prop-types'
import createReactClass from 'create-react-class'
import Main from '../../shared/Main'
import Form from '../../shared/forms/Form'
import Input from '../../shared/forms/Input'
import Submit from '../../shared/forms/Submit'
import { Link, withRouter } from 'react-router-dom'

import $ from 'jquery'
import { setCurrentUser } from '../../../actions'
import compose from '../../../utils/compose'
import { connect } from 'react-redux'
// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS103: Rewrite code to no longer use __guard__
 * DS207: Consider shorter variations of null checks
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
const LoginView = createReactClass({
  getInitialState() {
    return {
      user: {
        username:
          this.props.location.query != null
            ? this.props.location.query.username
            : undefined,
        password: null,
      },
    }
  },

  _handleError(user) {
    return this.setState({
      user: {
        username: this.state.user.username,
        password: null,
      },
    })
  },

  _handleLogin(session) {
    const user = session.current_user

    this.props.setCurrentUser(user)

    const next =
      this.props.history.location &&
      this.props.history.location.query &&
      this.props.history.location.query.next

    if (next) {
      return (window.location = next)
    } else {
      return this.props.history.push(user.link)
    }
  },

  componentDidMount() {
    return $('body').addClass('no-footer')
  },

  componentWillUnmount() {
    return $('body').removeClass('no-footer')
  },

  render() {
    return (
      <Main title="Login" className="shaded-background modal-page-content">
        <div className="modal-page-content">
          <div className="narrow-container">
            <h1>Log In</h1>

            <Form
              action="/session"
              method="POST"
              modelName="user"
              formName={'login_full'}
              model={this.state.user}
              onError={this._handleError}
              onChange={this._handleLogin}
            >
              <Input name="username" label="Username" autoFocus />
              <Input name="password" type="password" label="Password" />

              <Input
                type="checkbox"
                name="remember"
                label="Keep me signed in"
              />

              <div className="margin-top--medium">
                <Link
                  to="/register"
                  query={{ username: this.state.username }}
                  className="btn grey darken-3"
                >
                  Register
                </Link>

                <Submit className={'right'}>Log In</Submit>
              </div>
            </Form>
          </div>
        </div>
      </Main>
    )
  },
})

const mapStateToProps = ({ session }) => ({
  session,
})

const mapDispatchToProps = {
  setCurrentUser,
}

export default compose(
  connect(mapStateToProps, mapDispatchToProps),
  withRouter
)(LoginView)
