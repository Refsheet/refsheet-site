{ @Router, @browserHistory, @Route, @IndexRoute, @Link } = ReactRouter

@Routes = React.createClass
  render: ->
    `<Router history={ browserHistory }>
        <Route path='/' component={ App }>
            <IndexRoute component={ Loading } />

            <Route path='/users/:userId' component={ UserApp } />

            <Route path='/users/:userId/characters/:characterId' component={ CharacterApp }>
                <IndexRoute name='character-profile' component={ CharacterProfileView } />
                <Route name='character-details' path='details' component={ CharacterDetailView } />
            </Route>

            <Route path='*' component={ NotFound } />
        </Route>
    </Router>`
