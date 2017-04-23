@Tab = React.createClass
  propTypes:
    id: React.PropTypes.string.isRequired
    name: React.PropTypes.string
    icon: React.PropTypes.string
    className: React.PropTypes.string

  render: ->
    classNames = ['tab-content']
    classNames.push @props.className if @props.className

    `<div className={ classNames.join(' ') }
          id={ this.props.id }>
        { this.props.children }
    </div>`
