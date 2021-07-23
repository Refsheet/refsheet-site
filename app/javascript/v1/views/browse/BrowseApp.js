/* do-not-disable-eslint
    no-undef,
    react/jsx-no-undef,
    react/no-deprecated,
    react/react-in-jsx-scope,
*/
import React from 'react'
import createReactClass from 'create-react-class'
import PropTypes from 'prop-types'
import CharacterLinkCard from '../characters/CharacterLinkCard'
import StringUtils from '../../../utils/StringUtils'
import Main from '../../shared/Main'
import Section from '../../../components/Shared/Section'
import Loading from '../../shared/Loading'
import Button from '../../shared/material/Button'
import { Link } from 'react-router-dom'
import $ from 'jquery'
import Materialize from 'materialize-css'
// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
let BrowseApp
export default BrowseApp = createReactClass({
  perPage: 16,
  scrollOffset: 100,

  getInitialState() {
    return {
      searching: true,
      results: null,
      totalResults: null,
      page: null,
      lastPage: false,
    }
  },

  componentDidMount() {
    this.doSearch(this.props.location.query.q)

    return $(window).on('scroll.browse', () => {
      if (
        !this.state.lastPage &&
        !this.state.searching &&
        $(window).scrollTop() + $(window).height() >
          $(document).height() - this.scrollOffset
      ) {
        return this._loadMore()
      }
    })
  },

  componentWillUnmount() {
    return $(window).off('scroll.browse')
  },

  UNSAFE_componentWillReceiveProps(newProps) {
    if (newProps.location.query.q !== this.props.location.query.q) {
      return this.doSearch(newProps.location.query.q)
    }
  },

  _loadMore() {
    console.log(`[BrowseApp] Loading more content: page ${this.state.page + 1}`)
    return this.doSearch(this.props.location.query.q, this.state.page + 1)
  },

  doSearch(query, page) {
    let s
    if (query == null) {
      query = ''
    }
    if (page == null) {
      page = 1
    }
    if (page > 1) {
      s = { searching: true }
    } else {
      s = {
        results: null,
        searching: true,
        page: null,
        lastPage: true,
        totalResults: 0,
      }
    }

    return this.setState(s, () => {
      return $.ajax({
        url: '/characters.json',
        data: { q: query, page },
        success: data => {
          let results = []
          if (page > 1) {
            results = results.concat(this.state.results)
          }
          results = results.concat(data.characters)
          const lastPage = data.characters.length < this.perPage
          const totalResults = data.$meta.total
          this.setState({
            results,
            page,
            lastPage,
            totalResults,
            searching: false,
          })
          return console.debug(
            `[BrowseApp] Loaded ${data.characters.length} new records, ${results.length} total.`,
            data.$meta
          )
        },

        error: error => {
          console.error(error)
          this.setState({
            results: [],
            searching: false,
            page: null,
            lastPage: true,
            totalResults: 0,
          })
          return Materialize.toast({
            html: error.responseText || 'Unknown error.',
            displayLength: 3000,
            classes: 'red',
          })
        },
      })
    })
  },

  render() {
    let results, title
    if (this.props.location.query.q) {
      title = 'Search Results'
    } else {
      title = 'Browse'
    }

    if (this.state.results !== null) {
      results = this.state.results.map(character => (
        <div className="col m3 s6" key={character.slug}>
          <CharacterLinkCard {...StringUtils.camelizeKeys(character)} />
        </div>
      ))
    }

    return (
      <Main title={title}>
        <Section container className="search-results">
          {this.state.searching ? (
            <div>Searching...</div>
          ) : (
            this.state.results && (
              <div>
                Exactly {this.state.totalResults} results
                {this.props.location.query.q && (
                  <span>
                    {' '}
                    | <Link to="/browse">Clear Search</Link>
                  </span>
                )}
              </div>
            )
          )}
        </Section>

        {this.state.results == 0 && (
          <p className="caption center">No search results :(</p>
        )}

        <Section container className="results">
          <div className="row">{results}</div>

          {this.state.searching && (
            <Loading className="margin-top--large" message={false} />
          )}

          {!this.state.searching && !this.state.lastPage && (
            <div className="margin-top--large center">
              <Button
                href="#"
                onClick={this._loadMore}
                large
                block
                className="btn-flat grey darken-4 white-text"
              >
                Load More...
              </Button>
            </div>
          )}
        </Section>
      </Main>
    )
  },
})
