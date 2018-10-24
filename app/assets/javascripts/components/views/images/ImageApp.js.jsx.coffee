@ImageApp = React.createClass
  getInitialState: ->
    image: null

  load: (data) ->
    @setState image: data, ->
      data.directLoad = true
      $(document).trigger 'app:lightbox', data

  fetch: (imageId) ->
    return unless imageId
    Model.get "/images/#{imageId}.json", @load

  componentWillMount: ->
    @fetch @props.match?.params.imageId

  componentWillReceiveProps: (newProps) ->
    if newProps.match?.params.imageId and @state.image and (newProps.match?.params.imageId isnt @state.image?.id)
      @fetch newProps.match?.params.imageId

  render: ->
    if @state.image?
      `<CharacterViewSilhouette title={[ this.state.image.title, 'Images' ]}
                                coverImage={ this.state.image.character.featured_image_url }
                                immediate />`

    else
      `<CharacterViewSilhouette />`


      # BROKEN THINGS FOR TOMRROW

      # Change eagerload to CONTEXT
      # Loading screen broken?
      # Character load on their own.
