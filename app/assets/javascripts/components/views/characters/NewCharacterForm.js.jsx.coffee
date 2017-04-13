@NewCharacterForm = React.createClass
  propTypes:
    newCharacterPath: React.PropTypes.string.isRequired

  getInitialState: ->
    character:
      name: null
      species: null


  _handleCreate: (character) ->
    @props.onCreate data
    ReactGA.event
      category: 'Character'
      action: 'Created Character'

    
  render: ->
    `<Form action={ this.props.newCharacterPath }
           method='POST'
           modelName='character'
           model={ this.state.character }
           onError={ this._handleError }
           onChange={ this._handleCreate }>

        <Input name='name'
               label='Name'
               autoFocus />

        <Input name='species'
               label='Species' />

        <div className='actions margin-top--large'>
            <a onClick={ this.props.onCancel } className='btn right grey darken-3'>
                <i className='material-icons'>cancel</i>
            </a>

            <Submit>Create Character</Submit>
        </div>
    </Form>`
