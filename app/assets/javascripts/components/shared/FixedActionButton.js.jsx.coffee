@FixedActionButton = React.createClass
  componentDidMount: (e) ->
    $('.fixed-action-btn').floatingActionButton()

  render: ->
    children = React.Children.map @props.children, (child) =>
      `<li>{ React.cloneElement(child) }</li>`
      
    className = 'fixed-action-btn'
    className += ' click-to-toggle' if @props.clickToToggle

    `<div className={ className }>
        <ActionButton large={ true } {...this.props} />
        <ul>
            { children }
        </ul>
    </div>`
