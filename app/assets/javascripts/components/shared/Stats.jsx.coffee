@Stats = v1 -> React.createClass
  propTypes:
    className: React.PropTypes.string

  render: ->
    classNames = ['stats']
    classNames.push @props.className if @props.className

    `<ul className={ classNames.join(' ') }>
        { this.props.children }
    </ul>`

@Stats.Item = v1 -> React.createClass
  propTypes:
    label: React.PropTypes.string.isRequired

  render: ->
    `<li>
        <div className='label'>{ this.props.label }</div>
        <div className='value'>{ this.props.children }</div>
    </li>`
