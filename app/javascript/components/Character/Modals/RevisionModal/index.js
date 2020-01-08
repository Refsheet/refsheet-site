import React, { Component } from 'react'
import PropTypes from 'prop-types'
import compose from 'utils/compose'
import { Icon } from 'react-materialize'
import {withNamespaces} from "react-i18next";
import Moment from "react-moment";
import c from 'classnames'
import Diff from 'react-stylable-diff'

class RevisionModal extends Component {
  constructor(props) {
    super(props)

    this.state = {
      activeVersion: 0
    }
  }

  handleVersionClick(version) {
    return (e) => {
      e.preventDefault()
      this.setState({activeVersion: version})
    }
  }

  render() {
    const { t } = this.props

    const changes = {
      "name": ["Test Testington", "Dr Test Testington III"],
      "about": ["this is a really long about field that contains lots of text and should probrbgly be cut off at some point",
        "this is a really long about field that contains lots of text and should probably be cut off at some point"]
    }

    return (
      <Modal
        autoOpen
        sideSheet
        id={"character-revisions"}
        title={t("labels.character_revisions", "Character Revisions")}
        onClose={this.props.onClose}
      >
        <p>
          This is a list of recent changes to your character's information. Here you can view your character at
          previous points in time, and roll back to undo changes.
        </p>

        <ul className={'timeline'}>
          {[0,1,2,3,4,5,6].map((i) =>
          <li key={i} className={c('timeline-entry', { current: this.state.activeVersion === i })} onClick={this.handleVersionClick(i).bind(this)}>
            <Moment format={"L"} withTitle titleFormat={"L LT"} />
            <div className={'title'}>
              Update
            </div>

            You updated 9 fields

            { this.state.activeVersion === i && <div className={'details'}>
              <div className={'change-table'}>
                { Object.keys(changes).map(changeKey => <div className={'change'}>
                  <div className={'label'}>{ changeKey }</div>
                  <Diff inputA={changes[changeKey][0]} inputB={changes[changeKey][1]} type={'words'} />
                  {/*<div className={'from'}>{ changes[changeKey][0] }</div>*/}
                  {/*<div className={'to'}>{ changes[changeKey][1] }</div>*/}
                </div>)}
              </div>
            </div>}
          </li> )}
        </ul>
      </Modal>
    )
  }
}

RevisionModal.propTypes = {}

export default compose(
  withNamespaces('common')
)(RevisionModal)
