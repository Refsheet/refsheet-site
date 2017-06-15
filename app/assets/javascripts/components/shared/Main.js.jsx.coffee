@Main = React.createClass
  propTypes:
    style: React.PropTypes.object
    className: React.PropTypes.string
    bodyClassName: React.PropTypes.string
    fadeEffect: React.PropTypes.bool
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

  componentDidMount: ->
    if @props.fadeEffect
      $(@refs.main).fadeIn()

  componentWillUnmount: ->
    $('body').removeClass @props.bodyClassName


  render: ->
    style = @props.style || {}

    if @props.fadeEffect
      style.display = 'none'

    `<main style={ this.props.style } className={ this.props.className } ref='main'>
        { this.props.children }
    </main>`
