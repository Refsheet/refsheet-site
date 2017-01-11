@RegisterView = React.createClass
  getInitialState: ->
    username: @props.location.query.username
    email: null
    password: null
    password_confirmation: null
    loading: false
    errors: {}

  handleFormSubmit: (e) ->
    @setState loading: true

    $.ajax
      url: '/users',
      data:
        user:
          username: @state.username
          email: @state.email
          password: @state.password
          password_confirmation: @state.password_confirmation
      type: 'POST'

      success: (data) =>
        @props.onLogin data
        @setState loading: false, errors: {}
        @props.history.push '/' + data.username

      error: (error) =>
        message = error.responseJSON?.errors
        @setState errors: (message || {}), password: null, password_confirmation: null, loading: false

    e.preventDefault()

  handleInputChange: (key, value) ->
    obj = { errors: @state.errors }
    obj[key] = value
    obj.errors[key] = null
    @setState obj

  componentDidMount: ->
    Materialize.initializeForms()
    Materialize.updateTextFields()

  componentDidUpdate: ->
    Materialize.updateTextFields()

  render: ->
    if @state.loading
      `<Loading message='Sign Up' />`

    else
      `<div className='modal-page-content'>
          <div className='narrow-container'>
              <h1>Sign Up</h1>

              <form onSubmit={ this.handleFormSubmit } noValidate>
                  <Input id='username'
                         value={ this.state.username }
                         onChange={ this.handleInputChange }
                         label='Username'
                         autoFocus
                         error={ this.state.errors.username } />

                  <Input id='email'
                         type='email'
                         value={ this.state.email }
                         onChange={ this.handleInputChange }
                         label='Email'
                         error={ this.state.errors.email } />

                  <Input id='password'
                         value={ this.state.password }
                         type='password'
                         onChange={ this.handleInputChange }
                         label='Password'
                         error={ this.state.errors.password } />

                  <Input id='password_confirmation'
                         value={ this.state.password_confirmation }
                         type='password'
                         onChange={ this.handleInputChange }
                         label='Confirm Password'
                         error={ this.state.errors.password_confirmation } />

                  <button type='submit' className='btn margin-top--medium'>Sign Up</button>
              </form>
          </div>
      </div>`
