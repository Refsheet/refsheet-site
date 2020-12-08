import React from 'react'
import PropTypes from 'prop-types'
import * as Materialize from 'materialize-css'
import Input from '../../shared/forms/Input'
import Modal from '../../shared/Modal'
import Form from '../../shared/forms/Form'
import Row from '../../shared/material/Row'
import Submit from '../../shared/forms/Submit'
import Column from 'v1/shared/material/Column'
import StateUtils from '../../utils/StateUtils'
import compose, { withCurrentUser } from '../../../utils/compose'
import { closeReportModal } from '../../../actions'
import { connect } from 'react-redux'

class ReportModal extends React.Component {
  constructor(props) {
    super(props)

    this._handleSubmit = this._handleSubmit.bind(this)

    this.state = {
      report: {
        sender_user_id:
          props.currentUser != null ? props.currentUser.id : undefined,
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

  _handleSubmit(data) {
    this.props.closeReportModal()
    Materialize.toast({
      html: 'Thank you for your report, we will look into it shortly.',
      displayLength: 3000,
      classes: 'green',
    })
  }

  render() {
    console.log(this.props)
    const { open, id, type } = this.props
    if (!open) return null

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
      <Modal
        autoOpen
        onClose={this.props.closeReportModal}
        title="Report Image"
        id="report-modal"
        ref="modal"
      >
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
  reportImage: PropTypes.func,
}

ReportModal.propTypes = { imageId: PropTypes.string }

const mapStateToProps = (state, ownProps) => ({
  ...ownProps,
  ...state.modals.report,
})

export default compose(
  withCurrentUser(),
  connect(mapStateToProps, { closeReportModal })
)(ReportModal)
