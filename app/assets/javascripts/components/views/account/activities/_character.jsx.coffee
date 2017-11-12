@Views.Account.Activities.Character = React.createClass
  propTypes:
    characters: React.PropTypes.array.isRequired
    username: React.PropTypes.string.isRequired

  render: ->
    if @props.characters.length == 1
      str = 'a new character'
    else
      str = "#{@props.characters.length} new characters"

    characters = @props.characters.map (character) =>
      identity =
        username: @props.username
        name: character.name
        avatarUrl: character.profile_image_url
        link: character.link
        type: 'character'

      `<Row key={ character.id } oneColumn>
          <div className='character-card compact-mobile z-depth-0 margin-bottom--none' style={{ backgroundColor: '#1a1a1a', overflow: 'visible' }}>
              <div className='character-details' style={{ minHeight: 'initial' }}>
                  <h3 className='name margin-top--none'>
                      <IdentityLink to={ identity } />
                  </h3>

                  <div className='description'>
                      <AttributeTable defaultValue='Unspecified'>
                          <Attribute id='species' name='Species' value={ character.species } />
                          <Attribute id='gender' name='gender' value={ character.gender } />
                      </AttributeTable>
                  </div>
              </div>

              <div className='character-image' onClick={ this.handleImageClick }>
                  <div className='slant' style={{ backgroundColor: '#1a1a1a' }} />
                  <img src={ character.profile_image_url } />
              </div>
          </div>
      </Row>`

    `<div className='activity'>
        <div className='headline margin-bottom--medium'>
            Created { str }.
        </div>

        { characters }
    </div>`
