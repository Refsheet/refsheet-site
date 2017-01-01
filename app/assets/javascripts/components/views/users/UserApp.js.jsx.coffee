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
      signOutButton = `<a className='btn grey darken-3' onClick={ this.handleSignOut }>Log Out</a>`
    `<div>
        { signOutButton }
        { this.props.children }
    </div>`
