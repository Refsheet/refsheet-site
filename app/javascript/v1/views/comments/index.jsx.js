/* eslint-disable
    no-undef,
    react/jsx-no-undef,
    react/no-deprecated,
    react/no-string-refs,
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
this.Comments = {};

this.Comments.Index = React.createClass({
  contextTypes: {
    currentUser: React.PropTypes.object
  },

  propTypes: {
    mediaId: React.PropTypes.string.isRequired,
    comments: React.PropTypes.array,
    poll: React.PropTypes.bool,
    onCommentChange: React.PropTypes.func,
    onCommentsChange: React.PropTypes.func
  },

  getInitialState() {
    return {
      model: {
        comment: ''
      }
    };
  },

  _poll() {
    return this.poller = setTimeout(() => {
      return Model.poll(`/media/${this.props.mediaId}/comments`, {}, data => {
        if (this.props.onCommentsChange) { this.props.onCommentsChange(data); }
        return this._poll();
      });
    }
    , 3000);
  },

  componentDidMount() {
    if (this.props.onCommentsChange && this.props.poll) { return this._poll(); }
  },

  componentWillUnmount() {
    return clearTimeout(this.poller);
  },

  _handleComment(comment) {
    if (this.props.onCommentChange) { return this.props.onCommentChange(comment); }
  },

  render() {
    const comments = this.props.comments.map(function(comment) {
      if (comment.user) {
        return <div className='card flat with-avatar' key={ comment.id }>
            <img src={ comment.user.avatar_url } className='circle avatar' />
            <div className='card-content'>
                <div className='muted right' title={ comment.created_at }>{ comment.created_at_human }</div>
                <Link to={ comment.user.link }>{ comment.user.name }</Link>
                <RichText content={ comment.comment } markup={ comment.comment } />
            </div>
        </div>;

      } else {
        return <div className='card flat' key= { comment.id }>
            <div className='card-content red-text text-darken-2'>User Deactivated</div>
        </div>;
      }
    });

    return <div className='flex-vertical'>
        <div className='flex-content overflow' ref='commentBox'>
            { comments.reverse() }
            { comments.length <= 0 &&
                <p className='caption padding--medium'>No comments yet!</p> }
        </div>

        { this.context.currentUser &&
            <div className='flex-fixed'>
                <Form className='reply-box'
                      action={ '/media/' + this.props.mediaId + '/comments' }
                      model={ this.state.model }
                      modelName='comment'
                      onChange={ this._handleComment }
                      resetOnSubmit
                >
                    <Input type='textarea' name='comment' placeholder='Leave a comment...' noMargin browserDefault className='min-height overline block' />
                    <Submit className='btn-square btn-block'>Send Comment <Icon className='right'>send</Icon></Submit>
                </Form>
            </div> }
    </div>;
  }
});
