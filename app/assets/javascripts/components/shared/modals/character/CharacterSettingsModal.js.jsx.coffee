@CharacterSettingsModal = React.createClass
  propTypes:
    character: React.PropTypes.object.isRequired


  _handleSettingsChange: (data, onSuccess, onError) ->
    o = {}
    o[data.id] = data.value

    $.ajax
      url: @props.character.path
      data: character: o
      type: 'PATCH'
      success: (data) =>
        @setState character: data
        $(document).trigger 'app:character:update', data
        onSuccess() if onSuccess
      error: (error) =>
        e = error.responseJSON.errors[data.id]
        onError(value: e) if onError

  _handleSettingsClose: (e) ->
    $('#character-settings-form').modal('close')


  render: ->
    `<Modal id='character-settings-form'>
        <h2>Character Settings</h2>
        <p>Be sure to save each row individually. Do note that your URL slug is not case-sensitive, but changing it
            might break existing links to your character.</p>

        <AttributeTable onAttributeUpdate={ this._handleSettingsChange }
                        freezeName hideNotesForm>
            <Attribute id='name' name='Character Name' value={ this.props.character.name } />
            <Attribute id='slug' name='URL Slug' value={ this.props.character.slug } />
            <Attribute id='shortcode' name='Shortcode' value={ this.props.character.shortcode } />
            <li>
                <div className='attribute-data'>
                    <div className='key'>Delete</div>
                    <div className='value'>
                        <a className='red-text btn-small modal-trigger' href='#delete-form'>Delete Character</a>
                    </div>
                </div>
                <div className='actions' />
            </li>
        </AttributeTable>

        <div className='actions margin-top--large'>
            <a className='btn' onClick={ this._handleSettingsClose }>Done</a>
        </div>
    </Modal>`
