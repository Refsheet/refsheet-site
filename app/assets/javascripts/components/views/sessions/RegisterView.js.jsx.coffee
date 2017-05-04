@RegisterView = React.createClass
  contextTypes:
    router: React.PropTypes.object.isRequired
    setCurrentUser: React.PropTypes.func.isRequired


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
    @context.router.push '/' + user.username


  componentDidMount: ->
    $('body').addClass 'no-footer'

  componentWillUnmount: ->
    $('body').removeClass 'no-footer'

  render: ->
    `<Main title='Register'>
        <div className='modal-page-content'>
            <div className='narrow-container'>
                <h1>Sign Up</h1>

                <Form
                    action='/users'
                    method='POST'
                    model={ this.state.user }
                    onChange={ this._handleChange }
                    modelName='user'
                >

                    <Input
                        name='username'
                        value={ this.state.username }
                        label='Username'
                        autoFocus
                    />

                    <Input
                        name='email'
                        type='email'
                        value={ this.state.email }
                        label='Email'
                    />

                    <Input
                        name='password'
                        value={ this.state.password }
                        type='password'
                        label='Password'
                    />

                    <Input
                        name='password_confirmation'
                        value={ this.state.password_confirmation }
                        type='password'
                        label='Confirm Password'
                    />

                    <div className='form-actions margin-top--large'>
                        <Submit>Sign Up</Submit>
                    </div>
                </Form>
            </div>
        </div>
    </Main>`
