/* do-not-disable-eslint
    no-undef,
    no-unused-vars,
    react/jsx-no-undef,
    react/no-deprecated,
    react/no-string-refs,
    react/react-in-jsx-scope,
*/
import React from 'react'
import PropTypes from 'prop-types'
import createReactClass from 'create-react-class'

import Form from '../../shared/forms/Form'
import Input from '../../shared/forms/Input'
import Submit from '../../shared/forms/Submit'
import Row from 'v1/shared/material/Row'
import Column from 'v1/shared/material/Column'
import { Link } from 'react-router-dom'
import $ from 'jquery'
import * as Materialize from 'materialize-css'

// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
const PasswordResetForm = createReactClass({
  getInitialState() {
    return {
      email: null,
      token: null,
      userPath: null,
      user: {
        password: null,
        password_confirmation: null,
      },
    }
  },

  _handleCreate(data) {
    return $(this.refs.createForm).fadeOut(300, () => {
      return this.setState({ email: data.user.email })
    })
  },

  _handleUpdate(data) {
    return $(this.refs.updateForm).fadeOut(300, () => {
      return this.setState({ token: true, userPath: data.current_user.path })
    })
  },

  _handlePasswordChange(data) {
    if (this.props.onComplete) {
      this.props.onComplete()
    }
    return Materialize.toast({
      html: 'Password changed!',
      displayLength: 3000,
      classes: 'green',
    })
  },

  _handleSignInClick(e) {
    if (this.props.onSignInClick) {
      this.props.onSignInClick()
    }
    return e.preventDefault()
  },

  render() {
    const actions = (
      <Row className="actions">
        <Column>
          <Link
            to="/login"
            className="btn btn-secondary z-depth-0 modal-close waves-effect waves-light"
            onClick={this._handleSignInClick}
          >
            Sign In
          </Link>

          <div className="right">
            <Submit>{this.state.token ? 'Change Password' : 'Continue'}</Submit>
          </div>
        </Column>
      </Row>
    )

    if (this.state.email === null) {
      return (
        <div ref="createForm" key="ResetCreateForm">
          <Form
            action="/password_resets"
            onChange={this._handleCreate}
            modelName="user"
            method="POST"
            model={this.state}
          >
            <p className="margin-bottom--large">
              Need a new password? Enter your email or username below, and we'll
              send you a code to get back in.
            </p>

            <Input
              name="email"
              type="email"
              label="Username or Email"
              noMargin
              autoFocus
            />

            {actions}
          </Form>
        </div>
      )
    } else if (this.state.token === null) {
      return (
        <div ref="updateForm" key="ResetUpdateForm">
          <Form
            action="/password_resets"
            method="PUT"
            onChange={this._handleUpdate}
            modelName="reset"
            model={this.state}
          >
            <p className="margin-bottom--large">
              We've sent an email to {this.state.email}. Please enter the 6
              digit code in that email to continue.
            </p>

            <Input
              name="token"
              type="number"
              label="Reset Code"
              noMargin
              autoFocus
            />

            {actions}
          </Form>
        </div>
      )
    } else {
      return (
        <Form
          action={this.state.userPath}
          method="PUT"
          onChange={this._handlePasswordChange}
          modelName="user"
          model={this.state.user}
        >
          <p className="margin-bottom--large">
            Enter a new password and you should be good to go!
          </p>

          <Input name="password" type="password" label="Password" autoFocus />
          <Input
            name="password_confirmation"
            type="password"
            label="Password Confirmation"
            noMargin
          />

          {actions}
        </Form>
      )
    }
  },
})

export default PasswordResetForm
