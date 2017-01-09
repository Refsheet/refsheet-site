@RichText = React.createClass
  getInitialState: ->
    edit: false
    markup: @props.markup

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
      @setState edit: false
    e.preventDefault()

  componentDidUpdate: ->
    $('.rich-text textarea').trigger 'autoresize'

  render: ->
    console.log @state.markup

    if @state.edit
      `<div className={ 'rich-text editing ' + this.props.className }>
          <textarea className='materialize-textarea' onChange={ this.handleMarkupChange } value={ this.state.markup } autoFocus />
          <button type='submit' className='btn' onClick={ this.handleSubmit }>Save Changes</button>
          <a className='btn grey darken-3 right' onClick={ this.handleEditStop }>Cancel</a>
      </div>`

    else if @state.markup != null && @state.markup != ''
      `<div className={ 'rich-text ' + this.props.className } onClick={ this.handleEditStart } dangerouslySetInnerHTML={{ __html: this.props.content }} />`

    else
      if @props.onChange?
        placeholderText = 'Click to set text...'
      else
        placeholderText = @props.placeholder || 'No content.'

      `<div className={ 'rich-text empty ' + this.props.className } onClick={ this.handleEditStart }>{ placeholderText }</div>`
