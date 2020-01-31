@Jumbotron = v1 -> (props) ->
  classNames = ['jumbotron']
  classNames.push props.className if props.className

  `<div className={ classNames.join(' ') }>
      <div className='jumbotron-background'>
          <div className='container'>{ props.children }</div>
      </div>
  </div>`
