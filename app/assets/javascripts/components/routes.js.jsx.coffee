{ @Router, @browserHistory, @Route, @IndexRoute, @Link, @IndexLink } = ReactRouter

@Routes = React.createClass
  componentDidMount: ->
    if @props.gaPropertyID
      console.log 'Initialized GA Tracking: ' + @props.gaPropertyID
      ReactGA.initialize(@props.gaPropertyID)

  logPageView: ->
    if @props.gaPropertyID
      ReactGA.set page: window.location.pathname
      ReactGA.pageview window.location.pathname

  render: ->
    `<Router history={ browserHistory } onUpdate={ this.logPageView }>
        <Route path='/' component={ App }>
            <IndexRoute component={ Home } />

            <Route path='login' component={ LoginView } />
            <Route path='register' component={ RegisterView } />
            <Route path='browse' component={ BrowseApp } />

            <Route path='images/:imageId' component={ ImageApp } />

            <Route path=':userId' component={ UserApp } />
            <Route path=':userId/:characterId' component={ CharacterApp }/>

            <Route path='*' component={ NotFound } />
        </Route>
    </Router>`
