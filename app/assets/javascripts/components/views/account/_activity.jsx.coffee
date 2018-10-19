@Views.Account.Activity = React.createClass
  contextTypes:
    currentUser: React.PropTypes.object

  propTypes:
    filter: React.PropTypes.string

  timer: null
  dataPath: '/account/activity'
  stateLink: ->
    dataPath: '/account/activity?filter=' + @props.filter + '&before=' + @state.since
    statePath: 'activity'

  getInitialState: ->
    activity: null
    newActivity: null
    since: null
    timer: null
    lastUpdate: null

  componentDidMount: ->
    StateUtils.load @, 'activity', @props.params, =>
      @setState since: @state.activity[0]?.timestamp, lastUpdate: Math.floor(Date.now() / 1000)
      @_poll()
    , urlParams: filter: @props.filter

  componentWillUnmount: ->
    clearTimeout @timer if @timer

  componentWillReceiveProps: (newProps) ->
    if @props.filter isnt newProps.filter
      clearTimeout @timer if @timer
      @setState activity: null, =>
        StateUtils.load @, 'activity', newProps.params, =>
          @setState since: @state.activity[0]?.timestamp, lastUpdate: Math.floor(Date.now() / 1000)
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
        @setState newActivity: data.activity, lastUpdate: Math.floor(Date.now() / 1000), @_poll
    , 15000

  _prepend: ->
    act = (@state.newActivity || []).concat @state.activity
    @setState activity: act, since: act[0]?.timestamp, newActivity: null

  _append: (activity) ->
    StateUtils.updateItems @, 'activity', activity

  _groupedActivity: ->
    grouped = []

    for item in @state.activity
      last = grouped[grouped.length - 1]

      if item.activity and
         last and
         HashUtils.compare(item, last, 'user.username', 'character.id', 'activity_type', 'activity_method') and
         last.timestamp - item.timestamp < 3600

        last.activities ||= [last.activity]
        unless HashUtils.itemExists last.activities, item.activity, 'id'
          last.activities.push item.activity
      else
        grouped.push item

    grouped


  render: ->
    return `<Spinner className='margin-top--large' small center />` unless @state.activity

    out = @_groupedActivity().map (item) ->
      `<Views.Account.ActivityCard {...StringUtils.camelizeKeys(item)} key={item.id} />`

    `<div className='feed-item-stream'>
        { this.state.newActivity && this.state.newActivity.length > 0 &&
            <a className='btn btn-flat block margin-bottom--medium' onClick={ this._prepend }>
                { this.state.newActivity.length } new { this.state.newActivity.length == 1 ? 'activity' : 'activities' }
            </a> }

        { out }

        <InfiniteScroll onLoad={ this._append }
                        stateLink={ this.stateLink }
                        params={{}}
                        count={ this.state.activity.length } />
    </div>`
