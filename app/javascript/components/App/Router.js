import React from 'react'
import { BrowserRouter, Route, Switch } from 'react-router-dom'
import Character from 'Character'
import Moderate from 'Moderate'

const Router = () => (
  <BrowserRouter>
    <Switch>
      <Route path="/v2/:username/:slug" component={ Character } />
      <Route path={"/:username/:slug"} component={ Character } />
      <Route path="/moderate" component={ Moderate } />

      <Route path="*" component={ NotFound } />
    </Switch>
  </BrowserRouter>
)

export default Router
