@CharacterGallery = (props) ->
  if props.artistView
    featuredImage =
      `<div className='featured-image'>
          <img src={ props.featuredImage } />
      </div>`

  `<section className='character-gallery'>
      <div className='container'>
          { featuredImage }
      </div>
  </section>`
