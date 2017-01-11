@NewCharacterForm = React.createClass
  getInitialState: ->
    name: null
    errors: {}
    
  handleCreateCharacter: (e) ->
    $.ajax
      url: @props.newCharacterPath
      type: 'POST'
      data: character: name: @state.name
      success: (data) =>
        Materialize.toast 'Character created!', 3000, 'teal'
        @props.onCreate data

      error: (errors) =>
        console.log errors
        @setState errors: errors.responseJSON?.errors || {}

    e.preventDefault()

  handleInputChange: (k, v) ->
    o = {}
    o[k] = v
    @setState o

  componentDidMount: ->
    Materialize.initializeForms()
    
  render: ->
    `<form onSubmit={ this.handleCreateCharacter }>
        <Input id='name'
               label='New Character Name'
               onChange={ this.handleInputChange }
               autoFocus
               error={ this.state.errors.name }
               value={ this.state.name } />

        <a onClick={ this.props.onCancel } className='btn right grey darken-3'>
            <i className='material-icons'>cancel</i>
        </a>

        <button type='submit' className='btn'>Create Character</button>
    </form>`
