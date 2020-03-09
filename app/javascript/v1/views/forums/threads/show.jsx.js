/* eslint-disable
    no-undef,
    react/jsx-no-undef,
    react/no-deprecated,
    react/react-in-jsx-scope,
*/
// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
this.Forums.Threads.Show = React.createClass({
  contextTypes: {
    currentUser: React.PropTypes.object,
    eagerLoad: React.PropTypes.object
  },

  propTypes: {
    onReply: React.PropTypes.func
  },

  dataPath: '/forums/:forumId/:threadId',

  poller: null,

  paramMap: {
    forumId: 'forum_id',
    threadId: 'id'
  },

  getInitialState() {
    return {thread: null};
  },

  componentWillMount() {
    return StateUtils.load(this, 'thread', this.props, thread => {
      if (thread) { this._poll(); }
      return console.log('Starting poll.');
    });
  },

  componentWillUnmount() {
    clearTimeout(this.poller);
    return console.log('Stopping poll.');
  },

  _poll() {
    return this.poller = setTimeout(() => {
      return Model.poll(this.state.thread.path, {}, data => {
        if (data.id === this.state.thread.id) {
          const willScroll = (this.state.thread.posts.length < data.posts.length) && ((window.innerHeight + window.scrollY) >= document.body.offsetHeight);

          this.setState({thread: data}, () => {
            if (willScroll) { return window.scrollTo(0, document.getElementById('scroll-to-here').offsetTop); }
          });
        }

        return this._poll();
      });
    }
    , 3000);
  },

  componentWillReceiveProps(newProps) {
    return StateUtils.reload(this, 'thread', newProps);
  },

  _handleReply(post) {
    StateUtils.updateItem(this, 'thread.posts', post, 'id', () => window.scrollTo(0, document.getElementById('scroll-to-here').offsetTop));
    if (this.props.onReply) { return this.props.onReply(post); }
  },

  render() {
    if (!this.state.thread) { return <Loading />; }

    const posts = this.state.thread.posts.map(post => <div className='card sp with-avatar' key={ post.id }>
        <IdentityAvatar src={ post.user } avatarUrl={ post.character && (post.character.profile_image_url || (post.character.profile_image && post.character.profile_image.url.thumbnail)) } name={ post.character && post.character.name } />

        <div className='card-content'>
            <div className='muted right'>{ post.created_at_human }</div>
            <IdentityLink to={ post.user } name={ post.character && post.character.name } link={ post.character && post.character.link } avatarUrl={ post.character && (post.character.profile_image_url || (post.character.profile_image && post.character.profile_image.url.thumbnail)) } />
            <RichText className='margin-top--small' content={ post.content_html } markup={ post.content } />
        </div>
    </div>);

    return <Main title={ this.state.thread.topic }>
        <div className='card margin-top--none sp with-avatar'>
            <IdentityAvatar src={ this.state.thread.user } />

            <div className='card-content'>
                <div className='right muted right-align'>
                    { this.state.thread.created_at_human }
                </div>

                <div className='author'>
                    <IdentityLink to={ this.state.thread.user } />
                    <div className='muted'>@{ this.state.thread.user.username } { this.state.thread.user.is_admin && <span>&bull; Admin</span> }</div>
                </div>
            </div>

            <div className='card-header'>
                <h2 className='title'>{ this.state.thread.topic }</h2>
                <RichText markup={ this.state.thread.content } content={ this.state.thread.content_html } />
            </div>
        </div>

        { posts }

        <div id='scroll-to-here' />

        { this.context.currentUser &&
            <LegacyForumReply discussionId={ this.state.thread.guid }
                              onPost={ this._handleReply }
            /> }
    </Main>;
  }
});
