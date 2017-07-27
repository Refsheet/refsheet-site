@SessionModal = React.createClass
  getInitialState: ->
    view: 'login'

  close: ->
    $('#session-modal').modal 'close'

  _handleHelpClick: (e) ->
    @setState view: 'help'
    e.preventDefault()

  _handleComplete: ->
    @setState vuew: 'login'

  render: ->
    view = switch @state.view
      when 'help'
        `<PasswordResetForm onComplete={ this.close } />`

      else
        `<LoginForm onLogin={ this.close }>
            <div className='right-align'>
                <a href='/login' onClick={ this._handleHelpClick }>Forgot password?</a>
            </div>
        </LoginForm>`

    `<Modal id='session-modal'
            title='Welcome back!'
            onClose={ this._handleComplete }
            className='narrow'>
        { view }
    </Modal>`
