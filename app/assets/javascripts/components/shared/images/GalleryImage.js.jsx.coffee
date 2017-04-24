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


  componentDidMount: ->
    $image = $(@refs.image)

    if @props.editable
      _this = this

      $image.draggable
        revert: true
        opacity: 0.6

      $image.droppable
        drop: (event, ui) ->
          $source = ui.draggable
          $target = $(this)

#          $source.css top: '', left: '0'

          sourceId = $source.data 'gallery-image-id'
          targetId = $target.data 'gallery-image-id'

          _this.props.onSwap(sourceId, targetId) if _this.props.onSwap


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
