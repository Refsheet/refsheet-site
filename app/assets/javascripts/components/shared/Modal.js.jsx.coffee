@Modal = (props) ->
  `<div className='modal' id={ props.id }>
      <div className="modal-content">
          { props.children }
      </div>
  </div>`
