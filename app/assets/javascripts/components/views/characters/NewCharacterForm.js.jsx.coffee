@NewCharacterForm = React.createClass
  contextTypes:
    currentUser: React.PropTypes.object.isRequired

  propTypes:
    newCharacterPath: React.PropTypes.string.isRequired
    className: React.PropTypes.string


  getInitialState: ->
    character:
      name: null
      species: null
      slug: null
      shortcode: null


  _handleCreate: (character) ->
    @props.onCreate character
    ReactGA.event
      category: 'Character'
      action: 'Created Character'

    
  render: ->
    `<Form action={ this.props.newCharacterPath }
           method='POST'
           className={ this.props.className }
           modelName='character'
           model={ this.state.character }
           onError={ this._handleError }
           onChange={ this._handleCreate }>

        <Row>
            <Column m={6}>
                <Input name='name' label='Name' autoFocus />
            </Column>
            <Column m={6}>
                <Input name='species' label='Species' />
            </Column>
        </Row>

        <h3>URL Options</h3>
        <p className='muted'>Leave these blank for auto-generated values.</p>

        <Row>
            <Column m={6}>
                <Input name='slug' label={ 'refsheet.net/' + this.context.currentUser.username + '/' } />
            </Column>
            <Column m={6}>
                <Input name='shortcode' label='ref.st/' />
            </Column>
        </Row>

        <div className='actions margin-top--large'>
            <a onClick={ this.props.onCancel } className='btn right grey darken-3'>
                <i className='material-icons'>cancel</i>
            </a>

            <Submit>Create Character</Submit>
        </div>
    </Form>`
