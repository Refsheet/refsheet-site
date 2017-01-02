@CharacterProfileView = (props) ->
  `<div>
      <PageHeader backgroundImage="/assets/unsplash/sand.jpg">
          <CharacterCard character={ props.character } />
      </PageHeader>

      <SwatchRule swatches={ props.character.swatches } />
      
      <Link to={ props.character.path + '/details' }
            className='side-nav-trigger tooltipped' 
            data-tooltip='Technical Details' 
            data-position='right'>
          
          <i className='material-icons'>brush</i>
      </Link>
  </div>`
