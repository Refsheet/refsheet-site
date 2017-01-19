@Input = React.createClass
  handleChange: (e) ->
    @props.onChange e.target.id, e.target.value
    e.preventDefault()

  render: ->
    if @props.error?
      className = 'invalid'
      error = @props.error

      if error.length
        error = error[0]

    if @props.type == 'textarea'
      inputField =
        `<textarea id={ this.props.id }
                   name={ this.props.name }
                   placeholder={ this.props.placeholder }
                   value={ this.props.value || '' }
                   onChange={ this.handleChange }
                   autoFocus={ this.props.autoFocus }
                   className={ className + ' materialize-textarea' } />`

    else
      inputField =
        `<input type={ this.props.type || 'text' }
                id={ this.props.id }
                name={ this.props.id }
                placeholder={ this.props.placeholder }
                value={ this.props.value || ''}
                onChange={ this.handleChange }
                autoFocus={ this.props.autoFocus }
                className={ className } />`

    `<div className='input-field'>
        { inputField }
        <label htmlFor={ this.props.id }>{ this.props.label }</label>
        { error && <div className='hint-text red-text'>{ error }</div> }
        { !error && this.props.hint && <div className='hint-text'>{ this.props.hint }</div> }
    </div>`
