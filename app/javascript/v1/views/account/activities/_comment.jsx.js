/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
this.Views.Account.Activities.Comment = React.createClass({
  propTypes: {
    comments: React.PropTypes.array.isRequired
},

  render() {
    const comments = this.props.comments.map(comment => {
      return <Row key={ comment.id } noMargin className='padding-top--small'>
          <Column s={6} m={4}>
              <GalleryImage image={ comment.media } size='small_square' />
          </Column>
          <Column s={12} m={8}>
              <div className='chat-bubble receive turn-up-for-what margin-right--rlarge'>{ comment.comment }</div>
          </Column>
      </Row>;
    });

    return <div className='activity shift-up'>
        { comments }
    </div>;
}
});
