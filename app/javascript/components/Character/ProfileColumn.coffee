import PropTypes from 'prop-types'
import ProfileWidget from './ProfileWidget'

ProfileColumn = ({id, widgets, width, onChange, editable}) ->
  widgetCards = widgets.map (widget) ->
    `<ProfileWidget {...widget} key={widget.id} editable={editable} />`

  `<div className={"col s12 m" + width}>
    { widgetCards }

    { editable &&
      <a className='btn btn-flat block marin-top--large' style={{border: '1px dashed #ffffff33'}}>
        Add Widget
      </a> }
  </div>`

ProfileColumn.propTypes =
  id: PropTypes.string.isRequired
  widgets: PropTypes.arrayOf(PropTypes.object).isRequired
  width: PropTypes.number.isRequired
  onChange: PropTypes.func
  editable: PropTypes.bool

export default ProfileColumn
