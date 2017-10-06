@Dashboard.ActivityCard = React.createClass
  propTypes:
    activityType: React.PropTypes.string.isRequired
    activityMethod: React.PropTypes.string
    activityField: React.PropTypes.string
    activity: React.PropTypes.object
    activities: React.PropTypes.array
    user: React.PropTypes.object.isRequired
    character: React.PropTypes.object
    timestamp: React.PropTypes.number.isRequired

  _buildImageGrid: (images, grid=[]) ->
    key = images.length

    # 3 Block: 3, 5, 6
    if (images.length > 4 && images.length < 7) || images.length == 3
      [ one, two, three, images... ] = images

      grid.push(
        `<Row noMargin noGutter key={ key }>
            <Column s={8}><GalleryImage image={ one } size='medium_square' /></Column>
            <Column s={4}>
                <Row noMargin noGutter>
                  <Column><GalleryImage image={ two } size='medium_square' /></Column>
                  <Column><GalleryImage image={ three } size='medium_square' /></Column>
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
            <Column s={6}><GalleryImage image={ one } size='medium_square' /></Column>
            <Column s={6}><GalleryImage image={ two } size='medium_square' /></Column>
        </Row>`
      )

      @_buildImageGrid images, grid

    # Single: 1
    else if images.length == 1
      [ one ] = images

      grid.push(
        `<Row noMargin noGutter key={ key }>
            <Column><GalleryImage image={ one } size='medium' /></Column>
        </Row>`
      )

    `<div className='image-grid'>{ grid }</div>`

  _getAttachment: ->
    switch @props.activityType
      when 'Image'
        images = @props.activities || [@props.activity]
        for i in images
          i.character = @props.character
        @_buildImageGrid(@props.activities || [@props.activity])

  _getMessage: ->
    switch @props.activityType
      when 'Image'
        images = @props.activities || [@props.activity]
        str = if images.length == 1 then 'a new photo' else "#{images.length} new photos"
        `<div>Uploaded { str }:</div>`
      else
        `<div className='red-text'>Unsupported activity type: {this.props.activityType}.{this.props.activityMethod}</div>`

  _getIdentity: ->
    if @props.character
      avatarUrl = @props.character.profile_image_url
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
            <DateFormat className='muted right' timestamp={ this.props.timestamp } fuzzy />
            <Link to={ identity.link }>{ identity.name }</Link>

            { this._getMessage() }
        </div>

        { this._getAttachment() }
    </div>`
