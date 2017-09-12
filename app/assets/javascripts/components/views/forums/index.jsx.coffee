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
        `<Forums.Table title={ groupName } forums={ forums } />`
      )

    if forumTables.length == 0
      forumTables =
        `<p className='caption center'>Nothing to see here :(</p>`

    `<Main title='Forums' loading={!this.state.forums}>
        <Jumbotron>
            <h1>Discuss & Socialize</h1>
        </Jumbotron>

        <Container className='padding-top--large'>
            { forumTables }
        </Container>
    </Main>`
