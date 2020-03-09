/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
this.Views.Account.UserCard = React.createClass({
  propTypes: {
    user: React.PropTypes.object.isRequired,
    onFollow: React.PropTypes.func,
    smaller: React.PropTypes.bool
},

  render() {
    let imgShadow, nameColor;
    const nameClassNames = ['strong truncate'];
    if (!this.props.smaller) { nameClassNames.push('larger'); }
    const nameLh = this.props.smaller ? '1.5rem' : '2rem';
    const imgMargin = this.props.smaller ? '0 0.5rem 0 0' : '0.5rem 1rem 0.5rem 0';

    if (this.props.user.is_admin) {
      imgShadow = '0 0 3px 1px #2480C8';
      nameColor = '#2480C8';

    } else if (this.props.user.is_patron) {
      imgShadow = '0 0 3px 1px #F96854';
      nameColor = '#F96854';
  }

    return <div className='user-summary' style={{height: '2.5rem'}}>
        <img src={ this.props.user.avatar_url }
             alt={ this.props.user.username }
             className='circle left'
             style={{width: '3rem', height: '3rem', margin: imgMargin, boxShadow: imgShadow }} />

        <div className='user-details'>
            { this.props.onFollow &&
                <Views.User.Follow username={ this.props.user.username }
                                   followed={ this.props.user.followed }
                                   short={ this.props.smaller }
                                   onFollow={ this.props.onFollow } /> }

            <Link to={ this.props.user.link }
                  className={ nameClassNames.join(' ') }
                  style={{ lineHeight: nameLh, color: nameColor }}
            >
                { this.props.user.name }
            </Link>

            <div className='truncate lighter' style={{lineHeight: '1.5rem'}}>
                @{ this.props.user.username }
            </div>
        </div>
        <div className='clearfix' />
    </div>;
}
});
