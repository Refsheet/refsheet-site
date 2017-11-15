@Views.Account.UserCard = React.createClass
  propTypes:
    user: React.PropTypes.object.isRequired
    onFollow: React.PropTypes.func
    smaller: React.PropTypes.bool

  render: ->
    nameClassNames = ['strong truncate']
    nameClassNames.push 'larger' unless @props.smaller
    nameLh = if @props.smaller then '1.5rem' else '2rem'
    imgMargin = if @props.smaller then '0 0.5rem 0 0' else '0.5rem 1rem 0.5rem 0'

    `<div className='user-summary' style={{height: '2.5rem'}}>
        <img src={ this.props.user.avatar_url }
             alt={ this.props.user.username }
             className='circle left'
             style={{width: '3rem', height: '3rem', margin: imgMargin }} />

        <div className='user-details'>
            { this.props.onFollow &&
                <Views.User.Follow username={ this.props.user.username }
                                   followed={ this.props.user.followed }
                                   short={ this.props.smaller }
                                   onFollow={ this.props.onFollow } /> }

            <Link to={ this.props.user.link }
                  className={ nameClassNames.join(' ') }
                  style={{lineHeight: nameLh}}
            >
                { this.props.user.name }
            </Link>

            <div className='truncate lighter' style={{lineHeight: '1.5rem'}}>
                @{ this.props.user.username }
            </div>
        </div>
        <div className='clearfix' />
    </div>`
