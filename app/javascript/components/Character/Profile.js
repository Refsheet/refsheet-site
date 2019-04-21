/*
 * decaffeinate suggestions:
 * DS101: Remove unnecessary use of Array.from
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import React from 'react';
import PropTypes from 'prop-types';
import { RichText } from 'Shared';
import ProfileSection from './ProfileSection';
import c from 'classnames';

const Profile = ({profileSections, editable, refetch, characterId}) =>
  <div id='profile'>
    { renderProfileSections(profileSections, editable, refetch, characterId) }
  </div>
;

const groupProfileSections = function(profileSections, editable) {
  const groups = {};
  let lastId = 'main';
  for (let section of Array.from(profileSections)) {
    if (section.title || editable) { lastId = section.id; }
    if (!groups[lastId]) { groups[lastId] = []; }
    groups[lastId].push(section);
  }
  return groups;
};

const renderProfileSections = function(profileSections, editable, refetch, characterId) {
  const groups = groupProfileSections(profileSections, editable);
  const render = [];

  for (let id in groups) {
    var sections = groups[id];
    const renderedSections = sections.map(function(section, i) {
      const classNames = c({
        'margin-bottom--none': sections.length > 0,
        'margin-top--none': i > 0
      });

      return <ProfileSection key={section.id} {...section} className={ classNames } editable={editable} refetch={refetch} characterId={characterId} />;
    });

    render.push(<div id={id} key={id} className='profile-scrollspy'>{renderedSections}</div>);

    if (editable) {
      render.push(
        <a key={'new-' + id}
           className='btn btn-flat block margin-top--medium margin-bottom--large'
           style={{border: '1px dashed #ffffff33'}}>
          Add Section
        </a>
      )
    }
  }

  return render;
};

Profile.propTypes = {
  profileSections: PropTypes.arrayOf(
    PropTypes.shape({
      id: PropTypes.string.isRequired,
      title: PropTypes.string
    })
  ),
  editable: PropTypes.bool,
  characterId: PropTypes.string.isRequired
};

export default Profile;
