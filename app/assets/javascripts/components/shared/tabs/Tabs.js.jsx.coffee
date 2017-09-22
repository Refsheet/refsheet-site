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
        liClasses.push 'no-name' unless child.props.name

        `<li className={ liClasses.join(' ') }>
            <a href={ '#' + child.props.id }>
                { child.props.icon &&
                    <i className='material-icons'>{ child.props.icon }</i>
                }

                <span className='name'>{ child.props.name }</span>

                { child.props.count > 0 &&
                    <span className='count'>{ NumberUtils.format(child.props.count) }</span>
                }
            </a>
        </li>`
      else
        console.warn "Children to Tabs should be a Tab, got #{child?.type}." unless typeof child?.type is 'undefined'

    `<div className='tabs-container'>
        <ul ref='tabs' className={ className }>
            { tabs }
        </ul>

        { this.props.children }
    </div>`
