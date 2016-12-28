@AttributeForm = React.createClass
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
      @setState errors: data
        
    e.preventDefault()

  handleChange: (e) ->
    o = {}
    o[e.target.name] = e.target.value
    @setState o

  componentWillReceiveProps: (newProps) ->
    state = []
    state.name = newProps.name if newProps.name?
    state.value = newProps.value if newProps.value?
    state.notes = newProps.notes if newProps.notes?
    @setState state
    
  componentWillUpdate: ->
    Materialize.updateTextFields()

  render: ->
    if @props.onCancel?
      cancel =
        `<a className='' onClick={ this.props.onCancel }>
            <i className='material-icons'>cancel</i>
        </a>`

    className = 'attribute-form'

    if @props.inactive
      className += ' inactive'

    `<li className={ className }>
        <div className='icon'>
            <i className='material-icons'>edit</i>
        </div>

        <div className='name'>
            <input type='text' name='name' placeholder='Name'
                   className={ this.state.errors.name ? 'invalid' : '' }
                   data-error={ this.state.errors.name }
                   onChange={ this.handleChange }
                   value={ this.state.name }
                   onFocus={ this.props.onFocus }
            />

            <label data-error={ this.state.errors.name } />
        </div>

        <div className='value'>
            <input type='text' name='value' placeholder='Value'
                   className={ this.state.errors.value ? 'invalid' : '' }
                   onChange={ this.handleChange }
                   value={ this.state.value }
                   onFocus={ this.props.onFocus }
            />

            <label data-error={ this.state.errors.value } />
        </div>

        <div className='notes'>
            <input type='text' name='notes' placeholder='Notes'
                   className={ this.state.errors.notes ? 'invalid' : '' }
                   onChange={ this.handleChange }
                   value={ this.state.notes }
                   onFocus={ this.props.onFocus }
            />

            <label data-error={ this.state.errors.notes } />
        </div>

        <div className='actions'>
            <a className='' onClick={ this.commit }>
                <i className='material-icons'>save</i>
            </a>

            { cancel }
        </div>
    </li>`
