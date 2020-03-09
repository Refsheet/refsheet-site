/* eslint-disable
    no-undef,
    no-unused-vars,
    react/no-deprecated,
    react/react-in-jsx-scope,
*/
// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
this.IdentityAvatar = React.createClass({
  propTypes: {
    src: React.PropTypes.shape({
      link: React.PropTypes.string.isRequired,
      name: React.PropTypes.string.isRequired,
      username: React.PropTypes.string.isRequired,
      type: React.PropTypes.string,
      avatar_url: React.PropTypes.string
    }),
    avatarUrl: React.PropTypes.string
  },

  render() {
    let imgShadow, nameColor;
    const to = StringUtils.indifferentKeys(this.props.src);
    if (!to.type) { to.type = 'user'; }

    if (to.is_admin || (typeof user !== 'undefined' && user !== null ? user.is_admin : undefined)) {
      imgShadow = '0 0 3px 1px #2480C8';
      nameColor = '#2480C8';

    } else if (to.is_patron || (typeof user !== 'undefined' && user !== null ? user.is_patron : undefined)) {
      imgShadow = '0 0 3px 1px #F96854';
      nameColor = '#F96854';
    }

    return <img src={ this.props.avatarUrl || to.avatarUrl } alt={ this.props.name || to.name } className='avatar circle' style={{ boxShadow: imgShadow }} height={48} width={48} />;
  }
});
