@LoginView = v1 -> React.createClass
  contextTypes:
    router: React.PropTypes.object.isRequired


  getInitialState: ->
    user:
      username: @props.location.query?.username
      password: null

  _handleError: (user) ->
    @setState
      user:
        username: @state.user.username
        password: null

  _handleLogin: (session) ->
    user = session.current_user
    $(document).trigger 'app:session:update', session
    next = @context.router.history.location?.query?.next

    if next
      window.location = next
    else
      @context.router.history.push(user.link)

  componentDidMount: ->
    $('body').addClass 'no-footer'

  componentWillUnmount: ->
    $('body').removeClass 'no-footer'


  render: ->
    `<Main title='Login' className='shaded-background modal-page-content'>
        <div className='modal-page-content'>
            <div className='narrow-container'>
                <h1>Log In</h1>

                <Form action='/session'
                      method='POST'
                      modelName='user'
                      formName="login_full"
                      model={ this.state.user }
                      onError={ this._handleError }
                      onChange={ this._handleLogin }>

                    <Input name='username' label='Username' autoFocus />
                    <Input name='password' type='password' label='Password' />

                    <div className='margin-top--medium'>
                      <Link to='/register' query={{ username: this.state.username }} className='btn grey darken-3'>Register</Link>
                      <Submit className='right'>Log In</Submit>
                    </div>
                </Form>
            </div>
        </div>
    </Main>`
