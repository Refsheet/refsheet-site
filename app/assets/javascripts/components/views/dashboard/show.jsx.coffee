@Dashboard.Show = React.createClass
  contextTypes:
    currentUser: React.PropTypes.object

  render: ->
    `<Main title='Home' flex>
        <Container flex className='activity-feed'>
            <div className='sidebar transparent padding-top--large'>
                <Dashboard.UserCard user={ this.context.currentUser } />

                <ul className='character-group-list margin-top--large'>
                    <li>
                        <Link to='/'>
                            <Icon className='left'>home</Icon> Activity Feed
                        </Link>
                    </li>

                    <li>
                        <Link to='/settings'>
                            <Icon className='left'>settings</Icon> Settings
                        </Link>
                    </li>
                </ul>
            </div>

            <div className='content'>
                <Dashboard.Activity />
            </div>

            <div className='sidebar transparent padding-top--large'>
                <p className='caption center'>What goes here?</p>
            </div>
        </Container>
    </Main>`
