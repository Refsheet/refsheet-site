/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
this.FavoriteButton = React.createClass({
  contextTypes: {
    currentUser: React.PropTypes.object
  },

  propTypes: {
    mediaId: React.PropTypes.string.isRequired,
    favorites: React.PropTypes.array,
    isFavorite: React.PropTypes.bool,
    onChange: React.PropTypes.func,
    onFavorite: React.PropTypes.func
  },

  _isFavFromProps(props) {
    if (typeof props.isFavorite === 'undefined') {
      if (!props.favorites) { return false; }
      return (props.favorites.filter(fav => {
        return fav.user_id === this.context.currentUser.username;
      })).length > 0;
    } else {
      return props.isFavorite;
    }
  },

  getInitialState() {
    return {isFavorite: this._isFavFromProps(this.props)};
  },

  componentWillReceiveProps(newProps) {
    return this.setState({isFavorite: this._isFavFromProps(this.props)});
  },

  _handleFavorite(e) {
    const path = `/media/${this.props.mediaId}`;

    if (!this.state.isFavorite) {
      $.post(path + '/favorites', data => {
        this.setState({isFavorite: true});
        if (this.props.onChange) { this.props.onChange(true); }
        if (this.props.onFavorite) { return this.props.onFavorite(data, true); }
      });
    } else {
      $.ajax({
        url: path + '/favorite',
        type: 'DELETE',
        success: data => {
          this.setState({isFavorite: false});
          if (this.props.onChange) { this.props.onChange(false); }
          if (this.props.onFavorite) { return this.props.onFavorite(data, false); }
        }
      });
    }
    return e.preventDefault();
  },


  render() {
    const favoriteClassName = this.state.isFavorite ? 'favorite' : 'not-favorite';

    return <div className={ 'favorite-button ' + favoriteClassName } onClick={ this._handleFavorite }>
        <i className='material-icons'>star</i>
    </div>;
  }
});
