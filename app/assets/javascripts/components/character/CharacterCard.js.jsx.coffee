@CharacterCard = React.createClass
  getInitialState: ->
    character: @props.character

  handleAttributeChange: (data, onSuccess, onError) ->
    postData =
      character: {}

    postData.character[data.id] = data.value

    $.ajax
      url: @state.character.path
      type: 'PATCH',
      data: postData

      success: (data) =>
        @setState character: data
        onSuccess()

      error: (error) =>
        onError(value: error.JSONData?.errors[data.id])

  contextTypes:
    router: React.PropTypes.func

  render: ->
    [..., currentRoute] = @context.router.getCurrentRoutes()

    if currentRoute.name == 'character-details'
      if @state.character.special_notes?
        specialNotes =
          `<div className='important-notes'>
              <h2>Important Notes:</h2>
              <p>{ this.props.chraracter.special_notes }</p>
          </div>`

      heightWeight =
        [this.state.character.height, this.state.character.weight].filter((i) ->
          i?
        ).join ','

      description =
        `<div className='description'>
            <AttributeTable onAttributeUpdate={ this.handleAttributeChange }
                            defaultValue='Unspecified'
                            freezeName={ true }
                            hideNotesForm={ true }>

                <Attribute id='gender' name='Gender' value={ this.state.character.gender } />
                <Attribute id='species' name='Species' value={ this.state.character.species } />
                <Attribute id='height_weight' name='Height & Weight' value={ heightWeight } />
                <Attribute id='body_type' name='Body Type' value={ this.state.character.body_type } />
                <Attribute id='personality' name='Personality' value={ this.state.character.personality } />
            </AttributeTable>

            { specialNotes }
        </div>`

      actions =
        `<div>
        </div>`

    else
      description =
        `<div className='description flow-text'>
            { this.state.character.special_notes || <p className='no-description'>No description.</p> }
        </div>`

      actions =
        `<div className='actions'>
            <a href='#' className='btn z-index-1'>+ Follow</a>
        </div>`

    if @props.nickname
      nickname = `<span className='nickname'> ({ this.state.character.nickname })</span>`

    prefixClass = 'title-prefix'
    suffixClass = 'title-suffix'

    if @props.officialPrefix
      prefixClass += ' official'

    if @props.officialSuffix
      prefixClass += ' official'

    `<div className='character-card'>
        <div className='character-details'>
            <h1 className='name'>
                <span className={ prefixClass }>{ this.props.titlePrefix } </span>
                <span className='real-name'>{ this.state.character.name }</span>
                { nickname }
                <span className={ suffixClass }> { this.props.titleSuffix }</span>
            </h1>

            { description }
            { actions }
        </div>
        <div className='character-image'>
            <div className='slant' />
            <img src={ this.state.character.profile_image.url } />
        </div>
    </div>`
