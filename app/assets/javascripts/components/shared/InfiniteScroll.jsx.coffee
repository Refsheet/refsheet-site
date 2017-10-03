@InfiniteScroll = React.createClass
  propTypes:
    onLoad: React.PropTypes.func.isRequired
    stateLink: React.PropTypes.object.isRequired
    params: React.PropTypes.object.isRequired
    perPage: React.PropTypes.number
    scrollOffset: React.PropTypes.number

  getInitialState: ->
    page: 1
    lastPage: false
    loading: false

  componentDidMount: ->
    $(window).on 'scroll.infinite-scroll', =>
      if !@state.lastPage and !@state.loading and ($(window).scrollTop() + $(window).height() > $(document).height() - (@props.scrollOffset || 100))
        @_fetch()

  componentWillUnmount: ->
    $(window).off 'scroll.infinite-scroll'

  _fetch: ->
    console.log "Infinite fetch:", @props.stateLink, @props.params
    fetchUrl = StateUtils.getFetchUrl(@props.stateLink, @props.params)
    data = page: parseInt(@state.page) + 1

    @setState loading: true, =>
      Model.request 'GET', fetchUrl, data, (data) =>
        items = ObjectPath.get data, @props.stateLink.statePath
        meta  = data.$meta

        console.log "Infinite done:", items, meta

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
    </div>`

