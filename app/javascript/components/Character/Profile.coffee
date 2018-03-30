import { PropTypes } from 'prop-types'
import { RichText } from 'Shared'
import ProfileSection from './ProfileSection'

Profile = ({profileSections}) ->
  `<div id='profile' className='profile-scrollspy'>
    { renderProfileSections(profileSections) }
  </div>`

renderProfileSections = (profileSections) ->
  profileSections.map (section, i) ->
    next = profileSections[i+1]
    push = next && !next.title

    classNames = []
    classNames.push 'margin-bottom--none' if push
    classNames.push 'margin-top--none' unless section.title

    `<ProfileSection key={section.id} {...section} className={ classNames.join(' ') } />`

Profile.propTypes =
  profileSections: PropTypes.arrayOf(
    PropTypes.object
  )

export default Profile
