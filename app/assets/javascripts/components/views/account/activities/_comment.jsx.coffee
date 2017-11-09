@Views.Account.Activities.Comment = React.createClass
  propTypes:
    comments: React.PropTypes.array.isRequired

  render: ->
    str = if @props.comments.length == 1 then `<Link to={ this.props.comments[0].media.link }>{ this.props.comments[0].media.title }</Link>` else "#{@props.comments.length} photos"

    comments = @props.comments.map (comment) =>
      `<Row key={ comment.id }>
          <Column s={4}>
              <GalleryImage image={ comment.media } size='small_square' />
          </Column>
          <Column s={8}>
              <div className='chat-bubble receive'>{ comment.comment }</div>
          </Column>
      </Row>`

    `<div className='activity'>
        <div className='headline margin-bottom--medium'>
            Commented on { str }.
        </div>

        { comments }
    </div>`
