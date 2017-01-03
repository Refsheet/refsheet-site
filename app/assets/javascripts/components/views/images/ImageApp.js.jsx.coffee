@ImageApp = React.createClass
  getInitialState: ->
    image: null

  componentWillMount: ->
    $('body').addClass 'no-footer'

    $.ajax
      url: "/images/#{@props.params.imageId}.json"
      success: (data) =>
        @setState image: data
        @props.onLightbox data

  componentWillUnmount: ->
    $('body').removeClass 'no-footer'

  render: ->
    if @state.image?
      bgImgUrl = "url(#{@state.image?.character.featured_image_url})"
      `<main style={{ backgroundImage: bgImgUrl }} />`

    else
      `<Loading />`
