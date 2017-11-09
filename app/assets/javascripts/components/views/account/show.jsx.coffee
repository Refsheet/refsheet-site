@Views.Account.Show = React.createClass
  contextTypes:
    currentUser: React.PropTypes.object

  render: ->
    `<Main title='Home' flex className='with-sidebar'>
        <Container flex className='activity-feed'>
            <div className='sidebar'>
                <Views.Account.UserCard user={ this.context.currentUser } />

                <Views.Account.SideNav />
            </div>

            <div className='content'>
                <Views.Account.Activity filter={ this.props.location.query.feed } />
            </div>

            <div className='sidebar aside transparent'>
                <Advertisement />
            </div>
        </Container>
    </Main>`
