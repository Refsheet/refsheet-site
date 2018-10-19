@Favorites = {}
@Favorites.Index = React.createClass
  contextTypes:
    currentUser: React.PropTypes.object

  propTypes:
    mediaId: React.PropTypes.string.isRequired
    favorites: React.PropTypes.array
    poll: React.PropTypes.bool
    onFavoriteChange: React.PropTypes.func

  _poll: ->
    @poller = setTimeout =>
      Model.poll "/media/#{@props.mediaId}/favorites", {}, (data) =>
        data.map (favorite) =>
          @props.onFavoriteChange favorite if @props.onFavoriteChange
        @_poll()
    , 15000

  componentDidMount: ->
    @_poll() if @props.onFavoriteChange and @props.poll

  componentWillUnmount: ->
    clearTimeout @poller

  _handleFavorite: (favorite) ->
    @props.onFavoriteChange favorite if @props.onFavoriteChange

  render: ->
    favorites = @props.favorites.map (favorite) ->
      `<Column key={ favorite.user_id } s={3}>
          <img src={ favorite.user_avatar_url } className='responsive-img avatar' alt={ favorite.user_id } style={{ display: 'block' }} />
      </Column>`

    `<Row>
        { favorites }
        { favorites.length <= 0 &&
            <Column>
                <p className='caption center'>No favorites yet.</p>
            </Column> }
    </Row>`
