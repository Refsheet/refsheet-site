import { PropTypes } from 'prop-types'
import { RichText } from 'Shared'
import ProfileSection from './ProfileSection'

Profile = ({character, onChange}) ->
  profileSections = character.profile_sections.map (section) ->
    `<ProfileSection key={section.id} {...section} onChange={onChange} />`

  `<section className='character-profile'>
    <div className='container'>
      <div className='row no-margin margin-bottom--large' style={{borderBottom: '1px solid rgba(255,255,255,0.3)'}}>
        <div className='col s12 m4'>
          <h2 className='margin--none'>{ "About " + character.name }</h2>
        </div>
        <div className='col s12 m8 right-align'>
          <ul className='tabs transparent margin-bottom--small right'>
            <li className="tab"><a href="#">Hide</a></li>
          </ul>
        </div>
      </div>

      <RichText name='about'
                content={character.about}
                contentHtml={character.about_html}
                editable
                fixedTitle
                renderAsCard
                onChange={onChange}
      />

      { profileSections }
    </div>
  </section>`

Profile.propTypes =
  character: PropTypes.object

export default Profile
