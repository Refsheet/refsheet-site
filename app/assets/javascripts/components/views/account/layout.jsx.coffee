namespace 'Views.Account'

class @Views.Account.Layout extends React.Component
  @contextTypes:
    currentUser: React.PropTypes.object.isRequired

  _findTitle: (props=@props) ->
    if props.children and props.children.props
      c = @_findTitle(props.children.props)
      console.log {c}
    c || props.route?.title

  render: ->
    `<Main title={ this._findTitle() } flex className='with-sidebar'>
        <Container flex className='activity-feed'>
            <div className='sidebar'>
                <Views.Account.UserCard user={ this.context.currentUser } />

                <Views.Account.SideNav />
            </div>

            <div className='content'>
                { this.props.children }
            </div>

            <div className='sidebar aside transparent'>
                { typeof Advertisement != 'undefined' && <Advertisement /> }
                <Views.Account.Suggestions />
            </div>
        </Container>
    </Main>`
