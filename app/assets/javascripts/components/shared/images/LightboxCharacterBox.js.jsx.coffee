@LightboxCharacterBox = (props) ->
  `<div className='character-box'>
      <div className='character-avatar'>
          <img src={ props.character.profile_image_url } />
      </div>
      
      <div className='character-details'>
          <div className='name'>
              { props.character.name }
          </div>
      </div>
  </div>`
