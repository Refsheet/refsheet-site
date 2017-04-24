@GalleryFeature = React.createClass
  propTypes:
    editable: React.PropTypes.bool
    first: React.PropTypes.object
    second: React.PropTypes.object
    third: React.PropTypes.object
    onImageSwap: React.PropTypes.func
    onImageClick: React.PropTypes.func


  componentDidMount: ->
    $(window).resize @_initialize
    @_initialize()

  componentDidRecieveProps: (newProps) ->
    if @props.first?.id != newProps.first?.id ||
       @props.second?.id != newProps.second?.id ||
       @props.third?.id != newProps.third?.id
      @_initialize()

  componentWillUnmount: ->
    $(window).off 'resize', @_initialize


  _initialize: ->
    $(@refs.galleryFeature).imagesLoaded =>
      width = (selector) =>
        $(@refs.galleryFeature).find(selector).width()

      height = (selector) =>
        $(@refs.galleryFeature).find(selector).height()

      ratio = (selector) =>
        height(selector) / width(selector)

      g = 15
      x0 = $(@refs.galleryFeature).width() - 5
      r1 = ratio '.feature-main'
      r2 = ratio '.side-image.top'
      r3 = ratio '.side-image.bottom'

      # Lots of magic. Ask Wolfram Alpha.
      t = g - g*r2 - g*r3 + r2*x0 + r3*x0
      b = r1 + r2 + r3
      x1 = t / b
      x2 = x0 - x1 - g

      $(@refs.featureMain).css
        width: x1

      $(@refs.featureSide).css
        width: x2


  render: ->
    `<div ref='galleryFeature' className='gallery-feature'>
        <div ref='featureMain' className='feature-left'>
            <GalleryImage className='feature-main'
                          image={ this.props.first }
                          size='large'
                          onClick={ this.props.onImageClick }
                          onSwap={ this.props.onImageSwap }
                          editable={ this.props.editable } />
        </div>

        <div ref='featureSide' className='feature-side'>
            <GalleryImage className='side-image top'
                          image={ this.props.second }
                          size='medium'
                          onClick={ this.props.onImageClick }
                          onSwap={ this.props.onImageSwap }
                          editable={ this.props.editable } />

            <GalleryImage className='side-image bottom'
                          image={ this.props.third }
                          size='medium'
                          onClick={ this.props.onImageClick }
                          onSwap={ this.props.onImageSwap }
                          editable={ this.props.editable } />
        </div>
    </div>`
