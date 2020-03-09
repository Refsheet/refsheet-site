/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import React from 'react';
import PropTypes from 'prop-types';
import Card, { div as Slant } from 'Styled/Card';
import { H1, H2 } from 'Styled/Headings';

const gravityCrop = {
  center: { objectPosition: 'center' },
  north: { objectPosition: 'top' },
  south: { objectPosition: 'bottom' },
  east: { objectPosition: 'right' },
  west: { objectPosition: 'left' }
};

const Details = ({character, editable}) => <div className='details'>
  <AttributeTable defaultValue='Unspecified' freezeName hideNotesForm>
    <Attribute id='species' name='Species' value={ character.species } />
  </AttributeTable>

  <Views.Character.Attributes
      characterPath={ character.path }
      attributes={ character.custom_attributes }
  />

  { (character.special_notes || editable) &&
    <div className='important-notes margin-top--large margin-bottom--medium'>
      <H2>Important Notes</H2>

      <RichText
          content={ character.special_notes_html }
          markup={ character.special_notes }
      />
    </div>
  }
</div>;

const Image = ({image}) => <div className='character-image'>
  <Slant className='slant' />
  <img src={ image.url.medium }
       data-image-id={ image.id }
       style={ gravityCrop[image.gravity] } />
</div>;

const Summary = ({character, editable}) => <Card className='character-card'>
  <div className='character-details'>
    <div className='heading'>
      <H1 className='name'>
        <span className='real-name'>{ character.name }</span>
      </H1>
    </div>

    <Details character={character} editable={editable} />
  </div>

  <Image image={character.profile_image} />
</Card>;

Summary.propTypes = {
  editable: PropTypes.bool,
  character: PropTypes.object.isRequired
};

export default Summary;
