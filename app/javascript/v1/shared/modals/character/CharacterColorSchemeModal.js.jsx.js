/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
this.CharacterColorSchemeModal = React.createClass({
  propTypes: {
    characterPath: React.PropTypes.string.isRequired,
    colorScheme: React.PropTypes.object
},


  getInitialState() {
    return {
        color_data: (this.props.colorScheme != null ? this.props.colorScheme.color_data : undefined) || {},
        dirty: false
    };
},


  _handleColorSchemeClose(e) {
    return M.Modal.getInstance(document.getElementById('color-scheme-form')).close();
},

  _handleLoad(e, data) {
    const obj = JSON.parse(data);

    if (typeof obj === "object") {
      this.setState({color_data: obj});
      return this.refs.form.setModel(obj);
  }
},

  _handleChange(data) {
    return this.setState({color_data: data.color_scheme.color_data}, () => {
      $(document).trigger('app:color_scheme:update', data.color_scheme.color_data);
      Materialize.toast({ html: 'Color scheme saved.', displayLength: 3000, classes: 'green' });
      return this._handleColorSchemeClose();
    });
},

  _handleUpdate(data) {
    this.setState({color_data: data});
    return $(document).trigger('app:color_scheme:update', data);
},

  _handleDirty(dirty) {
    return this.setState({dirty});
},

  _handleCancel() {
    this.refs.form.reset();
    return this._handleColorSchemeClose();
},


  render() {
    const colorSchemeFields = [];

    const object = {
      primary: ['Primary Color', '#80cbc4'],
      accent1: ['Secondary Color', '#26a69a'],
      accent2: ['Accent Color', '#ee6e73'],
      text: ['Main Text', 'rgba(255,255,255,0.9)'],
      'text-medium': ['Muted Text', 'rgba(255,255,255,0.5)'],
      'text-light': ['Subtle Text', 'rgba(255,255,255,0.3)'],
      background: ['Page Background', '#262626'],
      'card-background': ['Card Background', '#212121'],
      'image-background': ['Image Background', '#000000']
    };
    for (let key in object) {
        const attr = object[key];
      const name = attr[0];
      const def = attr[1];

      if (this.props.colorScheme && this.props.colorScheme.color_data) {
        const value = this.props.colorScheme.color_data[key];
      }

      colorSchemeFields.push(
        <Column key={key} s={6} m={4}>
            <Input name={ key }
                   type='color'
                   errorPath='color_scheme'
                   label={ name }
                   default={ def } />
        </Column>
      );
    }

    return <Modal id='color-scheme-form'
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
    </Modal>;
}
});
