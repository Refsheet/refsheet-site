namespace 'Views.Images.ReportModal'

class @Views.Images.ReportModal extends React.Component
  @contextTypes:
    currentUser: React.PropTypes.object
    reportImage: React.PropTypes.func

  @propTypes:
    imageId: React.PropTypes.string

  constructor: (props, context) ->
    @state =
      report:
        sender_user_id: context.currentUser?.id
        violation_type: 'other'
        comment: null
        dmca_source_url: null
        image_id: props.imageId

    @violationTypes =
      dmca: "User doesn't have permission to post this."
      improper_flag: "This item was not flagged for proper maturity level."
      offensive: "This item is offensive or violates community standards."
      other: "Other, please specify in comment."

    super props

  componentWillReceiveProps: (newProps, newContext) ->
    if newProps.imageId != @state.report.image_id
      console.log "Reporting imageID changed:", newProps.imageId
      StateUtils.update @, 'report.image_id', newProps.imageId, =>
        console.log "Chagned to:", @state.report
        @refs.form.reload()

    else if newContext.currentUser?.id != @context.currentUser?.id
      StateUtils.update @, 'report.sender_user_id', newProps.imageId


  _handleSubmit: (data) =>
    @context.reportImage(null)
    M.Modal.getInstance(@refs.modal).close()
    Materialize.toast({ "Thank you for your report, we will look into it shortly.", displayLength: 3000, classes: 'green' })

  render: ->
    violationTypes = []

    for key, label of @violationTypes
      violationTypes.push \
        `<Input key={ key }
                id={ 'violation_type_' + key }
                name='violation_type'
                label={ label }
                default={ key }
                type='radio'
                noMargin />`

    `<Modal title='Report Image' id='report-modal' ref='modal'>
        <p>
            Refsheet.net values a strong and welcoming community for all.
            If you find any content that you believe is unwelcome in this community,
            please use the form below to report it to a moderator.
        </p>

        <p>
            We also strongly encourage all users to review
            our <a href='https://refsheet.net/terms' target='_blank'>Terms and Conditions</a> to
            better understand what content is acceptable on this website.
        </p>

        <Form action='/reports'
              ref='form'
              method='POST'
              model={ this.state.report }
              modelName='moderation_report'
              resetOnSubmit
              onChange={ this._handleSubmit }
        >

            <Row className='margin-top--large'>
                <Column>
                    <Input noMargin name='image_id' label='Image ID' readOnly={ !!this.props.imageId } />
                </Column>
            </Row>

            <Row>
                <Column>
                    { violationTypes }
                </Column>
            </Row>

            <Row noMargin>
                <Column>
                    <Input noMargin name='comment' type='textarea' label='Comment' />
                </Column>
            </Row>

            <Row className='actions right-align'>
                <Column>
                    <Submit />
                </Column>
            </Row>
        </Form>
    </Modal>`
