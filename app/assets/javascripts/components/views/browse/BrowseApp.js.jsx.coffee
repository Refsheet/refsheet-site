@BrowseApp = React.createClass
  getInitialState: ->
    results: null
    query: @props.location.query.q || ''
    committedQuery: @props.location.query.q || ''

  componentDidMount: ->
    Materialize.updateTextFields()
    $('.tabs').tabs()
    @doSearch()

  handleSearchChange: (e) ->
    @setState query: e.target.value

  handleSearchSubmit: (e) ->
    @doSearch()
    e.preventDefault()

  doSearch: (forceQuery) ->
    if forceQuery?
      o = results: null, committedQuery: forceQuery, query: forceQuery
    else
      o = results: null, committedQuery: @state.query, query: @state.query

    @setState o

    newPath = @props.location.pathname
    newPath += '?' + $.param q: o.query if o.query
    window.history.replaceState {}, '', newPath
    $('input[type=search]').blur()

    $.ajax
      url: '/characters.json'
      data: q: o.query
      success: (data) =>
        @setState results: data || []
      error: (error) =>
        @setState results: []
        Materialize.toast error, 3000, 'red'

  clearSearch: (e) ->
    @doSearch('')
    e.preventDefault()

  render: ->
    if @state.results != null
      results = @state.results.map (character) ->
        `<div className='col m3 s6' key={ character.slug }>
            <CharacterLinkCard path={ character.link }
                               name={ character.name }
                               profileImageUrl={ character.profile_image_url } />
        </div>`

    `<Main title='Browse'>
        <Section className='tab-row'>
            <ul className='tabs'>
                <li className='tab'>
                    <Link activeClassName='active' to='/browse'>Characters</Link>
                </li>
                {/*<li className='tab'>
                    <Link activeClassname='active' to='/browse/users'>Users</Link>
                </li>*/}
            </ul>

            <form className='search' onSubmit={ this.handleSearchSubmit }>
                <div className="input-field">
                    <input id="search" type="search" required value={ this.state.query } onChange={ this.handleSearchChange } />
                    <label htmlFor="search"><i className="material-icons">search</i></label>
                </div>
            </form>
        </Section>

        { this.state.results != null &&
            <Section className='search-results'>
                Exactly { this.state.results.length } results
                { this.state.committedQuery &&
                    <span> | <Link to='/browse' onClick={ this.clearSearch }>Clear Search</Link></span>
                }
            </Section>
        }

        { this.state.results == null &&
            <Loading />
        }

        { this.state.results == 0 &&
            <p className='caption center'>No search results :(</p>
        }

        <Section className='results'>
            <div className='row'>
                { results }
            </div>
        </Section>
    </Main>`
