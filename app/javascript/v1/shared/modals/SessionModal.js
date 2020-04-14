import React from 'react'
import createReactClass from 'create-react-class'
import PropTypes from 'prop-types'
import PasswordResetForm from '../../views/sessions/PasswordResetForm'
import LoginForm from '../../views/sessions/LoginForm'
import Modal from '../Modal'
import * as Materialize from 'materialize-css'
import $ from 'jquery'
import { withErrorBoundary } from '../../../components/Shared/ErrorBoundary'

// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS205: Consider reworking code to avoid use of IIFEs
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
const SessionModal = createReactClass({
  getInitialState() {
    return { view: 'login' }
  },

  close() {
    return Materialize.Modal.getInstance(
      document.getElementById('session-modal')
    ).close()
  },

  view(view) {
    return $(this.refs.view).fadeOut(300, () => {
      return this.setState({ view }, () => {
        return $(this.refs.view).fadeIn(300)
      })
    })
  },

  _handleHelpClick(e) {
    this.view('help')
    return e.preventDefault()
  },

  _handleComplete() {
    return this.view('login')
  },

  render() {
    const view = (() => {
      switch (this.state.view) {
        case 'help':
          return (
            <PasswordResetForm
              onComplete={this.close}
              onSignInClick={this._handleComplete}
            />
          )

        default:
          return (
            <LoginForm onLogin={this.close}>
              <div className="right-align">
                <a href="/login" onClick={this._handleHelpClick}>
                  Forgot password?
                </a>
              </div>
            </LoginForm>
          )
      }
    })()

    return (
      <Modal
        id="session-modal"
        title="Welcome back!"
        onClose={this._handleComplete}
        className="narrow"
      >
        <div ref="view" className="flex">
          {view}
        </div>
      </Modal>
    )
  },
})

export default withErrorBoundary(SessionModal)
