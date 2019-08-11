import React, { Component } from 'react'
import PropTypes from 'prop-types'
import Main from "../../Shared/Main"
import {forumType} from "../index";
import Jumbotron from "../../Shared/Jumbotron";
import {Link} from "react-router-dom";
import {withNamespaces} from 'react-i18next';
import DiscussionLink from './DiscussionLink';

class View extends Component {
  render() {
    const {
      forum,
      t
    } = this.props

    const discussions = [...forum.discussions]

    discussions.sort((a, b) => (
      a.karma_total - b.karma_total
    ))

    return (
      <Main title={'Forums'} className={'main-flex split-bg-right'}>
        <Jumbotron short>
          <h1>{ forum.name }</h1>
          <p>{ forum.description }</p>
        </Jumbotron>

        <div className='tab-row-container'>
          <div className='tab-row pushpin' ref='tabRow'>
            <div className='container'>
              <ul className='tabs'>
                <li className={ 'tab' }>
                  <Link className={ '' } to={`/v2/forums/${forum.slug}/about`}>{t('forums.about', "About & Rules")}</Link>
                </li>
                <li className={ 'tab active' }>
                  <Link className={ 'active' } to={`/v2/forums/${forum.slug}`}>{t('forums.posts', "Posts")}</Link>
                </li>
                <li className={ 'tab' }>
                  <Link className={ '' } to={`/v2/forums/${forum.slug}/members`}>{t('forums.members', "Members")}</Link>
                </li>
              </ul>
            </div>
          </div>
        </div>

        <div className={'container container-flex'}>
          <main className={'content-left'}>
            {/*<div className={'forum-sort margin-bottom--medium'} />*/}

            <div className='forum-posts--group-name'>
              { t('forums.recent_posts', "Recent Posts") }
            </div>

            { discussions.map((discussion) => (
              <DiscussionLink key={discussion.id} forum={forum} discussion={discussion} />
            ))}
          </main>

          <aside className={'sidebar left-pad'}>
            { typeof Advertisement != 'undefined' && <Advertisement /> }
          </aside>
        </div>
      </Main>
    )
  }
}

View.propTypes = {
  forum: forumType
}

const translated = withNamespaces('common')(View);

export default translated;