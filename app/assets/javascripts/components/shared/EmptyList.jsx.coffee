@EmptyList = (props) ->
  { coffee, caption } = props

  `<div className='empty-list'>
      { coffee &&
          <Icon className='other'>local_cafe</Icon> }

      { !coffee &&
          <Icon className='sun'>wb_sunny</Icon> }

      { !coffee &&
          <Icon className='cloud'>cloud</Icon> }

      <p>{ caption || 'Nothing to see here!' }</p>
  </div>`
