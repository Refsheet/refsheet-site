@GalleryImage = React.createClass
  propTypes:
    image: React.PropTypes.object
    editable: React.PropTypes.bool
    className: React.PropTypes.string
    size: React.PropTypes.string
    onSwap: React.PropTypes.func
    onClick: React.PropTypes.func


  getInitialState: ->
    image: @props.image


  load: (image) ->
    @setState image: image, @_initialize


  _handleClick: (e) ->
    @props.onClick(@state.image) if @props.onClick
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


  componentDidMount: ->
    @_initialize()

    $(document).on 'app:image:update', (e, image) =>
      return unless @state.image.id == image.id
      @load(image)

  componentWillReceiveProps: (newProps) ->
    if newProps.image?
      @load(newProps.image)


  render: ->
    classNames = ['gallery-image']
    classNames.push @props.className if @props.className
    classNames.push 'draggable' if @props.editable

    if @state.image
      imageSrc = @state.image[@props.size] || @state.image['medium']

      `<a ref='image'
          className={ classNames.join(' ') }
          onClick={ this._handleClick }
          href={ this.state.image.path }
          data-gallery-image-id={ this.state.image.id }
          style={{ backgroundColor: this.state.image.background_color }}
      >
          <img src={ imageSrc } alt={ this.state.image.title } title={ this.state.image.title } />
      </a>`

    else
      classNames.push 'image-placeholder'

      `<div className={ classNames.join(' ') } />`
