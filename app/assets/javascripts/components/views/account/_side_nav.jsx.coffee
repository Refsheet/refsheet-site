@Views.Account.SideNav = React.createClass
  contextTypes:
    currentUser: React.PropTypes.object.isRequired

  render: ->
    `<ul className='side-nav fixed in-page margin-top--large'>
        <NavLink to='/' icon='home' text='Activity Feed' exact={true}>
            <NavLink to='?feed=character' text='Characters' />
            <NavLink to='?feed=image' text='Images' />
            <NavLink to='?feed=forum' text='Forums' />
            <NavLink to='?feed=comment' text='Comments' />
            <Restrict development>
                <NavLink to='?feed=marketplace' text='Marketplace' disabled />
            </Restrict>
        </NavLink>

        <NavLink to='/notifications' icon='notifications' text='Notifications'>
            <NavLink to='/notifications?feed=comment' text='Comments' />
            <NavLink to='/notifications?feed=favorite' text='Favorites' />
            <NavLink to='/notifications?feed=tag' text='Mentions' />
            <NavLink to='/notifications?feed=reply' text='Replies' />
        </NavLink>

        <Restrict development>
            <NavLink to='/messages' icon='message' text='Messages' />
        </Restrict>

        <li className='subheader'>Account</li>

        <Restrict development>
            <NavLink to='/myrefs' icon='people' text='My Refs'>
                <NavLink to='/myrefs/new' text='New Page' />
                <NavLink to='/myrefs/worlds' text='Worlds' />
                <NavLink to='/myrefs/guilds' text='Guilds' />
            </NavLink>
        </Restrict>

        <NavLink to='/account' noStrict icon='settings' text='Settings'>
            <NavLink to='/account/settings' text='Account' />
            <NavLink to='/account/support' text='Support' />
            <NavLink to='/account/notifications' text='Notifications' />
            <NavLink to='/account/api_keys' text='API Keys' />
        </NavLink>
    </ul>`
