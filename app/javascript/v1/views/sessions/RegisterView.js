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
import * as ReactGA from 'react-ga'
import Main from '../../shared/Main'
import Form from '../../shared/forms/Form'
import Input from '../../shared/forms/Input'
import Submit from '../../shared/forms/Submit'
import $ from 'jquery'
import Flash from '../../../utils/Flash'
import { Link } from 'react-router-dom'
// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
const RegisterView = createReactClass({
  contextTypes: {
    router: PropTypes.object.isRequired,
    setCurrentUser: PropTypes.func.isRequired,
    currentUser: PropTypes.object,
  },

  getInitialState() {
    return {
      user: {
        username: this.props.location.query.username,
        email: null,
        password: null,
        password_confirmation: null,
      },
    }
  },

  _handleChange(user) {
    ReactGA.event({
      category: 'User',
      action: 'Sign Up',
    })

    Flash.info(
      'Thank you for registering! Please check your email for confirmation.'
    )
    this.context.setCurrentUser(user)
    this.context.router.history.push('/')
  },

  componentDidMount() {
    return $('body').addClass('no-footer')
  },

  componentWillUnmount() {
    return $('body').removeClass('no-footer')
  },

  render() {
    return (
      <Main title="Register" className="modal-page-content shaded-background">
        <div className="modal-page-content">
          <div className="narrow-container">
            <h1>Register</h1>

            <Form
              action="/users"
              method="POST"
              formName={'register_full'}
              model={this.state.user}
              onChange={this._handleChange}
              modelName="user"
            >
              <Input
                name="username"
                value={this.state.username}
                label="Username"
                autoFocus
              />

              <Input
                name="email"
                type="email"
                value={this.state.email}
                label="Email"
              />

              <Input
                name="password"
                value={this.state.password}
                type="password"
                label="Password"
              />

              <Input
                name="password_confirmation"
                value={this.state.password_confirmation}
                type="password"
                label="Confirm Password"
              />

              <div className="form-actions margin-top--large">
                <Link
                  to="/login"
                  query={{ username: this.state.username }}
                  className="btn grey darken-3"
                >
                  Log In
                </Link>
                <Submit className={'right'}>Register</Submit>
              </div>
            </Form>
          </div>
        </div>
      </Main>
    )
  },
})

export default RegisterView
