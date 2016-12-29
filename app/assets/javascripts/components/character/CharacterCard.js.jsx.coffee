@CharacterCard = React.createClass
  contextTypes:
    router: React.PropTypes.func

  render: ->
    [..., currentRoute] = @context.router.getCurrentRoutes()

    if currentRoute.name == 'character-details'
      description =
        `<div className='description'>
            <AttributeTable onAttributeChange={ console.log }>
                <Attribute name='Gender' value='Male' />
                <Attribute name='Species' value='Caracal, Snow Leopard' />
                <Attribute name='Size' value='Anthro - 6&apos;2&quot; / 135lbs' />
                <Attribute name='Personality' value='Calm, reserved, peaceful, shamanistic.' />
            </AttributeTable>

            <div className='important-notes'>
                <h2>Important Notes:</h2>
                <p>Mau's hair has been knotted into messy dreadlocks. Its coloration comes from a botched
                    red dye job. Please do not draw Mau in modern or sexual settings.</p>
            </div>
        </div>`

      actions =
        `<div>
        </div>`

    else
      description =
        `<div className='description flow-text'>
            { this.props.profile || <p className='no-description'>No description.</p> }
        </div>`

      actions =
        `<div className='actions'>
            <a href='#' className='btn z-index-1'>+ Follow</a>
        </div>`

    if @props.nickname
      nickname = `<span className='nickname'> ({ this.props.nickname })</span>`

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
                <span className='real-name'>{ this.props.name }</span>
                { nickname }
                <span className={ suffixClass }> { this.props.titleSuffix }</span>
            </h1>

            { description }
            { actions }
        </div>
        <div className='character-image'>
            <div className='slant' />
            <img src={ this.props.imageSrc } />
        </div>
    </div>`
