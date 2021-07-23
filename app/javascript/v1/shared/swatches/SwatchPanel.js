import React from 'react'
import createReactClass from 'create-react-class'
import PropTypes from 'prop-types'
import Attribute from 'v1/shared/attributes/attribute'
import AttributeTable from 'v1/shared/attributes/attribute_table'

import $ from 'jquery'
import * as Materialize from 'materialize-css'
import Flash from '../../../utils/Flash'

// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
let SwatchPanel
export default SwatchPanel = createReactClass({
  tooltipped: [],
  collapsible: undefined,

  getInitialState() {
    return { swatches: this.props.swatches }
  },

  swatchParams(data) {
    if (data.rowOrderPosition != null) {
      return {
        swatch: {
          row_order_position: data.rowOrderPosition,
        },
      }
    } else {
      return {
        swatch: {
          color: data.value || '',
          name: data.name || '',
          notes: data.notes || '',
        },
      }
    }
  },

  editSwatch(data, onSuccess, onFail) {
    return $.ajax({
      url: '/swatches/' + data.id,
      data: this.swatchParams(data),
      type: 'PATCH',
      success: _data => {
        this.setState({ swatches: _data })
        if (onSuccess != null) {
          return onSuccess(_data)
        }
      },
      error(error) {
        if (error.responseJSON) {
          const d = error.responseJSON.errors
          if (onFail != null) {
            return onFail({ value: d.color, name: d.name, notes: d.notes })
          }
        } else {
          Flash.error('An unknown error occurred saving this value.')
          console.warn(error)
          onFail({})
        }
      },
    })
  },

  newSwatch(data, onSuccess, onFail) {
    return $.ajax({
      url: this.props.swatchesPath,
      data: this.swatchParams(data),
      type: 'POST',
      success: _data => {
        this.setState({ swatches: _data })
        if (onSuccess != null) {
          return onSuccess(_data)
        }
      },
      error(error) {
        if (error.responseJSON) {
          const d = error.responseJSON.errors
          if (onFail != null) {
            return onFail({ value: d.color, name: d.name, notes: d.notes })
          }
        } else {
          Flash.error('An unknown error occurred saving this value.')
          console.warn(error)
          onFail({})
        }
      },
    })
  },

  removeSwatch(key) {
    return $.ajax({
      url: '/swatches/' + key,
      type: 'DELETE',
      success: _data => {
        return this.setState({ swatches: _data })
      },
    })
  },

  componentDidMount() {
    Materialize.Collapsible.init(this.collapsible)
    this.tooltipped.map(tooltip => {
      if (!tooltip) return
      Materialize.Tooltip.init(tooltip, {
        html: tooltip.dataset.tooltip,
        position: tooltip.dataset.position,
      })
    })
  },

  componentDidUpdate() {
    Materialize.Collapsible.init(this.collapsible)
    this.tooltipped.map(tooltip => {
      if (!tooltip) return
      Materialize.Tooltip.init(tooltip, {
        html: tooltip.dataset.tooltip,
        position: tooltip.dataset.position,
      })
    })
  },

  render() {
    let activeClass, createCallback, deleteCallback, updateCallback
    const swatches = this.state.swatches.map(swatch => (
      <div
        className="swatch tooltipped"
        key={swatch.id}
        style={{ backgroundColor: swatch.color }}
        ref={r => this.tooltipped.push(r)}
        data-tooltip={swatch.name + ' - ' + swatch.color}
        data-position="top"
      />
    ))

    const swatchDetails = this.state.swatches.map(swatch => (
      <Attribute
        key={swatch.id}
        value={swatch.color}
        iconColor={swatch.color}
        icon="palette"
        {...swatch}
      />
    ))

    if (this.props.swatchesPath != null && this.props.edit) {
      updateCallback = this.editSwatch
      createCallback = this.newSwatch
      deleteCallback = this.removeSwatch
    }

    if (this.props.expand) {
      activeClass = 'active'
    }

    return (
      <ul
        id="swatch-menu"
        className="collapsible character-swatches"
        ref={r => (this.collapsible = r)}
      >
        <li>
          <div className={'collapsible-header swatch-container ' + activeClass}>
            <div className="swatch-row">
              {swatches}
              <div
                className="swatch tooltipped"
                data-tooltip="More Details"
                data-position="top"
                data-testid={'swatch-panel-open'}
                ref={r => this.tooltipped.push(r)}
              >
                <i className="material-icons">palette</i>
              </div>
            </div>
          </div>
          <div className="collapsible-body">
            <AttributeTable
              onAttributeUpdate={updateCallback}
              onAttributeCreate={createCallback}
              onAttributeDelete={deleteCallback}
              sortable={true}
              valueType="color"
            >
              {swatchDetails}
            </AttributeTable>
          </div>
        </li>
      </ul>
    )
  },
})
