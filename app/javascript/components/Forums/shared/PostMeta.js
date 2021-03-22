import React, { Component } from 'react'
import PropTypes from 'prop-types'
import compose from 'utils/compose'
import { Link } from 'react-router-dom'
import Moment from 'react-moment'
import { withTranslation } from 'react-i18next'
import c from 'classnames'
import Muted, { MutedLink } from '../../Styled/Muted'

class PostMeta extends Component {
  render() {
    const { discussion, forum, t, className } = this.props

    return (
      <Muted className={c('forum-post--meta', className)}>
        {t('forums.replies', {
          defaultValue: '{{count}} replies',
          count: discussion.reply_count,
        })}
        {discussion.last_post_at && (
          <span className={'last-reply-at'}>
            {' '}
            (
            <MutedLink
              to={`/forums/${forum.slug}/${discussion.slug}#last`}
              title={t('forums.go_to_last', 'Go to last post')}
            >
              <Moment key={'date'} fromNow unix>
                {discussion.last_post_at}
              </Moment>
            </MutedLink>
            )
          </span>
        )}
        &nbsp;&bull;&nbsp;<a href={'#'}>{t('forums.save', 'Save')}</a>
        &nbsp;&bull;&nbsp;<a href={'#reply'}>{t('forums.reply', 'Reply')}</a>
      </Muted>
    )
  }
}

PostMeta.propTypes = {
  discussion: PropTypes.object.isRequired,
  forum: PropTypes.object.isRequired,
  className: PropTypes.string,
}

export default compose(withTranslation('common'))(PostMeta)
