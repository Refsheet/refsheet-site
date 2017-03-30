@Submit = (props) ->
  `<button type={ props.type || 'submit' }
           className={ props.className || 'btn waves-effect waves-light' }>
      { props.children || 'Submit' }
  </button>`
