@RichText = React.createClass
  render: ->
    `<div className={ 'rich-text ' + this.props.className } dangerouslySetInnerHTML={{ __html: this.props.content }} />`
