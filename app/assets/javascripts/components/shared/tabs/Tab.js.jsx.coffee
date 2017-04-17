@Tab = React.createClass
  propTypes:
    id: React.PropTypes.string.isRequired
    name: React.PropTypes.string.isRequired
    className: React.PropTypes.string

  render: ->
    `<div className={ this.props.className }
          id={ this.props.id }>
        { this.props.children }
    </div>`
