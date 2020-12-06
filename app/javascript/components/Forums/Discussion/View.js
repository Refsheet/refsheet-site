import React, { Component } from 'react'
import compose from '../../../utils/compose'
import { Trans, withTranslation } from 'react-i18next'
import KarmaCounter from '../shared/KarmaCounter'
import Moment from 'react-moment'
import UserAvatar from '../../User/UserAvatar'
import UserLink from '../../Shared/UserLink'
import PostMeta from '../shared/PostMeta'
import DiscussionReply from './DiscussionReply'
import RichText from '../../Shared/RichText'
import DiscussionReplyForm from './DiscussionReplyForm'
import c from 'classnames'
import Muted, { MutedAnchor } from '../../Styled/Muted'
import LinkUtils from 'utils/LinkUtils'
import { H2 } from '../../Styled/Headings'

import Advertisement from 'v1/shared/advertisement'
import { Divider, Dropdown, Icon} from "react-materialize"

class View extends Component {
  constructor(props) {
    super(props);

    this.state = {
      editing: false
    }
  }

  handleEditStart(e) {
    e.preventDefault();
    this.setState({ editing: true })
  }

  render() {
    const { discussion, forum, t, refetch } = this.props
    const { can_edit, can_destroy } = discussion

    return (
      <div className={'container container-flex'}>
        <main className={'content-left'}>
          <div className={'forum-post--main forum-post'}>
            <UserAvatar
              user={discussion.user}
              character={discussion.character}
            />

            <KarmaCounter discussion={discussion} forum={forum} />

            <div
              className={c('forum-card card sp', {
                admin: discussion.admin_post,
                moderator: discussion.moderator_post,
              })}
            >
              <div className={'forum-post--whodunnit card-header'}>
                <div className={'time right smaller'}>
                  <MutedAnchor
                    href={LinkUtils.forumDiscussionUrl({
                      forumId: forum.slug,
                      discussionId: discussion.slug,
                    })}
                  >
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
                  </MutedAnchor>

                  {discussion.is_edited && (
                    <Muted className={'margin-left--small inline'}>
                      (
                      <a href={'#'} title={'Show edit history...'}>
                        Edited
                      </a>
                      )
                    </Muted>
                  )}

                  <Dropdown
                    id={`Discussion_${discussion.id}`}
                    options={{
                      alignment: "right",
                      constrainWidth: false,
                    }}
                    trigger={
                      <MutedAnchor href={'#'}>
                        <Icon className={'right smaller'}>more_vert</Icon>
                      </MutedAnchor>
                    }
                  >
                    {[ can_edit && <a key="edit" href={'#'} onClick={this.handleEditStart.bind(this)}>
                      <Icon left>edit</Icon>
                      <span>Edit</span>
                    </a>,
                    can_destroy && <a key="delete" href={'#'}>
                      <Icon left>delete</Icon>
                      <span>Delete</span>
                    </a>, 
                    <a key="report" href={'#'}>
                      <Icon left>flag</Icon>
                      <span>Report</span>
                    </a>].filter(Boolean)}
                  </Dropdown>
                </div>

                <UserLink
                  user={discussion.user}
                  character={discussion.character}
                />
              </div>

              <div className={'card-content'}>
                <H2>{discussion.topic}</H2>
                <div className={'forum-post--content'}>
                  <RichText
                    content={discussion.content}
                    contentHtml={discussion.content_html}
                  />
                </div>

                <PostMeta
                  forum={forum}
                  discussion={discussion}
                  className={'margin-top--medium'}
                />
              </div>
            </div>
          </div>

          <div className={'forum-post--replies'}>
            {discussion.posts.map((post) => (
              <DiscussionReply
                key={post.id}
                post={post}
                forumId={forum.slug}
                discussionId={discussion.slug}
              />
            ))}

            <DiscussionReplyForm
              key={'new-reply'}
              discussion={discussion}
              forum={forum}
              inCharacter={!forum.no_rp}
              refetch={refetch}
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

export default compose(withTranslation('common'))(View)
