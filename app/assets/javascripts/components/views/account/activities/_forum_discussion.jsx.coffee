@Views.Account.Activities.ForumDiscussion = React.createClass
  propTypes:
    discussions: React.PropTypes.array.isRequired

  render: ->
    if @props.discussions.length == 1
      str = "a discussion"
    else
      str = "#{@props.discussions.length} discussions"

    discussions = @props.discussions.map (discussion) =>
      console.log discussion
      `<div key={ discussion.id } className='card-panel z-depth-0' style={{ backgroundColor: '#1a1a1a', padding: '1rem' }}>
          <div className='muted right'><Link to={ '/forums/' + discussion.forum.id }>{ discussion.forum.name }</Link></div>
          <h3 className='margin-top--none margin-bottom--medium'><Link to={ discussion.path }>{ discussion.topic }</Link></h3>
          { discussion.content_text.substr(0, 120) }
      </div>`

    `<div className='activity padding-bottom--small'>
        <div className='headline margin-bottom--medium'>
            Started { str }:
        </div>

        { discussions }
    </div>`
