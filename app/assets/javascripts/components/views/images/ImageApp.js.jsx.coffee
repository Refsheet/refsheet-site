@ImageApp = React.createClass
  getInitialState: ->
    image: null

  load: (data) ->
    @setState image: data
    data.directLoad = true
    $(document).trigger 'app:lightbox', data

  fetch: (imageId) ->
    return unless imageId
    $.ajax
      url: "/images/#{imageId}.json"
      success: @load

  componentWillMount: ->
    @fetch @props.params.imageId

  componentWillReceiveProps: (newProps) ->
    @fetch newProps.params.imageId

  render: ->
    if @state.image?
      bgImgUrl = "url(#{@state.image.character.featured_image_url})"
      `<Main title={[ this.state.image.title, 'Images' ]}
             bodyClassName='no-footer'
             style={{ backgroundImage: bgImgUrl }} />`

    else
      `<Loading />`
