@Views.Account.Show = v1 -> React.createClass
  contextTypes:
    currentUser: React.PropTypes.object

  render: ->
    `<Views.Account.Layout {...this.props}>
        <Views.Account.Activity filter={ this.props.location.query.feed } />
    </Views.Account.Layout>`
