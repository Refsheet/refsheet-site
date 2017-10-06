@Dashboard.Activity = React.createClass
  contextTypes:
    currentUser: React.PropTypes.object

  dataPath: '/account/activity'
  stateLink:
    dataPath: '/account/activity'
    statePath: 'activity'

  getInitialState: ->
    activity: null

  componentDidMount: ->
    StateUtils.load @, 'activity'

  _append: (activity) ->
    StateUtils.updateItems @, 'activity', activity

  _groupedActivity: ->
    grouped = []

    for item in @state.activity
      last = grouped[grouped.length - 1]

      if last and HashUtils.compare(item, last, 'user.username', 'character.id', 'activity_type', 'activity_method') and last.timestamp - item.timestamp < 3600
        last.activities ||= [last.activity]
        last.activities.push item.activity
      else
        grouped.push item

    grouped


  render: ->
    return `<Loading />` unless @state.activity

    out = @_groupedActivity().map (item) ->
      `<Dashboard.ActivityCard {...StringUtils.camelizeKeys(item)} key={item.id} />`

    `<div>
        { out }

        <InfiniteScroll onLoad={ this._append } stateLink={ this.stateLink } params={{}} />
    </div>`
