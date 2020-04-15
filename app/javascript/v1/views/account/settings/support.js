/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import React from 'react'
import createReactClass from 'create-react-class'
import PropTypes from 'prop-types'
import * as Materialize from 'materialize-css'
import Form from '../../../shared/forms/Form'
import Input from '../../../shared/forms/Input'
import Submit from '../../../shared/forms/Submit'
import Attribute from '../../../shared/attributes/attribute'
import AttributeTable from '../../../shared/attributes/attribute_table'

class Support extends React.Component {
  static initClass() {
    this.contextTypes = {
      currentUser: PropTypes.object.isRequired,
      setCurrentUser: PropTypes.func.isRequired,
    }
  }

  constructor(props, context) {
    super(props)
    this._handleFormChange = this._handleFormChange.bind(this)
    this.state = {
      user: context.currentUser,
      patron: context.currentUser.patron,
      lookup: {
        lookup_email: context.currentUser.email,
      },
    }
  }

  _handleFormChange(patron) {
    console.debug(patron)
    return Materialize.toast({
      html: 'Settings Saved',
      displayLength: 3000,
      classes: 'green',
    })
  }

  render() {
    let patreonStatus
    if (this.state.user.is_patron) {
      const attributes = []

      // for k, v of @state.user.patron
      //   attributes.push `<Attribute key={ k } name={ k } value={ v } />`

      // @state.user.pledges.map (pledge) =>
      //   for k, v of pledge
      //     attributes.push `<Attribute key={ k } name={ k } value={ v } />`

      patreonStatus = (
        <div className="card sp margin-bottom--none">
          <div className="card-header">
            <h2>Patreon Support</h2>
          </div>

          <div className="card-content">
            <p>
              Thank you for supporting us on Patreon! A summary of your support
              level is shown below. Please visit{' '}
              <a
                href="https://patreon.com/refsheet"
                target="_blank"
                rel="noopener noreferrer"
              >
                Patreon.com/Refsheet
              </a>{' '}
              to manage your pledges.
            </p>

            <AttributeTable>{attributes}</AttributeTable>
          </div>
        </div>
      )
    } else {
      patreonStatus = (
        <div className="card sp margin-bottom--none">
          <div className="card-header">
            <h2>Patreon Support</h2>
          </div>

          <Form
            action="/account/support/patron"
            model={this.state.lookup}
            modelName="patron"
            method="PUT"
            onChange={this._handleFormChange}
          >
            <div className="card-content padding-bottom--none">
              <p>
                You are not currently a patron. If you would like to become a
                patron, please visit{' '}
                <a
                  href="https://patreon.com/refsheet"
                  target="_blank"
                  rel="noopener noreferrer"
                >
                  Patreon.com/Refsheet
                </a>{' '}
                to pledge your support.
              </p>
            </div>

            <div className="card-content padding-bottom--none">
              <p className="margin-bottom--medium">
                If you are sure you pledged, and you are seeing this message,
                please enter the email address that you used on Patreon below,
                and we will link your account.
              </p>

              <Input
                type="email"
                name="lookup_email"
                placeholder="Patreon Email Address"
              />
            </div>

            <div className="card-action right-align">
              <Submit>Link Account</Submit>
            </div>
          </Form>
        </div>
      )
    }

    return <div className="account-settings">{patreonStatus}</div>
  }
}
Support.initClass()

export default Support
