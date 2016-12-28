@CharacterApp = React.createClass
  getInitialState: ->
    current_user: @props.currentUser
    character: null
    artistView: @props.artistView || true

  setArtistView: (av) ->
    @setState artistView: av
    
  componentDidMount: ->
    $.get @props.characterPath, (data) =>
      @setState character: data

  render: ->
    if !@state.character?
      `<Loading />`

    else
      swatches = [
        { color: 'rgb(253, 244, 221)', name: 'Light Fur', notes: 'Belly spot, under arms, etc.' },
        { color: 'rgb(193, 180, 146)', name: 'Fur Base Color', notes: 'Main Coat' },
        { color: 'rgb(148, 131, 107)', name: 'Fur Gradient (Dark)', notes: 'Along spine, arms, thights' },
        { color: 'rgb(108, 96, 78)', name: 'Inner Rosette' },
        { color: 'rgb(74, 62, 49)', name: 'Claws!' },
        { color: 'rgb(57, 50, 43)', name: 'Ear Backs', notes: 'Also: Facial markings' },
        { color: 'rgb(48, 43, 36)', name: 'Rosette Border', notes: 'Also: Tufts, Skin (black)' },
        { color: 'rgb(81, 57, 57)', name: 'Paw Pads + Skin', notes: 'Pinker flesh - My coffee beanz are kinda reddish.' },
        { color: 'rgb(174, 196, 77)', name: 'Eyes - Inner Iris', notes: 'Innermost of the eyes, slightly golden.' },
        { color: 'rgb(53, 73, 42)', name: 'Eyes - Outer Iris', notes: 'Outermost of the iris, green!' }
      ]

      `<div>
          <UserBar user={ this.state.current_user } />
          <ArtistToggleButton artistView={ this.state.artistView } onChange={ this.setArtistView } />

          <PageHeader backgroundImage="/assets/unsplash/sand.jpg">
              <CharacterCard artistView={ this.state.artistView }
                             imageSrc="http://d.facdn.net/art/mauabata/1475972185/1475972185.mauabata_mauflamescrying.png"
                             name={ this.state.character.name }
                             profile={ this.state.character.profile }
              />
          </PageHeader>

          <CharacterSwatches artistView={ this.state.artistView } characterPath={ this.state.character.path } swatches={ swatches } />
          <CharacterGallery artistView={ this.state.artistView } featuredImage="http://d.facdn.net/art/mauabata/1472002969/1472002969.mauabata_maushamanreference_postres.png" />

          { this.state.artistView ? null : <CharacterComments /> }
      </div>`
