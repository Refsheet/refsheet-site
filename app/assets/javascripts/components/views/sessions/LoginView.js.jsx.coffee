@LoginView = React.createClass
  getInitialState: ->
    username: null
    password: null
    loading: false
    
  handleFormSubmit: (e) ->
    @setState loading: true

    $.ajax
      url: '/session',
      data: { username: @state.username, password: @state.password }
      type: 'POST'
      success: (data) =>
        @props.onLogin data
        @setState loading: false
        @props.history.push '/users/' + data.username

      error: (error) =>
        message = error.responseJSON?.error
        Materialize.toast message, 3000, 'red'

        @setState password: null, loading: false

    e.preventDefault()

  handleInputChange: (key, value) ->
    obj = {}
    obj[key] = value
    @setState obj

  componentDidMount: ->
    Materialize.initializeForms()

  componentDidUpdate: ->
    Materialize.updateTextFields()

  render: ->
    if @state.loading
      `<Loading message='Log In' />`

    else
      `<div className='modal-content'>
          <h1>Log In</h1>

          <form onSubmit={ this.handleFormSubmit }>
              <Input id='username' value={ this.state.username } onChange={ this.handleInputChange } label='Username' autoFocus />
              <Input id='password' value={ this.state.password } type='password' onChange={ this.handleInputChange } label='Password' />
              <button type='submit' className='btn'>Log In</button>
          </form>
      </div>`
