/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
this.Favorites = {};
this.Favorites.Index = React.createClass({
  contextTypes: {
    currentUser: React.PropTypes.object
  },

  propTypes: {
    mediaId: React.PropTypes.string.isRequired,
    favorites: React.PropTypes.array,
    poll: React.PropTypes.bool,
    onFavoriteChange: React.PropTypes.func
  },

  _poll() {
    return this.poller = setTimeout(() => {
      return Model.poll(`/media/${this.props.mediaId}/favorites`, {}, data => {
        data.map(favorite => {
          if (this.props.onFavoriteChange) { return this.props.onFavoriteChange(favorite); }
        });
        return this._poll();
      });
    }
    , 15000);
  },

  componentDidMount() {
    if (this.props.onFavoriteChange && this.props.poll) { return this._poll(); }
  },

  componentWillUnmount() {
    return clearTimeout(this.poller);
  },

  _handleFavorite(favorite) {
    if (this.props.onFavoriteChange) { return this.props.onFavoriteChange(favorite); }
  },

  render() {
    const favorites = this.props.favorites.map(favorite => <Column key={ favorite.user_id } s={3}>
        <img src={ favorite.user_avatar_url } className='responsive-img avatar' alt={ favorite.user_id } style={{ display: 'block' }} />
    </Column>);

    return <Row>
        { favorites }
        { favorites.length <= 0 &&
            <Column>
                <p className='caption center'>No favorites yet.</p>
            </Column> }
    </Row>;
  }
});
