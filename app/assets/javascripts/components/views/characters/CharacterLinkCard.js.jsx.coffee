@CharacterLinkCard = (props) ->
  `<Link to={ props.path } className='character-link-card'>
      <img src={ props.profileImageUrl } />
      <div className='character-name'>{ props.name }</div>
  </Link>`
