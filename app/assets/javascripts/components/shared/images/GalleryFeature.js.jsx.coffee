@GalleryFeature = v1 -> React.createClass
  propTypes:
    editable: React.PropTypes.bool
    first: React.PropTypes.object
    second: React.PropTypes.object
    third: React.PropTypes.object
    onImageSwap: React.PropTypes.func
    onImageClick: React.PropTypes.func
    gallery: React.PropTypes.array


  componentDidMount: ->
    $(window).resize @_initialize
    @_initialize()

  componentDidRecieveProps: (newProps) ->
    if @props.first?.id != newProps.first?.id ||
       @props.second?.id != newProps.second?.id ||
       @props.third?.id != newProps.third?.id
      @_initialize()

  componentDidUpdate: ->
    @_initialize()

  componentWillUnmount: ->
    $(window).off 'resize', @_initialize


  _initialize: ->
    console.debug "[GalleryFeature] Initializing featured gallery..."

    $(@refs.galleryFeature).imagesLoaded =>
      select = (selector) =>
        $(@refs.galleryFeature).find(selector)
      width = (selector) =>
        select(selector).width()
      height = (selector) =>
        select(selector).height()

      ratio = (selector) =>
        if select(selector).data 'aspect-ratio'
          end = select(selector).data('aspect-ratio')
        else
          end = (height(selector + ' img') / width(selector + ' img')) || 1
          select(selector).data('aspect-ratio', end)
        end

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
      y1 = x1 * r1
      y2 = x2 * r2
      y3 = x2 * r3

      $(@refs.featureMain)
        .css
          width: x1
          height: y1
        .children('.feature-main')
          .addClass 'gf-entry'

      $(@refs.featureSide).css
        width: x2

      setTimeout =>
        $(@refs.featureSide).children('.top')
          .css
            height: y2
          .addClass 'gf-entry'
      , 250

      setTimeout =>
        $(@refs.featureSide).children('.bottom')
          .css
            height: y3
          .addClass 'gf-entry'
      , 500



  render: ->
    firstId = this.props.first?.id || 'placeholder-first'
    secondId = this.props.second?.id || 'placeholder-second'
    thirdId = this.props.third?.id || 'placeholder-third'

    `<div ref='galleryFeature' className='gallery-feature'>
        <div ref='featureMain' className='feature-left'>
            <GalleryImage key={ firstId }
                          className='feature-main'
                          image={ this.props.first }
                          size='large'
                          onClick={ this.props.onImageClick }
                          onSwap={ this.props.onImageSwap }
                          gallery={ this.props.gallery }
                          editable={ this.props.editable } />
        </div>

        <div ref='featureSide' className='feature-side'>
            <GalleryImage key={ secondId }
                          className='side-image top'
                          image={ this.props.second }
                          size='medium'
                          onClick={ this.props.onImageClick }
                          onSwap={ this.props.onImageSwap }
                          gallery={ this.props.gallery }
                          editable={ this.props.editable } />

            <GalleryImage key={ thirdId }
                          className='side-image bottom'
                          image={ this.props.third }
                          size='medium'
                          onClick={ this.props.onImageClick }
                          onSwap={ this.props.onImageSwap }
                          gallery={ this.props.gallery }
                          editable={ this.props.editable } />
        </div>
    </div>`
