@RichText = React.createClass
  getInitialState: ->
    edit: false
    markup: @props.markup
    error: null

  handleEditStart: (e) ->
    if @props.onChange?
      @setState edit: true
      Materialize.initializeForms()

  handleEditStop: (e) ->
    @setState edit: false, markup: @props.markup

  handleMarkupChange: (e) ->
    @setState markup: e.target.value

  handleSubmit: (e) ->
    @props.onChange @state.markup, =>
      @setState edit: false,
    (error) =>
      @setState error: error
      console.log error
    e.preventDefault()

  componentDidUpdate: ->
    $('.rich-text textarea').trigger 'autoresize'

  render: ->
    if @state.edit
      `<div className={ 'rich-text editing ' + this.props.className }>
          <textarea className='materialize-textarea' onChange={ this.handleMarkupChange } value={ this.state.markup } autoFocus />
          <button type='submit' className='btn' onClick={ this.handleSubmit }>Save Changes</button>
          <a className='right btn grey darken-3' onClick={ this.handleEditStop }>
              <i className='material-icons'>cancel</i>
          </a>
      </div>`

    else if @state.markup != null && @state.markup != '' && @state.markup != undefined
      `<div className={ 'rich-text ' + this.props.className } onClick={ this.handleEditStart }>
          <a className='edit-button right' onClick={ this.handleEditStart }>
              <i className='material-icons'>edit</i>
          </a>

          <div dangerouslySetInnerHTML={{ __html: this.props.content }} />
      </div>`

    else
      if @props.onChange?
        placeholderText = 'Click to set text...'
      else
        placeholderText = @props.placeholder || 'No content.'

      `<div className={ 'rich-text empty ' + this.props.className } onClick={ this.handleEditStart }>
          <a className='edit-button right' onClick={ this.handleEditStart }>
              <i className='material-icons'>edit</i>
          </a>

          <div>{ placeholderText }</div>
      </div>`
