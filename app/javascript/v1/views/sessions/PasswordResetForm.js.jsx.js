@PasswordResetForm = React.createClass
  getInitialState: ->
    email: null
    token: null
    userPath: null
    user:
      password: null
      password_confirmation: null

  _handleCreate: (data) ->
    $(@refs.createForm).fadeOut 300, =>
      @setState email: data.user.email

  _handleUpdate: (data) ->
    $(@refs.updateForm).fadeOut 300, =>
      @setState token: true, userPath: data.current_user.path

  _handlePasswordChange: (data) ->
    @props.onComplete() if @props.onComplete
    Materialize.toast({ html: 'Password changed!', displayLength: 3000, classes: 'green' })

  _handleSignInClick: (e) ->
    @props.onSignInClick() if @props.onSignInClick
    e.preventDefault()

  render: ->
    actions =
      `<Row className='actions'>
          <Column>
              <Link to='/login' className='btn btn-secondary z-depth-0 modal-close waves-effect waves-light' onClick={ this._handleSignInClick }>Sign In</Link>

              <div className='right'>
                  <Submit>{ this.state.token ? 'Change Password' : 'Continue' }</Submit>
              </div>
          </Column>
      </Row>`

    if @state.email is null
      `<div ref='createForm' key='ResetCreateForm'>
          <Form action='/password_resets'
                onChange={ this._handleCreate }
                modelName='user'
                method='POST'
                model={ this.state }
          >
              <p className='margin-bottom--large'>Need a new password? Enter your email or username below, and we'll send you a code to get back in.</p>

              <Input name='email' type='email' label='Username or Email' noMargin autoFocus />

              { actions }
          </Form>
      </div>`

    else if @state.token is null
      `<div ref='updateForm' key='ResetUpdateForm'>
          <Form action='/password_resets'
                method='PUT'
                onChange={ this._handleUpdate }
                modelName='reset'
                model={ this.state }
          >
              <p className='margin-bottom--large'>We've sent an email to { this.state.email }. Please enter the 6 digit code in that email to continue.</p>

              <Input name='token' type='number' label='Reset Code' noMargin autoFocus />

              { actions }
          </Form>
      </div>`

    else
      `<Form action={ this.state.userPath }
             method='PUT'
             onChange={ this._handlePasswordChange }
             modelName='user'
             model={ this.state.user }
      >
          <p className='margin-bottom--large'>Enter a new password and you should be good to go!</p>

          <Input name='password' type='password' label='Password' autoFocus />
          <Input name='password_confirmation' type='password' label='Password Confirmation' noMargin />

          { actions }
      </Form>`
