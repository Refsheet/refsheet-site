@CharacterApp = React.createClass
  getInitialState: ->
    character: null
    artistView: @props.artistView || true
    loaded: false

  setArtistView: (av) ->
    @setState artistView: av
    
  componentDidMount: ->
    $.get @props.characterPath, (data) =>
      @setState character: data, loaded: true

  render: ->
    if !@state.loaded
      loading = `<Loading />`

    else
      `<div>
          <UserBar />
          <ArtistToggleButton artistView={ this.state.artistView } onChange={ this.setArtistView } />

          <PageHeader backgroundImage="/assets/unsplash/sand.jpg">
              <CharacterCard artistView={ this.state.artistView }
                             imageSrc="http://d.facdn.net/art/mauabata/1475972185/1475972185.mauabata_mauflamescrying.png"
                             name={ this.state.character.name }
                             profile={ this.state.character.profile }
              />
          </PageHeader>

          <CharacterSwatches artistView={ this.state.artistView } characterPath={ this.state.character.path } />
          <CharacterGallery artistView={ this.state.artistView } featuredImage="http://d.facdn.net/art/mauabata/1472002969/1472002969.mauabata_maushamanreference_postres.png" />

          { this.state.artistView ? null : <CharacterComments /> }
      </div>`
