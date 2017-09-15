@Icon = (props) ->
  { children, title, className } = props
  classNames = ['material-icons']
  classNames.push className if className

  `<i className={ classNames.join(' ') } title={ title }>{ children }</i>`
