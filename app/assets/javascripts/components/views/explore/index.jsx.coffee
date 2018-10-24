@Explore.Index = React.createClass
  contextTypes:
    eagerLoad: React.PropTypes.object
    currentUser: React.PropTypes.object

  propTypes:
    media: React.PropTypes.object

  # new syntax
  stateLink:
    dataPath: '/explore/:scope'
    statePath: 'media'
    paramMap:
      scope: 'scope'

  # old syntax
  dataPath: '/explore/:scope'

  paramMap:
    scope: 'scope'

  getInitialState: ->
    media: null

  componentWillMount: ->
    StateUtils.load @, 'media'

  componentDidMount: ->
    $(@refs.tabRow).pushpin
      top: $(@refs.tabRow).offset().top
      offset: 56

  componentWillReceiveProps: (newProps) ->
    if @props.match.params.scope != newProps.match.params.scope
      @setState media: null
    StateUtils.reload @, 'media', newProps

  _append: (data) ->
    StateUtils.updateItems @, 'media', data

  _renderImages: ->
    return `<Loading />` unless @state.media

    `<div key={ this.props.match.params.scope }>
        <ImageGallery images={ this.state.media } noFeature noSquare />
        <InfiniteScroll onLoad={ this._append } stateLink={ this.stateLink } params={ this.props.match.params } />
    </div>`

  render: ->
    switch @props.match.params.scope
      when 'favorites'
        title = 'Your Favorites'
        description = 'Everything you\'ve ever loved in one place (finally)!'

      when 'popular'
        title = 'Popular Media'
        description = 'See what\'s getting a lot of love this week on Refsheet.net!'

      else
        title = 'Explore Images'
        description = 'Explore recent artwork uploads across all of Refsheet.net!'

    `<Main title={ title }>
        <Jumbotron className='short'>
            <h1>{ title }</h1>
            <p>{ description }</p>
        </Jumbotron>

        <div className='tab-row-container'>
            <div className='tab-row pushpin' ref='tabRow'>
                <div className='container'>
                    <ul className='tabs'>
                        <li className={ !this.props.match.params.scope ? 'active tab' : 'tab' }>
                            <Link className={ !this.props.match.params.scope ? 'active' : '' } to='/explore'>Recent</Link>
                        </li>

                        <li className={ this.props.match.params.scope == 'popular' ? 'active tab' : 'tab' }>
                            <Link className={ this.props.match.params.scope == 'popular' ? 'active' : '' } to='/explore/popular'>Popular</Link>
                        </li>

                        { this.context.currentUser &&
                            <li className={ this.props.match.params.scope == 'favorites' ? 'active tab' : 'tab' }>
                                <Link className={ this.props.match.params.scope == 'favorites' ? 'active' : '' } to='/explore/favorites'>Favorites</Link>
                            </li> }
                    </ul>
                </div>
            </div>
        </div>

        <Container className='padding-top--large padding-bottom--large'>
            { this._renderImages() }
        </Container>
    </Main>`
