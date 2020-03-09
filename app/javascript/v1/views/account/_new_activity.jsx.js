@Views.Account.NewActivity = React.createClass
  contextTypes:
    currentUser: React.PropTypes.object

  getInitialState: ->
    model:
      name: @props.name
      comment: null

  _handleSubmit: (feedback) ->
    Materialize.toast({ html: 'Thanks for the feedback!', displayLength: 3000, classes: 'green' })
    @setState model: comment: null

  render: ->
    `<Form className='card reply-box margin-top--none sp with-avatar'
           onChange={ this._handleSubmit }
           action='/feedbacks'
           model={ this.state.model }
           modelName='feedback'
    >
        <img className='avatar circle' src={ this.context.currentUser.avatar_url } alt={ this.context.currentUser.name } />

        <div className='card-content reply-box'>
            <Input type='textarea' name='comment' browserDefault noMargin placeholder='Would status updates be helpful? Submit a feedback request!' />

            <Row noMargin>
                <Column s={8}></Column>
                <Column s={4}><Submit className='btn-block'>Feedback!</Submit></Column>
            </Row>
        </div>
    </Form>`
