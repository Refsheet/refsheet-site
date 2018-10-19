@Submit = (props) ->
  classNames = ['btn']
  classNames.push props.className
  classNames.push 'waves-effect waves-light' unless props.noWaves
  classNames.push 'btn-flat' if props.flat
  classNames.push 'btn-link' if props.link

  `<button type={ props.type || 'submit' }
           className={ classNames.join(' ') }>
      { props.children || 'Submit' }
  </button>`
