{ @Router, @browserHistory, @Route, @IndexRoute, @Link, @IndexLink } = ReactRouter

@Routes = React.createClass
  render: ->
    `<Router history={ browserHistory }>
        <Route path='/' component={ App }>
            <IndexRoute component={ Home } />

            <Route path='login' component={ LoginView } />
            <Route path='register' component={ RegisterView } />

            <Route path='users/:userId' component={ UserApp } />

            <Route path='users/:userId/characters/:characterId' component={ CharacterApp }>
                <IndexRoute component={ CharacterProfileView } />
                <Route path='details' component={ CharacterDetailView } />
            </Route>

            <Route path='marketplace' component={ Loading }>
                <Route path='child' component={ Loading } />
            </Route>

            <Route path='*' component={ NotFound } />
        </Route>
    </Router>`
