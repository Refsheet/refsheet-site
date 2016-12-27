@CharacterApp = React.createClass
  getInitialState: ->
    current_user: @props.currentUser
    user: @props.user
    character: @props.character
    artistView: @props.artistView || true

  setArtistView: (av) ->
    @setState artistView: av

  render: ->
    if @state.character != undefined
      `<Loading />`

    else
      swatches = [
        'rgb(253, 244, 221)',
        'rgb(193, 180, 146)',
        'rgb(148, 131, 107)',
        'rgb(108, 96, 78)',
        'rgb(74, 62, 49)',
        'rgb(57, 50, 43)',
        'rgb(48, 43, 36)',
        'rgb(81, 57, 57)',
        'rgb(174, 196, 77)',
        'rgb(53, 73, 42)'
      ]

      `<div>
          <UserBar user={ this.state.current_user } />
          <ArtistToggleButton artistView={ this.state.artistView } onChange={ this.setArtistView } />

          <PageHeader backgroundImage="/assets/unsplash/sand.jpg">
              <CharacterCard artistView={ this.state.artistView }
                             imageSrc="http://d.facdn.net/art/mauabata/1475972185/1475972185.mauabata_mauflamescrying.png"
                             name='Akhet'
                             titleSuffix='of Horus'
              />
          </PageHeader>

          <CharacterSwatches artistView={ this.state.artistView } swatches={ swatches } />
          <CharacterGallery artistView={ this.state.artistView } featuredImage="http://d.facdn.net/art/mauabata/1472002969/1472002969.mauabata_maushamanreference_postres.png" />

          { this.state.artistView ? null : <CharacterComments /> }
      </div>`
