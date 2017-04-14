@CharacterSettingsModal = React.createClass
  propTypes:
    character: React.PropTypes.object.isRequired


  getInitialState: ->
    dirty: false


  _handleSettingsClose: (e) ->
    $('#character-settings-form').modal('close')

  _handleChange: (character) ->
    Materialize.toast 'Character saved!', 3000, 'green'

  _handleCancel: (e) ->
    @refs.form.reset()
    e.preventDefault()

  _handleDirty: (dirty) ->
    @setState dirty: dirty


  render: ->
    `<Modal id='character-settings-form'
            bottomSheet
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

            <Row noMargin>
                <Column m={6}>
                    <a className='red-text' href='#delete-form'>Delete Character</a>
                    <div className='muted'>This can not be undone!</div>
                </Column>
                <Column m={6}>
                    <a href='#transfer-form'>Transfer Character</a>
                    <div className='muted'>The recipient will have to accept.</div>
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
