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
            <NavLink to='?feed=marketplace' text='Marketplace' disabled />
        </NavLink>

        <NavLink to='/notifications' icon='notifications' text='Notifications'>
            <NavLink to='/notifications?feed=comment' text='Comments' />
            <NavLink to='/notifications?feed=favorite' text='Favorites' />
            <NavLink to='/notifications?feed=tag' text='Mentions' />
            <NavLink to='/notifications?feed=reply' text='Replies' />
        </NavLink>

        <li className='subheader'>Account</li>

        <NavLink to='/account' noStrict icon='settings' text='Settings'>
            <NavLink to='/account/settings' text='Account' />
            <NavLink to='/account/support' text='Support' />
            <NavLink to='/account/notifications' text='Notifications' />
        </NavLink>
    </ul>`
