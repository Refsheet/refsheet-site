@Explore.Index = React.createClass
  contextTypes:
    eagerLoad: React.PropTypes.object

  propTypes:
    media: React.PropTypes.object

  dataPath: '/explore/:scope'

  paramMap:
    scope: 'scope'

  getInitialState: ->
    media: null

  componentWillMount: ->
    StateUtils.load @, 'media'

  componentWillReceiveProps: (newProps) ->
    StateUtils.reload @, 'media', newProps

  _renderImages: ->
    return `<Loading />` unless @state.media

    `<ImageGallery images={ this.state.media } noFeature noSquare />`

  render: ->
    switch @props.params.scope
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

        <div className='tab-row'>
            <div className='container'>
                <ul className='tabs'>
                    <li className={ !this.props.params.scope ? 'active tab' : 'tab' }><Link className={ !this.props.params.scope ? 'active' : '' } to='/explore'>Recent</Link></li>
                    <li className={ this.props.params.scope == 'popular' ? 'active tab' : 'tab' }><Link className={ this.props.params.scope == 'popular' ? 'active' : '' } to='/explore/popular'>Popular</Link></li>
                    <li className={ this.props.params.scope == 'favorites' ? 'active tab' : 'tab' }><Link className={ this.props.params.scope == 'favorites' ? 'active' : '' } to='/explore/favorites'>Favorites</Link></li>
                </ul>
            </div>
        </div>

        <Container className='padding-top--large padding-bottom--large'>
            { this._renderImages() }
        </Container>
    </Main>`
