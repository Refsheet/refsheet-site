@Jumbotron = (props) ->
  `<div className='jumbotron'>
      <div className='jumbotron-background'>
          <div className='container'>{ props.children }</div>
      </div>
  </div>`
