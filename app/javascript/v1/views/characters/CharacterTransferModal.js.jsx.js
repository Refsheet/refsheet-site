@CharacterTransferModal = React.createClass
  propTypes:
    character: React.PropTypes.object.isRequired


  getInitialState: ->
    dirty: false
    model:
      transfer_to_user: null


  _handleModalClose: (e) ->
    M.Modal.getInstance(document.getElementById('character-transfer-modal')).close()

  _handleChange: (character) ->
    @setState model: transfer_to_user: null
    $(document).trigger 'app:character:update', character

    @_handleModalClose()
    Materialize.toast({ html: 'Character transfer initiated.', displayLength: 3000, classes: 'green' })

  _handleCancel: (e) ->
    @refs.form.reset()
    @_handleModalClose()
    e.preventDefault()

  _handleDirty: (dirty) ->
    @setState dirty: dirty


  render: ->
    `<Modal id='character-transfer-modal'
            title='Character Transfer'
    >
        <Form action={ this.props.character.path }
              method='PUT'
              modelName='character'
              model={ this.state.model }
              onChange={ this._handleChange }
              onDirty={ this._handleDirty }
              ref="form"
        >
            <p>
                If you wish to transfer a character, and <strong>all</strong> the art assets and history attached,
                enter the destination username or email below.
            </p>
            <p>
                If the user does not have an account, they will be sent an email prompting them to create one
                before accepting this transfer.
            </p>
            <p>
                This character transfer, if accepted, will be recorded in the character's history. You will not
                be able to recall this character. All rights to this character's file will be reassigned.
            </p>

            <Row noMargin>
                <Column>
                    <Input name='transfer_to_user' label='Destination Email or Username' autoFocus />
                </Column>
            </Row>

            <Row hidden={ !this.state.dirty } className='actions'>
                <Column>
                    <a className='btn btn-secondary' onClick={ this._handleCancel }>Cancel</a>
                    <div className='right'>
                        <Submit>Send Transfer</Submit>
                    </div>
                </Column>
            </Row>
        </Form>

        <Row hidden={ this.state.dirty } className='actions'>
            <Column>
                <a className='btn right' onClick={ this._handleModalClose }>Back</a>
            </Column>
        </Row>
    </Modal>`
