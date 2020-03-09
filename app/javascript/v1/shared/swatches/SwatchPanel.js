/* eslint-disable
    no-undef,
    react/jsx-no-undef,
    react/no-deprecated,
    react/react-in-jsx-scope,
*/
// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
this.SwatchPanel = React.createClass({
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
        const d = error.responseJSON.errors
        if (onFail != null) {
          return onFail({ value: d.color, name: d.name, notes: d.notes })
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
        const d = error.responseJSON.errors
        if (onFail != null) {
          return onFail({ value: d.color, name: d.name, notes: d.notes })
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
    return $('#swatch-menu').collapsible()
  },

  componentDidUpdate() {
    return $('#swatch-menu').collapsible()
  },

  render() {
    let activeClass, createCallback, deleteCallback, updateCallback
    const swatches = this.state.swatches.map(swatch => (
      <div
        className="swatch tooltipped"
        key={swatch.id}
        style={{ backgroundColor: swatch.color }}
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
      <ul id="swatch-menu" className="collapsible character-swatches">
        <li>
          <div className={'collapsible-header swatch-container ' + activeClass}>
            <div className="swatch-row">
              {swatches}
              <div
                className="swatch tooltipped"
                data-tooltip="More Details"
                data-position="top"
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
