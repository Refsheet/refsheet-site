/* do-not-disable-eslint
    no-undef,
    react/jsx-no-undef,
    react/no-deprecated,
    react/react-in-jsx-scope,
*/
import React from 'react'
import createReactClass from 'create-react-class'
import PropTypes from 'prop-types'
import Attribute from '../../shared/attributes/attribute'
import AttributeTable from 'v1/shared/attributes/attribute_table'
import Model from '../../utils/Model'
// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
let Attributes
export default Attributes = createReactClass({
  propTypes: {
    characterPath: PropTypes.string.isRequired,
    attributes: PropTypes.array.isRequired,
    onChange: PropTypes.func.isRequired,
    editable: PropTypes.bool,
  },

  _handleAttributeUpdate(attr, complete, error) {
    return Model.post(
      this.props.characterPath + '/attributes',
      { custom_attributes: attr },
      data => {
        this.props.onChange(data)
        if (complete) {
          return complete()
        }
      },
      error
    )
  },

  _handleAttributeDelete(id) {
    return Model.delete(
      this.props.characterPath + '/attributes/' + id,
      data => {
        return this.props.onChange(data)
      }
    )
  },

  render() {
    let deleteCallback, updateCallback
    if (this.props.editable) {
      updateCallback = this._handleAttributeUpdate
      deleteCallback = this._handleAttributeDelete
    } else {
      if (!this.props.attributes || this.props.attributes.length <= 0) {
        return null
      }
    }

    const attributes = this.props.attributes
      .filter(attr => !!attr)
      .map(attr => <Attribute key={attr.id} {...attr} />)

    return (
      <AttributeTable
        onAttributeUpdate={updateCallback}
        onAttributeDelete={deleteCallback}
        onAttributeCreate={updateCallback}
        defaultValue="Unspecified"
        className="char-custom-attrs"
        editable={this.props.editable}
        hideNotesForm
        hideIcon
        sortable
      >
        {attributes}
      </AttributeTable>
    )
  },
})
