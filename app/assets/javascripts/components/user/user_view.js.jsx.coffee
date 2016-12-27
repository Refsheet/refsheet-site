@UserView = (props) ->
  `<div className='user-view'>
      <div className='background'>
          <img src={ props.backgroundImage } />
      </div>

      <img className='circle' src={ props.avatar } />
      <div className='white-text name'>{ props.name }</div>
      <div className='white-text email'>{ props.email }</div>
  </div>`
