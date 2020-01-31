@CharacterLinkCard = v1 -> (props) ->
  colorData = props.colorScheme?.color_data || {}

  `<div className='character-link-card' style={{ backgroundColor: colorData['image-background'] || '#000000' }}>
      <Link to={ props.link } className='image'>
          <img src={ props.profileImageUrl } />
      </Link>

      <div className='details' style={{ backgroundColor: colorData['card-background'] }}>
        <Link to={ props.link } className='name' style={{ color: colorData['accent1'] }}>{ props.name }</Link>
        <div className='species' style={{ color: colorData['text'] }}>{ props.species || 'Unknown Species' }</div>
      </div>
  </div>`
