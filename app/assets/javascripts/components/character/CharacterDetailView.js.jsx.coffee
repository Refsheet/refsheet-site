@CharacterDetailView = (props) ->
  `<div>
      <ArtistToggleButton linkTo='summary'
                          linkParams={{ id: props.characterId, userId: props.userId }}
                          icon='perm_identity'
                          tooltip='Character Profile' />

      <PageHeader backgroundImage="/assets/unsplash/sand.jpg">
          <CharacterCard artistView={ true }
                         imageSrc="http://d.facdn.net/art/mauabata/1475972185/1475972185.mauabata_mauflamescrying.png"
                         name={ props.character.name }
          />
      </PageHeader>

      <CharacterSwatches artistView={ true } characterPath={ props.character.path } />
      <CharacterGallery artistView={ true } featuredImage="http://d.facdn.net/art/mauabata/1472002969/1472002969.mauabata_maushamanreference_postres.png" />
  </div>`
