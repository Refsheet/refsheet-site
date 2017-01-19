@FeedbackModal = React.createClass
  getInitialState: ->
    model:
      name: @props.name
      comment: null
    errors: {}

  handleChange: (key, value) ->
    o = @state.model
    o[key] = value
    @setState model: o, errors: {}

  handleSubmit: (e) ->
    $.ajax
      url: '/feedbacks'
      type: 'POST'
      data: feedback: @state.model
      success: =>
        @setState model: { name: @props.name }, errors: {}
        $('#feedback-modal').modal('close')
        Materialize.toast 'Thanks for the feedback!', 3000, 'green'
        Materialize.updateTextFields()
      error: (error) =>
        @setState errors: (error.responseJSON || {}).errors || {}
    e.preventDefault()

  handleClose: (e) ->
    $('#feedback-modal').modal('close')
    e.preventDefault()

  componentDidMount: ->
    Materialize.initializeForms()
    Materialize.updateTextFields()

  render: ->
    `<Modal id='feedback-modal'>
        <h2>Feedback</h2>
        <p>Something not quite right? Want a new feature? Let me know!</p>

        <form onSubmit={ this.handleSubmit } className='margin-top--large'>
            <Input type='text'
                   autoFocus
                   value={ this.state.model.name }
                   label='Your Name'
                   id='name'
                   onChange={ this.handleChange }
                   error={ this.state.errors.name } />

            <Input type='textarea'
                   value={ this.state.model.comment }
                   label='Comment'
                   id='comment'
                   onChange={ this.handleChange }
                   error={ this.state.errors.comment } />

            <div className='actions margin-top--large'>
                <button className='btn' type='submit'>Submit</button>
                <a className='btn grey right darken-3' onClick={ this.handleClose }>
                    <i className='material-icons'>cancel</i>
                </a>
            </div>
        </form>
    </Modal>`
