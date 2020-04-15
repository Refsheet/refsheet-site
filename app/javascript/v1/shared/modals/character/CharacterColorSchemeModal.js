import React from 'react'
import createReactClass from 'create-react-class'
import PropTypes from 'prop-types'
import Modal from 'v1/shared/Modal'
import Form from 'v1/shared/forms/Form'
import Row from 'v1/shared/material/Row'
import Column from 'v1/shared/material/Column'
import Input from 'v1/shared/forms/Input'
import Submit from 'v1/shared/forms/Submit'
import AttributeTable from 'v1/shared/attributes/attribute_table'
import Attribute from 'v1/shared/attributes/attribute'
import Tabs from 'v1/shared/tabs/Tabs'
import Tab from 'v1/shared/tabs/Tab'

import * as Materialize from 'materialize-css'
import ColorUtils from '../../../../utils/ColorUtils'

// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
let CharacterColorSchemeModal
export default CharacterColorSchemeModal = createReactClass({
  propTypes: {
    characterPath: PropTypes.string.isRequired,
    colorScheme: PropTypes.object,
  },

  defaultColors: {
    primary: ['Primary Color', '#80cbc4'],
    accent1: ['Secondary Color', '#26a69a'],
    accent2: ['Accent Color', '#ee6e73'],
    text: ['Main Text', 'rgba(255,255,255,0.9)'],
    textMedium: ['Muted Text', 'rgba(255,255,255,0.5)'],
    textLight: ['Subtle Text', 'rgba(255,255,255,0.3)'],
    background: ['Page Background', '#262626'],
    cardBackground: ['Card Background', '#212121'],
    cardHeaderBackground: ['Card Header', 'rgba(0,0,0,0.2)'],
    border: ['Border Colors', 'rgba(255,255,255,0.1)'],
    imageBackground: ['Image Background', '#000000'],
  },

  getInitialState() {
    return {
      color_data: ColorUtils.rejectV1(
        (this.props.colorScheme != null
          ? this.props.colorScheme.color_data
          : undefined) || {}
      ),
      dirty: false,
    }
  },

  _handleColorSchemeClose(e) {
    return Materialize.Modal.getInstance(
      document.getElementById('color-scheme-form')
    ).close()
  },

  _handleLoad(e, data) {
    const obj = JSON.parse(data)

    if (typeof obj === 'object') {
      const data = ColorUtils.rejectV1(ColorUtils.convertV1(obj))
      this.setState({ color_data: data })
      return this.refs.form.setModel(obj)
    }
  },

  _handleChange(data) {
    return this.setState({ color_data: data.color_scheme.color_data }, () => {
      this.props.onChange &&
        this.props.onChange(ColorUtils.rejectV1(data.color_scheme.color_data))

      Materialize.toast({
        html: 'Color scheme saved.',
        displayLength: 3000,
        classes: 'green',
      })
      return this._handleColorSchemeClose()
    })
  },

  _handleUpdate(data) {
    this.setState({ color_data: data })
    this.props.onChange && this.props.onChange(ColorUtils.rejectV1(data))
  },

  _handleDirty(dirty) {
    return this.setState({ dirty })
  },

  _handleCancel() {
    this.refs.form.reset()
    return this._handleColorSchemeClose()
  },

  render() {
    const colorSchemeFields = []

    for (let key in this.defaultColors) {
      const attr = this.defaultColors[key]
      const name = attr[0]
      const def = attr[1]
      let value

      if (this.props.colorScheme && this.props.colorScheme.color_data) {
        value = this.props.colorScheme.color_data[key]
      }

      colorSchemeFields.push(
        <Column key={key} s={6} m={4}>
          <Input
            name={key}
            type="color"
            errorPath="color_scheme"
            label={name}
            default={def}
            value={value}
          />
        </Column>
      )
    }

    return (
      <Modal id="color-scheme-form" title="Page Color Scheme">
        <Form
          action={this.props.characterPath}
          ref="form"
          model={this.state.color_data}
          modelName="character.color_scheme_attributes.color_data"
          method="PUT"
          onUpdate={this._handleUpdate}
          onDirty={this._handleDirty}
          onChange={this._handleChange}
        >
          <Tabs>
            <Tab name="Advanced" id="advanced" active>
              <Row>{colorSchemeFields}</Row>
            </Tab>
            <Tab name="Export" id="export">
              <p>
                Copy and paste the following code to share this color scheme
                with other Profiles. If you have a code, paste it here and we'll
                load it.
              </p>
              <Input
                onChange={this._handleLoad}
                type="textarea"
                ref="code"
                browserDefault
                focusSelectAll
                value={JSON.stringify(this.state.color_data)}
              />
            </Tab>
          </Tabs>

          <div className="divider" />

          <Row className="margin-top--large" noMargin>
            <Column m={6}>
              <h1>Sample Text</h1>
              <p>
                This is a sample, with <a href="#">Links</a> and such.
              </p>
              <p>
                It is funny how many people read filler text all the way
                through, isn't it?
              </p>
            </Column>
            <Column m={6}>
              <h2>Lorem Ipsum</h2>
              <AttributeTable>
                <Attribute name="Name" value="Color Test" />
                <Attribute name="Personality" value="Very helpful!" />
              </AttributeTable>
            </Column>
          </Row>

          <Row className="actions" hidden={this.state.dirty}>
            <Column>
              <div className="right">
                <a
                  onClick={this._handleColorSchemeClose}
                  className="btn waves-effect waves-light"
                >
                  Done
                </a>
              </div>
            </Column>
          </Row>

          <Row className="actions" hidden={!this.state.dirty}>
            <Column>
              <a
                onClick={this._handleCancel}
                className="btn btn-secondary waves-effect waves-light"
              >
                Cancel
              </a>

              <div className="right">
                <Submit>Save Changes</Submit>
              </div>
            </Column>
          </Row>
        </Form>
      </Modal>
    )
  },
})
