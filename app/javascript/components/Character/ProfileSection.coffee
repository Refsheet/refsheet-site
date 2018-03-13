import PropTypes from 'prop-types'
import ProfileWidget from './ProfileWidget'

ProfileSection = ({columns, id}) ->
  sectionColumns = columns.map ({id, width, widget}) ->
    width ||= Math.floor 12 / columns.length

    `<div key={id} className={"col s12 m" + width}>
      <ProfileWidget {...widget} />
    </div>`

  `<div className='row'>
    { sectionColumns }
  </div>`

ProfileSection.propTypes =
  columns: PropTypes.array.isRequired
  id: PropTypes.string.isRequired
  onChange: PropTypes.func

export default ProfileSection
