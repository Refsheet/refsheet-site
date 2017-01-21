@ImageApp = React.createClass
  getInitialState: ->
    image: null

  componentWillMount: ->
    $('body').addClass 'no-footer'

    $.ajax
      url: "/images/#{@props.params.imageId}.json"
      success: (data) =>
        @setState image: data

  componentWillUnmount: ->
    $('body').removeClass 'no-footer'

  componentWillUpdate: (newProps, newState) ->
    if newState.image? && !@state.image?
      console.log 'Triggering LB event'
      $(document).trigger 'app:lightbox', newState.image

  render: ->
    if @state.image?
      bgImgUrl = "url(#{@state.image?.character.featured_image_url})"
      `<main style={{ backgroundImage: bgImgUrl }} />`

    else
      `<Loading />`
