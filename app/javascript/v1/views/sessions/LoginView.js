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
import { Link } from 'react-router-dom'
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
  contextTypes: {
    router: PropTypes.object.isRequired,
  },

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
    $(document).trigger('app:session:update', session)
    const next = __guard__(
      this.context.router.history.location != null
        ? this.context.router.history.location.query
        : undefined,
      x => x.next
    )

    if (next) {
      return (window.location = next)
    } else {
      return this.context.router.history.push(user.link)
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
      <Main title="Login">
        <div className="modal-page-content">
          <div className="narrow-container">
            <h1>Log In</h1>

            <Form
              action="/session"
              method="POST"
              modelName="user"
              model={this.state.user}
              onError={this._handleError}
              onChange={this._handleLogin}
            >
              <Input name="username" label="Username" autoFocus />
              <Input name="password" type="password" label="Password" />

              <div className="margin-top--medium">
                <Submit>Log In</Submit>
                <Link
                  to="/register"
                  query={{ username: this.state.username }}
                  className="btn grey darken-3 right"
                >
                  Sign Up
                </Link>
              </div>
            </Form>
          </div>
        </div>
      </Main>
    )
  },
})

function __guard__(value, transform) {
  return typeof value !== 'undefined' && value !== null
    ? transform(value)
    : undefined
}

export default LoginView
