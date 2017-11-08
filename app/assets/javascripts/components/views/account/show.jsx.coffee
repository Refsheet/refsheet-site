@Views.Account.Show = React.createClass
  contextTypes:
    currentUser: React.PropTypes.object

  render: ->
    `<Main title='Home' flex className='with-sidebar'>
        <Container flex className='activity-feed'>
            <div className='sidebar'>
                <Views.Account.UserCard user={ this.context.currentUser } />

                <ul className='side-nav fixed in-page margin-top--large'>
                    <NavLink to='/' icon='home' text='Activity Feed'>
                        <NavLink to='/?show=character' text='Characters' />
                        <NavLink to='/?show=image' text='Images' />
                        <NavLink to='/?show=forum' text='Forums' />
                        <NavLink to='/?show=comment' text='Comment' />
                        <NavLink to='/?show=marketplace' text='Marketplace' disabled />
                    </NavLink>

                    <NavLink to='/account/notifications' icon='notifications' text='Notifications' disabled />

                    <li className='subheader'>Account</li>

                    <NavLink to='/account/settings' icon='settings' text='Settings' disabled>
                        <NavLink to='/account/settings' icon='settings' text='Settings' disabled />
                    </NavLink>
                </ul>
            </div>

            <div className='content'>
                <Views.Account.NewActivity />
                <Views.Account.Activity />
            </div>

            <div className='sidebar aside transparent'>
                <p className='caption center'>What goes here?</p>
            </div>
        </Container>
    </Main>`
