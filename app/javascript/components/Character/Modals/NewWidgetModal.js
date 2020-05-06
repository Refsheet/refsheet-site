import React, { Component } from 'react'
import PropTypes from 'prop-types'
import { Mutation } from 'react-apollo'
import * as M from 'materialize-css'
import createWidget from './createWidget.graphql'
import Modal from 'v1/shared/Modal'

class NewWidgetModal extends Component {
  constructor(props) {
    super(props)
  }

  handleWidgetClick(type) {
    return e => {
      e.preventDefault()
      this.props
        .createWidget({
          variables: {
            characterId: this.props.characterId,
            sectionId: this.props.sectionId,
            columnId: this.props.columnId,
            type: type,
          },
        })
        .then(({ data, errors }) => {
          if (errors) {
            console.error(errors)
            errors.map(e =>
              M.toast({ html: e.message, classes: 'red', displayLength: 3000 })
            )
          } else {
            console.log({ data })
            this.props.onCreate(data.createProfileWidget)
          }
        })
        .catch(console.error)
    }
  }

  render() {
    const widgets = [
      {
        name: 'Rich Text',
        type: 'RichText',
        description: 'Standard, Markdown-supported text widget.',
        accessLevel: 0,
      },
      {
        name: 'Youtube',
        type: 'Youtube',
        description: 'Add a Youtube video as a widget.',
        accessLevel: 5,
      },
      {
        name: 'Lodestone Class / Job Data',
        type: 'LodestoneClassJob',
        description:
          "If synced, a place to show off your FFXIV character's class and job!",
        accessLevel: 5,
      },
      {
        name: 'Lodestone Portrait',
        type: 'LodestonePortrait',
        description:
          "Display and capture your character's most recent Lodestone selfie!",
        accessLevel: 5,
      },
    ]

    return (
      <Modal
        autoOpen
        id="character-new-widget"
        title={'Add Widget'}
        onClose={this.props.onClose}
      >
        <ul className={'widget-list row no-margin'}>
          {widgets.map(widget => (
            <li key={widget.type} className={'widget col s6 m3'}>
              <a
                href={'#'}
                onClick={this.handleWidgetClick(widget.type).bind(this)}
              >
                {widget.name}
              </a>
            </li>
          ))}
        </ul>
      </Modal>
    )
  }
}

NewWidgetModal.propTypes = {
  sectionId: PropTypes.number.isRequired,
  columnId: PropTypes.number.isRequired,
  onClose: PropTypes.func,
  createWidget: PropTypes.func.isRequired,
  onCreate: PropTypes.func.isRequired,
}

const Mutated = props => (
  <Mutation mutation={createWidget}>
    {(createWidget, { data }) => (
      <NewWidgetModal
        {...props}
        createWidget={createWidget}
        mutationData={data}
      />
    )}
  </Mutation>
)

export default Mutated
