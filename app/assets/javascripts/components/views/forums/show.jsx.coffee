@Forums.Show = React.createClass
  dataPath: '/forums/:forumId'
  paramMap:
    forumId: 'slug'

  getInitialState: ->
    forum: null

  componentWillMount: ->
    StateUtils.load @, 'forum'

  componentWillReceiveProps: (newProps) ->
    StateUtils.reload @, 'forum', newProps


  render: ->
    return null unless @state.forum

    `<Main title={ this.state.forum.name } fadeEffect flex>
        <Container flex>
            <div className='sidebar sidebar-flex'>
                <Jumbotron className='short'>
                    <h1>{ this.state.forum.name }</h1>
                    <p>{ this.state.forum.description }</p>
                </Jumbotron>

                <Forums.Threads.List />
            </div>

            <div className='content'>
                { this.props.children ||
                    <p className='caption center'>Forum Topics will go here soon :3</p>
                }
            </div>
        </Container>
    </Main>`
