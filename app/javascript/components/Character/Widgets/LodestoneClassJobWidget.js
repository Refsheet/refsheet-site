import React, { Component } from 'react'
import PropTypes from 'prop-types'
import Attribute from '../../../v1/shared/attributes/attribute'
import AttributeTable from 'v1/shared/attributes/attribute_table'
import StringUtils from '../../../utils/StringUtils'
import * as ObjectUtils from 'utils/ObjectUtils'

class LodestoneClassJobWidget extends Component {
  render() {
    const {
      character: { lodestone_character },
    } = this.props

    const flat = ObjectUtils.flatten(
      ObjectUtils.deepRemoveKeys(lodestone_character, '__typename')
    )

    return (
      <div className={'card-content'}>
        <AttributeTable>
          {Object.keys(flat).map(k => (
            <Attribute key={k} name={StringUtils.humanize(k)} value={flat[k]} />
          ))}
        </AttributeTable>
      </div>
    )
  }
}

LodestoneClassJobWidget.propTypes = {
  character: PropTypes.shape({
    lodestone_character: PropTypes.object,
  }),
}

export default LodestoneClassJobWidget
