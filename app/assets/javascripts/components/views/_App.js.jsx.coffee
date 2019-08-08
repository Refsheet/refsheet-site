@LegacyApp = React.createClass
  childContextTypes:
    currentUser: React.PropTypes.object
    session: React.PropTypes.object
    setCurrentUser: React.PropTypes.func
    eagerLoad: React.PropTypes.object
    environment: React.PropTypes.string
    reportImage: React.PropTypes.func


  getInitialState: ->
    return {
      loading: 0
      reportImageId: null
      eagerLoad: @props.eagerLoad || {}
    }

  getChildContext: ->
    currentUser: @props.session.currentUser
    session: StringUtils.unCamelizeKeys @props.session
    setCurrentUser: @_onLogin
    eagerLoad: @state.eagerLoad
    environment: @props.environment
    reportImage: @_reportImage

  componentDidMount: ->
    @setState eagerLoad: null
    console.debug '[App] Mount complete, clearing eager load.'

    $(document)
      .on 'app:session:update', (e, session) =>
        console.log("Event login (deprecated!): ", session)
        ReactGA.set userId: session.current_user?.id
        @props.setCurrentUser session.current_user

      .on 'app:loading', =>
        val = @state.loading + 1
        val = 1 if val <= 0
        @setState loading: val

      .on 'app:loading:done', =>
        val = @state.loading - 1
        val = 0 if val < 0
        @setState loading: val


  _onLogin: (user, callback) ->
    @props.setCurrentUser user
    ReactGA.set userId: user?.id

  _reportImage: (e) ->
    if e?.target
      imageId = $(e.target).data('image-id')
    else
      imageId = e

    console.debug "Reporting: #{imageId}"
    @setState reportImageId: imageId

  render: ->
    currentUser = @props.session.currentUser || {}

    `<div id='rootApp'>
        { this.state.loading > 0 &&
            <LoadingOverlay /> }

        { Packs.application.Chat && <Packs.application.Chat /> }
        { Packs.application.NewLightbox && <Packs.application.NewLightbox /> }

        <SessionModal />
        <Views.Images.ReportModal imageId={ this.state.reportImageId } />
        <Lightbox currentUser={ currentUser } history={ this.props.history } />

        <Packs.application.NavBar
            query={ this.props.location.query.q }
            onUserChange={ this._onLogin }
            notice={ this.props.notice }
        />

        { this.props.children }

        <Footer />

        {/*<FeedbackModal name={ currentUser && currenUser.name } />*/}
        {/*<a className='btn modal-trigger feedback-btn' href='#feedback-modal'>Feedback</a>*/}

        {/*<NagBar action={{ href: 'https://patreon.com/refsheet', text: 'To Patreon!' }} type='neutral'>*/}
            {/*<div className='first-a-sincere-thank-you'>*/}
                {/*<strong>Hey, friend!</strong> &mdash; We've been making a lot of changes lately, and that's a good thing!*/}
            {/*</div>*/}

            {/*<div className='now-for-some-shameless-begging margin-top--small'>*/}
                {/*I can't make it happen without all your support. Thank you! In return, I'm giving all my supporters*/}
                {/*early access to new features as I develop them. Why not become a Patron?*/}
            {/*</div>*/}
        {/*</NagBar>*/}
    </div>`

# HACK : Redux bridge for session
console.log("Bridging redux to session.")

mapStateToProps = (state) ->
  session: state.session

mapDispatchToProps =
  setCurrentUser: setCurrentUser

@App = connect(mapStateToProps, mapDispatchToProps)(@LegacyApp)