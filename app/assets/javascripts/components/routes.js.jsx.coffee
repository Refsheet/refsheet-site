{ @Router, @browserHistory, @Route, @IndexRoute, @Link, @IndexLink } = ReactRouter

@Routes = React.createClass
  render: ->
    `<Router history={ browserHistory }>
        <Route path='/' component={ App }>
            <IndexRoute component={ Home } />

            <Route path='login' component={ LoginView } />
            <Route path='register' component={ RegisterView } />
            <Route path='marketplace' component={ Loading } />

            <Route path='images/:imageId' component={ ImageApp } />

            <Route path=':userId' component={ UserApp } />
            <Route path=':userId/:characterId' component={ CharacterApp }/>

            <Route path='*' component={ NotFound } />
        </Route>
    </Router>`
