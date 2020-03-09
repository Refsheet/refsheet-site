@Views.Account.Activities.ForumPost = React.createClass
  propTypes:
    posts: React.PropTypes.array.isRequired
    action: React.PropTypes.string

  render: ->
    if @props.posts.length == 1
      str = "a discussion"
    else
      str = "#{@props.posts.length} discussions"

    action = @props.action || "Replied to"

    posts = @props.posts.map (post) =>
      `<div key={ post.id } className='card-panel z-depth-0' style={{ backgroundColor: '#1a1a1a', padding: '1rem' }}>
          <div className='muted right'><Link to={ '/forums/' + post.forum.id }>
            { post.forum.name }
          </Link></div>

          <h3 className='margin-top--none margin-bottom--medium'><Link to={ post.path || '' }>RE: { post.thread.topic }</Link></h3>
          { post.content_text.substr(0, 120) }
      </div>`

    `<div className='activity padding-bottom--small'>
        <div className='headline margin-bottom--medium'>
            { action } { str }:
        </div>

        { posts }
    </div>`
