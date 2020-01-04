@Modal = React.createClass
  componentDidMount: ->
    $modal = M.Modal.init @refs.modal,
      onCloseEnd: (args) =>
        if @props.sideSheet
          document.body.classList.remove('side-sheet-open', 'side-sheet-closing', 'side-sheet-opening')

        if @props.onClose
          @props.onClose(args)

        if window.location.hash is "##{@props.id}"
          window.location.hash = ""

      onCloseStart: =>
        if @props.sideSheet
          document.body.classList.add('side-sheet-closing')

      onOpenStart: =>
        if @props.sideSheet
          document.body.classList.add('side-sheet-opening')
          document.body.classList.add('side-sheet-open')

      onOpenEnd: =>
        if @props.id
          window.location.hash = "##{@props.id}"
        $(document).trigger 'materialize:modal:ready'

    if window.location.hash is "##{@props.id}"
      $modal.open()

    if @props.autoOpen
      $modal.open()

  componentWillUnmount: ->
    $modal = M.Modal.getInstance(@refs.modal)
    $modal.close()
    $modal.destroy()

  close: ->
    $modal = M.Modal.getInstance(@refs.modal)
    $modal.close()

  _handleClose: (e) ->
    @close()
    e.preventDefault()

    
  render: ->
    classes = ['modal']
    classes.push 'wide' if @props.wide
    classes.push 'bottom-sheet' if @props.bottomSheet
    classes.push 'side-sheet' if @props.sideSheet
    classes.push @props.className if @props.className

    containerClasses = ['modal-stretch']
    containerClasses.push 'modal-content' unless @props.noContainer
    containerClasses.push 'container' if @props.container

    actions = (@props.actions || []).map (action) ->
      `<a className={ 'modal-action waves-effect waves-light btn ' + action.className }
          key={ action.name }
          onClick={ action.action }>
          { action.name }
      </a>`

    `<div ref='modal' className={ classes.join(' ') } id={ this.props.id }>
        <div className='modal-body'>
            { this.props.title &&
                <div className='modal-header-wrap'>
                    <div className='modal-header'>
                        <a className='modal-close' onClick={ this._handleClose }>
                            <i className='material-icons'>close</i>
                        </a>

                        <h2>{ this.props.title }</h2>
                    </div>
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
