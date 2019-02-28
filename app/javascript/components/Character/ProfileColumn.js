/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import React from 'react';
import PropTypes from 'prop-types';
import ProfileWidget from './ProfileWidget';
import { camelize } from 'object-utils';

const ProfileColumn = function({widgets, width, editable}) {
  const widgetCards = widgets.map(widget => <ProfileWidget {...camelize(widget)} key={widget.id} editable={editable} />);

  return <div className={`col s12 m${width}`}>
    { widgetCards }

    { editable &&
    <a className='btn btn-flat block margin-top--medium' style={{border: '1px dashed #ffffff33'}}>
      Add Widget
    </a> }
  </div>;
};

ProfileColumn.propTypes = {
  id: PropTypes.number.isRequired,
  widgets: PropTypes.arrayOf(PropTypes.object).isRequired,
  width: PropTypes.number.isRequired,
  onChange: PropTypes.func,
  editable: PropTypes.bool
};

export default ProfileColumn;
