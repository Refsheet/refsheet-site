import React, { Component } from 'react'
import PropTypes from 'prop-types'
import { div as Card } from 'Styled/Card'
import { H1, H2 } from 'Styled/Headings'
import EditableHeader from '../Shared/EditableHeader'
import { Mutation } from 'react-apollo'
import updateCharacter from './updateCharacter.graphql'
import * as M from 'materialize-css'
import WindowAlert from '../../utils/WindowAlert'

import AttributeTable from 'v1/shared/attributes/attribute_table'
import Attribute from 'v1/shared/attributes/attribute'
import Attributes from 'v1/views/characters/_attributes'
import { Caption } from '../Styled/Caption'
import RichText from '../Shared/RichText'
import MarketplaceBuyModal from './Modals/MarketplaceBuyModal'
import CharacterSaleButton from './Modals/MarketplaceBuyModal/CharacterSaleButton'

class Summary extends Component {
  constructor(props) {
    super(props)

    // TODO: Finish migrating Attributes. Until then, they're stored as a local state.
    this.state = {
      attributes: props.character.custom_attributes,
      name: props.character.name,
      species: props.character.species,
      special_notes: props.character.special_notes,
      special_notes_html: props.character.special_notes_html,
    }
  }

  updateCharacter(variables, done, reject) {
    this.props
      .update({
        variables: {
          ...variables,
          id: this.props.character.id,
        },
      })
      .then(({ data, errors }) => {
        if (errors) {
          console.error(errors)
          reject && reject(errors)
          errors.map(e =>
            M.toast({ html: e.message, classes: 'red', displayLength: 3000 })
          )
        } else {
          done(data.updateCharacter)
        }
      })
      .catch(reject || console.error)
  }

  handleNameChange(name) {
    this.updateCharacter({ name }, data => {
      this.setState({ name: data.name })
      WindowAlert.add('main', data.name)
    })
  }

  handleSpeciesChange(attribute, done) {
    this.updateCharacter({ species: attribute.value }, data => {
      done()
      this.setState({ species: data.species })
    })
  }

  handleNotesChange({ value }) {
    return new Promise((resolve, reject) => {
      this.updateCharacter(
        { special_notes: value },
        data => {
          resolve({ value: data.special_notes })
          this.setState({
            special_notes: data.special_notes,
            special_notes_html: data.special_notes_html,
          })
        },
        reject
      )
    })
  }

  handleAttributesChange({ custom_attributes: attributes }) {
    this.setState({ attributes })
  }

  render() {
    const { character, editable, onAvatarEdit, onMarketplaceBuy } = this.props

    const {
      profile_image,
      avatar_url,
      lodestone_character,
      marketplace_listing,
    } = character

    const image = avatar_url || profile_image.url.medium

    let title,
      titleBefore,
      forSale = false,
      staticAttributes = [
        {
          id: 'species',
          name: 'Species',
          value: this.state.species,
        },
      ],
      lockStaticAttributes = false,
      dataLinkName

    if (lodestone_character) {
      title = lodestone_character.title
      titleBefore = !lodestone_character.title_top
      dataLinkName = lodestone_character.name

      lockStaticAttributes = true

      staticAttributes = [
        {
          id: 'race',
          name: 'Race / Tribe',
          value: `${lodestone_character.race.name} / ${lodestone_character.tribe}`,
        },
        {
          id: 'server',
          name: 'Server / Datacenter',
          value: `${lodestone_character.server.name} / ${lodestone_character.server.datacenter}`,
        },
      ]
    }

    if (marketplace_listing) {
      forSale = true
    }

    const gravityCrop = {
      center: { objectPosition: 'center' },
      north: { objectPosition: 'top' },
      south: { objectPosition: 'bottom' },
      east: { objectPosition: 'right' },
      west: { objectPosition: 'left' },
    }

    return (
      <Card className="character-card" noPadding>
        <div className="character-details">
          <div className="heading">
            {forSale && (
              <CharacterSaleButton
                character={character}
                onClick={onMarketplaceBuy}
              />
            )}

            {title && titleBefore && (
              <Caption className={'margin-top--none margin-bottom--none'}>
                &laquo; {title} &raquo;
              </Caption>
            )}
            <EditableHeader
              className="name margin-bottom--none"
              component={H1}
              editable={editable && !dataLinkName}
              onValueChange={this.handleNameChange.bind(this)}
            >
              {dataLinkName || this.state.name}
            </EditableHeader>
            {title && !titleBefore && (
              <Caption className={'margin-top--none margin-bottom--none'}>
                &laquo; {title} &raquo;
              </Caption>
            )}
          </div>

          <div className="details">
            <AttributeTable
              defaultValue="Unspecified"
              freezeName
              hideNotesForm
              onAttributeUpdate={
                editable && !lockStaticAttributes
                  ? this.handleSpeciesChange.bind(this)
                  : undefined
              }
            >
              {staticAttributes.map(a => (
                <Attribute key={a.id} id={a.id} name={a.name} value={a.value} />
              ))}
            </AttributeTable>

            <Attributes
              characterPath={`/users/${character.username}/characters/${character.slug}`}
              attributes={this.state.attributes}
              onChange={this.handleAttributesChange.bind(this)}
              editable={editable}
            />

            {(character.special_notes || editable) && (
              <div className="important-notes margin-top--large margin-bottom--medium">
                <RichText
                  title={'Important Notes'}
                  contentHtml={this.state.special_notes_html}
                  content={this.state.special_notes}
                  onChange={
                    editable ? this.handleNotesChange.bind(this) : undefined
                  }
                />
              </div>
            )}
          </div>
        </div>

        <div className="character-image">
          <Card className="slant" />
          <img
            src={image}
            data-image-id={image.id || 'v2-image'}
            style={gravityCrop[image.gravity || 'center']}
          />
          {onAvatarEdit && (
            <a className="image-edit-overlay" onClick={onAvatarEdit}>
              <div className="content">
                <i className="material-icons">photo_camera</i>
                Change Image
              </div>
            </a>
          )}
        </div>
      </Card>
    )
  }
}

Summary.propTypes = {
  editable: PropTypes.bool,
  character: PropTypes.object.isRequired,
}

const Mutated = props => (
  <Mutation mutation={updateCharacter}>
    {(update, { data }) => (
      <Summary {...props} update={update} mutationData={data} />
    )}
  </Mutation>
)

export default Mutated
