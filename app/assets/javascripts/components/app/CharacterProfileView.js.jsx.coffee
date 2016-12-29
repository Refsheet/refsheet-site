@CharacterProfileView = (props) ->
  `<div>
      <SwatchRule swatches={ props.character.swatches } />
      
      <Link to='character-details' 
            params={{ userId: props.character.user_id, characterId: props.character.url }}
            className='side-nav-trigger tooltipped' 
            data-tooltip='Technical Details' 
            data-position='right'>
          
          <i className='material-icons'>brush</i>
      </Link>
  </div>`
