{ @Router, @browserHistory, @Route, @IndexRoute, @Link, @IndexLink } = ReactRouter

@Routes = React.createClass
  propTypes:
    gaPropertyID: React.PropTypes.string
    eagerLoad: React.PropTypes.object
    flash: React.PropTypes.object

  componentDidMount: ->
    console.debug '[Routes] Initializing app with: ', @props

    if @props.gaPropertyID
      ReactGA.initialize(@props.gaPropertyID)

    if @props.flash
      for level, message of @props.flash
        color =
          switch level
            when 'error' then 'red'
            when 'warn' then 'yellow darken-1'
            when 'notice' then 'green'
            else 'grey darken-2'

        Materialize.toast message, 3000, color

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

            <Route path=':userId' component={ User.View } />
            <Route path=':userId/:characterId' component={ CharacterApp } />

            <Route path='*' component={ NotFound } />
        </Route>
    </Router>`
