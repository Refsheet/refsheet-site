@SessionModal = v1 -> React.createClass
  getInitialState: ->
    view: 'login'

  close: ->
    M.Modal.getInstance(document.getElementById('session-modal')).close()

  view: (view) ->
    $(@refs.view).fadeOut 300, =>
      @setState view: view, =>
        $(@refs.view).fadeIn 300

  _handleHelpClick: (e) ->
    @view 'help'
    e.preventDefault()

  _handleComplete: ->
    @view 'login'

  render: ->
    view = switch @state.view
      when 'help'
        `<PasswordResetForm onComplete={ this.close } onSignInClick={ this._handleComplete } />`

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
        <div ref='view' className='flex'>
            { view }
        </div>
    </Modal>`
