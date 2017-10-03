@Dashboard.UserCard = React.createClass
  propTypes:
    user: React.PropTypes.object.isRequired

  render: ->
    `<div className='user-summary'>
        <Row noMargin>
            <Column s={3} className='center'>
                <img src={ this.props.user.avatar_url } alt={ this.props.user.username } className='responsive-img circle' />
            </Column>

            <Column s={9}>
                <Link to={ this.props.user.link } className='strong larger truncate'>{ this.props.user.name }</Link>
                <div className='light truncate'>@{ this.props.user.username }</div>
            </Column>
        </Row>
    </div>`
