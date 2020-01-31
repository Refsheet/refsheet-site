@Views.Account.Activities.ForumDiscussion = v1 -> React.createClass
  propTypes:
    discussions: React.PropTypes.array.isRequired

  render: ->
    discussions = @props.discussions.map (discussion) =>
      `<div key={ discussion.id } className='card-panel z-depth-0 margin-bottom--none margin-top--small' style={{ backgroundColor: '#1a1a1a', padding: '1rem' }}>
          <div className='muted right'><Link to={ '/forums/' + discussion.forum.id }>{ discussion.forum.name }</Link></div>
          <h3 className='margin-top--none margin-bottom--medium'><Link to={ discussion.path }>{ discussion.topic }</Link></h3>
          { discussion.content_text.substr(0, 120) }
      </div>`

    `<div className='activity shift-up'>
        { discussions }
    </div>`
