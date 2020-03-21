/* do-not-disable-eslint
    constructor-super,
    no-constant-condition,
    no-this-before-super,
    no-undef,
    no-unused-vars,
    react/jsx-no-target-blank,
    react/jsx-no-undef,
    react/no-deprecated,
    react/no-string-refs,
    react/prop-types,
    react/react-in-jsx-scope,
*/
import React from 'react'
import createReactClass from 'create-react-class'
import PropTypes from 'prop-types'
import * as Materialize from 'materialize-css'
import Input from '../../shared/forms/Input'
import Modal from '../../shared/Modal'
import Form from '../../shared/forms/Form'
import Row from '../../shared/material/Row'
import Submit from '../../shared/forms/Submit'
import Column from 'v1/shared/material/Column'
import StateUtils from "../../utils/StateUtils"
// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS001: Remove Babel/TypeScript constructor workaround
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */

class ReportModal extends React.Component {
  constructor(props, context) {
    super(props)

    this._handleSubmit = this._handleSubmit.bind(this)
    this.state = {
      report: {
        sender_user_id:
          context.currentUser != null ? context.currentUser.id : undefined,
        violation_type: 'other',
        comment: null,
        dmca_source_url: null,
        image_id: props.imageId,
      },
    }

    this.violationTypes = {
      dmca: "User doesn't have permission to post this.",
      improper_flag: 'This item was not flagged for proper maturity level.',
      offensive: 'This item is offensive or violates community standards.',
      other: 'Other, please specify in comment.',
    }
  }

  UNSAFE_componentWillReceiveProps(newProps, newContext) {
    if (newProps.imageId !== this.state.report.image_id) {
      console.log('Reporting imageID changed:', newProps.imageId)
      return StateUtils.update(
        this,
        'report.image_id',
        newProps.imageId,
        () => {
          return this.refs.form.reload()
        }
      )
    } else if (
      (newContext.currentUser != null
        ? newContext.currentUser.id
        : undefined) !==
      (this.context.currentUser != null
        ? this.context.currentUser.id
        : undefined)
    ) {
      return StateUtils.update(this, 'report.sender_user_id', newProps.imageId)
    }
  }

  _handleSubmit(data) {
    this.context.reportImage(null)
    Materialize.Modal.getInstance(this.refs.modal).close()
    return Materialize.toast({
      html: 'Thank you for your report, we will look into it shortly.',
      displayLength: 3000,
      classes: 'green',
    })
  }

  render() {
    const violationTypes = []

    for (let key in this.violationTypes) {
      const label = this.violationTypes[key]
      violationTypes.push(
        <Input
          key={key}
          id={'violation_type_' + key}
          name="violation_type"
          label={label}
          default={key}
          type="radio"
          noMargin
        />
      )
    }

    return (
      <Modal title="Report Image" id="report-modal" ref="modal">
        <p>
          Refsheet.net values a strong and welcoming community for all. If you
          find any content that you believe is unwelcome in this community,
          please use the form below to report it to a moderator.
        </p>

        <p>
          We also strongly encourage all users to review our{' '}
          <a
            href="https://refsheet.net/terms"
            target="_blank"
            rel="noopener noreferrer"
          >
            Terms and Conditions
          </a>{' '}
          to better understand what content is acceptable on this website.
        </p>

        <Form
          action="/reports"
          ref="form"
          method="POST"
          model={this.state.report}
          modelName="moderation_report"
          resetOnSubmit
          onChange={this._handleSubmit}
        >
          <Row className="margin-top--large">
            <Column>
              <Input
                noMargin
                name="image_id"
                label="Image ID"
                readOnly={!!this.props.imageId}
              />
            </Column>
          </Row>

          <Row>
            <Column>{violationTypes}</Column>
          </Row>

          <Row noMargin>
            <Column>
              <Input noMargin name="comment" type="textarea" label="Comment" />
            </Column>
          </Row>

          <Row className="actions right-align">
            <Column>
              <Submit />
            </Column>
          </Row>
        </Form>
      </Modal>
    )
  }
}

ReportModal.contextTypes = {
  currentUser: PropTypes.object,
  reportImage: PropTypes.func,
}

ReportModal.propTypes = { imageId: PropTypes.string }

export default ReportModal