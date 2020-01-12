import React, { Component } from 'react'
import PropTypes from 'prop-types'
import compose from 'utils/compose'
import { Icon } from 'react-materialize'
import {Trans, withNamespaces} from "react-i18next";
import Moment from "react-moment";
import c from 'classnames'
import Diff from 'react-stylable-diff'
import TimelineEntry from "../../../Shared/Timeline/TimelineEntry";

class RevisionModal extends Component {
  constructor(props) {
    super(props)

    this.state = {
      activeVersion: 0
    }
  }

  componentDidUpdate() {
    M.Collapsible.init(this.collapsible)
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
        <Trans i18nKey={'captions.character_revisions'} parent={'p'}>
          This is a list of recent changes to your character's information. Here you can view your character at
          previous points in time, and roll back to undo changes.
        </Trans>

        <ul className={'timeline collapsible accordion'} ref={r => this.collapsible = r}>
          {[0,1,2,3,4,5,6].map((i) =>
          <TimelineEntry key={i}
                         current={ this.state.activeVersion === i }
                         onClick={this.handleVersionClick(i).bind(this)}
                         time={123456789123}
                         title={"Update"}
                         summary={"You updated 2 fields"}
          >
              <div className={'change-table'}>
                { Object.keys(changes).map(changeKey => <div className={'change'}>
                  <div className={'label'}>{ changeKey }</div>
                  <Diff inputA={changes[changeKey][0]} inputB={changes[changeKey][1]} type={'words'} />
                  {/*<div className={'from'}>{ changes[changeKey][0] }</div>*/}
                  {/*<div className={'to'}>{ changes[changeKey][1] }</div>*/}
                </div>)}
              </div>
          </TimelineEntry> )}
        </ul>
      </Modal>
    )
  }
}

RevisionModal.propTypes = {}

export default compose(
  withNamespaces('common')
)(RevisionModal)
