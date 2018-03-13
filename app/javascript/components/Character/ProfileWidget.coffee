import PropTypes from 'prop-types'
import { camelize } from 'object-utils'
import widgets, { SerializerWidget } from './Widgets'

ProfileWidget = ({id, type, title, data, onChange}) ->
  Widget = widgets[type] || SerializerWidget

  if title
    header = \
      `<div className='card-header'>
        <h3 className='margin--none'>{ title || 'Untitled ' + type + ' Widget' }</h3>
      </div>`

  `<div className='card profile-widget'>
    { header }

    <Widget {...camelize(data)} onChange={onChange} />
  </div>`

ProfileWidget.propTypes =
  id: PropTypes.string.isRequired
  type: PropTypes.string.isRequired
  data: PropTypes.object.isRequired
  onChange: PropTypes.func

export default ProfileWidget
