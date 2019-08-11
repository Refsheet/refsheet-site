@ImageGravityModal = React.createClass
  getInitialState: ->
    gravity: @props.image.gravity || 'center'
    loading: false
    
  handleGravityChange: (e) ->
    gravity = $(e.target).closest('[data-gravity]').data 'gravity'
    @setState gravity: gravity

  handleSave: (e) ->
    @setState loading: true
    $.ajax
      url: @props.image.path
      type: 'PATCH'
      data: image: gravity: @state.gravity
      success: (data) =>
        $(document).trigger 'app:image:update', data
        Materialize.toast 'Cropping settings saved. It may take a second to rebuild your thumbnails.', 3000, 'green'
        @setState loading: false
        M.Modal.getInstance(document.getElementById('image-gravity-modal')).close()
      error: (error) =>
        Materialize.toast 'Something bad happened', 3000, 'red'
        @setState loading: false
        console.log error
    e.preventDefault()

  handleClose: (e) ->
    $('#image-gravity-modal').modal('close')
    @setState gravity: @getInitialState()
    e.preventDefault()
    
  render: ->
    gravity_crop = {
      center: { objectPosition: 'center' }
      north: { objectPosition: 'top' }
      south: { objectPosition: 'bottom' }
      east: { objectPosition: 'right' }
      west: { objectPosition: 'left' }
    }

    `<Modal id='image-gravity-modal' title='Change Image Cropping'>
        <p>Images can crop with a focus on the top, bottom, left, right or center. Ideally, the most important
            part of the image will be visible when cropped to a square or circle.</p>

        <div className='image-crop margin-top--large'>
            <img src={ this.props.image.url } style={ gravity_crop[this.state.gravity] } />
            <a onClick={ this.handleGravityChange } className='btn g-north' data-gravity='north'><i className='material-icons'>keyboard_arrow_up</i></a>
            <a onClick={ this.handleGravityChange } className='btn g-east' data-gravity='east'><i className='material-icons'>keyboard_arrow_right</i></a>
            <a onClick={ this.handleGravityChange } className='btn g-south' data-gravity='south'><i className='material-icons'>keyboard_arrow_down</i></a>
            <a onClick={ this.handleGravityChange } className='btn g-west' data-gravity='west'><i className='material-icons'>keyboard_arrow_left</i></a>
            <a onClick={ this.handleGravityChange } className='btn g-center' data-gravity='center'><i className='material-icons'>close</i></a>
        </div>

        <Row className='actions'>
            <Column>
                <div className='right'>
                    { this.state.loading
                        ? <a className='btn disabled'>Saving...</a>
                        : <a className='btn waves-effect waves-light' onClick={ this.handleSave }>Save</a> }
                </div>

                <a className='btn grey darken-3' onClick={ this.handleClose }>
                    <i className='material-icons'>cancel</i>
                </a>
            </Column>
        </Row>
    </Modal>`
