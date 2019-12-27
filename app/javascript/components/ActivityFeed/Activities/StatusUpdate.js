import React, { Component } from 'react'
import PropTypes from 'prop-types'
import Restrict from '../../Shared/Restrict'
import CommentForm from '../../Shared/CommentForm'
import c from 'classnames'

const LARGE_LETTER_THRESHOLD = 240

class StatusUpdate extends Component {
  constructor(props) {
    super(props)

    this.state = {
      expanded: false,
      replyFieldOpen: false,
    }
  }

  render() {
    const { comment } = this.props

    const lines = comment.split('\n')
    const short = comment.length < LARGE_LETTER_THRESHOLD

    return (
      <div className="activity">
        <div
          className={c('card-content padding-top--none', {
            larger: short,
            thinner: short,
          })}
        >
          {lines.map((line, i) => (
            <span key={i}>
              {line}
              <br />
            </span>
          ))}
        </div>

        <Restrict patron hideAll>
          <CommentForm onChange={console.log} inCharacter flat condense />
        </Restrict>
      </div>
    )
  }
}

StatusUpdate.propTypes = {
  comment: PropTypes.string.isRequired,
}

export default StatusUpdate
