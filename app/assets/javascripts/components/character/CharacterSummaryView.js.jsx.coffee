@CharacterSummaryView = (props) ->
  `<div>
      <ArtistToggleButton linkTo='details'
                          linkParams={{ id: props.characterId, userId: props.userId }}
                          icon='brush'
                          tooltip='Artist-Friendly Information' />

      <PageHeader backgroundImage="/assets/unsplash/sand.jpg">
          <CharacterCard artistView={ false }
                         imageSrc="http://d.facdn.net/art/mauabata/1475972185/1475972185.mauabata_mauflamescrying.png"
                         name={ props.character.name }
                         profile={ props.character.profile }
          />
      </PageHeader>

      <CharacterSwatches artistView={ false } characterPath={ props.character.path } />
      <CharacterGallery />
      <CharacterComments />
  </div>`
