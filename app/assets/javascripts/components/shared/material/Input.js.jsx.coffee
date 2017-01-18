@Input = React.createClass
  handleChange: (e) ->
    @props.onChange e.target.id, e.target.value
    e.preventDefault()

  handleFileChange: (e) ->
    @props.onChange e.target.id, e.target.files[0]

  render: ->
    if @props.error?
      className = 'invalid'
      error = @props.error

      if error.length
        error = error[0]

    if @props.type == 'file'
      `<div className='file-field input-field'>
          <div className='btn'>
              <span>{ this.props.buttonText || 'Browse' }</span>
              <input type='file'
                     id={ this.props.id }
                     name={ this.props.id }
                     placeholder={ this.props.placeholder }
                     onChange={ this.handleFileChange }
                     autoFocus={ this.props.autoFocus }
                     className={ className } />
          </div>
          <div className='file-path-wrapper'>
              <input className='file-path validate' type='text' placeholder={ this.props.label } />
              <label htmlFor={ this.props.id } data-error={ error } />
          </div>
      </div>`

    else
      `<div className='input-field'>
          <input type={ this.props.type || 'text' }
                 id={ this.props.id }
                 name={ this.props.id }
                 placeholder={ this.props.placeholder }
                 value={ this.props.value || ''}
                 onChange={ this.handleChange }
                 autoFocus={ this.props.autoFocus }
                 className={ className } />

          <label htmlFor={ this.props.id } data-error={ error }>{ this.props.label }</label>
      </div>`
