@CharacterApp = React.createClass
  contextTypes:
    router: React.PropTypes.func

  params: ->
    @context.router.getCurrentParams()

  getInitialState: ->
    character: null
    loaded: false
    
  componentDidMount: ->
    path = '/users/' + @params().userId + '/characters/' + @params().characterId
    
    $.get path, (data) =>
      @setState character: data, loaded: true

  render: ->
    if !@state.loaded
      loading = `<Loading />`

    else
      `<div>
          <PageHeader backgroundImage="/assets/unsplash/sand.jpg">
              <CharacterCard character={ this.state.character } />
          </PageHeader>
          
          <RouteHandler character={ this.state.character } />
      </div>`
