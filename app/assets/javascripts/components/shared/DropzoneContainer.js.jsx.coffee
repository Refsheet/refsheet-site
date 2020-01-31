# @prop url [String] REQUIRED
# @prop clickable [Selector]
# @prop method [String]
# @prop paramName [String]
#
@DropzoneContainer = v1 -> React.createClass
  getInitialState: ->
    uploading: false
    uploadPercent: 0
    initialized: false

  componentDidMount: ->
    if this.props.url?
      ___this = this

      $(@refs.dropzone).dropzone
        clickable: @props.clickable || undefined
        url: @props.url
        method: @props.method || 'POST'
        previewTemplate: ''
        headers: { "X-CSRF-Token" : $('meta[name="csrf-token"]').attr('content') }
        paramName: @props.paramName || 'image[image]'

        addedfile: (file) =>
          @setState uploading: true

        thumbnail: (file, dataUrl) ->
          # Display the image in your file.previewElement

        uploadprogress: (file, progress, bytesSent) =>
          console.log progress
          @setState uploadPercent: progress

        success: =>
          @setState uploading: false, uploadPercent: 0

        error: =>
          @setState uploading: false, uploadPercent: 0

        init: ->
          ___this.setState initialized: true

          @on 'error', (_, error) ->
            if error.errors?.image
              Materialize.toast({ html: "Image #{error.errors.image}", displayLength: 3000, classes: 'red' })
            else
              console.error JSON.stringify(error)
              Materialize.toast({ html: "An unknown error has occurred :( Please find Mau and tell them this: #{JSON.stringify(error)}" })

          @on 'success', (_, data) ->
            Materialize.toast({ html: "Image uploaded!", displayLength: 3000, classes: 'green' })
            ___this.props.onUpload(data) if ___this.props.onUpload?

  componentWillUnmount: ->
    if this.props.url? and @state.initialized
      Dropzone.forElement(@refs.dropzone).destroy();

  render: ->
    if @state.uploading
      className = 'dropzone-container uploading'

      if @state.uploadPercent == 100
        statusMessage = 'Processing thumbnails...'

      else
        statusMessage = Math.round(this.state.uploadPercent) + '%'

      dropZoneContent =
        `<div className='container'>
            <h1 className='white-text'>Uploading...</h1>
            <Spinner />
            <p className='flow-text'>{ statusMessage }</p>
        </div>`

    else
      className = 'dropzone-container'
      dropZoneContent =
        `<div className='container'>
            <h1 className='white-text'>Drop images to uplaod</h1>
            <div className='flow-text'>Images only, please.</div>
        </div>`

    `<div className={ className } ref='dropzone'>
        <div className='dropzone-overlay valign-wrapper' data-dz-overlay>
            <div className='modal-page-content valign'>
                { dropZoneContent }
            </div>
        </div>

        { this.props.children }
    </div>`
