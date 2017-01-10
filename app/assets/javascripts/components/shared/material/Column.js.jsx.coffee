@Column = (props) ->
  classes = ['col']
  
  props['s'] = 12 unless props['s']?
  
  for s in ['s', 'm', 'l', 'xl', 'offset-s', 'offset-m', 'offset-l']
    classes.push "#{s}#{props[s]}" if props[s]?
    
  `<div className={ classes.join(' ') }>{ props.children }</div>`
