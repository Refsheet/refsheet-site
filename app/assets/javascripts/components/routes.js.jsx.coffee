{ @Router, @browserHistory, @Route, @IndexRoute, @Link, @IndexLink } = ReactRouter

@Routes = React.createClass
  componentDidMount: ->
    if @props.gaPropertyID
      ReactGA.initialize(@props.gaPropertyID)

  _handleRouteUpdate: ->
    if @props.gaPropertyID
      ReactGA.set page: window.location.pathname
      ReactGA.pageview window.location.pathname
    @_handleRouteUpdate()

  _handleRouteUpdate: (offset = 0) ->
    if $('html').scrollTop()
      $('html').animate scrollTop: offset, 3000
    else
      $('body').animate scrollTop: offset, 3000

  render: ->
    `<Router history={ browserHistory } onUpdate={ this._handleRouteUpdate }>
        <Route path='/' component={ App }>
            <IndexRoute component={ Home } />

            <Route path='login' component={ LoginView } />
            <Route path='register' component={ RegisterView } />

            <Route path='browse' component={ BrowseApp }>
                <IndexRoute component={ CharacterIndexView } />
                <Route path='users' component={ UserIndexView } />
            </Route>

            <Route path='images/:imageId' component={ ImageApp } />

            <Route path=':userId' component={ UserApp } />
            <Route path=':userId/:characterId' component={ CharacterApp }/>

            <Route path='*' component={ NotFound } />
        </Route>
    </Router>`
