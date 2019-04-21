import React, { Component } from 'react'
import PropTypes from 'prop-types'
import Card, { div as Slant } from 'Styled/Card'
import { H1, H2 } from 'Styled/Headings'
import EditableHeader from "../Shared/EditableHeader";
import {Mutation} from "react-apollo";
import updateCharacter from './updateCharacter.graphql'
import * as M from "materialize-css";

class Summary extends Component {
  constructor(props) {
    super(props)

    // TODO: Finish migrating Attributes. Until then, they're stored as a local state.
    this.state = {
      attributes: props.character.custom_attributes,
      name: props.character.name,
      species: props.character.species
    }
  }

  handleNameChange(name) {
    this.props.update({
      variables: {
        name,
        id: this.props.character.shortcode
      }
    })
      .then(({data, errors}) => {
        if (errors) {
          console.error(errors)
          errors.map((e) => M.toast({html: e.message, classes: 'red', duration: 3000}))
        } else {
          this.setState({name: data.updateCharacter.name})
        }
      })
      .catch(console.error)
  }

  handleSpeciesChange(attribute, done) {
    this.props.update({
      variables: {
        species: attribute.value,
        id: this.props.character.shortcode
      }
    })
      .then(({data, errors}) => {
        if (errors) {
          console.error(errors)
          errors.map((e) => M.toast({html: e.message, classes: 'red', duration: 3000}))
        } else {
          done()
          this.setState({species: data.updateCharacter.species})
        }
      })
      .catch(console.error)
  }

  handleAttributesChange({custom_attributes: attributes}) {
    this.setState({attributes})
  }

  render() {
    const {
      character,
      editable,
    } = this.props

    const {
      profile_image: image
    } = character

    const gravityCrop = {
      center: { objectPosition: 'center' },
      north: { objectPosition: 'top' },
      south: { objectPosition: 'bottom' },
      east: { objectPosition: 'right' },
      west: { objectPosition: 'left' }
    }

    return (
      <Card className='character-card'>
        <div className='character-details'>
          <div className='heading'>
            <EditableHeader className='name margin-bottom--none' component={H1} editable={editable} onValueChange={this.handleNameChange.bind(this)}>{ this.state.name }</EditableHeader>
          </div>

          <div className='details'>
            <AttributeTable defaultValue='Unspecified' freezeName hideNotesForm onAttributeUpdate={editable ? this.handleSpeciesChange.bind(this) : undefined}>
              <Attribute id='species' name='Species' value={ this.state.species } />
            </AttributeTable>

            <Views.Character.Attributes
              characterPath={ `/users/${character.username}/characters/${character.slug}` }
              attributes={this.state.attributes}
              onChange={this.handleAttributesChange.bind(this)}
              editable={editable}
            />

            { (character.special_notes || editable) && <div className='important-notes margin-top--large margin-bottom--medium'>
              <H2>Important Notes</H2>

              <RichText
                content={ character.special_notes_html }
                markup={ character.special_notes }
              />
            </div> }
          </div>
        </div>

        <div className='character-image'>
          <Slant className='slant' />
          <img src={ image.url.medium }
               data-image-id={ image.id }
               style={ gravityCrop[image.gravity] } />
        </div>
      </Card>
    )
  }
}

Summary.propTypes = {
  editable: PropTypes.bool,
  character: PropTypes.object.isRequired
}

const Mutated = (props) => (
  <Mutation mutation={updateCharacter}>
    {(update, {data}) => <Summary {...props} update={update} mutationData={data} />}
  </Mutation>
)

export default Mutated