@DropzoneContainer = React.createClass
  getInitialState: ->
    uploading: false
    uploadPercent: 0

  componentDidMount: ->
    if this.props.url?
      ___this = this

      $('.dropzone-container').dropzone
        clickable: false
        url: this.props.url
        previewTemplate: ''
        headers: { "X-CSRF-Token" : $('meta[name="csrf-token"]').attr('content') }
        paramName: 'image[image]'

        addedfile: (file) =>
          @setState uploading: true

        thumbnail: (file, dataUrl) ->
          # Display the image in your file.previewElement

        uploadprogress: (file, progress, bytesSent) =>
          if progress >= 100
            @setState uploading: false, uploadPercent: 0
          else
            @setState uploadPercent: progress

        init: ->
          @on 'error', (_, error) ->
            Materialize.toast "Image #{error.errors.image}", 3000, 'red'

          @on 'success', (_, data) ->
            Materialize.toast "Image uploaded!", 3000, 'green'
            ___this.props.onUpload(data) if ___this.props.onUpload?

  render: ->
    if @state.uploading
      className = 'dropzone-container uploading'
      dropZoneContent =
        `<div className='container'>
            <h1 className='white-text'>Uploading...</h1>
            <Spinner />
            <p className='flow-text'>{ Math.round(this.state.uploadPercent) + '%' }</p>
        </div>`

    else
      className = 'dropzone-container'
      dropZoneContent =
        `<div className='container'>
            <h1 className='white-text'>Drop images to uplaod</h1>
            <div className='flow-text'>Images only, please.</div>
        </div>`

    `<div className={ className }>
        <div className='dropzone-overlay valign-wrapper' data-dz-overlay>
            <div className='modal-page-content valign'>
                { dropZoneContent }
            </div>
        </div>

        { this.props.children }
    </div>`
