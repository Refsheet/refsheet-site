import React, { Component } from 'react'
import PropTypes from 'prop-types'
import compose from 'utils/compose'
import { Link } from 'react-router-dom'
import Moment from 'react-moment'
import { withNamespaces } from 'react-i18next'

class PostMeta extends Component {
  render() {
    const { discussion, forum, t } = this.props

    return (
      <div className={'forum-post--meta'}>
        {t('forums.replies', {
          defaultValue: '{{count}} replies',
          count: discussion.reply_count,
        })}
        {discussion.last_post_at && (
          <span className={'last-reply-at'}>
            {' '}
            (
            <Link
              to={`/v2/forums/${forum.slug}/${discussion.slug}#last`}
              title={t('forums.go_to_last', 'Go to last post')}
            >
              <Moment key={'date'} fromNow unix>
                {discussion.last_post_at}
              </Moment>
            </Link>
            )
          </span>
        )}
        &nbsp;&bull;&nbsp;<a href={'#'}>{t('forums.save', 'Save')}</a>
      </div>
    )
  }
}

PostMeta.propTypes = {
  discussion: PropTypes.object.isRequired,
  forum: PropTypes.object.isRequired,
}

export default compose(withNamespaces('common'))(PostMeta)
