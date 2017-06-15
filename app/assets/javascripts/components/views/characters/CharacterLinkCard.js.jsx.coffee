@CharacterLinkCard = (props) ->
  colorData = props.colorScheme?.color_data || {}

  `<div className='character-link-card'>
      <Link to={ props.link } className='image'>
          <img src={ props.profileImageUrl } />
      </Link>

      <div className='details' style={{ backgroundColor: colorData['card-background'] }}>
        <Link to={ props.link } className='name' style={{ color: colorData['accent1'] }}>{ props.name }</Link>
        <div className='species' style={{ color: colorData['text'] }}>{ props.species || 'Unknown Species' }</div>
      </div>
  </div>`
