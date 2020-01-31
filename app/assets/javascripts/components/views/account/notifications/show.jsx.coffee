namespace 'Views.Account.Notifications'

@Views.Account.Notifications.Show = v1 ->
  class C extends React.Component
    render: ->
      `<Views.Account.Layout {...this.props}>
          <Views.Account.Notifications.Feed filter={ this.props.location.query.feed } />
      </Views.Account.Layout>`
