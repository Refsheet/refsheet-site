@RegisterView = v1 -> React.createClass
  contextTypes:
    router: React.PropTypes.object.isRequired
    setCurrentUser: React.PropTypes.func.isRequired
    currentUser: React.PropTypes.object


  getInitialState: ->
    user:
      username: @props.location.query.username
      email: null
      password: null
      password_confirmation: null


  _handleChange: (user) ->
    ReactGA.event
      category: 'User'
      action: 'Sign Up'

    @context.setCurrentUser user

  componentDidUpdate: (oldProps) ->
    if @context.currentUser
      @context.router.history.push '/'


  componentDidMount: ->
    $('body').addClass 'no-footer'

  componentWillUnmount: ->
    $('body').removeClass 'no-footer'

  render: ->
    `<Main title='Register' className='modal-page-content shaded-background'>
        <div className='modal-page-content'>
            <div className='narrow-container'>
                <h1>Register</h1>

                <Form
                    action='/users'
                    method='POST'
                    model={ this.state.user }
                    onChange={ this._handleChange }
                    modelName='user'
                    formName='register'
                >

                    <Input
                        key='username'
                        name='username'
                        value={ this.state.username }
                        label='Username'
                        autoFocus
                    />

                    <Input
                        key='email'
                        name='email'
                        type='email'
                        value={ this.state.email }
                        label='Email'
                    />

                    <Input
                        key='password'
                        name='password'
                        value={ this.state.password }
                        type='password'
                        label='Password'
                    />

                    <Input
                        key='password_confirmation'
                        name='password_confirmation'
                        value={ this.state.password_confirmation }
                        type='password'
                        label='Confirm Password'
                    />

                    <div className='form-actions margin-top--large'>
                        <Link to='/login' query={{ username: this.state.username }} className='btn grey darken-3'>Log In</Link>
                        <Submit className='right'>Register</Submit>
                    </div>
                </Form>
            </div>
        </div>
    </Main>`
