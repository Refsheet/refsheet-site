@UserApp = React.createClass
  handleSignOut: (e) ->
    $.ajax
      url: '/session'
      type: 'DELETE'
      success: =>
        @props.onLogin null

    e.preventDefault()

  render: ->
    if @props.currentUser?
      signOutButton =
        `<div className='container'>
            <a className='btn grey darken-3 right' onClick={ this.handleSignOut }>Log Out</a>
        </div>`
      
    `<main>
        { signOutButton }
        { this.props.children }
    </main>`
