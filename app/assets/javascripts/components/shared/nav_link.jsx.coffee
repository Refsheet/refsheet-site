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
    active = @context.router.isActive @props.to

    classNames = ['nav-link']
    classNames.push @props.className if @props.className
    classNames.push 'active' if active
    classNames.push 'disabled' if @props.disabled

    linkClassNames = []
    linkClassNames.push 'disabled' if @props.disabled

    activeClassNames = ['active current']
    activeClassNames.push @props.activeClassName if @props.activeClassName

    `<li className={ classNames.join(' ') }>
        <Link to={this.props.to} activeClassName={ activeClassNames.join(' ') } className={ linkClassNames.join(' ') }>
            { this.props.icon && <Icon className='left'>{ this.props.icon }</Icon> } { this.props.text }
        </Link>

        { active && this.props.children &&
            <ul className='subnav'>
                { this.props.children }
            </ul> }
    </li>`
