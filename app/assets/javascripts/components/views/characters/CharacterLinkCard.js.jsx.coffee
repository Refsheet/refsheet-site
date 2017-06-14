@CharacterLinkCard = (props) ->
  console.debug props

  `<div className='character-link-card'>
      <Link to={ props.link } className='image'>
          <img src={ props.profileImageUrl } />
      </Link>

      <div className='details'>
        <Link to={ props.link } className='name'>{ props.name }</Link>
        <div className='species'>{ props.species || 'Unknown Species' }</div>
      </div>
  </div>`
