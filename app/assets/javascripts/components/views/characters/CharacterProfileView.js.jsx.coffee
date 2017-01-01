@CharacterProfileView = (props) ->
  `<div>
      <PageHeader backgroundImage="/assets/unsplash/sand.jpg">
          <CharacterCard character={ props.character } />
      </PageHeader>

      <SwatchRule swatches={ props.character.swatches } />
      
      <Link to={ props.character.path + '/details' }
            params={{ userId: props.character.user_id, characterId: props.character.slug }}
            className='side-nav-trigger tooltipped' 
            data-tooltip='Technical Details' 
            data-position='right'>
          
          <i className='material-icons'>brush</i>
      </Link>
  </div>`
