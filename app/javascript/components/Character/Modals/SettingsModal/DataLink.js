import React, { Component, Fragment } from 'react'
import Restrict from '../../../Shared/Restrict'
import Button from '../../../Styled/Button'
import Input from '../../../../v1/shared/forms/Input'
import Submit from '../../../../v1/shared/forms/Submit'
import updateLodestoneLink from './LodestoneSource/updateLodestoneLink.graphql'
import createLodestoneLink from './LodestoneSource/createLodestoneLink.graphql'
import compose, { withMutations } from '../../../../utils/compose'
import Flash from '../../../../utils/Flash'
import gql from 'graphql-tag'
import Moment from 'react-moment'

class DataLink extends Component {
  constructor(props) {
    super(props)

    this.state = {
      saving: false,
      lodestoneId: '',
    }
  }

  handleLodestoneLink(e) {
    const {
      createLodestoneLink,
      character: { id },
    } = this.props
    e.preventDefault()
    this.setState({ saving: true })

    createLodestoneLink({
      wrapped: true,
      variables: {
        characterId: id,
        lodestoneId: this.state.lodestoneId,
      },
      update: (cache, { data: { createLodestoneLink: link } }) => {
        const fragment = gql`
          fragment lodestoneLink on Character {
            id
            lodestone_character {
              id
            }
          }
        `

        const prev = cache.readFragment({
          id: `Character:${id}`,
          fragment,
        })

        console.log({ prev, cache, rf: cache.readFragment, fragment })

        cache.writeFragment({
          id: `Character:${id}`,
          fragment,
          data: {
            ...prev,
            lodestone_character: {
              ...link,
            },
          },
        })
      },
    })
      .then(({ data }) => {
        Flash.info(
          `Character linked to ${data.createLodestoneLink.name}@${data.createLodestoneLink.server.name}`
        )
      })
      .catch(console.error)
      .finally(() => this.setState({ saving: false }))
  }

  handleInputChange(name, value) {
    let state = {}
    state[name] = value
    this.setState(state)
  }

  handleLodestoneUpdate(e) {
    const {
      updateLodestoneLink,
      character: { id },
    } = this.props
    e.preventDefault()
    this.setState({ saving: true })

    updateLodestoneLink({
      wrapped: true,
      variables: {
        characterId: id,
      },
    })
      .then(({ data }) => {
        Flash.info(
          `Character updated from ${data.updateLodestoneLink.name}@${data.updateLodestoneLink.server.name}`
        )
      })
      .catch(console.error)
      .finally(() => this.setState({ saving: false }))
  }

  renderLodestone() {
    const {
      character: { lodestone_character: lodestoneCharacter },
    } = this.props

    return (
      <div>
        <p>You're connected to the Lodestone!</p>
        <ul>
          <li>
            Character: {lodestoneCharacter.name}@
            {lodestoneCharacter.server.name}
          </li>
          <li>
            Latest data:{' '}
            <Moment unix fromNow>
              {lodestoneCharacter.remote_updated_at}
            </Moment>
          </li>
          <li>
            Last update request:{' '}
            <Moment unix fromNow>
              {lodestoneCharacter.updated_at}
            </Moment>
          </li>
        </ul>
        <Button
          disabled={this.state.saving}
          onClick={this.handleLodestoneUpdate.bind(this)}
        >
          {this.state.saving ? 'Updating...' : 'Update Data'}
        </Button>
      </div>
    )
  }

  renderLinkOptions() {
    const { character } = this.props

    if (character.lodestone_character) {
      return this.renderLodestone(character.lodestone_character)
    } else {
      return (
        <div>
          <h3>Final Fantasy XIV Online Lodestone Link</h3>
          <p>
            If this character comes from Final Fantasy XIV Online, you can
            automatically fetch character data from the Lodestone, enabling a
            rich set of widgets.
          </p>
          <p>
            To start, please paste the URL of your character on the Lodestone:
          </p>
          <form onSubmit={this.handleLodestoneLink.bind(this)}>
            <Input
              onChange={this.handleInputChange.bind(this)}
              type={'text'}
              name={'lodestoneId'}
              placeholder={'Lodestone URL or ID'}
              value={this.state.lodestoneId}
            />
            <Submit disabled={this.state.saving}>
              {this.state.saving ? 'Linking...' : 'Link to Lodestone'}
            </Submit>
          </form>
        </div>
      )
    }
  }

  render() {
    return (
      <Fragment>
        <Restrict invert patron>
          <p>
            Site supporters and Patrons have access to Character Data Links!
          </p>
          <p>
            Linking your character to a data source provides automatic updates
            as you continue your adventure in other realms.
          </p>
          <p>Current supported Data Links:</p>
          <ul>
            <li>Final Fantasy XIV Lodestone</li>
          </ul>
        </Restrict>
        <Restrict patron>{this.renderLinkOptions()}</Restrict>
      </Fragment>
    )
  }
}

export default compose(
  withMutations({
    updateLodestoneLink,
    createLodestoneLink,
  })
)(DataLink)
