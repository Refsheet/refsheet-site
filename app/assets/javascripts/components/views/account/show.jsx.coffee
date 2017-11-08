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
                        <NavLink to='?feed=character' text='Characters' />
                        <NavLink to='?feed=image' text='Images' />
                        <NavLink to='?feed=forum' text='Forums' />
                        <NavLink to='?feed=comment' text='Comments' />
                        <NavLink to='?feed=marketplace' text='Marketplace' disabled />
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

                <Views.Account.Activity filter={ this.props.location.query.feed } />
            </div>

            <div className='sidebar aside transparent'>
                <div className='sponsored-content center' style={{ display: 'none', fontSize: '0.8rem', maxWidth: 220, padding: 10, paddingTop: 5, borderTop: '1px solid #333', borderRadius: 10, borderBottom: '1px solid #333'}}>
                    <div className='sponsor-blurb grey-text text-darken-2 margin-bottom--small'>
                        From our Friends:
                    </div>

                    <img className='responsive-img' src='/assets/sandbox/RefsheetAdBannerTest.png' alt='Sponsored Content Test' width='200px' height='175px' />

                    <a href='#' target='_blank' className='grey-text text-darken-2 block' style={{textDecoration: 'underline', fontSize: '0.9rem', marginBottom: 5}}>Sitehive Web Design</a>

                    <div className='sponsor-blurb grey-text text-darken-2'>
                        { "You get 75 characters, use wisely or you might just lose them all in a bet.".substring(0,75) }
                    </div>
                </div>


            </div>
        </Container>
    </Main>`
