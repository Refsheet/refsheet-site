@BrowseApp = React.createClass
  getInitialState: ->
    searching: false
    results: null

  componentDidMount: ->
    @doSearch(@props.location.query.q)

  componentWillReceiveProps: (newProps) ->
    if newProps.location.query.q != @props.location.query.q
      @doSearch(newProps.location.query.q)

  doSearch: (query='') ->
    $.ajax
      url: '/characters.json'
      data: q: query
      success: (data) =>
        @setState results: data || [], searching: false

      error: (error) =>
        console.error error
        @setState results: [], searching: false
        Materialize.toast error.responseText, 3000, 'red'

  render: ->
    if @props.location.query.q
      title = 'Search Results'
    else
      title = 'Browse'

    if @state.results != null
      results = @state.results.map (character) ->
        `<div className='col m3 s6' key={ character.slug }>
            <CharacterLinkCard {...StringUtils.camelizeKeys(character)} />
        </div>`

    `<Main title={ title }>
        { this.state.results != null &&
            <Section className='search-results'>
                Exactly { this.state.results.length } results
                { this.props.location.query.q &&
                  <span> | <Link to='/browse'>Clear Search</Link></span>
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
