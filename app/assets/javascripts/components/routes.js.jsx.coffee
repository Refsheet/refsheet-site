{ @Router, @browserHistory, @Route, @IndexRoute, @Link, @IndexLink } = ReactRouter

@Routes = React.createClass
  getInitialState: ->
    eagerLoad: @props.eagerLoad || {}

  componentDidMount: ->
    console.debug '[Routes] Initializing app with: ', @props

    if @props.gaPropertyID
      ReactGA.initialize(@props.gaPropertyID)

    @setState eagerLoad: {}

  _handleRouteUpdate: ->
    if @props.gaPropertyID
      ReactGA.set page: window.location.pathname
      ReactGA.pageview window.location.pathname

  render: ->
    `<Router history={ browserHistory } onUpdate={ this._handleRouteUpdate }>
        <Route path='/' component={ App } session={ this.state.eagerLoad.session }>
            <IndexRoute component={ Home } />

            <Route path='login' component={ LoginView } />
            <Route path='register' component={ RegisterView } />

            <Route path='browse' component={ BrowseApp }>
                <IndexRoute component={ CharacterIndexView } />
                <Route path='users' component={ UserIndexView } />
            </Route>

            <Route path='images/:imageId' component={ ImageApp } image={ this.state.eagerLoad.image } />

            <Route path=':userId' component={ UserApp } user={ this.state.eagerLoad.user } />
            <Route path=':userId/:characterId' component={ CharacterApp } character={ this.state.eagerLoad.character } />

            <Route path='*' component={ NotFound } />
        </Route>
    </Router>`
