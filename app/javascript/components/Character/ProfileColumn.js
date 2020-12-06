/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import React from 'react'
import PropTypes from 'prop-types'
import ProfileWidget from './ProfileWidget'
import { camelize } from 'utils/ObjectUtils'

const ProfileColumn = function ({
  id,
  widgets,
  width,
  editable,
  onNewClick,
  onWidgetDelete,
  last,
  character,
}) {
  const widgetCards = widgets
    .sort((a, b) => (a.row_order || 0) - (b.row_order || 0))
    .map((widget, i) => (
      <ProfileWidget
        {...camelize(widget)}
        key={widget.id}
        editable={editable}
        onDelete={onWidgetDelete}
        firstColumn={id === 0}
        lastColumn={last}
        character={character}
        first={i === 0}
        last={i >= widgets.length - 1}
      />
    ))

  return (
    <div className={`col s12 m${width}`}>
      {widgetCards}

      {editable && (
        <a
          key={'new'}
          className="btn btn-flat block margin-top--medium"
          style={{ border: '1px dashed #ffffff33' }}
          onClick={onNewClick}
        >
          Add Widget
        </a>
      )}
    </div>
  )
}

ProfileColumn.propTypes = {
  id: PropTypes.number.isRequired,
  widgets: PropTypes.arrayOf(PropTypes.object).isRequired,
  width: PropTypes.number.isRequired,
  onChange: PropTypes.func,
  editable: PropTypes.bool,
  onNewClick: PropTypes.func,
  onWidgetDelete: PropTypes.func,
  last: PropTypes.bool,
}

export default ProfileColumn
