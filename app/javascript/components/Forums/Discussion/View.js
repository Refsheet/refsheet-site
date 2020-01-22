import React, { Component } from 'react'
import compose from '../../../utils/compose'
import { Trans, withNamespaces } from 'react-i18next'
import KarmaCounter from '../shared/KarmaCounter'
import Moment from 'react-moment'
import UserAvatar from '../../User/UserAvatar'
import UserLink from '../../Shared/UserLink'
import PostMeta from '../shared/PostMeta'
import DiscussionReply from './DiscussionReply'
import RichText from '../../Shared/RichText'
import DiscussionReplyForm from './DiscussionReplyForm'

class View extends Component {
  render() {
    const { discussion, forum, t } = this.props

    console.log({ discussion })

    return (
      <div className={'container container-flex'}>
        <main className={'content-left'}>
          <div className={'forum-post--main forum-post'}>
            <UserAvatar
              user={discussion.user}
              character={discussion.character}
            />

            <KarmaCounter discussion={discussion} forum={forum} />

            <div className={'forum-card card sp'}>
              <div className={'time card-header'}>
                <Trans
                  i18nKey={'forums.summary-posted-date'}
                  defaults={'Posted <0>{{ date }}</0>'}
                  values={{
                    date: discussion.created_at,
                  }}
                  components={[
                    <Moment key={'date'} fromNow unix>
                      {discussion.created_at}
                    </Moment>,
                  ]}
                />
              </div>

              <div className={'forum-post--whodunnit card-header'}>
                <UserLink
                  user={discussion.user}
                  character={discussion.character}
                />
              </div>

              <div className={'card-content'}>
                <h2>{discussion.topic}</h2>
                <div className={'forum-post--content'}>
                  <RichText
                    content={discussion.content}
                    contentHtml={discussion.content_html}
                  />
                </div>

                <PostMeta
                  forum={forum}
                  discussion={discussion}
                  className={'margin-top--small'}
                />
              </div>
            </div>
          </div>

          <div className={'forum-post--replies'}>
            {discussion.posts.map(post => (
              <DiscussionReply key={post.id} post={post} />
            ))}

            <DiscussionReplyForm
              key={'new-reply'}
              discussion={discussion}
              forum={forum}
            />
          </div>
        </main>

        <aside className={'sidebar left-pad'}>
          {typeof Advertisement != 'undefined' && <Advertisement />}
        </aside>
      </div>
    )
  }
}

export default compose(withNamespaces('common'))(View)
