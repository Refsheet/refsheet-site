@Route = ReactRouter.Route
@NotFoundRoute = ReactRouter.NotFoundRoute
@DefaultRoute = ReactRouter.DefaultRoute
{ @RouteHandler, @Link } = ReactRouter

@Routes =
  `<Route handler={ App }>
      <DefaultRoute handler={ Loading } />
      <Route path='/users/:id' handler={ UserApp } />

      <Route path='/users/:userId/:id' handler={ CharacterApp }>
          <DefaultRoute name='summary' handler={ CharacterSummaryView } />
          <Route name='details' path='details' handler={ CharacterDetailView } />
      </Route>

      <NotFoundRoute handler={ NotFound } />
  </Route>`
