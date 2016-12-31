@Loading = (props) ->
  `<div className='loading'>
      <h1>{ props.message || 'Loading...' }</h1>
      <Spinner />
      { props.children }
  </div>`
