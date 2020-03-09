/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
namespace('Views.Account.Notifications');

this.Views.Account.Notifications.Show = class Show extends React.Component {
  render() {
    return <Views.Account.Layout {...this.props}>
        <Views.Account.Notifications.Feed filter={ this.props.location.query.feed } />
    </Views.Account.Layout>;
  }
};
