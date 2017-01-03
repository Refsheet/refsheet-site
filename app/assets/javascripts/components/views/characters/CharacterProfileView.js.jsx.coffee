@CharacterProfileView = (props) ->
  `<div>
      <PageHeader backgroundImage={ props.character.featured_image.url }>
          <CharacterCard character={ props.character } />
      </PageHeader>

      <SwatchRule swatches={ props.character.swatches } />

      <ImageGallery edit={ false } imagesPath={ props.character.path + '/images/' } onImageClick={ props.onLightbox } />
      
      <Link to={ props.character.path + '/details' }
            className='side-nav-trigger tooltipped' 
            data-tooltip='Technical Details' 
            data-position='right'>
          
          <i className='material-icons'>brush</i>
      </Link>
  </div>`
