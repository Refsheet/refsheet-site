import React, { Component } from 'react'
import PropTypes from 'prop-types'
import compose from 'utils/compose'
import { withNamespaces } from 'react-i18next'
import { TextInput, Row, Col } from 'react-materialize'

class EditCharacter extends Component {
  constructor(props) {
    super(props)

    this.state = { character: this.props.character }
  }

  handleInputChange(e) {
    let character = { ...this.state.character }
    let value = e.target.value
    let name = e.target.name

    if (e.target.type === 'checkbox') {
      value = e.target.checked
      name = e.target.value
    }

    character[name] = value
    this.setState({ image: character })
  }

  handleSubmit(e) {
    e.preventDefault()
    console.log(this.state.character)
  }

  render() {
    return <form onSubmit={this.handleSubmit}>
      <Row>
        <TextInput s={12} m={6} label={t('labels.character_name', "Name")} name={'name'} id={'character_name'} value={this.state.character.name} onChange={this.handleInputChange.bind(this)} />
        <TextInput s={12} m={6} label={t('labels.character_species', "Species / Race")} name={'species'} id={'character_species'} value={this.state.character.species} onChange={this.handleInputChange.bind(this)} />
      </Row>
      <Row>
        <TextInput s={12} m={6} label={`refsheet.net/${username}/`} name={'slug'} id={'character_slug'} value={this.state.character.slug} onChange={this.handleInputChange.bind(this)} />
        <TextInput s={12} m={6} label={'ref.st/'} name={'shortcode'} id={'character_shortcode'} value={this.state.character.shortcode} onChange={this.handleInputChange.bind(this)} />
      </Row>

      <div className={'actions'}>
        <button type={'button'} className={'btn btn-secondary'}>{t('actions.cancel', "Cancel")}</button>
        <button type={'submit'} className={'btn btn-primary'}>{t('actions.save', "Save")}</button>
      </div>
    </form>
  }
}

EditCharacter.propTypes = {
  character: PropTypes.object.isRequired,
  onSave: PropTypes.func,
  goTo: PropTypes.func,
}

export default compose(withNamespaces('common'))(EditCharacter)
