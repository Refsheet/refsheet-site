@Section = v1 -> (props) ->
  `<section className={ props.className }>
      <div className='container'>
          { props.children }
      </div>
  </section>`
