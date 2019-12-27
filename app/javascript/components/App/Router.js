import React from 'react'
import { BrowserRouter, Route, Switch } from 'react-router-dom'
import Character from 'Character'
import Moderate from 'Moderate'
import Forums from 'Forums'
import Forum from 'Forums/Forum'
import Artists from 'Artists'

const Router = () => (
  <BrowserRouter>
    <Switch>
      {/** Forums **/}
      <Route path={'/v2/forums/:id'} component={Forum} />
      <Route path={'/v2/forums'} component={Forums} />
      {/*<Route path={"/forums/new"} component={ NewForum } />*/}
      {/*<Route path={"/forums/:id/settings"} component={ EditForum } />*/}
      {/*<Route path={"/forums/:forumId/:id"} component={ Discussion } />*/}

      {/** Moderation **/}
      <Route path="/moderate" component={Moderate} />

      {/** Artists **/}
      <Route path={'/artists/:slug'} component={ Artists.Show } />
      <Route path={'/artists'} component={ Artists.Index } />

      {/** Character Profiles **/}
      <Route path="/v2/:username/:slug" component={Character} />
      <Route path={'/:username/:slug'} component={Character} />

      {/** Account **/}
      <Route path="/myrefs/new" component={Loading} />
      <Route path="/myrefs" component={Loading} />

      {/** Misc **/}
      <Route path="*" component={NotFound} />
    </Switch>
  </BrowserRouter>
)

export default Router
