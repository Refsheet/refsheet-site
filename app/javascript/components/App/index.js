import React from 'react'
import reactGuard from 'react-guard'
import { ApolloProvider } from 'react-apollo'
import { Provider as ReduxProvider } from 'react-redux'
import { createStore } from 'redux'
import rootReducer from 'reducers'
import Router from './Router'
import client from 'ApplicationService'

reactGuard(React, (error, componentInfo) => {
  const errorString = `Failed to render <${componentInfo.name} />!`

  if (console && console.error) {
    console.error(errorString, componentInfo)
    console.error(error.stack)
  }

  return <span>{errorString}</span>
})

const App = ({children: propChildren}) => {
  // const store = createStore(rootReducer)

  const children = propChildren || <Router />

  return (
    <ApolloProvider client={ client }>
      {/*<ReduxProvider store={ store }>*/}
      { children }
      {/*</ReduxProvider>*/}
    </ApolloProvider>
  )
}

export default App
