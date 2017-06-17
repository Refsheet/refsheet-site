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
    if @props.route.image and @props.route.image.id is @props.params.imageId
      console.debug "EAGER LOADING:", @props.route.image
      @load @props.route.image
    else
      @fetch @props.params.imageId

  componentWillReceiveProps: (newProps) ->
    if newProps.params.imageId and newProps.params.imageId isnt @state.image.id
      @fetch newProps.params.imageId

  render: ->
    if @state.image?
      `<CharacterViewSilhouette title={[ this.state.image.title, 'Images' ]}
                                coverImage={ this.state.image.character.featured_image_url }
                                immediate />`

    else
      `<CharacterViewSilhouette />`
