import React, { Component } from 'react'
import PropTypes from 'prop-types'
import compose from '../../../utils/compose'
import { withTranslation } from 'react-i18next'

import { Redirect, Route, Switch } from 'react-router'
import { NavLink } from 'react-router-dom'
import { Icon } from 'react-materialize'

import Main from '../../Shared/Main'
import Jumbotron from '../../Shared/Jumbotron'

import Discussions from './Discussions'
import Discussion from '../Discussion'
import About from './About'
import Members from './Members'
import NewDiscussion from '../NewDiscussion'
import SearchForm from './SearchForm'
import { withQuery } from '../../../utils/RouteUtils'
import Error from '../../Shared/Error'

class View extends Component {
  constructor(props) {
    super(props)

    this.tabRow = null
  }

  render() {
    const { forum, t, query } = this.props
    if (!forum) return <Error error={'Forum undefined!'} />

    return (
      <Main
        title={[forum.name, 'Forums']}
        className={'main-flex split-bg-right'}
      >
        <div
          className={'forum-header z-depth-1'}
          style={{ position: 'relative', zIndex: 1 }}
        >
          <Jumbotron short>
            <h1>{forum.name}</h1>
            <p>{forum.summary}</p>
          </Jumbotron>

          <div className="tab-row-container">
            <div className="tab-row pushpin" ref={r => (this.tabRow = r)}>
              <div className="container">
                <ul className="tabs">
                  <li className={'tab'}>
                    <NavLink
                      activeClassName={'active'}
                      to={`/forums/${forum.slug}/about`}
                    >
                      {t('forums.about', 'About & Rules')}
                    </NavLink>
                  </li>
                  <li className={'tab'}>
                    <NavLink
                      activeClassName={'active'}
                      isActive={(match, location) => {
                        const subPath = location.pathname.split('/')[3]
                        return (
                          ['about', 'members', 'edit'].indexOf(subPath) === -1
                        )
                      }}
                      to={`/forums/${forum.slug}`}
                    >
                      {t('forums.posts', 'Posts')}
                    </NavLink>
                  </li>
                  <li className={'tab'}>
                    <NavLink
                      activeClassName={'active'}
                      to={`/forums/${forum.slug}/members`}
                    >
                      {t('forums.members', 'Members')}
                    </NavLink>
                  </li>
                </ul>

                <div className={'action'}>
                  <SearchForm forum={forum} query={query.q} />
                </div>
              </div>
            </div>
          </div>
        </div>

        <Switch>
          <Redirect
            from={'/v2/forums/:forumId/about'}
            to={'/forums/:forumId/about'}
          />
          <Route path={'/forums/:forumId/about'}>
            <About forum={forum} />
          </Route>
          <Redirect
            from={'/v2/forums/:forumId/members'}
            to={'/forums/:forumId/members'}
          />
          <Route path={'/forums/:forumId/members'}>
            <Members forum={forum} />
          </Route>
          <Redirect
            from={'/v2/forums/:forumId/post'}
            to={'/forums/:forumId/post'}
          />
          <Route path={'/forums/:forumId/post'}>
            <NewDiscussion forum={forum} />
          </Route>
          <Redirect
            from={'/v2/forums/:forumId/:discussionId'}
            to={'/forums/:forumId/:discussionId'}
          />
          <Route path={'/forums/:forumId/:discussionId'}>
            <Discussion forum={forum} />
          </Route>
          <Route>
            <Discussions forum={forum} query={query.q} />
          </Route>
        </Switch>
      </Main>
    )
  }
}

export const forumType = PropTypes.shape({
  slug: PropTypes.string.isRequired,
  name: PropTypes.string.isRequired,
  summary: PropTypes.string,
  description: PropTypes.string,
  system_owned: PropTypes.bool,
  rules: PropTypes.string,
  prepost_message: PropTypes.string,
  open: PropTypes.bool,
})

View.propTypes = {
  forum: forumType,
}

export default compose(withTranslation('common'), withQuery)(View)
