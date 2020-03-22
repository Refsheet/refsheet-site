import React from 'react'
import createReactClass from 'create-react-class'
import PropTypes from 'prop-types'
import StringUtils from '../../utils/StringUtils'

// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
let IdentityAvatar
export default IdentityAvatar = createReactClass({
  propTypes: {
    src: PropTypes.shape({
      link: PropTypes.string.isRequired,
      name: PropTypes.string.isRequired,
      username: PropTypes.string.isRequired,
      type: PropTypes.string,
      avatar_url: PropTypes.string,
    }),
    avatarUrl: PropTypes.string,
  },

  render() {
    let imgShadow, nameColor
    const to = StringUtils.indifferentKeys(this.props.src)
    const user = undefined
    if (!to.type) {
      to.type = 'user'
    }

    if (
      to.is_admin ||
      (typeof user !== 'undefined' && user !== null ? user.is_admin : undefined)
    ) {
      imgShadow = '0 0 3px 1px #2480C8'
      nameColor = '#2480C8'
    } else if (
      to.is_patron ||
      (typeof user !== 'undefined' && user !== null
        ? user.is_patron
        : undefined)
    ) {
      imgShadow = '0 0 3px 1px #F96854'
      nameColor = '#F96854'
    }

    return (
      <img
        src={this.props.avatarUrl || to.avatarUrl}
        alt={this.props.name || to.name}
        className="avatar circle"
        style={{ boxShadow: imgShadow }}
        height={48}
        width={48}
      />
    )
  },
})
