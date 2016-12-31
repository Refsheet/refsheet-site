@PageHeader = (props) ->
  backdropStyle = {
    backgroundImage: "url(" + props.backgroundImage + ")"
  }
  
  `<section className='page-header'>
      <div className='page-header-backdrop' style={backdropStyle}></div>
      <div className='page-header-content'>
        <div className='container'>
            { props.children }
        </div>
      </div>
  </section>`
