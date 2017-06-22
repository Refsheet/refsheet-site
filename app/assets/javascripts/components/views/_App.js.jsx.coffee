@App = React.createClass
  childContextTypes:
    currentUser: React.PropTypes.object
    session: React.PropTypes.object
    setCurrentUser: React.PropTypes.func
    eagerLoad: React.PropTypes.object


  getInitialState: ->
    session: @props.route.session || {}
    loading: 0
    eagerLoad: @props.route.eagerLoad || {}

  getChildContext: ->
    currentUser: @state.session.current_user
    session: @state.session
    setCurrentUser: @_onLogin
    eagerLoad: @state.eagerLoad


  componentWillMount: ->
    unless @state.session.current_user
      @setState loading: 1
      $.get '/session', (data) =>
        @setState session: data, loading: 0
        ReactGA.set userId: data.current_user?.id

  componentDidMount: ->
    @setState eagerLoad: null

    $(document)
      .on 'app:session:update', (e, session) =>
        @setState session: session
        ReactGA.set userId: session.current_user?.id

      .on 'app:loading', =>
        val = @state.loading + 1
        val = 1 if val <= 0
        @setState loading: val

      .on 'app:loading:done', =>
        val = @state.loading - 1
        val = 0 if val < 0
        @setState loading: val


  _onLogin: (user, callback) ->
    s = @state.session
    s.current_user = user
    @setState session: s, callback


  render: ->
    childrenWithProps = React.Children.map this.props.children, (child) =>
      React.cloneElement child,
        onLogin: @_onLogin
        currentUser: @state.currentUser


    `<div id='rootApp'>
        { this.state.loading > 0 &&
            <LoadingOverlay /> }

        <SessionModal />
        <Lightbox currentUser={ this.state.session.current_user } history={ this.props.history } />

        <UserBar session={ this.state.session } query={ this.props.location.query.q }/>

        { childrenWithProps }

        <Footer />

        <FeedbackModal name={ this.state.session.current_user && this.state.session.current_user.name } />
        <a className='btn modal-trigger feedback-btn blue-grey' href='#feedback-modal'>Feedback</a>
    </div>`
