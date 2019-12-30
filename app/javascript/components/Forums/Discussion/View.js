import React, { Component } from 'react'
import compose from '../../../utils/compose'
import PostTags, { Tag } from '../shared/PostTags'
import { Trans, withNamespaces } from 'react-i18next'
import KarmaCounter from '../shared/KarmaCounter'
import { Link } from 'react-router-dom'
import Moment from 'react-moment'
import UserAvatar from '../../User/UserAvatar'
import UserLink from '../../Shared/UserLink'
import PostMeta from './PostMeta'

class View extends Component {
  render() {
    const { discussion, forum, t } = this.props

    console.log({ discussion })

    return (
      <div className={'container container-flex'}>
        <main className={'content-left'}>
          <div className={'forum-post--main forum-post'}>
            <KarmaCounter discussion={discussion} forum={forum} />

            <h2>{discussion.topic}</h2>
            <PostMeta forum={forum} discussion={discussion} />

            <div className={'forum-post--content'}>{discussion.content}</div>
          </div>

          <div className={'forum-post--replies'}>
            <div className={'forum-posts--group-name'}>
              {discussion.reply_count} Replies
            </div>

            {discussion.posts.map(post => {
              return (
                <div className={'margin-top--medium forum-post--reply'}>
                  <UserAvatar user={post.user} character={post.character} />

                  <div className={'time'}>
                    <Trans
                      i18nKey={'forums.summary-posted-date'}
                      defaults={'Posted <0>{{ date }}</0>'}
                      values={{
                        date: post.created_at,
                      }}
                      components={[
                        <Moment key={'date'} fromNow unix>
                          {post.created_at}
                        </Moment>,
                      ]}
                    />
                  </div>

                  <UserLink user={post.user} character={post.character} />

                  <div className={'reply-content'}>{post.content}</div>
                </div>
              )
            })}
          </div>
        </main>

        <aside className={'sidebar left-pad'}>
          <div className="forum-post--date margin-bottom--large">
            <div className={'user-summary'}>
              <UserAvatar
                user={discussion.user}
                character={discussion.character}
              />

              <UserLink
                user={discussion.user}
                character={discussion.character}
              />

              <div className={'time'}>
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
            </div>
          </div>

          {typeof Advertisement != 'undefined' && <Advertisement />}
        </aside>
      </div>
    )
  }
}

export default compose(withNamespaces('common'))(View)
