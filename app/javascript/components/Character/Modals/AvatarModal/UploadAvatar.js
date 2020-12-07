import React, { Component } from 'react'
import PropTypes from 'prop-types'
import { withTranslation } from 'react-i18next'
import compose from 'utils/compose'
import { H1 } from 'Styled/Headings'
import { DirectUploadProvider } from 'react-activestorage-provider'
import { TextInput, Button, Row, Col, ProgressBar } from 'react-materialize'
import Muted, { MutedAnchor } from '../../../Styled/Muted'
import { withMutations } from '../../../../utils/compose'
import setCharacterAvatarBlob from './setCharacterAvatarBlob.graphql'
import * as M from 'materialize-css'

class UploadAvatar extends Component {
  constructor(props) {
    super(props)

    this.state = {
      file: null,
      loading: false,
      error: null,
    }
  }

  handleFileChange(e) {
    this.setState({ file: e.currentTarget.files[0] })
  }

  handleSubmit(e, handleUpload) {
    e.preventDefault()
    this.setState({ loading: true })
    handleUpload([this.state.file])
  }

  handleClearClick(e) {
    e.preventDefault()
    this.handleSuccess([])
  }

  renderInput({ handleUpload, uploads, ready }) {
    const { t, id, character } = this.props

    return (
      <form
        className={'file-upload-input'}
        onSubmit={e => this.handleSubmit(e, handleUpload)}
      >
        {!this.state.loading && uploads.length === 0 && (
          <Row>
            <TextInput
              s={12}
              type={'file'}
              id={id}
              label={'Browse...'}
              disabled={!ready}
              onChange={this.handleFileChange.bind(this)}
            />
          </Row>
        )}

        {uploads.length > 0 && (
          <Row className={'margin-top--large'}>
            {uploads.map(upload => (
              <Col s={12} key={upload.id}>
                <p>
                  <Muted className={'right'}>{upload.state}</Muted>
                  {upload.file.name}
                </p>
                <ProgressBar progress={(upload.progress || 0) * 100} />
              </Col>
            ))}
          </Row>
        )}

        {this.state.loading && uploads.length === 0 && (
          <Row className={'margin-top--large'}>
            <Col s={12}>
              <p>Finishing up...</p>
              <ProgressBar />
            </Col>
          </Row>
        )}

        {this.state.error && (
          <Row className={'margin-top--large'}>
            <Col s={12}>
              <div className={'error red-text'}>{this.state.error}</div>
            </Col>
          </Row>
        )}

        <div className={'center-align margin-top--large'}>
          <Button
            type={'submit'}
            className={'btn-large'}
            disabled={!ready || !this.state.file || this.state.loading}
          >
            {this.state.loading ? 'Uploading...' : 'Upload'}
          </Button>

          {character.avatar_url && (
            <div className={'margin-top--small'}>
              <MutedAnchor
                href={'#'}
                onClick={this.handleClearClick.bind(this)}
              >
                Remove Image
              </MutedAnchor>
            </div>
          )}
        </div>
      </form>
    )
  }

  handleSuccess(blobs) {
    const blob = blobs[0]
    const { setCharacterAvatarBlob, character, onSave, onClose } = this.props

    setCharacterAvatarBlob({
      wrapped: true,
      variables: {
        blob,
        id: character.id,
      },
    })
      .then(({ setCharacterAvatarBlob }) => {
        M.toast({
          html: 'Avatar updated!',
          displayLength: 3000,
          classes: 'green',
        })
        onSave && onSave(setCharacterAvatarBlob)
        onClose && onClose()
      })
      .catch(({ errorString }) => {
        this.setState({ error: errorString, loading: false })
      })
  }

  render() {
    const { t } = this.props

    return (
      <DirectUploadProvider
        onSuccess={this.handleSuccess.bind(this)}
        render={this.renderInput.bind(this)}
      />
    )
  }
}

UploadAvatar.propTypes = {
  character: PropTypes.object.isRequired,
  onSave: PropTypes.func.isRequired,
}

export default compose(
  withTranslation('common'),
  withMutations({ setCharacterAvatarBlob })
)(UploadAvatar)
