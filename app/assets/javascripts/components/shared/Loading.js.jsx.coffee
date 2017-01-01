@Loading = (props) ->
  `<div className='modal-content'>
      <h1>{ props.message || 'Loading...' }</h1>
      <Spinner />
      { props.children }
  </div>`
