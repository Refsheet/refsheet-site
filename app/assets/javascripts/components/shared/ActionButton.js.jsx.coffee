@ActionButton = React.createClass
  componentDidMount: ->
    $('.tooltipped').tooltip(delay: 0, position: 'left')

  componentWillUnmount: ->
    $('.tooltipped').tooltip('remove')

  render: ->
    largeClass = ''
    iconClass = ''

    if @props.large
      largeClass = ' btn-large'
      iconClass = ' large'

    `<a className={ 'btn-floating tooltipped ' + this.props.className + largeClass }
        data-tooltip={ this.props.tooltip }
        href={ this.props.href }
        onClick={ this.props.onClick }>

         <i className={ 'material-icons' + iconClass }>{ this.props.icon }</i>
     </a>`
