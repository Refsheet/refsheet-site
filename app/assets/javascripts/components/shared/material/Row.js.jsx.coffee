@Row = React.createClass
  propTypes:
    hidden: React.PropTypes.bool
    oneColumn: React.PropTypes.bool


  componentWillReceiveProps: (newProps) ->
    if newProps.hidden != @props.hidden
      if newProps.hidden
        $(@refs.row).hide(0).addClass 'hidden'
      else
        $(@refs.row).fadeIn(300).removeClass 'hidden'


  render: ->
    className = @props.className || ''
    className += ' no-margin' if @props.noMargin
    className += ' hidden' if @props.hidden
    className += ' no-gutter' if @props.noGutter

    if this.props.oneColumn
      children =
        `<Column>{ this.props.children }</Column>`
    else
      children = this.props.children

    `<div ref='row' className={ 'row ' + className }>
        { children }
    </div>`
