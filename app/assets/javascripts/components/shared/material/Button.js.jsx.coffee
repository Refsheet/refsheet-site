@Button = v1 -> (props) ->
  {
    children
    href
    onClick
    block
    large
    noWaves
    className
    target
  } = props

  classNames = ['btn']
  classNames.push className if className
  classNames.push 'waves-effect waves-light' unless noWaves
  classNames.push 'btn-block' if block
  classNames.push 'btn-large' if large

  `<a className={ classNames.join(' ') }
      href={ href }
      onClick={ onClick }
      target={ target }
  >
      { children }
  </a>`
