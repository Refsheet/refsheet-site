@App = React.createClass
  getInitialState: ->
    session: {}
    loading: true

  componentWillMount: ->
    $.get '/session', (data) =>
      @setState session: data, loading: false
      ReactGA.set userId: data.current_user?.id


  componentDidMount: ->
    $(document).on 'app:session:update', (e, session) =>
      @setState session: session
      ReactGA.set userId: session.current_user?.id

  onLogin: (user) ->
    s = @session
    s.current_user = user
    @setState session: s

  render: ->
    if @state.loading
      `<div id='rootApp'>
          <Loading />
      </div>`
    
    else
      childrenWithProps = React.Children.map this.props.children, (child) =>
        React.cloneElement child,
          onLogin: @onLogin
          currentUser: @state.session.current_user


      `<div id='rootApp'>
          <Lightbox currentUser={ this.state.session.current_user } history={ this.props.history } />

          <FeedbackModal name={ this.state.session.current_user && this.state.session.current_user.name } />
          <a className='btn modal-trigger feedback-btn blue-grey' href='#feedback-modal'>Feedback</a>

          <UserBar session={ this.state.session } />

          { childrenWithProps }

          <Footer />
      </div>`
