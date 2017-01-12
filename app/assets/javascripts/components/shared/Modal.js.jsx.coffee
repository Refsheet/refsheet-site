@Modal = React.createClass
  componentDidMount: ->
    $('#' + @props.id).modal()
    
  render: ->
    `<div className='modal' id={ this.props.id }>
        <div className="modal-content">
            { this.props.children }
        </div>
    </div>`
