@CharacterColorSchemeModal = React.createClass
  propTypes:
    colorScheme: React.PropTypes.object.isRequired
    characterPath: React.PropTypes.string.isRequired


  getInitialState: ->
    color_data: @props.colorScheme.color_data


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

  _handleChange: (data) ->
    $(document).trigger 'app:color_scheme:update', data.color_scheme.color_data
    Materialize.toast 'Color scheme saved.', 3000, 'green'

  _handleUpdate: (data) ->
    $(document).trigger 'app:color_scheme:update', data


  render: ->
    colorSchemeFields = []

    for key, attr of {
      primary: ['Primary Color', '#80cbc4']
      accent1: ['Secondary Color', '#26a69a']
      accent2: ['Accent Color', '#ee6e73']
      text: ['Main Text', 'rgba(255,255,255,0.9)']
      'text-medium': ['Muted Text', 'rgba(255,255,255,0.5)']
      'text-light': ['Subtle Text', 'rgba(255,255,255,0.3)']
      background: ['Page Background', '#262626']
      'card-background': ['Card Background', '#212121']
    }
      name = attr[0]
      def = attr[1]

      if @props.colorScheme && @props.colorScheme.color_data
        value = @props.colorScheme.color_data[key]

      colorSchemeFields.push `<Column s={6}>
          <Input name={ key }
                 type='color'
                 label={ name }
                 default={ def }
                 value={ value } />
      </Column>`

    `<Modal id='color-scheme-form'
            title='Page Color Scheme'>

        <Form action={ this.props.characterPath }
              model={ this.state.color_data }
              modelName='character[color_scheme_attributes][color_data]'
              method='PUT'
              onUpdate={ this._handleUpdate }
              onChange={ this._handleChange }>

            <Row>
                <Column m={6}>
                    <Row>
                        { colorSchemeFields }
                    </Row>
                </Column>

                <Column m={6}>
                    <h1>Sample Text</h1>
                    <p>This is a sample, with <a href='#'>Links</a> and such.</p>

                    <h2>Lorem Ipsum</h2>
                    <p>It is funny how many people read filler text all the way through, isn't it?</p>
                </Column>
            </Row>

            <Row className='actions'>
                <Column>
                    <div className='right'>
                        <Submit />
                    </div>
                </Column>
            </Row>
        </Form>
    </Modal>`
