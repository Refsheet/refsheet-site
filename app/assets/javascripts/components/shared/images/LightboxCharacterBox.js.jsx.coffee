@LightboxCharacterBox = (props) ->
  `<div className='character-box'>
      <Link to={ props.character.link } className='character-avatar'>
          <img src={ props.character.profile_image_url } />
      </Link>
      
      <div className='character-details'>
          <Link to={ props.character.link } className='name'>
              { props.character.name }
          </Link>
          <div className='date'>
              { props.postDate }
          </div>
      </div>
  </div>`
