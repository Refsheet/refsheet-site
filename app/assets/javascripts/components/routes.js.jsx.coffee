{ @Router, @browserHistory, @Route, @IndexRoute, @IndexRedirect, @Link, @IndexLink } = ReactRouter

@Routes = React.createClass
  propTypes:
    gaPropertyID: React.PropTypes.string
    eagerLoad: React.PropTypes.object
    flash: React.PropTypes.object

  componentDidMount: ->
    console.log "Loading #{@props.environment} environment."

    $ ->
      $('#rootAppLoader').fadeOut(300)

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

    $(document).trigger 'navigate'

  render: ->
    staticPaths = ['privacy', 'terms', 'support'].map (path) ->
      `<Route key={ path } path={ path } component={ Static.View } />`

    `<Router history={ browserHistory } onUpdate={ this._handleRouteUpdate }>
        <Route path='/' component={ App } eagerLoad={ this.props.eagerLoad } environment={ this.props.environment }>
            <IndexRoute component={ Home } title='Home' />

            <Route path='login' component={ LoginView } />
            <Route path='register' component={ RegisterView } />

            <Route path='account' title='Account' component={ Views.Account.Layout }>
                <IndexRedirect to='settings' />
                <Route path='settings' title='Account Settings' component={ Views.Account.Settings.Show } />
                <Route path='support' title='Support Settings' component={ Views.Account.Settings.Support } />
                <Route path='notifications' title='Notification Settings' component={ Views.Account.Settings.Notifications } />
            </Route>

            <Route path='/notifications' title='Notifications' component={ Views.Account.Notifications.Show } />

            <Route path='browse' component={ BrowseApp }>
                <IndexRoute component={ CharacterIndexView } />
                <Route path='users' component={ UserIndexView } />
            </Route>

            <Route path='explore' component={ Explore.Index }>
                <Route path=':scope' />
            </Route>


            <Route path='forums'>
                <IndexRoute component={ Forums.Index } />

                <Route path=':forumId' component={ Forums.Show }>
                    <Route path=':threadId' component={ Forums.Threads.Show } />
                </Route>
            </Route>


            {/*== Static Routes */}

            { staticPaths }
            <Route path='static/:pageId' component={ Static.View } />


            {/*== Profile Content */}

            <Route path='images/:imageId' component={ ImageApp } />
            <Route path=':userId' component={ User.View } />
            <Route path=':userId/:characterId' component={ Packs.application.CharacterView } />


            {/*== Fallback */}

            <Route path='*' component={ NotFound } />
        </Route>
    </Router>`
