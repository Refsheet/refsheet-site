@Loading = (props) ->
  classNames = ['modal-page-content']
  classNames.push props.className if props.className

  `<main className={ classNames.join(' ') }>
      <div className='container'>
          <Spinner />

          { props.message !== false &&
              <h1>{ props.message || 'Loading...' }</h1>
          }

          { props.children }
      </div>
  </main>`
