@Forums.Index = React.createClass
  contextTypes:
    eagerLoad: React.PropTypes.object

  propTypes:
    forums: React.PropTypes.object

  dataPath: '/forums'

  getInitialState: ->
    forums: null

  componentWillMount: ->
    StateUtils.load @, 'forums'

  render: ->
    forumGroups = HashUtils.groupBy @state.forums, 'group_name'
    forumTables = []

    # Build Table Children
    for groupName, forums of forumGroups
      forumTables.push(
        `<Forums.Table key={ groupName } title={ groupName } forums={ forums } />`
      )

    if !@state.forums
      forumTables =
        `<Loading />`

    else if forumTables.length == 0
      forumTables =
        `<p className='caption center'>Nothing to see here :(</p>`

    `<Main title='Forums' flex>
        <Container flex>
            <div className='sidebar'>
                <Jumbotron className='short'>
                    <h1>Discuss & Socialize</h1>
                </Jumbotron>

                <Tabs>
                    <Tab name='Following' />
                    <Tab name='Recent' />
                </Tabs>

                <Forums.Threads.List />
            </div>

            <div className='content'>
                { forumTables }
            </div>
        </Container>
    </Main>`
