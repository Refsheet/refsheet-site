@Tabs = React.createClass
  propTypes:
    className: React.PropTypes.string

  componentDidMount: ->
    $(@refs.tabs).tabs()
    # https://github.com/Dogfalo/materialize/issues/2102
    $(document).on 'materialize:modal:ready', ->
      window.dispatchEvent(new Event('resize'))

  render: ->
    className  = 'tabs'
    className += ' ' + @props.className if @props.className

    tabs = React.Children.map @props.children, (child) =>
      if child?.type == Tab
        liClasses = ['tab']

        `<li className={ liClasses.join(' ') }>
            <a href={ '#' + child.props.id }>
                { child.props.name }
                { child.props.icon &&
                    <i className='material-icons left'>{ child.props.icon }</i>
                }
            </a>
        </li>`
      else
        console.log "Children to Tabs should be a Tab, got #{child?.type}."

    `<div className='tabs-container'>
        <ul ref='tabs' className={ className }>
            { tabs }
        </ul>

        { this.props.children }
    </div>`
