@Main = React.createClass
  propTypes:
    style: React.PropTypes.object
    className: React.PropTypes.string
    bodyClassName: React.PropTypes.string
    fadeEffect: React.PropTypes.bool
    slideEffect: React.PropTypes.bool
    title: React.PropTypes.oneOfType([
      React.PropTypes.string
      React.PropTypes.array
    ])


  componentWillMount: ->
    if @props.title
      title = []
      title.push @props.title if @props.title
      title.push 'Refsheet.net'
      document.title = [].concat.apply([], title).join ' - '

    $('body').addClass @props.bodyClassName

  componentDidMount: ->
    if @props.fadeEffect
      $(@refs.main).fadeIn()

    if @props.slideEffect
      $(@refs.main).slideDown()

  componentWillUnmount: ->
    $('body').removeClass @props.bodyClassName


  render: ->
    style = @props.style || {}
    classNames = [this.props.className]
    classNames.push 'main-flex' if this.props.flex

    if @props.fadeEffect or @props.slideEffect
      style.display = 'none'

    `<main style={ this.props.style } className={ classNames.join(' ') } ref='main'>
        { this.props.children }
    </main>`
