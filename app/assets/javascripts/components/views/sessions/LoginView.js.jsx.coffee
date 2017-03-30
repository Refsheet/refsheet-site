@LoginView = React.createClass
  contextTypes:
    router: React.PropTypes.object.isRequired


  getInitialState: ->
    user:
      username: @props.location.query.username
      password: null

  _handleError: (user) ->
    @setState
      user:
        username: @state.user.username
        password: null

  _handleLogin: (user) ->
    console.log "Navigating to #{user.link}"
    @context.router.push user.link

  componentDidMount: ->
    $('body').addClass 'no-footer'

  componentWillUnmount: ->
    $('body').removeClass 'no-footer'


  render: ->
    `<div className='modal-page-content'>
        <div className='narrow-container'>
            <h1>Log In</h1>

            <Form action='/session'
                  method='POST'
                  modelName='user'
                  model={ this.state.user }
                  onError={ this._handleError }
                  onChange={ this._handleLogin }>

                <Input name='username' label='Username' autoFocus />
                <Input name='password' type='password' label='Password' />

                <div className='margin-top--medium'>
                    <Submit>Log In</Submit>
                    <Link to='/register' query={{ username: this.state.username }} className='btn grey darken-3 right'>Sign Up</Link>
                </div>
            </Form>
        </div>
    </div>`
