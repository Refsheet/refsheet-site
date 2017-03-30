@App = React.createClass
  childContextTypes:
    currentUser: React.PropTypes.object


  getInitialState: ->
    currentUser: null
    loading: 1

  getChildContext: ->
    currentUser: @state.currentUser


  componentWillMount: ->
    $.get '/session', (data) =>
      @setState currentUser: data, loading: (@state.loading - 1)
      ReactGA.set userId: data?.id

  componentDidMount: ->
    $(document)
      .on 'app:sign_in', (e, user) =>
        @setState currentUser: user
        ReactGA.set userId: user?.id

      .on 'app:loading', =>
        val = @state.loading + 1
        val = 1 if val <= 0
        @setState loading: val
        console.debug "Loading: ", val

      .on 'app:loading:done', =>
        val = @state.loading - 1
        val = 0 if val < 0
        @setState loading: val
        console.debug "Loading done: ", val


  signInUser: (user) ->
    console.warn "Deprecated: signInUser is very deprecated!!"
    @setState currentUser: user


  render: ->
    childrenWithProps = React.Children.map this.props.children, (child) =>
      React.cloneElement child,
        onLogin: @signInUser
        currentUser: @state.currentUser


    `<div id='rootApp'>
        { this.state.loading > 0 &&
            <LoadingOverlay /> }

        <Lightbox currentUser={ this.state.currentUser } history={ this.props.history } />

        <FeedbackModal name={ this.state.currentUser && this.state.currentUser.name } />
        <a className='btn modal-trigger feedback-btn blue-grey waves waves-light' href='#feedback-modal'>Feedback</a>

        <UserBar currentUser={ this.state.currentUser } />

        { childrenWithProps }

        <Footer />
    </div>`
