@Views.Account.Activities.Comment = React.createClass
  propTypes:
    comments: React.PropTypes.array.isRequired

  render: ->
    comments = @props.comments.map (comment) =>
      `<Row key={ comment.id } noMargin className='padding-top--small'>
          <Column s={6} m={4}>
              <GalleryImage image={ comment.media } size='small_square' />
          </Column>
          <Column s={12} m={8}>
              <div className='chat-bubble receive turn-up-for-what margin-right--rlarge'>{ comment.comment }</div>
          </Column>
      </Row>`

    `<div className='activity shift-up'>
        { comments }
    </div>`
