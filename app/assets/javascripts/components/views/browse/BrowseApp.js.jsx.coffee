@BrowseApp = React.createClass
  perPage: 16
  scrollOffset: 100

  getInitialState: ->
    searching: true
    results: null
    totalResults: null
    page: null
    lastPage: false


  componentDidMount: ->
    @doSearch(@props.location.query.q)

    $(window).scroll =>
      if !@state.lastPage and !@state.searching and $(window).scrollTop() + $(window).height() > $(document).height() - @scrollOffset
        @_loadMore()

  componentWillReceiveProps: (newProps) ->
    if newProps.location.query.q != @props.location.query.q
      @doSearch(newProps.location.query.q)

  _loadMore: ->
    console.log "[BrowseApp] Loading more content: page #{@state.page + 1}"
    @doSearch @props.location.query.q, @state.page + 1

  doSearch: (query='', page=1) ->
    if page > 1
      s = searching: true
    else
      s = results: null, searching: true, page: null, lastPage: true, totalResults: 0

    @setState s, =>
      $.ajax
        url: '/characters.json'
        data: q: query, page: page
        success: (data) =>
          results = []
          results = results.concat @state.results if page > 1
          results = results.concat data.characters
          lastPage = data.characters.length < @perPage
          totalResults = data.$meta.total
          @setState { results, page, lastPage, totalResults, searching: false }
          console.debug "[BrowseApp] Loaded #{data.characters.length} new records, #{results.length} total.", data.$meta

        error: (error) =>
          console.error error
          @setState results: [], searching: false, page: null, lastPage: true, totalResults: 0
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
        <Section className='search-results'>
            { this.state.searching
                ? <div>Searching...</div>
                : this.state.results &&
                    <div>
                        Exactly { this.state.totalResults } results
                        { this.props.location.query.q &&
                            <span> | <Link to='/browse'>Clear Search</Link></span>
                        }
                    </div>
            }
        </Section>

        { this.state.results == 0 &&
            <p className='caption center'>No search results :(</p>
        }

        <Section className='results'>
            <div className='row'>
                { results }
            </div>

            { this.state.searching && <Loading className='margin-top--large' message={ false } /> }

            { !this.state.searching && !this.state.lastPage &&
                <div className='margin-top--large center'>
                    <Button href='#' onClick={ this._loadMore } large block className='btn-flat grey darken-4 white-text'>Load More...</Button>
                </div> }
        </Section>
    </Main>`
