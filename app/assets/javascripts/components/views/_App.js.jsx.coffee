@App = React.createClass
  childContextTypes:
    currentUser: React.PropTypes.object


  getInitialState: ->
    currentUser: null
    loading: true

  getChildContext: ->
    currentUser: @state.currentUser


  componentWillMount: ->
    $.get '/session', (data) =>
      @setState currentUser: data, loading: false
      ReactGA.set userId: data?.id

  componentDidMount: ->
    $(document).on 'app:sign_in', (e, user) =>
      @setState currentUser: user
      ReactGA.set userId: user?.id


  signInUser: (user) ->
    @setState currentUser: user


  render: ->
    if @state.loading
      `<div id='rootApp'>
          <Loading />
      </div>`
    
    else
      childrenWithProps = React.Children.map this.props.children, (child) =>
        React.cloneElement child,
          onLogin: @signInUser
          currentUser: @state.currentUser


      `<div id='rootApp'>
          <Lightbox currentUser={ this.state.currentUser } history={ this.props.history } />

          <FeedbackModal name={ this.state.currentUser && this.state.currentUser.name } />
          <a className='btn modal-trigger feedback-btn blue-grey' href='#feedback-modal'>Feedback</a>

          <UserBar currentUser={ this.state.currentUser } />

          { childrenWithProps }

          <Footer />
      </div>`
