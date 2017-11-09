@Views.Account.Activities.Image = React.createClass
  propTypes:
    images: React.PropTypes.array.isRequired
    character: React.PropTypes.object.isRequired

  _buildSingle: (key, one) ->
    `<Row noMargin tinyGutter key={ key }>
        <Column><GalleryImage image={ one } size='medium' /></Column>
    </Row>`

  _buildDouble: (key, one, two) ->
    `<Row noMargin tinyGutter key={ key }>
        <Column s={6}><GalleryImage image={ one } size='medium_square' /></Column>
        <Column s={6}><GalleryImage image={ two } size='medium_square' /></Column>
    </Row>`

  _buildTriple: (key, one, two, three) ->
    `<Row noMargin tinyGutter key={ key }>
        <Column s={8}><GalleryImage image={ one } size='medium_square' /></Column>
        <Column s={4}>
            <Row noMargin tinyGutter>
                <Column><GalleryImage image={ two } size='medium_square' /></Column>
                <Column><GalleryImage image={ three } size='medium_square' /></Column>
            </Row>
        </Column>
    </Row>`

  _buildImageGrid: (images, grid=[]) ->
    key = images.length

    # 3 Block: 3, 5, 6
    if (images.length > 4 && images.length < 7) || images.length == 3
      [ one, two, three, images... ] = images
      grid.push @_buildTriple key, one, two, three
      @_buildImageGrid images, grid

    # 2 Block: 2, 4, 7+
    else if images.length == 2 || images.length == 4 || images.length >= 7
      [ one, two, images... ] = images
      grid.push @_buildDouble key, one, two
      @_buildImageGrid images, grid

    # Single: 1
    else if images.length == 1
      [ one ] = images
      grid.push @_buildSingle key, one

    grid

  render: ->
    str = if @props.images.length == 1 then 'a new photo' else "#{@props.images.length} new photos"

    for i in @props.images
      i.character = @props.character

    `<div className='activity'>
        <div className='headline margin-bottom--medium'>Uploaded { str }:</div>
        <Row oneColumn>{ this._buildImageGrid(this.props.images) }</Row>
    </div>`
