@LoginView = React.createClass
  contextTypes:
    router: React.PropTypes.object.isRequired


  getInitialState: ->
    username: @props.location.query.username
    password: null
    loading: false
    
  handleFormSubmit: (e) ->
    @setState loading: true

    $.ajax
      url: '/session',
      data: { username: @state.username, password: @state.password }
      type: 'POST'
      success: (data) =>
        $(document).trigger 'app:sign_in', data
        @setState loading: false
        @context.router.push '/' + data.username

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
    Materialize.updateTextFields()
    $('body').addClass 'no-footer'

  componentDidUpdate: ->
    Materialize.updateTextFields()

  componentWillUnmount: ->
    $('body').removeClass 'no-footer'

  render: ->
    if @state.loading
      `<Loading message='Log In' />`

    else
      `<div className='modal-page-content'>
          <div className='narrow-container'>
              <h1>Log In</h1>
    
              <form onSubmit={ this.handleFormSubmit } noValidate>
                  <Input id='username' value={ this.state.username } onChange={ this.handleInputChange } label='Username' autoFocus />
                  <Input id='password' value={ this.state.password } type='password' onChange={ this.handleInputChange } label='Password' />
                  <div className='margin-top--medium'>
                      <button type='submit' className='btn'>Log In</button>
                      <Link to='/register' query={{ username: this.state.username }} className='btn grey darken-3 right'>Sign Up</Link>
                  </div>
              </form>
          </div>
      </div>`
