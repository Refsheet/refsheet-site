@CharacterSettingsModal = React.createClass
  propTypes:
    character: React.PropTypes.object.isRequired


  getInitialState: ->
    dirty: false


  _handleSettingsClose: (e) ->
    M.Modal.getInstance(document.getElementById('character-settings-form')).close()

  _handleChange: (character) ->
    if character.link != @props.character.link
      window.history.replaceState {}, '', character.link

    $(document).trigger 'app:character:update', character

    @_handleSettingsClose()
    Materialize.toast 'Character saved!', 3000, 'green'

  _handleCancel: (e) ->
    @refs.form.reset()
    @_handleSettingsClose()
    e.preventDefault()

  _handleDirty: (dirty) ->
    @setState dirty: dirty


  render: ->
    `<Modal id='character-settings-form'
            title='Character Settings'
    >
        <Form action={ this.props.character.path }
              method='PUT'
              modelName='character'
              model={ this.props.character }
              onChange={ this._handleChange }
              onDirty={ this._handleDirty }
              ref="form"
        >
            <Row noMargin>
                <Column m={6}>
                    <Input name='name' label='Name' autoFocus />
                </Column>
                <Column s={6} m={3}>
                    <Input name='nsfw' type='checkbox' label='NSFW' />
                </Column>
                <Column s={6} m={3}>
                    <Input name='hidden' type='checkbox' label='Hidden' />
                </Column>
            </Row>

            <Row>
                <Column m={6}>
                    <Input name='slug' label={ 'refsheet.net/' + this.props.character.user_id + '/' } />
                </Column>
                <Column m={6}>
                    <Input name='shortcode' label='ref.st/' />
                </Column>
            </Row>

            <Row noMargin hidden={ this.props.character.pending_transfer }>
                <Column m={6}>
                    <a className='red-text modal-trigger' href='#delete-form'>Delete Character</a>
                    <div className='muted'>This can not be undone!</div>
                </Column>
                <Column m={6}>
                    <a href='#character-transfer-modal' className='modal-trigger'>Transfer Character</a>
                    <div className='muted'>The recipient will have to accept.</div>
                </Column>
            </Row>

            <Row noMargin hidden={ !this.props.character.pending_transfer }>
                <Column>
                    <p>Transfer Pending</p>
                    <div className='muted'>You cannot delete or initiate a new transfer until the old one is finished.</div>
                </Column>
            </Row>

            <Row hidden={ !this.state.dirty } className='actions'>
                <Column>
                    <a className='btn btn-secondary' onClick={ this._handleCancel }>Cancel</a>
                    <div className='right'>
                        <Submit>Save</Submit>
                    </div>
                </Column>
            </Row>
        </Form>

        <Row hidden={ this.state.dirty } className='actions'>
            <Column>
                <a className='btn right' onClick={ this._handleSettingsClose }>Done</a>
            </Column>
        </Row>
    </Modal>`
