@FeedbackModal = React.createClass
  propTypes:
    name: React.PropTypes.string


  getInitialState: ->
    model:
      name: @props.name
      comment: null


  _handleSubmit: (feedback) ->
    $('#feedback-modal').modal('close')
    Materialize.toast 'Thanks for the feedback!', 3000, 'green'
    @setState comment: null

  _handleClose: (e) ->
    $('#feedback-modal').modal('close')
    e.preventDefault()


  render: ->
    `<Modal id='feedback-modal'>
        <h2>Feedback</h2>
        <p>Something not quite right? Want a new feature? Let me know!</p>

        <Form onChange={ this._handleSubmit }
              action='/feedbacks'
              className='margin-top--large'
              model={ this.state.model }
              modelName='feedback' >

            <Input type='text' name='name' label='Your Name' autoFocus={ !this.state.name } />
            <Input type='textarea' name='comment' label='Comment' autoFocus={ !!this.state.name } />

            <div className='actions margin-top--large'>
                <Submit />

                <a className='btn grey right darken-3 waves waves-light' onClick={ this._handleClose }>
                    <i className='material-icons'>cancel</i>
                </a>
            </div>
        </Form>
    </Modal>`
