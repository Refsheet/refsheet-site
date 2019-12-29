import React from 'react'
import PropTypes from 'prop-types'
import { Dropdown, Icon } from 'react-materialize'

const PostTags = ({ children }) => (
  <div className={'forum-post--tags'}>{children}</div>
)

const Tag = ({ icon, label, children }) => (
  <div className={'tag'}>
    {icon && <Icon className={'left'}>{icon}</Icon>}
    <span className={'label'}>{label || children}</span>
  </div>
)

Tag.propTypes = {
  icon: PropTypes.string,
  label: PropTypes.string,
}

const DropdownTag = ({ icon, label, children }) => (
  <div className={'dropdown-container'}>
    <Dropdown
      options={{
        alignment: 'left',
        constrainWidth: false,
      }}
      trigger={
        <div className={'tag link'}>
          {icon && <Icon className={'left'}>{icon}</Icon>}
          <span className={'label'}>{label}</span>
        </div>
      }
    >
      {children}
    </Dropdown>
  </div>
)

DropdownTag.propTypes = {
  icon: PropTypes.string,
  label: PropTypes.string,
}

export default PostTags

export { Tag, DropdownTag }
