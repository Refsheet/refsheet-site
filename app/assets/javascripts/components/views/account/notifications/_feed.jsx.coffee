namespace 'Views.Account.Notifications'

@Views.Account.Notifications.Feed = React.createClass
  contextTypes:
    currentUser: React.PropTypes.object

  propTypes:
    filter: React.PropTypes.string

  timer: null
  dataPath: '/notifications'
  stateLink: ->
    dataPath: '/notifications?filter=' + @props.filter + '&before=' + @state.since
    statePath: 'notifications'

  getInitialState: ->
    notifications: null
    newActivity: null
    since: null
    timer: null
    lastUpdate: null

  componentDidMount: ->
    StateUtils.load @, 'notifications', @props.params, =>
      @setState since: @state.notifications[0]?.timestamp, lastUpdate: Math.floor(Date.now() / 1000)
      @_poll()
    , urlParams: filter: @props.filter

  componentWillUnmount: ->
    clearTimeout @timer if @timer

  componentWillReceiveProps: (newProps) ->
    if @props.filter isnt newProps.filter
      clearTimeout @timer if @timer
      @setState notifications: null, =>
        StateUtils.load @, 'notifications', newProps.params, =>
          @setState since: @state.notifications[0]?.timestamp, lastUpdate: Math.floor(Date.now() / 1000)
          @_poll()
        , urlParams: filter: @props.filter

  componentWillUpdate: (newProps, newState) ->
    if newState.newActivity != @state.newActivity
      document.title = document.title.replace /^\(\d+\)\s+/, ''
      if newState.newActivity and newState.newActivity.length > 0
        document.title = "(#{newState.newActivity.length}) " + document.title

  _poll: ->
    @timer = setTimeout =>
      Model.poll @dataPath, { since: @state.since, filter: @props.filter }, (data) =>
        @setState newActivity: data.notifications, lastUpdate: Math.floor(Date.now() / 1000), @_poll
    , 15000

  _prepend: ->
    act = (@state.newActivity || []).concat @state.notifications
    @setState notifications: act, since: act[0]?.timestamp, newActivity: null

  _append: (notifications) ->
    StateUtils.updateItems @, 'notifications', notifications

  _groupedActivity: ->
    grouped = []

    for item in @state.notifications
      last = grouped[grouped.length - 1]

      if item.notification and
         last and
         HashUtils.compare(item, last, 'user.username', 'character.id', 'notifications_type', 'notifications_method') and
         last.timestamp - item.timestamp < 3600

        last.notifications ||= [last.notifications]
        unless HashUtils.itemExists last.notifications, item.notifications, 'id'
          last.notifications.push item.notifications
      else
        grouped.push item

    grouped


  render: ->
    return `<Spinner className='margin-top--large' small center />` unless @state.notifications

    out = @_groupedActivity().map (item) ->
      `<Views.Account.Notifications.Card {...StringUtils.camelizeKeys(item)} key={item.id} />`

    `<div className='feed-item-stream'>
        { this.state.newActivity && this.state.newActivity.length > 0 &&
            <a className='btn btn-flat block margin-bottom--medium' onClick={ this._prepend }>
                { this.state.newActivity.length } new { this.state.newActivity.length == 1 ? 'notification' : 'notifications' }
            </a> }

        { out }

        <InfiniteScroll onLoad={ this._append }
                        stateLink={ this.stateLink }
                        params={{}}
                        count={ this.state.notifications.length } />
    </div>`
