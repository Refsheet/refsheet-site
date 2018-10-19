@Main = React.createClass
  propTypes:
    style: React.PropTypes.object
    className: React.PropTypes.string
    bodyClassName: React.PropTypes.string
    fadeEffect: React.PropTypes.bool
    slideEffect: React.PropTypes.bool
    id: React.PropTypes.string
    title: React.PropTypes.oneOfType([
      React.PropTypes.string
      React.PropTypes.array
    ])


  _updateTitle: (title) ->
    titles = []
    titles.push title
    titles.push 'Refsheet.net'
    document.title = [].concat.apply([], titles).join ' - '

  componentWillMount: ->
    if @props.title
      @_updateTitle @props.title

    $('body').addClass @props.bodyClassName

  componentWillReceiveProps: (newProps) ->
    if newProps.title
      @_updateTitle newProps.title

    if newProps.bodyClassName != @props.bodyClassName
      $('body').removeClass @props.bodyClassName
      $('body').addClass newProps.bodyClassName

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

    `<main style={ this.props.style } id={ this.props.id } className={ classNames.join(' ') } ref='main'>
        { this.props.children }
    </main>`
