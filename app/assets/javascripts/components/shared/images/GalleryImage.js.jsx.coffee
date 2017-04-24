@GalleryImage = React.createClass
  propTypes:
    image: React.PropTypes.object
    editable: React.PropTypes.bool
    className: React.PropTypes.string
    size: React.PropTypes.string
    onSwap: React.PropTypes.func
    onClick: React.PropTypes.func


  _handleClick: (e) ->
    @props.onClick(@props.image) if @props.onClick
    e.preventDefault()

  _initialize: ->
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
          $("<div class='card-panel'>#{@props.image.title}</div>")

      $image.droppable
        tolerance: 'pointer'
        drop: (event, ui) =>
          $source = ui.draggable
          sourceId = $source.data 'gallery-image-id'
          _this.props.onSwap(sourceId, @props.image.id) if _this.props.onSwap


  componentDidMount: ->
    @_initialize()


  render: ->
    classNames = ['gallery-image']
    classNames.push @props.className if @props.className
    classNames.push 'draggable' if @props.editable
    classNames.push 'image-placeholder' unless @props.image

    if @props.image
      imageSrc = @props.image[@props.size] || @props.image['medium']
      image = `<img src={ imageSrc } alt={ this.props.image.title } title={ this.props.image.title } />`

    `<a ref='image'
        className={ classNames.join(' ') }
        onClick={ this._handleClick }
        href={ this.props.image.path }
        data-gallery-image-id={ this.props.image.id }
    >
        { image }
    </a>`
