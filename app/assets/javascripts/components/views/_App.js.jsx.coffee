@App = React.createClass
  getInitialState: ->
    currentUser: null
    lightboxImageId: null
    loading: true

  componentDidMount: ->
    $.get '/session', (data) =>
      @setState currentUser: data, loading: false

  signInUser: (user) ->
    @setState currentUser: user
    
  openLightbox: (imageId) ->
    console.log "Opening lightbox for #{imageId}"
    @setState lightboxImageId: imageId

  closeLightbox: ->
    @setState lightboxImageId: null

  render: ->
    if @state.loading
      `<div id='rootApp'>
          <Loading />
      </div>`
    
    else
      childrenWithProps = React.Children.map this.props.children, (child) =>
        React.cloneElement child,
          onLogin: @signInUser
          onLightbox: @openLightbox
          currentUser: @state.currentUser


      `<div id='rootApp'>
          { this.state.lightboxImageId && <Lightbox imageId={ this.state.lightboxImageId } history={ this.props.history } onClose={ this.closeLightbox } /> }

          <FeedbackModal name={ this.state.currentUser && this.state.currentUser.name } />
          <a className='btn modal-trigger feedback-btn blue-grey' href='#feedback-modal'>Feedback</a>

          <UserBar currentUser={ this.state.currentUser } />

          { childrenWithProps }

          <Footer />
      </div>`
