@Loading = (props) ->
  `<main className='modal-content'>
      <div className='container'>
          <h1>{ props.message || 'Loading...' }</h1>
          <Spinner />
          { props.children }
      </div>
  </main>`
