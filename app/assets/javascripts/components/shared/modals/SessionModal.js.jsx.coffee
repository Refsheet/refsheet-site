@SessionModal = React.createClass
  getInitialState: ->
    user:
      username: null
      password: null

  _handleError: (user) ->
    @setState
      user:
        username: @state.user.username
        password: null

  _handleLogin: (session) ->
    user = session.current_user
    $(document).trigger 'app:session:update', session
    $('#session-modal').modal 'close'


  render: ->
    `<Modal id='session-modal'
            title='Log In'
            className='narrow'>
        <Form action='/session'
              method='POST'
              modelName='user'
              model={ this.state.user }
              onChange={ this._handleLogin }>

            <Input name='username' label='Username' autoFocus />
            <Input name='password' type='password' label='Password' />

            <Row className='actions'>
                <Column>
                    <Link to='/register' className='btn btn-secondary modal-close waves-effect waves-light'>Register</Link>

                    <div className='right'>
                        <Submit>Log In</Submit>
                    </div>
                </Column>
            </Row>
        </Form>
    </Modal>`
