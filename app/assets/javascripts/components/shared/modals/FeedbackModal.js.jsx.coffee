@FeedbackModal = React.createClass
  propTypes:
    name: React.PropTypes.string


  getInitialState: ->
    model:
      name: @props.name
      comment: null


  _handleSubmit: (feedback) ->
    @refs.modal.close()
    Materialize.toast({ html: 'Thanks for the feedback!', displayLength: 3000, classes: 'green' })
    @setState model: comment: null

  _handleClose: (e) ->
    @refs.modal.close()
    e.preventDefault()


  render: ->
    `<Modal id='feedback-modal' ref='modal' title='Feedback'>
        <p>Something not quite right? Want a new feature? Let me know!</p>

        <Form onChange={ this._handleSubmit }
              action='/feedbacks'
              className='margin-top--large'
              model={ this.state.model }
              modelName='feedback' >

            <Row>
                <Column m={6}><Input type='text' name='name' label='Your Name' autoFocus={ !this.state.model.name } /></Column>
                <Column m={6}><Input type='text' name='email' label='Your Email' /></Column>
            </Row>

            <Input type='textarea' name='comment' label='Comment' autoFocus={ !!this.state.model.name } />

            <Row className='actions right-align'>
                <Column>
                    <Submit>Send Feedback</Submit>
                </Column>
            </Row>
        </Form>
    </Modal>`
