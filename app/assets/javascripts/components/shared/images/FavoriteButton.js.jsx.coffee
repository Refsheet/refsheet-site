@FavoriteButton = React.createClass
  propTypes:
    mediaId: React.PropTypes.string.isRequired
    isFavorite: React.PropTypes.bool
    onChange: React.PropTypes.func

  getInitialState: ->
    isFavorite: @props.isFavorite

  _handleFavorite: (e) ->
    path = "/media/#{@props.mediaId}"

    if !@state.isFavorite
      $.post path + '/favorites', (data) =>
        @setState isFavorite: true
        @props.onChange(true) if @props.onChange
    else
      $.ajax
        url: path + '/favorite'
        type: 'DELETE'
        success: (data) =>
          @setState isFavorite: false
          @props.onChange(false) if @props.onChange
    e.preventDefault()


  render: ->
    favoriteClassName = if @state.isFavorite then 'favorite' else 'not-favorite'

    `<div className={ 'favorite-button ' + favoriteClassName } onClick={ this._handleFavorite }>
        <i className='material-icons'>star</i>
    </div>`
