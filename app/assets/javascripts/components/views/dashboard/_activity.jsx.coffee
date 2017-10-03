@Dashboard.Activity = React.createClass
  contextTypes:
    currentUser: React.PropTypes.object

  render: ->
    `<div className='activity-feed'>
        <div className='card sp with-avatar margin-bottom--large'>
            <img className='avatar circle' src={ this.context.currentUser.avatar_url } alt={ this.context.currentUser.name } />

            <div className='card-content'>
                <div className='muted right'>1 day ago</div>
                <Link to={ this.context.currentUser.link }>{ this.context.currentUser.name }</Link>
                <div>Uploaded 3 new photos to <Link to='/c/mau'>Akhet</Link>:</div>
            </div>

            <Row noMargin noGutter>
                <Column s={4}><img src='https://s3.amazonaws.com/refsheet-prod/images/images/000/000/006/small_square/1483044380.wolnir_ych101.png?1492920243' className='responsive-img block' /></Column>
                <Column s={4}><img src='https://s3.amazonaws.com/refsheet-prod/images/images/000/001/398/small_square/MauPort_PostRes.png?1493006941' className='responsive-img block' /></Column>
                <Column s={4}><img src='https://s3.amazonaws.com/refsheet-prod/images/images/000/001/399/small_square/MauPort_Night_PostRes.png?1492919942' className='responsive-img block' /></Column>
            </Row>
        </div>

        <div className='card sp with-avatar'>
            <img className='avatar circle' src={ this.context.currentUser.avatar_url } alt={ this.context.currentUser.name } />

            <div className='card-content'>
                <div className='muted right'>1 day ago</div>
                <Link to={ this.context.currentUser.link }>{ this.context.currentUser.name }</Link>
                <div>Uploaded a new photo to <Link to='/c/mau'>Akhet</Link>:</div>
            </div>

            <img src='https://s3.amazonaws.com/refsheet-prod/images/images/000/001/545/medium/FiresightRedux_PostRes.png?1494397581' className='responsive-img block' />
        </div>
    </div>`
