@Tabs = React.createClass
  componentDidMount: ->
    $('.tabs').tabs()

  render: ->
    `<ul className='tabs'>
        { this.props.children }
    </ul>`