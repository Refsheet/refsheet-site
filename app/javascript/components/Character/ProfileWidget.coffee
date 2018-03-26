import PropTypes from 'prop-types'
import { camelize } from 'object-utils'
import widgets, { SerializerWidget } from './Widgets'

ProfileWidget = ({id, type, title, data, onChange, editable}) ->
  Widget = widgets[type] || SerializerWidget

  if editable
    header = \
      `<div className='muted card-header'>
        <div className='right' style={{opacity: 0.3}}>
          <a href='#' className='margin-right--medium'><Icon className='muted' style={{fontSize: '1rem', color: 'rgba(255,255,255,0.1) !important'}}>delete</Icon></a>
          <a href='#'><Icon className='muted' style={{fontSize: '1rem', color: 'rgba(255,255,255,0.1) !important'}}>edit</Icon></a>
        </div>
        <div className='left' style={{opacity: 0.3}}>
          <a href='#' className='margin-right--medium'><Icon className='muted' style={{fontSize: '1rem', color: 'rgba(255,255,255,0.1) !important'}}>reorder</Icon></a>
          <a href='#'><Icon className='muted' style={{fontSize: '1rem', color: 'rgba(255,255,255,0.1) !important'}}>content_copy</Icon></a>
        </div>

        <div className='center'>
          { title || type }
        </div>
      </div>`

  else if title
    header = \
      `<div className='card-header'>
        { title }
      </div>`

  `<div className='card profile-widget margin--none'>
    { header }

    <Widget {...camelize(data)} onChange={onChange} />
  </div>`

ProfileWidget.propTypes =
  id: PropTypes.string.isRequired
  type: PropTypes.string.isRequired
  data: PropTypes.object.isRequired
  onChange: PropTypes.func
  editable: PropTypes.bool

export default ProfileWidget
