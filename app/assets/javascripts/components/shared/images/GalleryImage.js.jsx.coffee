@GalleryImage = React.createClass
  contextTypes:
    currentUser: React.PropTypes.object

  propTypes:
    image: React.PropTypes.object
    editable: React.PropTypes.bool
    wrapperClassName: React.PropTypes.string
    className: React.PropTypes.string
    size: React.PropTypes.string
    onSwap: React.PropTypes.func
    onClick: React.PropTypes.func


  getInitialState: ->
    image: @props.image


  load: (image) ->
    @setState image: image, @_initialize

  _handleFavoriteClick: (e) ->
    action = if @state.image?.is_favorite then 'delete' else 'post'
    Model.request action, '/media/' + @state.image.id + '/favorites', {}, (data) =>
      @_handleFavorite !!data.media_id
    e.preventDefault()


  _handleFavorite: (fav) ->
    o = @state.image
    o.is_favorite = fav
    @setState image: o
    $(document).trigger 'app:image:update', o

  _handleClick: (e) ->
    $target = $(e.target)
    if $target.prop('tagName') == 'IMG'
      if @props.onClick
        @props.onClick(@state.image)
      else
        $(document).trigger 'app:lightbox', [ @state.image, @load ]
    e.preventDefault()

  _initialize: ->
    return unless @state.image

    $image = $(@refs.image)

    if @props.editable
      _this = this

      $image.draggable
        revert: true
        opacity: 0.6
        appendTo: 'body'
        cursorAt:
          top: 5
          left: 5
        helper: =>
          $("<div class='card-panel'>#{@state.image.title}</div>")

      $image.droppable
        tolerance: 'pointer'
        drop: (event, ui) =>
          $source = ui.draggable
          sourceId = $source.data 'gallery-image-id'
          _this.props.onSwap(sourceId, @state.image.id) if _this.props.onSwap


  _updateEvent: (e, image) ->
    return unless @state.image and image and @state.image.id == image.id
    @load(image)


  componentDidMount: ->
    @_initialize()

    $(document).on 'app:image:update', @_updateEvent

  componentWillUnmount: ->
    $(document).off 'app:image:update', @_updateEvent

  componentWillReceiveProps: (newProps) ->
    if newProps.image?
      @load(newProps.image)


  render: ->
    classNames = ['gallery-image']
    classNames.push @props.className if @props.className
    classNames.push 'draggable' if @props.editable

    if @state.image
      if typeof @state.image.url == 'object'
        imageSrc = @state.image.url[@props.size] || @state.image.url['large']
      else
        imageSrc = @state.image[@props.size] || @state.image['large']

      showNsfwWarning = @state.image.nsfw and not @context.currentUser?.settings?.nsfw_ok

      contents =
        `<a ref='image'
            className={ classNames.join(' ') }
            onClick={ this._handleClick }
            href={ this.state.image.path }
            data-gallery-image-id={ this.state.image.id }
            style={{ backgroundColor: this.state.image.background_color }}
        >
            { showNsfwWarning &&
              <div className='nsfw-cover'>
                  <Icon>remove_circle_outline</Icon>
                  <div className='caption'>NSFW</div>
              </div> }

            <div className='overlay'>
                <div className='interactions'>
                    <div className='favs clickable' onClick={ this._handleFavoriteClick }>
                        <Icon>{ this.state.image.is_favorite ? 'star' : 'star_outline' }</Icon>
                        &nbsp;{ NumberUtils.format(this.state.image.favorites_count) }
                    </div>
                    &nbsp;
                    <div className='favs'>
                        <Icon>comment</Icon>
                        &nbsp;{ NumberUtils.format(this.state.image.comments_count) }
                    </div>
                </div>

                <div className='image-title'>
                    <div className='truncate'>{ this.state.image.title }</div>
                    <div className='muted truncate'>By: { this.state.image.character.name }</div>
                </div>
            </div>

            <img src={ imageSrc } alt={ this.state.image.title } title={ this.state.image.title } />
        </a>`

    else
      classNames.push 'image-placeholder'

      contents =
        `<div className={ classNames.join(' ') } />`

    if @props.wrapperClassName
      `<div className={ this.props.wrapperClassName }>
          { contents }
      </div>`

    else
      contents
