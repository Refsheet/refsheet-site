/* do-not-disable-eslint
    no-undef,
    react/jsx-no-undef,
    react/no-deprecated,
    react/react-in-jsx-scope,
*/
import React from 'react'
import createReactClass from 'create-react-class'
import PropTypes from 'prop-types'
import * as ReactGA from 'react-ga'
import Form from '../../shared/forms/Form'
import Row from '../../shared/material/Row'
import Column from '../../shared/material/Column'
import Input from '../../shared/forms/Input'
import Restrict from '../../../components/Shared/Restrict'
import Submit from '../../shared/forms/Submit'
import compose, { withCurrentUser } from '../../../utils/compose'
import EmailConfirmationNag from '../../../components/User/EmailConfirmationNag'
// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
const NewCharacterForm = createReactClass({
  propTypes: {
    newCharacterPath: PropTypes.string.isRequired,
    className: PropTypes.string,
    onCreate: PropTypes.func.isRequired,
  },

  getInitialState() {
    return {
      character: {
        name: null,
        species: null,
        slug: null,
        shortcode: null,
        create_v2: false,
      },
    }
  },

  _handleCreate(character) {
    this.props.onCreate(character)
    return ReactGA.event({
      category: 'Character',
      action: 'Created Character',
    })
  },

  render() {
    return (
      <Form
        action={this.props.newCharacterPath}
        method="POST"
        className={this.props.className}
        modelName="character"
        model={this.state.character}
        onError={this._handleError}
        onChange={this._handleCreate}
      >
        <EmailConfirmationNag
          notice={
            'If character creation fails, you have exceeded your quota for character profiles. ' +
            'You can increase this limit by confirming your email address.'
          }
        />
        <Row>
          <Column m={6}>
            <Input name="name" label="Name" autoFocus />
          </Column>
          <Column m={6}>
            <Input name="species" label="Species" />
          </Column>
        </Row>

        <h3>URL Options</h3>
        <p className="muted">Leave these blank for auto-generated values.</p>

        <Row>
          <Column m={6}>
            <Input
              name="slug"
              label={'refsheet.net/' + this.props.currentUser.username + '/'}
            />
          </Column>
          <Column m={6}>
            <Input name="shortcode" label="ref.st/" />
          </Column>
        </Row>

        <Restrict tag="CREATE V2 PROFILE" patron>
          <Row>
            <Column m={6}>
              <div className="beta-feature">
                <Input
                  name="create_v2"
                  type="checkbox"
                  noMargin
                  label="Create V2 Profile"
                />
                <div className="muted">
                  Create a V2 profile, which allows more customization. This
                  feature is currently in Beta, and is NOT COMPLETE. You can use
                  this to get a preview of the new characters, but it is not
                  suggested for refsheets you intend to send to other people.
                </div>
              </div>
            </Column>
          </Row>
        </Restrict>

        <Row className="actions margin-top--large">
          <a onClick={this.props.onCancel} className="btn grey darken-3">
            <i className="material-icons">cancel</i>
          </a>

          <div className="right">
            <Submit>Create Character</Submit>
          </div>
        </Row>
      </Form>
    )
  },
})

export default compose(withCurrentUser())(NewCharacterForm)
