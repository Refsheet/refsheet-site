import { PropTypes } from 'prop-types'
import { RichText } from 'Shared'
import ProfileSection from './ProfileSection'
import c from 'classnames'

Profile = ({profileSections}) ->
  `<div id='profile'>
    { renderProfileSections(profileSections) }
  </div>`

groupProfileSections = (profileSections) ->
  groups = {}
  lastId = 'main'
  for section in profileSections
    lastId = section.id if section.title
    groups[lastId] ||= []
    groups[lastId].push section
  groups

renderProfileSections = (profileSections) ->
  groups = groupProfileSections(profileSections)
  render = []
  for id, sections of groups
    renderedSections = sections.map (section, i) ->
      classNames = c
        'margin-bottom--none': sections.length > 0
        'margin-top--none': i > 0

      `<ProfileSection key={section.id} {...section} className={ classNames } />`

    render.push `<div id={id} key={id} className='profile-scrollspy'>{renderedSections}</div>`
  render

Profile.propTypes =
  profileSections: PropTypes.arrayOf(
    PropTypes.shape(
      id: PropTypes.string.isRequired
      title: PropTypes.string
    )
  )

export default Profile
