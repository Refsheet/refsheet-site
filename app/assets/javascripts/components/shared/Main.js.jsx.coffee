@Main = React.createClass
  propTypes:
    style: React.PropTypes.object
    bodyClassName: React.PropTypes.string
    title: React.PropTypes.oneOfType([
      React.PropTypes.string
      React.PropTypes.array
    ])


  componentWillMount: ->
    title = []
    title.push @props.title if @props.title
    title.push 'Refsheet.net'
    document.title = [].concat.apply([], title).join ' - '
    $('body').addClass @props.bodyClassName

  componentWillUnmount: ->
    $('body').removeClass @props.bodyClassName


  render: ->
    `<main style={ this.props.style }>
        { this.props.children }
    </main>`
