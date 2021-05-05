import React, { Component } from 'react'
import compose, { withMutations } from '../../../utils/compose'
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
import { Divider, Dropdown, Icon } from 'react-materialize'
import Restrict from '../../Shared/Restrict'
import NewDiscussionForm from '../NewDiscussion/NewDiscussionForm'
import { openReportModal } from '../../../actions'
import { connect } from 'react-redux'
import e from 'utils/e'
import destroyDiscussion from './destroyDiscussion.graphql'
import { withRouter } from 'react-router'
import NotFound from '../../Shared/views/NotFound'
import EmailConfirmationNag from '../../User/EmailConfirmationNag'

class View extends Component {
  constructor(props) {
    super(props)

    this.state = {
      editing: false,
      editingReply: false,
      pendingAction: false,
    }
  }

  handleEditStart(e) {
    e.preventDefault()
    this.setState({ editing: true })
  }

  handleEditStop() {
    this.setState({ editing: false })
  }

  handleReplyEditStart() {
    this.setState({ editingReply: true })
  }

  handleReplyEditStop() {
    this.setState({ editingReply: false })
  }

  handleDestroyDiscussion(e) {
    e.preventDefault()
    this.setState({ pendingAction: true })

    this.props
      .destroyDiscussion({
        wrapped: true,
        variables: {
          id: this.props.discussion.id,
        },
      })
      .then(() => {
        this.props.history.push(
          LinkUtils.forumPath({ forumId: this.props.discussion.forum.slug })
        )
      })
      .finally(() => {
        this.setState({ pendingAction: false })
      })
  }

  render() {
    const { discussion, forum, t, refetch, openReportModal } = this.props

    if (!discussion || discussion.deleted_at) {
      return <NotFound />
    }

    const { can_edit, can_destroy } = discussion

    if (this.state.editing) {
      return (
        <NewDiscussionForm
          edit
          discussion={discussion}
          onSubmit={console.log}
          onCancel={console.log}
        />
      )
    }

    return (
      <div className={'container container-flex'}>
        <main className={'content-left'}>
          <div
            className={c('forum-post--main forum-post', {
              loading: this.state.pendingAction,
              destroyed: discussion.deleted_at,
            })}
          >
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
                      alignment: 'right',
                      constrainWidth: false,
                    }}
                    trigger={
                      <MutedAnchor href={'#'}>
                        <Icon className={'right smaller'}>more_vert</Icon>
                      </MutedAnchor>
                    }
                  >
                    {can_edit && (
                      <a
                        key="edit"
                        href={'#'}
                        onClick={this.handleEditStart.bind(this)}
                      >
                        <Icon left>edit</Icon>
                        <span>Edit</span>
                      </a>
                    )}
                    {can_destroy && (
                      <a
                        key="delete"
                        href={'#'}
                        onClick={this.handleDestroyDiscussion.bind(this)}
                      >
                        <Icon left>delete</Icon>
                        <span>Delete</span>
                      </a>
                    )}
                    <Restrict admin>
                      <a key={'lock'} href={'#'}>
                        <Icon left>lock</Icon>
                        <span>Lock</span>
                      </a>
                    </Restrict>
                    <Restrict admin>
                      <a key={'sticky'} href={'#'}>
                        <Icon left>push_pin</Icon>
                        <span>Make Sticky</span>
                      </a>
                    </Restrict>
                    <Divider />
                    <a
                      key="report"
                      href={'#'}
                      onClick={e(() => openReportModal(discussion))}
                    >
                      <Icon left>flag</Icon>
                      <span>Report</span>
                    </a>
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
            {discussion.posts.map(post => (
              <DiscussionReply
                key={post.id}
                post={post}
                forumId={forum.slug}
                discussionId={discussion.slug}
                onEditStart={this.handleReplyEditStart.bind(this)}
                onEditStop={this.handleReplyEditStop.bind(this)}
              />
            ))}

            {!this.state.editingReply && (
              <EmailConfirmationNag permit={forum.slug === 'support'}>
                <DiscussionReplyForm
                  key={'new-reply'}
                  discussion={discussion}
                  forum={forum}
                  inCharacter={!forum.no_rp}
                  refetch={refetch}
                />
              </EmailConfirmationNag>
            )}
          </div>
        </main>

        <aside className={'sidebar left-pad'}>
          {typeof Advertisement != 'undefined' && <Advertisement />}
        </aside>
      </div>
    )
  }
}

export default compose(
  withTranslation('common'),
  connect(undefined, { openReportModal }),
  withMutations({ destroyDiscussion }),
  withRouter
)(View)
