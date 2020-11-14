import React, { Component } from 'react'
import PropTypes from 'prop-types'
import compose from 'utils/compose'
import { withCurrentUser } from '../../../utils/compose'
import { withTranslation } from 'react-i18next'
import { Row, Col, TextInput, Checkbox } from 'react-materialize'
import DiscussionReplyForm from '../Discussion/DiscussionReplyForm'
import FormUtils from 'utils/FormUtils'
import LinkUtils from 'utils/LinkUtils'
import { withRouter } from 'react-router'
import Restrict from '../../Shared/Restrict'

import Advertisement from 'v1/shared/advertisement'

class NewDiscussion extends Component {
  constructor(props) {
    super(props)

    this.state = {
      post: {
        topic: '',
        sticky: false,
        hidden: false,
        locked: false,
      },
    }

    this.handleInputChange = FormUtils.handleInputChange('post').bind(this)
  }

  handleSubmit({ slug: discussionId, forum: { slug: forumId } }) {
    const { history } = this.props
    const path = LinkUtils.forumDiscussionPath({ discussionId, forumId })
    history.push(path)
  }

  render() {
    const { forum, t } = this.props

    return (
      <div className={'container container-flex'}>
        <main className={'content-left padding-bottom--large'}>
          <DiscussionReplyForm
            forum={forum}
            newDiscussion
            post={this.state.post}
            onSubmit={this.handleSubmit.bind(this)}
          >
            <div className={'card-header'}>
              <Row className={'no-margin'}>
                <TextInput
                  id={'discussion_topic'}
                  s={12}
                  m={6}
                  key={'discussion_topic'}
                  placeholder={'Discussion Topic'}
                  value={this.state.post.topic}
                  inputClassName={'outlined'}
                  name={'topic'}
                  onChange={this.handleInputChange}
                />
                <Col s={6} m={3} className={'right-align checkbox-full-height'}>
                  <Restrict admin>
                    <Checkbox
                      id={'sticky'}
                      value={'sticky'}
                      label={'Sticky'}
                      checked={this.state.post.sticky}
                      onChange={this.handleInputChange}
                    />
                  </Restrict>
                </Col>
                <Col s={6} m={3} className={'right-align checkbox-full-height'}>
                  <Restrict admin>
                    <Checkbox
                      id={'locked'}
                      value={'locked'}
                      label={'Locked'}
                      checked={this.state.post.locked}
                      onChange={this.handleInputChange}
                    />
                  </Restrict>
                </Col>
              </Row>
            </div>
          </DiscussionReplyForm>
        </main>

        <aside className={'sidebar left-pad'}>
          {typeof Advertisement != 'undefined' && <Advertisement />}
        </aside>
      </div>
    )
  }
}

NewDiscussion.propTypes = {
  forum: PropTypes.object.isRequired,
}

export default compose(
  withTranslation('common'),
  withCurrentUser(),
  withRouter
)(NewDiscussion)
