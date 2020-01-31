@LightboxCharacterBox = v1 -> (props) ->
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

              { props.hidden &&
                  <span title='Hidden'>
                      <i className='material-icons'>visibility_off</i>
                  </span> }

              { props.nsfw &&
                  <span title='NSFW'>
                      <i className='material-icons'>remove_circle</i>
                  </span> }
          </div>
      </div>
  </div>`
