@CharacterApp = React.createClass
  contextTypes:
    router: React.PropTypes.func

  params: ->
    this.context.router.getCurrentParams()

  getInitialState: ->
    character: null
    loaded: false
    
  componentDidMount: ->
    path = '/users/' + @params().userId + '/characters/' + @params().id
    $.get path, (data) =>
      @setState character: data, loaded: true

  render: ->
    if !@state.loaded
      loading = `<Loading />`

    else
      `<div>
          <RouteHandler character={ this.state.character } characterId={ this.params().id } userId={ this.params().userId }  />
      </div>`
