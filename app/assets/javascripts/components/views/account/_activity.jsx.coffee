@Views.Account.Activity = React.createClass
  contextTypes:
    currentUser: React.PropTypes.object

  timer: null
  dataPath: '/account/activity'
  stateLink: ->
    dataPath: '/account/activity?before=' + @state.since
    statePath: 'activity'

  getInitialState: ->
    activity: null
    newActivity: null
    since: null
    timer: null

  componentDidMount: ->
    StateUtils.load @, 'activity', @props.params, =>
      @setState since: @state.activity[0]?.timestamp
      @_poll()

  componentWillUnmount: ->
    clearTimeout @timer if @timer

  _poll: ->
    @timer = setTimeout =>
      Model.poll @dataPath, { since: @state.since }, (data) =>
        @setState newActivity: data.activity, @_poll
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

    `<div>
        { this.state.newActivity && this.state.newActivity.length > 0 &&
            <a className='btn block white-text margin-bottom--medium' onClick={ this._prepend }>
                { this.state.newActivity.length } new { this.state.newActivity.length == 1 ? 'activity' : 'activities' }
            </a> }

        { out }

        <InfiniteScroll onLoad={ this._append } stateLink={ this.stateLink } params={{}} />
    </div>`
