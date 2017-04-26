@CharacterColorSchemeModal = React.createClass
  propTypes:
    colorScheme: React.PropTypes.object.isRequired
    characterPath: React.PropTypes.string.isRequired


  getInitialState: ->
    color_data: @props.colorScheme?.color_data || {}
    dirty: false


  _handleColorSchemeClose: (e) ->
    $('#color-scheme-form').modal('close')

  _handleLoad: (e, data) ->
    obj = JSON.parse data

    if typeof obj == "object"
      @setState color_data: obj
      @refs.form.setModel obj

  _handleChange: (data) ->
    @setState color_data: data.color_scheme.color_data, =>
      $(document).trigger 'app:color_scheme:update', data.color_scheme.color_data
      Materialize.toast 'Color scheme saved.', 3000, 'green'
      @_handleColorSchemeClose()

  _handleUpdate: (data) ->
    @setState color_data: data
    $(document).trigger 'app:color_scheme:update', data

  _handleDirty: (dirty) ->
    @setState dirty: dirty

  _handleCancel: ->
    @refs.form.reset()
    @_handleColorSchemeClose()


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

      colorSchemeFields.push `<Column s={6} m={4}>
          <Input key={ key }
                 name={ key }
                 type='color'
                 label={ name }
                 default={ def } />
      </Column>`

    `<Modal id='color-scheme-form'
            title='Page Color Scheme'>

        <Form action={ this.props.characterPath }
              ref='form'
              model={ this.state.color_data }
              modelName='character.color_scheme_attributes.color_data'
              method='PUT'
              onUpdate={ this._handleUpdate }
              onDirty={ this._handleDirty }
              onChange={ this._handleChange }>

            <Tabs>
                <Tab name='Advanced' id='advanced' active>
                    <Row>
                        { colorSchemeFields }
                    </Row>
                </Tab>
                <Tab name='Export' id='export'>
                    <p>
                        Copy and paste the following code to share this color scheme with other Profiles. If you have a
                        code, paste it here and we'll load it.
                    </p>
                    <Input onChange={ this._handleLoad }
                           type='textarea'
                           ref='code'
                           browserDefault
                           focusSelectAll
                           value={ JSON.stringify(this.state.color_data) } />
                </Tab>
            </Tabs>

            <div className='divider' />

            <Row className='margin-top--large' noMargin>
                <Column m={6}>
                    <h1>Sample Text</h1>
                    <p>This is a sample, with <a href='#'>Links</a> and such.</p>
                    <p>It is funny how many people read filler text all the way through, isn't it?</p>
                </Column>
                <Column m={6}>
                    <h2>Lorem Ipsum</h2>
                    <AttributeTable>
                        <Attribute name='Name' value='Color Test' />
                        <Attribute name='Personality' value='Very helpful!' />
                    </AttributeTable>
                </Column>
            </Row>

            <Row className='actions' hidden={ this.state.dirty }>
                <Column>
                    <div className='right'>
                        <a onClick={ this._handleColorSchemeClose } className='btn waves-effect waves-light'>Done</a>
                    </div>
                </Column>
            </Row>

            <Row className='actions' hidden={ !this.state.dirty }>
                <Column>
                    <a onClick={ this._handleCancel } className='btn btn-secondary waves-effect waves-light'>Cancel</a>

                    <div className='right'>
                        <Submit>Save Changes</Submit>
                    </div>
                </Column>
            </Row>
        </Form>
    </Modal>`
