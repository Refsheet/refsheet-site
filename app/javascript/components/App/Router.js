import React from 'react'
import { BrowserRouter, Route } from 'react-router-dom'
import Character from 'Character'

const Router = () => (
  <BrowserRouter>
    <Route path="/v2/:username/:slug" component={ Character } />
  </BrowserRouter>
)

export default Router
