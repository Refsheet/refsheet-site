@CharacterDetailView = (props) ->
  `<div>
      <SwatchPanel swatchesPath={ props.character.path + '/swatches/' } swatches={ props.character.swatches } />

      <Link to='character-profile'
            params={{ userId: props.character.user_id, characterId: props.character.url }}
            className='side-nav-trigger tooltipped'
            data-tooltip='Character Profile'
            data-position='right'>

          <i className='material-icons'>perm_identity</i>
      </Link>
  </div>`
