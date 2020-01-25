import React, { Component } from 'react'
import PropTypes from 'prop-types'
import compose from 'utils/compose'
import { withNamespaces } from 'react-i18next'
import Stats, { Stat } from '../../Shared/Stats'
import { Icon, Dropdown } from 'react-materialize'
import PostTags, { DropdownTag, Tag } from '../shared/PostTags'

class About extends Component {
  render() {
    const { forum, t } = this.props

    return (
      <div className={'container container-flex'}>
        <main className={'content-left padding-bottom--large'}>
          <div className={'forum-post--content'}>
            <div className={'forum-posts--header'}>
              <div className={'right'}>
                <a href={'#'} className={'btn btn-small'}>
                  {t('forums.join_group', 'Join Group')}
                </a>
              </div>

              <PostTags>
                <Tag icon={'shield'} label={'System Group'} />
              </PostTags>
            </div>

            {forum.about || (
              <p className={'caption'}>
                {t('forums.no_description', 'This group has no description.')}
              </p>
            )}

            {forum.rules && (
              <div className={'forum-rules'}>
                <div className="forum-posts--group-name">
                  {t('forums.rules', 'Group Rules')}
                </div>
              </div>
            )}

            <div className={'forum-stats'}>
              <div className={'forum-posts--group-name'}>
                {t('forums.stats', 'Group Statistics')}
              </div>
              <Stats>
                <Stat age label={t('labels.created_at', 'Created')}>
                  {forum.created_at}
                </Stat>
                <Stat numeric label={t('forums.members', 'Members')}>
                  {forum.member_count}
                </Stat>
                <Stat numeric label={t('forums.discussions', 'Discussions')}>
                  {forum.discussion_count}
                </Stat>
              </Stats>
            </div>
          </div>
        </main>

        <aside className={'sidebar left-pad'}>
          {typeof Advertisement != 'undefined' && <Advertisement />}
        </aside>
      </div>
    )
  }
}

About.propTypes = {}

export default compose(withNamespaces('common'))(About)
