import React, { Component } from 'react'
import PropTypes from 'prop-types'
import compose from 'utils/compose'
import { withCurrentUser } from '../../../utils/compose'
import { withNamespaces } from 'react-i18next'
import { Row, Col, TextInput, Checkbox } from 'react-materialize'
import DiscussionReplyForm from "../Discussion/DiscussionReplyForm";

class NewDiscussion extends Component {
  constructor(props) {
    super(props)

    this.state = { post: {} }
  }

  render() {
    const { forum, t } = this.props

    return (
      <div className={'container container-flex'}>
        <main className={'content-left padding-bottom--large'}>
          <DiscussionReplyForm forum={forum} newDiscussion>
            <div className={'card-header'}>
              <Row className={'no-margin'}>
                <TextInput id={'discussion_title'} s={12} m={6} placeholder={'Discussion Title'} inputClassName={'outlined'} />
                <Col s={6} m={3} className={'right-align checkbox-full-height'}>
                  <Checkbox id={'nsfw'} value={'nsfw'} label={'NSFW'} />
                </Col>
                <Col s={6} m={3} className={'right-align checkbox-full-height'}>
                  <Checkbox id={'locked'} value={'locked'} label={'Locked'} />
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
  withNamespaces('common'),
  withCurrentUser()
)(NewDiscussion)
