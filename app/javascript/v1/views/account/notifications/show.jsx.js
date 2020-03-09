namespace 'Views.Account.Notifications'

class @Views.Account.Notifications.Show extends React.Component
  render: ->
    `<Views.Account.Layout {...this.props}>
        <Views.Account.Notifications.Feed filter={ this.props.location.query.feed } />
    </Views.Account.Layout>`
