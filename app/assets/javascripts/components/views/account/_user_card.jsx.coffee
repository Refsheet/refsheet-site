@Views.Account.UserCard = React.createClass
  propTypes:
    user: React.PropTypes.object.isRequired

  render: ->
    `<div className='user-summary' style={{height: '2.5rem'}}>
        <img src={ this.props.user.avatar_url } alt={ this.props.user.username } className='circle left' style={{width: '3rem', height: '3rem', margin: '0.5rem 1rem 0.5rem 0'}} />
        <div className='user-details'>
            <Link to={ this.props.user.link } className='strong larger truncate' style={{lineHeight: '2rem'}}>{ this.props.user.name }</Link>
            <div className='truncate lighter' style={{lineHeight: '1.5rem'}}>@{ this.props.user.username }</div>
        </div>
        <div className='clearfix' />
    </div>`
