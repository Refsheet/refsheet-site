@SideNav = React.createClass
  componentDidMount: ->
    $('.side-nav-trigger').sideNav
      menuWidth: 200
      closeOnClick: true
      draggable: true

  render: ->
    `<div>
        <a className='side-nav-trigger' data-activates='slide-out'>
            <i className='material-icons'>menu</i>
        </a>

        <ul id='slide-out' className='side-nav'>
            { this.props.children }
        </ul>
    </div>`
