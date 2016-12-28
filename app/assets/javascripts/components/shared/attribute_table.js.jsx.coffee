@AttributeTable = React.createClass
  render: ->
    children = React.Children.map @props.children, (child) =>
      React.cloneElement child,
        onChange: @props.onAttributeChange
        onDelete: @props.onAttributeDelete

    `<ul className='attribute-table'>
        { children }
    </ul>`
