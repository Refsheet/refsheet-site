@FavoriteButton = React.createClass
  contextTypes:
    currentUser: React.PropTypes.object

  propTypes:
    mediaId: React.PropTypes.string.isRequired
    favorites: React.PropTypes.array
    isFavorite: React.PropTypes.bool
    onChange: React.PropTypes.func
    onFavorite: React.PropTypes.func

  _isFavFromProps: (props) ->
    if typeof props.isFavorite == 'undefined'
      return false unless props.favorites
      (props.favorites.filter (fav) =>
        fav.user_id == @context.currentUser.username
      ).length > 0
    else
      props.isFavorite

  getInitialState: ->
    isFavorite: @_isFavFromProps(@props)

  componentWillReceiveProps: (newProps) ->
    @setState isFavorite: @_isFavFromProps(@props)

  _handleFavorite: (e) ->
    path = "/media/#{@props.mediaId}"

    if !@state.isFavorite
      $.post path + '/favorites', (data) =>
        @setState isFavorite: true
        @props.onChange(true) if @props.onChange
        @props.onFavorite(data, true) if @props.onFavorite
    else
      $.ajax
        url: path + '/favorite'
        type: 'DELETE'
        success: (data) =>
          @setState isFavorite: false
          @props.onChange(false) if @props.onChange
          @props.onFavorite(data, false) if @props.onFavorite
    e.preventDefault()


  render: ->
    favoriteClassName = if @state.isFavorite then 'favorite' else 'not-favorite'

    `<div className={ 'favorite-button ' + favoriteClassName } onClick={ this._handleFavorite }>
        <i className='material-icons'>star</i>
    </div>`
