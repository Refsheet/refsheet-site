@UserApp = React.createClass
  getInitialState: ->
    characterName: null

  handleSignOut: (e) ->
    $.ajax
      url: '/session'
      type: 'DELETE'
      success: =>
        @props.onLogin null

    e.preventDefault()

  # TODO: This is going away.
  handleCreateCharacter: (e) ->
    $.ajax
      url: @props.currentUser.path + 'characters'
      type: 'POST'
      data: { character: { name: @state.characterName } }
      success: (data) =>
        @props.history.push data.path
        
      error: ->
        Materialize.toast 'Unknown error!', 3000, 'red'
    
    e.preventDefault()

  setCharacterName: (k, v) ->
    @setState characterName: v

  render: ->
    if @props.currentUser?
      signOutButton =
        `<div className='container'>
            <a className='btn grey darken-3 right' onClick={ this.handleSignOut }>Log Out</a>
        </div>`

    characters = @props.currentUser.characters.map (character) =>
      _this = @
      `<li>
          <Link to={ _this.props.currentUser.path + 'characters/' + character.slug } className='btn'>{ character.name }</Link>
      </li>`
      
    `<main>
        { signOutButton }

        <div className='container'>
            <form onSubmit={ this.handleCreateCharacter }>
                <Input id='name' label='New Character Name' onChange={ this.setCharacterName } value={ this.state.characterName } />
                <button type='submit' className='btn'>Create Character</button>
            </form>

            <ul>
                { characters }
            </ul>
        </div>

        { this.props.children }
    </main>`
