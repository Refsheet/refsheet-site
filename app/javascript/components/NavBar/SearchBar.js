import React, { Component } from 'react'
import PropTypes from 'prop-types'
import c from 'classnames'
import qs from 'query-string'
import { withRouter } from 'react-router-dom'

class SearchBar extends Component {
  constructor(props) {
    super(props)

    this.state = {
      active: !!props.query,
      query: props.query,
    }

    this.activate = this.activate.bind(this)
    this.deactivate = this.deactivate.bind(this)
    this.handleQueryChange = this.handleQueryChange.bind(this)
    this.handleSearchSubmit = this.handleSearchSubmit.bind(this)
  }

  UNSAFE_componentWillReceiveProps(newProps) {
    const { query } = newProps
    const { query: oldQuery } = this.state
    const active = !!query

    if (query !== oldQuery) this.setState({ query, active })
  }

  activate() {
    const active = true
    this.setState({ active })
  }

  deactivate() {
    const active = !!this.state.query
    this.setState({ active })
  }

  handleQueryChange(e) {
    e.preventDefault()
    const query = e.target.value
    this.setState({ query })
  }

  handleSearchSubmit(e) {
    e.preventDefault()
    const { query } = this.state

    if (query) {
      const newPath = `/browse?${qs.stringify({ q: query })}`
      e.target.elements[0].blur()
      this.props.history.push(newPath)
    }
  }

  render() {
    const { active, query = '' } = this.state

    return (
      <form
        className={c('search', { active: active })}
        onSubmit={this.handleSearchSubmit}
      >
        <div className="input-field">
          <input
            id="search"
            type="search"
            onChange={this.handleQueryChange}
            onFocus={this.activate}
            onBlur={this.deactivate}
            value={query}
          />

          <label htmlFor="search">
            <i className="material-icons">search</i>
          </label>
        </div>
      </form>
    )
  }
}

SearchBar.propTypes = {
  query: PropTypes.string,
  history: PropTypes.object.isRequired,
}

export default withRouter(SearchBar)
