import React from 'react'
import { BrowserRouter as Router, Route } from 'react-router-dom'
import { ApolloProvider } from 'react-apollo'
import client from 'ApplicationService'
import Character from 'Character'

App = () ->
  `<Router>
    <ApolloProvider client={client}>
      <Route path="/v2/:username/:slug" component={ Character } />
    </ApolloProvider>
  </Router>`

export default App
