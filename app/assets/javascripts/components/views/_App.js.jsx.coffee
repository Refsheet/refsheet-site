@App = React.createClass
  childContextTypes:
    currentUser: React.PropTypes.object
    session: React.PropTypes.object
    setCurrentUser: React.PropTypes.func
    eagerLoad: React.PropTypes.object
    environment: React.PropTypes.string


  getInitialState: ->
    session: @props.route.eagerLoad?.session || { fetch: true }
    loading: 0
    eagerLoad: @props.route.eagerLoad || {}

  getChildContext: ->
    currentUser: @state.session.current_user
    session: @state.session
    setCurrentUser: @_onLogin
    eagerLoad: @state.eagerLoad
    environment: @props.route.environment


  componentWillMount: ->
    if @state.session.fetch
      Model.get '/session', (data) =>
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
        <a className='btn modal-trigger feedback-btn' href='#feedback-modal'>Feedback</a>

        <NagBar action={{ href: 'https://patreon.com/refsheet', text: 'To Patreon!' }} type='good'>
            <div className='first-a-sincere-thank-you'>
                <strong>Hey, friend!</strong> &mdash; We're growing really quickly! This makes me super happy, thank you!
            </div>

            <div className='now-for-some-shameless-begging margin-top--small'>
                Did you know, Refsheet is currently funded entirely through Patreon by wonderful people like you? If
                you can help out, for as little as <strong>$1/month</strong>, we can grow even faster!
            </div>
        </NagBar>
    </div>`
