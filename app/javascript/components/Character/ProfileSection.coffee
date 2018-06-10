import PropTypes from 'prop-types'
import ProfileColumn from './ProfileColumn'
import Section from 'Shared/Section'
import { Component } from 'react'
import c from 'classnames'

ProfileSection = ({id, title, columns, widgets, editable, className}) ->
  `<Section title={title} className={ c('margin-bottom--large', className) }>
    <div className='row margin-top--medium'>
      { renderSectionColumns(columns, widgets, editable) }
    </div>
  </Section>`

renderSectionColumns = (columns, widgets, editable) ->
  columns.map (width, id) ->
    columnWidgets = widgets.filter (w) -> w.column == id

    `<ProfileColumn key={id}
                    id={id}
                    width={width}
                    widgets={columnWidgets}
                    editable={editable} />`

ProfileSection.prototype.propTypes =
  columns: PropTypes.array.isRequired
  id: PropTypes.string.isRequired
  title: PropTypes.string
  onChange: PropTypes.func
  editable: PropTypes.bool
  className: PropTypes.string

export default ProfileSection
