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
              <CharacterCard imageSrc="http://d.facdn.net/art/mauabata/1475972185/1475972185.mauabata_mauflamescrying.png"
                             name={ this.state.character.name } />
          </PageHeader>
          
          <RouteHandler character={ this.state.character } />
      </div>`
