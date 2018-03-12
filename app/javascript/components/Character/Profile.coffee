import { PropTypes } from 'prop-types'
import { RichText } from 'Shared'

Profile = ({character, onChange}) ->
  `<section className='character-profile'>
    <div className='container'>
      <RichText title='About'
                name='about'
                content={character.about}
                contentHtml={character.about_html}
                editable
                fixedTitle
                onChange={onChange}
      />
      <h1>About { character.name }</h1>
      <p>{ character.about_html }</p>
    </div>
  </section>`

Profile.propTypes =
  character: PropTypes.object

export default Profile
