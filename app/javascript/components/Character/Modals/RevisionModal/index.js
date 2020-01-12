import React, { Component } from 'react'
import PropTypes from 'prop-types'
import compose from 'utils/compose'
import { Icon } from 'react-materialize'
import { Trans, withNamespaces } from 'react-i18next'
import Moment from 'react-moment'
import c from 'classnames'
import Diff from 'react-stylable-diff'
import TimelineEntry from '../../../Shared/Timeline/TimelineEntry'
import { Loading } from '../../../Lightbox/Status'
import Error from '../../../Shared/Error'
import { Query } from 'react-apollo'
import getCharacterVersions from './getCharacterVersions.graphql'

class RevisionModal extends Component {
  constructor(props) {
    super(props)

    this.state = {
      activeVersion: 0,
    }

    this.ignoredFields = ['created_at', 'updated_at', 'deleted_at']
  }

  componentDidUpdate() {
    M.Collapsible.init(this.collapsible)
  }

  handleVersionClick(version) {
    return e => {
      e.preventDefault()
      this.setState({ activeVersion: version })
    }
  }

  renderHistory({ data, loading, error }) {
    if (loading) {
      return <Loading />
    }

    if (error || !data) {
      return <Error error={error} />
    }

    let versions = [...data.getCharacter.versions]
    versions.sort((a, b) => b.created_at - a.created_at)

    return (
      <ul
        className={'timeline collapsible accordion'}
        ref={r => (this.collapsible = r)}
      >
        <TimelineEntry
          key={'current'}
          current={this.state.activeVersion === 'current'}
          onClick={this.handleVersionClick('current').bind(this)}
          title={'Current Profile'}
          summary={'You are here.'}
        />

        {versions.map(version => {
          const changes = JSON.parse(version.object_changes)
          const changed_fields = Object.keys(changes).filter(
            k => this.ignoredFields.indexOf(k) === -1
          )

          return (
            <TimelineEntry
              key={version.index}
              current={this.state.activeVersion === version.index}
              onClick={this.handleVersionClick(version.index).bind(this)}
              time={version.created_at}
              title={version.event}
              summary={`${version.whodunnit.name || 'Someone'} updated ${
                changed_fields.length
              } fields`}
            >
              <div className={'change-table'}>
                {changed_fields.map(changeKey => (
                  <div className={'change'}>
                    <div className={'label'}>{changeKey}</div>
                    <Diff
                      inputA={changes[changeKey][0]}
                      inputB={changes[changeKey][1]}
                      type={'words'}
                    />
                  </div>
                ))}
              </div>
            </TimelineEntry>
          )
        })}
      </ul>
    )
  }

  render() {
    const { t } = this.props

    return (
      <Modal
        autoOpen
        sideSheet
        id={'character-revisions'}
        title={t('labels.character_revisions', 'Character Revisions')}
        onClose={this.props.onClose}
      >
        <Trans i18nKey={'captions.character_revisions'} parent={'p'}>
          This is a list of recent changes to your character's information. Here
          you can view your character at previous points in time, and roll back
          to undo changes.
        </Trans>

        <Query
          query={getCharacterVersions}
          variables={{ characterId: this.props.characterId }}
        >
          {this.renderHistory.bind(this)}
        </Query>
      </Modal>
    )
  }
}

RevisionModal.propTypes = {}

export default compose(withNamespaces('common'))(RevisionModal)
