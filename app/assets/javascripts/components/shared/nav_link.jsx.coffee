@NavLink = React.createClass
  contextTypes:
    router: React.PropTypes.object

  propTypes:
    to: React.PropTypes.string.isRequired
    text: React.PropTypes.string.isRequired
    icon: React.PropTypes.string
    disabled: React.PropTypes.bool
    className: React.PropTypes.string
    activeClassName: React.PropTypes.string

  render: ->
    { to } = @props

    to = '/' + to if to[0] is '?'

    console.log(@context.router)

    if to.match /\?/
      currentPath = @context.router.route.match.path + (@context.router.route.location.search || '')
    else
      currentPath = @context.router.route.match.path

    console.log currentPath, to

    active = ReactRouter.matchPath to,
      path: currentPath,
      exact: true#, @props.exact

    to = '' if @props.disabled

    classNames = ['nav-link']
    classNames.push @props.className if @props.className
    classNames.push 'active' if active
    classNames.push 'disabled' if @props.disabled

    linkClassNames = []
    linkClassNames.push 'disabled' if @props.disabled

    activeClassNames = ['active current']
    activeClassNames.push @props.activeClassName if @props.activeClassName

    linkClassNames.push activeClassNames if active

    `<li className={ classNames.join(' ') }>
        <Link to={ to } className={ linkClassNames.join(' ') }>
            { this.props.icon && <Icon className='left'>{ this.props.icon }</Icon> } { this.props.text }
        </Link>

        { !this.props.disabled && active && this.props.children &&
            <ul className='subnav'>
                { this.props.children }
            </ul> }
    </li>`
