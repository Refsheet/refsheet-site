@Icon = v1 -> (props) ->
  { children, title, className, style } = props
  classNames = ['material-icons']
  classNames.push className if className

  `<i className={ classNames.join(' ') } title={ title } style={ style }>{ children }</i>`
