import React, { Component } from 'react'
import PropTypes from 'prop-types'
import Main from '../../Shared/Main'
import { forumType } from '../index'
import Jumbotron from '../../Shared/Jumbotron'
import { Link, NavLink } from 'react-router-dom'
import { withNamespaces } from 'react-i18next'
import Discussions from './Discussions'
import Discussion from '../Discussion'
import { Route, Switch } from 'react-router'
import About from './About'
import Members from './Members'
import NewPost from './NewPost'

class View extends Component {
  render() {
    const { forum, t } = this.props

    return (
      <Main title={'Forums'} className={'main-flex split-bg-right'}>
        <Jumbotron short>
          <h1>{forum.name}</h1>
          <p>{forum.description}</p>
        </Jumbotron>

        <div className="tab-row-container">
          <div className="tab-row pushpin" ref="tabRow">
            <div className="container">
              <ul className="tabs">
                <li className={'tab'}>
                  <NavLink
                    activeClassName={'active'}
                    to={`/v2/forums/${forum.slug}/about`}
                  >
                    {t('forums.about', 'About & Rules')}
                  </NavLink>
                </li>
                <li className={'tab'}>
                  <NavLink
                    activeClassName={'active'}
                    exact
                    to={`/v2/forums/${forum.slug}`}
                  >
                    {t('forums.posts', 'Posts')}
                  </NavLink>
                </li>
                <li className={'tab'}>
                  <NavLink
                    activeClassName={'active'}
                    to={`/v2/forums/${forum.slug}/members`}
                  >
                    {t('forums.members', 'Members')}
                  </NavLink>
                </li>
              </ul>
            </div>
          </div>
        </div>

        <Switch>
          <Route path={'/v2/forums/:forumId/about'}>
            <About forum={forum} />
          </Route>
          <Route path={'/v2/forums/:forumId/members'}>
            <Members forum={forum} />
          </Route>
          <Route path={'/v2/forums/:forumId/post'}>
            <NewPost forum={forum} />
          </Route>
          <Route path={'/v2/forums/:forumId/:discussionId'}>
            <Discussion forum={forum} />
          </Route>
          <Route>
            <Discussions forum={forum} />
          </Route>
        </Switch>
      </Main>
    )
  }
}

View.propTypes = {
  forum: forumType,
}

const translated = withNamespaces('common')(View)

export default translated
