@Views.Account.SideNav = React.createClass
  contextTypes:
    currentUser: React.PropTypes.object.isRequired

  render: ->
    `<ul className='side-nav fixed in-page margin-top--large'>
        <NavLink to='/' icon='home' text='Activity Feed'>
            <NavLink to='?feed=character' text='Characters' />
            <NavLink to='?feed=image' text='Images' />
            <NavLink to='?feed=forum' text='Forums' />
            <NavLink to='?feed=comment' text='Comments' />
            <NavLink to='?feed=marketplace' text='Marketplace' disabled />
        </NavLink>

        <NavLink to='/notifications' icon='notifications' text='Notifications' disabled />

        <li className='subheader'>Account</li>

        <NavLink to='/account' icon='settings' text='Settings'>
            <NavLink to='/account/settings' text='Account' />
            <NavLink to='/account/support' text='Support' />

            { this.context.currentUser.is_patron &&
                <NavLink to='/account/notifications' text='Notifications' /> }
        </NavLink>
    </ul>`
