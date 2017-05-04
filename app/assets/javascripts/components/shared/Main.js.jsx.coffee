@Main = React.createClass
  propTypes:
    style: React.PropTypes.object
    title: React.PropTypes.oneOf([
      React.PropTypes.string
      React.PropTypes.array
    ])


  componentDidMount: ->
    title = []
    title.push @props.title if @props.title
    title.push 'Refsheet.net'
    document.title = [].concat.apply([], title).join ' - '


  render: ->
    `<main style={ this.props.style }>
        { this.props.children }
    </main>`
