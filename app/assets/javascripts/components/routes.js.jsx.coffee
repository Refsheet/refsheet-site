{ 
  @RouteHandler
  @Link
  @Route
  @NotFoundRoute
  @DefaultRoute
} = ReactRouter

@Routes =
  `<Route handler={ App }>
      <DefaultRoute handler={ Loading } />
      
      <Route path='/users/:userId' handler={ UserApp } />

      <Route path='/users/:userId/:characterId' handler={ CharacterApp }>
          <DefaultRoute name='character-profile' handler={ CharacterProfileView } />
          <Route name='character-details' path='details' handler={ CharacterDetailView } />
      </Route>

      <NotFoundRoute handler={ NotFound } />
  </Route>`
