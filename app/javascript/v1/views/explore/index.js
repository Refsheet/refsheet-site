/* eslint-disable
    no-undef,
    react/jsx-no-undef,
    react/no-deprecated,
    react/no-string-refs,
    react/react-in-jsx-scope,
*/
import React from 'react'
import createReactClass from 'create-react-class'
import PropTypes from 'prop-types'
// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
let Index; export default Index = createReactClass({
  contextTypes: {
    eagerLoad: PropTypes.object,
    currentUser: PropTypes.object,
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

  componentWillMount() {
    return StateUtils.load(this, 'media')
  },

  componentDidMount() {
    return $(this.refs.tabRow).pushpin({
      top: $(this.refs.tabRow).offset().top,
      offset: 56,
    })
  },

  componentWillReceiveProps(newProps) {
    if (
      (this.props.match != null ? this.props.match.params.scope : undefined) !==
      (newProps.match != null ? newProps.match.params.scope : undefined)
    ) {
      this.setState({ media: null })
    }
    return StateUtils.reload(this, 'media', newProps)
  },

  _append(data) {
    return StateUtils.updateItems(this, 'media', data)
  },

  _renderImages() {
    if (!this.state.media) {
      return <Loading />
    }

    return (
      <div key={this.props.match && this.props.match.params.scope}>
        <ImageGallery images={this.state.media} noFeature noSquare />
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

    return (
      <Main title={title}>
        <Jumbotron className="short">
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

                {this.context.currentUser && (
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
