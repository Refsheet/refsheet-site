namespace 'Views.Account'

class Layout extends React.Component
  @contextTypes:
    router: React.PropTypes.object.isRequired

  _findTitle: (props=@props) ->
    if props.children and props.children.props
      c = @_findTitle(props.children.props)
    c || props.route?.title

  componentWillReceiveProps: (newProps) ->
    if (!newProps.currentUser)
      @context.router.history.push '/'

  render: ->
    if !@props.currentUser
      return `<span>Signed out, redirecting...</span>`

    `<Main title={ this._findTitle() } flex className='with-sidebar'>
        <Container flex className='activity-feed'>
            <div className='sidebar'>
                <Views.Account.UserCard user={ this.props.currentUser } />

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

mapStateToProps = (state) => currentUser: state.session.currentUser
@Views.Account.Layout = connect(mapStateToProps)(Layout)