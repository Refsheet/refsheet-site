import React, { Component } from 'react'
import PropTypes from 'prop-types'
import {Trans, withNamespaces} from 'react-i18next'
import UserLink from "../../Shared/UserLink";
import Moment from "react-moment";

class DiscussionLink extends Component {
  render() {
    const {
      forum,
      discussion,
      t
    } = this.props

    return (
      <div className={'row forum-post'}>
        <div className={'col s2 m1 forum-post--votes'}>
          <div className="forum-post--upvote">
            <a href={'#'} title={t('forums.karma.give', "Give Karma")}>
              <Icon>keyboard_arrow_up</Icon>
            </a>
          </div>

          <div className={'forum-post--karma'}>
            { discussion.karma_total || 0 }
          </div>

          <div className="forum-post--downvote">
            <a href={'#'} title={t('forums.karma.take', "Take Karma")}>
              <Icon>keyboard_arrow_down</Icon>
            </a>
          </div>
        </div>

        <div className={'col s10 m11'}>
          <div className="forum-post--title">
            <a href={`/v2/forums/${forum.slug}/${discussion.slug}`}>
              { discussion.topic }
            </a>
          </div>

          <div className="forum-post--date">
            <Trans i18nKey={'forums.post-date'}
                   defaults={"Submitted <0>{{ date }}</0> by <1></1>"}
                   values={{
                     date: discussion.created_at
                   }}
                   components={[
                     <Moment key={'date'} fromNow unix>{ discussion.created_at }</Moment>,
                     <UserLink key={'user'} user={discussion.user} character={discussion.character} />
                   ]}
            />
          </div>

          <div className={"forum-post--meta"}>
            {t('forums.replies', {
              defaultValue: "{{count}} reply",
              count: 0
            })}

            &nbsp;| <a href={'#'}>{t('forums.save', "Save")}</a>
          </div>
        </div>
      </div>
    )
  }
}

DiscussionLink.propTypes = {};

const translated = withNamespaces('common')(DiscussionLink);

export default translated;