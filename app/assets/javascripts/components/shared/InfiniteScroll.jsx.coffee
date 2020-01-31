@InfiniteScroll = v1 -> React.createClass
  propTypes:
    onLoad: React.PropTypes.func.isRequired
    params: React.PropTypes.object.isRequired
    perPage: React.PropTypes.number
    scrollOffset: React.PropTypes.number
    count: React.PropTypes.number

    stateLink: React.PropTypes.oneOfType([
      React.PropTypes.object
      React.PropTypes.func
    ]).isRequired

  getDefaultProps: ->
    perPage: 24
    count: 0

  getInitialState: ->
    page: 1
    lastPage: false # @props.count > 0 and @props.count < @props.perPage
    loading: false

  componentWillReceiveProps: (newProps) ->
#    if newProps.count < newProps.perPage
#      @setState lastPage: true
#    else
#      @setState lastPage: false

  componentDidMount: ->
    $(window).on 'scroll.infinite-scroll', =>
      if !@state.lastPage and !@state.loading and ($(window).scrollTop() + $(window).height() > $(document).height() - (@props.scrollOffset || 100))
        @_fetch()

  componentWillUnmount: ->
    $(window).off 'scroll.infinite-scroll'

  _fetch: ->
    fetchUrl = StateUtils.getFetchUrl(@props.stateLink, params: @props.match?.params)
    data = page: parseInt(@state.page) + 1

    @setState loading: true, =>
      Model.request 'GET', fetchUrl, data, (fetchData) =>
        path = if typeof @props.stateLink is 'function' then @props.stateLink().statePath else @props.stateLink.statePath
        items = ObjectPath.get fetchData, path
        meta  = fetchData.$meta

        console.debug "Infinite done:", items, meta

        lastPage = items.length < (@props.perPage || 24)
        @setState page: meta.page, lastPage: lastPage, loading: false, =>
          @props.onLoad items

  _loadMore: (e) ->
    @_fetch()
    e.preventDefault()

  render: ->
    `<div className='infinite-scroll'>
        { !this.state.lastPage && !this.state.loading &&
            <div className='margin-top--large center'>
                <Button href='#' onClick={ this._loadMore } large block className='btn-flat grey darken-4 white-text'>Load More...</Button>
            </div> }

        { this.state.loading &&
            <div className='margin-top--large center'>
                <Spinner small />
            </div> }
    </div>`

