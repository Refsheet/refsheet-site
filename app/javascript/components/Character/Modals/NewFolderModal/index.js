import React, { Component } from 'react'
import PropTypes from 'prop-types'
import Modal from '../../../Styled/Modal'
import { withTranslation } from 'react-i18next'
import { Col, Row, TextInput, Button } from 'react-materialize'
import validate, {
  isRequired,
  isSluggable,
  isSlug,
  errorProps,
} from 'utils/validate'
import M from 'materialize-css'
import compose, {
  withCurrentUser,
  withMutations,
} from '../../../../utils/compose'
import createFolder from './createFolder.graphql'

class NewFolderModal extends Component {
  constructor(props) {
    super(props)

    this.validations = {
      name: [isRequired, isSluggable],
      slug: [isSlug],
    }

    this.state = {
      folder: this.props.folder || {},
      submitting: false,
      errors: {},
    }

    this.handleSubmit = this.handleSubmit.bind(this)
    this.handleInputChange = this.handleInputChange.bind(this)
  }

  handleInputChange(e) {
    let folder = { ...this.state.folder }
    let value = e.target.value
    let name = e.target.name

    if (e.target.type === 'checkbox') {
      value = e.target.checked
      name = e.target.value
    }

    folder[name] = value

    const errors = validate(folder, this.validations)
    this.setState({ folder, errors })
  }

  handleSubmit(e) {
    e.preventDefault()

    const { createFolder, characterId, onSave = _c => {} } = this.props

    createFolder({
      wrapped: true,
      variables: {
        ...this.state.folder,
        characterId,
      },
    })
      .then(({ data: { createFolder } }) => {
        M.toast({
          html: 'Folder saved!',
          classes: 'green',
          displayLength: 3000,
        })

        onSave(createFolder)
      })
      .catch(({ formErrors }) => {
        this.setState({ errors: formErrors })
      })
  }

  render() {
    const { onClose, t } = this.props
    const { folder, errors, submitting } = this.state
    console.log({ folder })

    return (
      <div>
        <Modal
          autoOpen
          id="new-media-folder"
          title={t('labels.new_media_folder', 'New Media Folder')}
          onClose={onClose}
        >
          <form onSubmit={this.handleSubmit}>
            <Row>
              <TextInput
                s={12}
                m={6}
                label={t('labels.folder_name', 'Folder Name')}
                name={'name'}
                id={'folder_name'}
                value={folder.name}
                {...errorProps(errors.name)}
                onChange={this.handleInputChange}
              />
              <TextInput
                s={12}
                m={6}
                label={t('labels.folder_url', 'Folder URL')}
                name={'slug'}
                id={'folder_slug'}
                value={folder.slug}
                {...errorProps(errors.slug)}
                onChange={this.handleInputChange}
              />
            </Row>

            <Row className={'actions'}>
              <Col s={6}></Col>
              <Col s={6} className={'right-align'}>
                <Button
                  type={'submit'}
                  className={'btn btn-primary'}
                  disabled={submitting}
                >
                  {t('actions.save', 'Save')}
                </Button>
              </Col>
            </Row>
          </form>
        </Modal>
      </div>
    )
  }
}

NewFolderModal.propTypes = {
  folder: PropTypes.object,
  onClose: PropTypes.func,
  onSave: PropTypes.func,
  t: PropTypes.func,
}

export default compose(
  withTranslation('common'),
  withMutations({ createFolder }),
  withCurrentUser()
)(NewFolderModal)
