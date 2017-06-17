{ @Router, @browserHistory, @Route, @IndexRoute, @Link, @IndexLink } = ReactRouter

@Routes = React.createClass
  propTypes:
    gaPropertyID: React.PropTypes.string
    eagerLoad: React.PropTypes.object

  componentDidMount: ->
    console.debug '[Routes] Initializing app with: ', @props

    if @props.gaPropertyID
      ReactGA.initialize(@props.gaPropertyID)

  _handleRouteUpdate: ->
    if @props.gaPropertyID
      ReactGA.set page: window.location.pathname
      ReactGA.pageview window.location.pathname

  render: ->
    `<Router history={ browserHistory } onUpdate={ this._handleRouteUpdate }>
        <Route path='/' component={ App } eagerLoad={ this.props.eagerLoad }>
            <IndexRoute component={ Home } />

            <Route path='login' component={ LoginView } />
            <Route path='register' component={ RegisterView } />

            <Route path='browse' component={ BrowseApp }>
                <IndexRoute component={ CharacterIndexView } />
                <Route path='users' component={ UserIndexView } />
            </Route>

            <Route path='images/:imageId' component={ ImageApp } />

            <Route path=':userId' component={ UserApp } />
            <Route path=':userId/:characterId' component={ CharacterApp } />

            <Route path='*' component={ NotFound } />
        </Route>
    </Router>`
