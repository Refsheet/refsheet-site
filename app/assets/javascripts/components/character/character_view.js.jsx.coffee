@CharacterView = (props) ->
  `<div className='character-view'>
      <div className='background'>
          <img src={ props.backgroundImage } />
      </div>

      <img className='circle' src={ props.avatar } />
  </div>`
