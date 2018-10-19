@ActionButton = React.createClass
  componentDidUpdate: ->
    $(@refs.actionButton).tooltip(delay: 0, position: 'left')

  componentDidMount: ->
    $(@refs.actionButton).tooltip(delay: 0, position: 'left')

  componentWillUnmount: ->
    $(@refs.actionButton).tooltip('remove')

  render: ->
    largeClass = ''
    iconClass = ''

    if @props.large
      largeClass = ' btn-large red'
      iconClass = ' large'

    `<a className={ 'btn-floating tooltipped waves waves-light ' + this.props.className + largeClass }
        ref='actionButton'
        data-tooltip={ this.props.tooltip }
        href={ this.props.href }
        onClick={ this.props.onClick }
        id={ this.props.id }>

         <i className={ 'material-icons' + iconClass }>{ this.props.icon }</i>
     </a>`
