/* do-not-disable-eslint
    constructor-super,
    no-constant-condition,
    no-this-before-super,
    no-undef,
    react/jsx-no-undef,
    react/no-deprecated,
    react/react-in-jsx-scope,
*/
import React from 'react'
import createReactClass from 'create-react-class'
import PropTypes from 'prop-types'
import Form from '../../../shared/forms/Form'
import Row from '../../../shared/material/Row'
import Column from '../../../shared/material/Column'
import Input from '../../../shared/forms/Input'
import Submit from '../../../shared/forms/Submit'
import DeleteUser from '../../../../components/Settings/Account/DeleteUser'

import Materialize from 'materialize-css'
import Error from '../../../../components/Shared/Error'
import compose, { withCurrentUser } from '../../../../utils/compose'
import EmailConfirmationNag from '../../../../components/User/EmailConfirmationNag'
// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
class Show extends React.Component {
  constructor(props) {
    super(props)

    this._handleFormChange = this._handleFormChange.bind(this)
    this.state = {
      user: props.currentUser,
    }
  }

  _handleFormChange(user) {
    this.props.setCurrentUser(user)
    return Materialize.toast({
      html: 'Settings Saved',
      displayLength: 3000,
      classes: 'green',
    })
  }

  render() {
    if (!this.state.user) {
      return (
        <div className={'account-settings'}>
          <Error
            error={
              'Refsheet thinks, for whatever reason, that you are not signed in. If you are actually signed in, please report this via Twitter.'
            }
          />
        </div>
      )
    }
    return (
      <div className="account-settings">
        <EmailConfirmationNag />
        <Form
          action={this.state.user.path}
          className="card sp"
          method="PATCH"
          onChange={this._handleFormChange}
          model={this.state.user}
          modelName="user"
        >
          <div className="card-header">
            <h2>User Settings</h2>
          </div>

          <div className="card-content padding-bottom--none">
            <Row noMargin>
              <Column m={6}>
                <Input name="name" type="text" label="Display Name" />
              </Column>

              <Column m={6}>
                <Input name="email" type="email" label="Email Address" />
              </Column>
            </Row>

            <Row noMargin>
              <Column m={6}>
                <Input name="username" type="text" label="Username" />
              </Column>

              <Column m={6}>
                <div className="padding-top--small strong red-text text-darken-1">
                  Warning!
                </div>

                <div className="muted">
                  Changing your username will break any links to your account.
                </div>
              </Column>
            </Row>
          </div>

          <div className="card-action right-align">
            <Submit>Save Settings</Submit>
          </div>
        </Form>

        <Form
          action={this.state.user.path}
          className="card sp margin-top--large"
          method="PATCH"
          onChange={this._handleFormChange}
          model={this.state.user}
          modelName="user"
        >
          <div className="card-header">
            <h2>Change Password</h2>
          </div>

          <div className="card-content padding-bottom--none">
            <Row noMargin>
              <Column m={6}>
                <Input
                  name="password"
                  type="password"
                  placeholder="Change Password"
                />
              </Column>

              <Column m={6}>
                <Input
                  name="password_confirmation"
                  type="password"
                  placeholder="Password Confirmation"
                />
              </Column>
            </Row>
          </div>

          <div className="card-action right-align">
            <Submit>Change Password</Submit>
          </div>
        </Form>

        <DeleteUser user={this.state.user} />
      </div>
    )
  }
}

export default compose(withCurrentUser(true))(Show)
