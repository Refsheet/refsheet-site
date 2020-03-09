/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
this.Views.Account.Show = React.createClass({
  contextTypes: {
    currentUser: React.PropTypes.object
  },

  render() {
    return <Views.Account.Layout {...this.props}>
        <Views.Account.Activity filter={ this.props.location.query.feed } />
    </Views.Account.Layout>;
  }
});
