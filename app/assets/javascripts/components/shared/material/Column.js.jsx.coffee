@Column = v1 -> (props) ->
  classes = ['col']
  classes.push props.className
  classes.push 's12' unless props['s']

  for s in ['s', 'm', 'l', 'xl', 'offset-s', 'offset-m', 'offset-l']
    classes.push "#{s}#{props[s]}" if props[s]
    
  `<div className={ classes.join(' ') }>{ props.children }</div>`
