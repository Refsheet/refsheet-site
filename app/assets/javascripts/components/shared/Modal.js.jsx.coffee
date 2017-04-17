@Modal = React.createClass
  componentDidMount: ->
    $('#' + @props.id).modal
      complete: @props.onClose
    
  render: ->
    classes = ['modal']
    classes.push 'wide' if @props.wide
    classes.push 'bottom-sheet' if @props.bottomSheet

    containerClasses = ['modal-content']
    containerClasses.push 'container' if @props.container

    actions = (@props.actions || []).map (action) ->
      `<a className={ 'modal-action waves-effect waves-light btn ' + action.className }
          key={ action.name }
          onClick={ action.action }>
          { action.name }
      </a>`

    `<div className={ classes.join(' ') } id={ this.props.id }>
        <div className='modal-body'>
            { this.props.title &&
                <div className='modal-header'>
                    <a className='modal-close'>
                        <i className='material-icons'>close</i>
                    </a>

                    <h2>{ this.props.title }</h2>
                </div> }

            <div className={ containerClasses.join(' ') }>
                { this.props.children }
            </div>

            { actions.length > 0 &&
                <div className='modal-footer'>
                    { actions }
                </div> }
        </div>
    </div>`
