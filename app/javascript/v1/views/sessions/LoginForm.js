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
import Form from '../../shared/forms/Form'
import Input from '../../shared/forms/Input'
import Row from '../../shared/material/Row'
import Column from '../../shared/material/Column'
import { Link } from 'react-router-dom'
import Submit from '../../shared/forms/Submit'

import $ from 'jquery'
// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
const LoginForm = createReactClass({
  getInitialState() {
    return {
      user: {
        username: null,
        password: null,
        remember: true,
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
    if (this.props.onLogin) {
      return this.props.onLogin(session)
    }
  },

  render() {
    return (
      <Form
        action="/session"
        method="POST"
        modelName="user"
        model={this.state.user}
        onChange={this._handleLogin}
      >
        <Input name="username" label="Username" autoFocus />
        <Input name="password" type="password" label="Password" />

        {this.props.children}

        <Input type="checkbox" name="remember" label="Keep me signed in" />

        <Row className="actions">
          <Column>
            <Link
              to="/register"
              className="btn btn-secondary z-depth-0 modal-close waves-effect waves-light"
            >
              Register
            </Link>

            <div className="right">
              <Submit>Log In</Submit>
            </div>
          </Column>
        </Row>
      </Form>
    )
  },
})

export default LoginForm