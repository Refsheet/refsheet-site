@CharacterColorSchemeModal = React.createClass
  propTypes:
    colorScheme: React.PropTypes.object.isRequired
    characterPath: React.PropTypes.string.isRequired


  _handleColorSchemeChange: (data, onSuccess, onError) ->
    c = @props.colorScheme
    c = { color_data: {} } unless c && c.color_data
    c.color_data[data.id] = data.value

    $.ajax
      url: @props.characterPath
      data: character: color_scheme_attributes: c
      type: 'PATCH'
      success: (data) =>
        $(document).trigger 'app:color_scheme:update', data
        onSuccess() if onSuccess
      error: (error) =>
        onError(error) if onError

  _handleColorSchemeClear: (key, onSuccess, onError) ->
    data = { id: key, value: null }
    @handleColorSchemeChange(data)

  _handleColorSchemeClose: (e) ->
    $('#color-scheme-form').modal('close')


  render: ->
    colorSchemeFields = []

    for key, name of {
      primary: 'Primary Color'
      accent1: 'Secondary Color'
      accent2: 'Accent Color'
      text: 'Main Text'
      'text-medium': 'Muted Text'
      'text-light': 'Subtle Text'
      background: 'Page Background'
      'card-background': 'Card Background'
    }
      if @props.colorScheme && @props.colorScheme.color_data
        value = @props.colorScheme.color_data[key]

      colorSchemeFields.push `<Attribute key={ key }
                                         id={ key }
                                         name={ name }
                                         value={ value }
                                         iconColor={ value || '#000000' }
                                         icon='palette'
                                         placeholder='Not Set' />`

    `<Modal id='color-scheme-form'>
        <h2>Page Color Scheme</h2>
        <p>Be sure to save each row individually. Click the trash bin to revert the color to Refsheet's default.</p>

        <AttributeTable valueType='color'
                        onAttributeUpdate={ this._handleColorSchemeChange }
                        onAttributeDelete={ this._handleColorSchemeClear }
                        freezeName hideNotesForm>
            { colorSchemeFields }
        </AttributeTable>

        <div className='actions margin-top--large'>
            <a className='btn' onClick={ this._handleColorSchemeClose }>Done</a>
        </div>
    </Modal>`
