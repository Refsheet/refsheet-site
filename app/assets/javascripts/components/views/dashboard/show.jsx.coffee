@Dashboard.Show = React.createClass
  contextTypes:
    currentUser: React.PropTypes.object

  render: ->
    `<Main title='Home' flex>
        <Container flex>
            <div className='sidebar transparent padding-top--large'>
                <Dashboard.UserCard user={ this.context.currentUser } />

                <ul className='character-group-list'>
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
        </Container>
    </Main>`
