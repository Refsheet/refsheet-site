@Dashboard.ActivityCard = React.createClass
  propTypes:
    user: React.PropTypes.object.isRequired
    character: React.PropTypes.object
    images: React.PropTypes.array
    activityType: React.PropTypes.string.isRequired
    dateHuman: React.PropTypes.string.isRequired
    date: React.PropTypes.string.isRequired

  _getMessage: ->
    switch @props.activityType
      when 'Image'
        str = if @props.images.length == 1 then 'a new photo' else "#{@props.images.length} new photos"
        `<div>Uploaded { str }:</div>`

  _buildImageGrid: (images, grid=[]) ->
    key = images.length

    # 3 Block: 3, 5, 6
    if (images.length > 4 && images.length < 7) || images.length == 3
      [ one, two, three, images... ] = images

      grid.push(
        `<Row noMargin noGutter key={ key }>
            <Column s={8}><img src={ one.url.medium_square } alt={ one.name } className='responsive-img block' /></Column>
            <Column s={4}>
                <Row noMargin noGutter>
                  <Column><img src={ two.url.medium_square } alt={ two.name } className='responsive-img block' /></Column>
                  <Column><img src={ three.url.medium_square } alt={ three.name } className='responsive-img block' /></Column>
                </Row>
            </Column>
        </Row>`
      )

      @_buildImageGrid images, grid

    # 2 Block: 2, 4, 7+
    else if images.length == 2 || images.length == 4 || images.length >= 7
      [ one, two, images... ] = images

      grid.push(
        `<Row noMargin noGutter key={ key }>
            <Column s={6}><img src={ one.url.medium_square } alt={ one.name } className='responsive-img block' /></Column>
            <Column s={6}><img src={ two.url.medium_square } alt={ two.name } className='responsive-img block' /></Column>
        </Row>`
      )

      @_buildImageGrid images, grid

    # Single: 1
    else if images.length == 1
      [ one ] = images

      grid.push(
        `<Row noMargin noGutter key={ key }>
            <Column><img src={ one.url.medium } alt={ one.name } className='responsive-img block' /></Column>
        </Row>`
      )

    `<div className='image-grid'>{ grid }</div>`

  _getAttachment: ->
    if @props.images?
      @_buildImageGrid @props.images

  _getIdentity: ->
    if @props.character
      avatarUrl = @props.character.profile_image.url.thumb_square
      name = @props.character.name
      link = @props.character.link

    else
      avatarUrl = @props.user.avatar_url
      name = @props.user.name
      link = @props.user.link

    { avatarUrl, name, link }

  render: ->
    { date, dateHuman } = @props
    identity = @_getIdentity()

    `<div className='card sp with-avatar margin-bottom--medium'>
        <img className='avatar circle' src={ identity.avatarUrl } alt={ identity.name } />

        <div className='card-content'>
            <div className='muted right' title={ date }>{ dateHuman }</div>
            <Link to={ identity.link }>{ identity.name }</Link>

            { this._getMessage() }
        </div>

        { this._getAttachment() }
    </div>`
