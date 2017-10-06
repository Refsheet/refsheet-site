@DateFormat = React.createClass
  propTypes:
    timestamp: React.PropTypes.number.isRequired
    fuzzy: React.PropTypes.bool
    dateOnly: React.PropTypes.bool
    short: React.PropTypes.bool
    className: React.PropTypes.string

  getInitialState: ->
    timer: null
    dateDisplay: null

  componentWillMount: ->
    @_initialize()

  componentWillReceiveProps: (newProps) ->
    @_initialize newProps

  componentWillUnmount: ->
    clearTimeout @state.timer if @state.timer

  _initialize: (props=@props) ->
    clearTimeout @state.timer if @state.timer

    if props.fuzzy
      t = setTimeout @_fuzzyPoll, (60 - @date().getSeconds()) * 1000
      @setState dateDisplay: @fuzzyDate(), timer: t

    else
      @setState dateDisplay: @showDate()

  _fuzzyPoll: ->
    console.debug 'fuzzy poll'
    t = setTimeout @_fuzzyPoll, 60000
    @setState dateDisplay: @fuzzyDate(), timer: t

  _z: (n) ->
    if n < 10 then '0' + n else n

  _p: (i, word) ->
    return "#{i}#{word.substring(0,1)}" if @props.short

    s = if i == 1 then '' else 's'
    "#{i} #{word}#{s}"

  monthNames: [
    "January"
    "February"
    "March"
    "April"
    "May"
    "June"
    "July"
    "August"
    "September"
    "October"
    "November"
    "December"
  ]

  date: ->
    ts = parseInt @props.timestamp
    ts *= 1000 if ts < 10**11
    new Date ts

  fullTime: ->
    date = @date()
    "#{date.getFullYear()}-#{@_z date.getMonth() + 1}-#{@_z date.getDate()} #{@_z date.getHours()}:#{@_z date.getMinutes()}:#{@_z date.getSeconds()}"

  showDate: ->
    date = @date()
    month = @monthNames[@date.getMonth()]
    month = @monthNames.substr(0,3) if @props.short

    hour = date.getHours() % 12
    hour = 12 if hour == 0
    apm = if hour >= 12 then 'pm' else 'am'

    end = "#{month} #{date.getDate()}, #{date.getYear()}"
    end += " #{@_z hour}:#{@_z date.getMinutes()} #{apm}" unless @props.dateOnly
    end

  fuzzyDate: ->
    msPerMinute = 60 * 1000
    msPerHour = msPerMinute * 60
    msPerDay = msPerHour * 24
    msPerMonth = msPerDay * 30
    msPerYear = msPerDay * 365

    elapsed = (new Date()).getTime() - @date().getTime()
    ago = if @props.short then '' else ' ago'
    about = if @props.short then '' else 'about '

    switch
      when elapsed < msPerMinute
        if @props.short then '<1m' else 'just now'
      when elapsed < msPerHour
        "#{@_p Math.round(elapsed / msPerMinute), 'minute'}#{ago}"
      when elapsed < msPerDay
        "#{@_p Math.round(elapsed / msPerHour), 'hour'}#{ago}"
      when elapsed < msPerMonth
        "#{about}#{@_p Math.round(elapsed / msPerDay), 'day'}#{ago}"
      when elapsed < msPerYear
        "#{about}#{@_p Math.round(elapsed / msPerMonth), 'month'}#{ago}"
      else
        "#{about}#{@_p Math.round(elapsed / msPerYear), 'year'}#{ago}"

  render: ->
    `<span className={ this.props.className } title={ this.fullTime() }>
        { this.state.dateDisplay }
    </span>`
