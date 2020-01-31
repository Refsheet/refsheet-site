@AttributeForm = v1 -> React.createClass
  getInitialState: ->
    name: @props.name
    value: @props.value
    notes: @props.notes
    errors: {}
    
  commit: (e) ->
    @props.onCommit
      id:  @props.id
      name:  @state.name
      value: @state.value
      notes: @state.notes
    , =>
      if @props.onCancel?
        @props.onCancel()
      else
        @setState errors: {}
        @setState name: '', value: '', notes: '' unless @props.id?
    , (data) =>
      console.log data
      @setState errors: data
        
    e.preventDefault()

  handleChange: (key, value) ->
    o = {}
    o[key] = value
    @setState o

  colorPicker: (e) ->
    @setState value: e.target.value

  colorPickerClick: (e) ->
    $(e.target).children('input').click()

  componentWillReceiveProps: (newProps) ->
    state = []
    state.name = newProps.name if newProps.name?
    state.value = newProps.value if newProps.value?
    state.notes = newProps.notes if newProps.notes?
    @setState state

  componentWillUpdate: ->
    Materialize.updateTextFields() if Materialize.updateTextFields?

  componentDidMount: ->
    $('[name="value"]').focus()

  render: ->
    if @props.onCancel?
      cancel =
        `<a className='' onClick={ this.props.onCancel }>
            <i className='material-icons'>cancel</i>
        </a>`

    className = 'attribute-form'

    if Object.keys(@state.errors).length != 0
      saveClassName = 'red-text'

    else
      saveClassName = 'teal-text'

    if @props.inactive
      className += ' inactive'

    unless @props.hideIcon
      iconTag =
        `<div className='icon'>
            <i className='material-icons'>edit</i>
        </div>`

    if @props.freezeName
      nameTag =
        `<div className='key'>{ this.state.name }</div>`

    else
      nameTag =
        `<div className='key'>
            <Input type='text'
                   name='name'
                   placeholder='Name'
                   error={ this.state.errors.name }
                   onChange={ this.handleChange }
                   value={ this.state.name } />
        </div>`

    unless @props.hideNotes
      notesTag =
        `<div className='notes'>
            <Input type='text'
                   name='notes'
                   placeholder='Notes'
                   error={ this.state.errors.notes }
                   onChange={ this.handleChange }
                   value={ this.state.notes } />
        </div>`

    `<li className={ className } data-attribute-id={ this.props.id }>
        <form onSubmit={ this.commit }>
            { iconTag }

            <div className='attribute-data'>
                { nameTag }

                <div className='value'>
                    <Input type={ this.props.valueType || 'text' }
                           name='value'
                           onChange={ this.handleChange }
                           error={ this.state.errors.value }
                           value={ this.state.value } />
                </div>

                { notesTag }
            </div>

            <div className='actions'>
                <a className={ saveClassName } onClick={ this.commit } href='#'>
                    <i className='material-icons'>save</i>
                </a>

                { cancel }
            </div>
        </form>
    </li>`
