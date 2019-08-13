import React, { Component } from 'react'
import PropTypes from 'prop-types'
import Restrict from "../../Shared/Restrict";
import CommentForm from "../../Shared/CommentForm";

class StatusUpdate extends Component {
  constructor(props) {
    super(props)

    this.state = {
      expanded: false,
      replyFieldOpen: false
    }
  }

  render() {
    const {
      comment
    } = this.props

    const lines = comment.split('\n')

    return (
      <div className='activity'>
        <div className='headline padding-bottom--medium'>
          { lines.map((line, i) => (
            <span key={i}>{line}<br/></span>
          )) }
        </div>

        <Restrict patron>
          <CommentForm onChange={console.log}
                       inCharacter
                       condense
          />
        </Restrict>
      </div>
    )
  }
}

StatusUpdate.propTypes = {
  comment: PropTypes.string.isRequired
}

export default StatusUpdate