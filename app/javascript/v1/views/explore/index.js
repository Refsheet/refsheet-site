/* do-not-disable-eslint
    no-undef,
    react/jsx-no-undef,
    react/no-deprecated,
    react/no-string-refs,
    react/react-in-jsx-scope,
*/
import React from 'react'
import createReactClass from 'create-react-class'
import PropTypes from 'prop-types'
import Loading from '../../shared/Loading'
import InfiniteScroll from '../../shared/InfiniteScroll'
import Main from '../../shared/Main'
import Jumbotron from '../../../components/Shared/Jumbotron'
import { Link } from 'react-router-dom'
import Container from '../../shared/material/Container'

import $ from 'jquery'
import StateUtils from '../../utils/StateUtils'
import Gallery from '../../../components/Character/Gallery'
import compose, { withCurrentUser } from '../../../utils/compose'
// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
const Index = createReactClass({
  contextTypes: {
    eagerLoad: PropTypes.object,
  },

  propTypes: {
    media: PropTypes.object,
  },

  // new syntax
  stateLink: {
    dataPath: '/explore/:scope',
    statePath: 'media',
    paramMap: {
      scope: 'scope',
    },
  },

  // old syntax
  dataPath: '/explore/:scope',

  paramMap: {
    scope: 'scope',
  },

  getInitialState() {
    return { media: null }
  },

  UNSAFE_componentWillMount() {
    StateUtils.load(this, 'media')
  },

  componentDidMount() {
    // return $(this.refs.tabRow).pushpin({
    //   top: $(this.refs.tabRow).offset().top,
    //   offset: 56,
    // })
  },

  UNSAFE_componentWillReceiveProps(newProps) {
    if (
      (this.props.match != null ? this.props.match.params.scope : undefined) !==
      (newProps.match != null ? newProps.match.params.scope : undefined)
    ) {
      this.setState({ media: null })
    }
    StateUtils.reload(this, 'media', newProps)
  },

  _append(data) {
    return StateUtils.updateItems(this, 'media', data)
  },

  _renderImages() {
    if (!this.state.media) {
      return <Loading />
    }

    console.log(this.state.media)

    return (
      <div key={this.props.match && this.props.match.params.scope}>
        <Gallery v1Data noHeader images={this.state.media} />
        <InfiniteScroll
          onLoad={this._append}
          stateLink={this.stateLink}
          params={this.props.match && this.props.match.params}
        />
      </div>
    )
  },

  render() {
    let description, title
    switch (
      this.props.match != null ? this.props.match.params.scope : undefined
    ) {
      case 'favorites':
        title = 'Your Favorites'
        description = "Everything you've ever loved in one place (finally)!"
        break

      case 'popular':
        title = 'Popular Media'
        description =
          "See what's getting a lot of love this week on Refsheet.net!"
        break

      default:
        title = 'Explore Images'
        description =
          'Explore recent artwork uploads across all of Refsheet.net!'
    }

    console.log(this.context)

    return (
      <Main title={title}>
        <Jumbotron short>
          <h1>{title}</h1>
          <p>{description}</p>
        </Jumbotron>

        <div className="tab-row-container">
          <div className="tab-row pushpin" ref="tabRow">
            <div className="container">
              <ul className="tabs">
                <li
                  className={
                    !this.props.match.params.scope ? 'active tab' : 'tab'
                  }
                >
                  <Link
                    className={!this.props.match.params.scope ? 'active' : ''}
                    to="/explore"
                  >
                    Recent
                  </Link>
                </li>

                <li
                  className={
                    this.props.match.params.scope == 'popular'
                      ? 'active tab'
                      : 'tab'
                  }
                >
                  <Link
                    className={
                      this.props.match.params.scope == 'popular' ? 'active' : ''
                    }
                    to="/explore/popular"
                  >
                    Popular
                  </Link>
                </li>

                {this.props.currentUser && (
                  <li
                    className={
                      this.props.match.params.scope == 'favorites'
                        ? 'active tab'
                        : 'tab'
                    }
                  >
                    <Link
                      className={
                        this.props.match.params.scope == 'favorites'
                          ? 'active'
                          : ''
                      }
                      to="/explore/favorites"
                    >
                      Favorites
                    </Link>
                  </li>
                )}
              </ul>
            </div>
          </div>
        </div>

        <Container className="padding-top--large padding-bottom--large">
          {this._renderImages()}
        </Container>
      </Main>
    )
  },
})

export default compose(withCurrentUser())(Index)
