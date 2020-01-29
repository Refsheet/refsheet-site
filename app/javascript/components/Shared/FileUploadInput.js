import React, { Component } from 'react'
import PropTypes from 'prop-types'
import { withNamespaces } from 'react-i18next'
import compose from 'utils/compose'
import { TextInput } from 'react-materialize'
import { DirectUploadProvider } from 'react-activestorage-provider'

class FileUploadInput extends Component {
  constructor(props) {
    super(props)

    this.state = {
      file: null,
    }
  }

  handleFileChange(e) {
    this.setState({ file: e.currentTarget.files[0] })
  }

  handleSuccess(success) {
    console.log({ success })
  }

  renderInput({ handleUpload, uploads, ready }) {
    const { t, id, label } = this.props

    console.log({ uploads })

    return (
      <div className={'file-upload-input row'}>
        <TextInput
          s={12}
          type={'file'}
          id={id}
          label={label}
          disabled={!ready}
          onChange={e => handleUpload(e.currentTarget.files)}
        />
        <ul>
          {uploads.map(upload => (
            <li key={upload.id}>
              {upload.file.filename}: {upload.state}
            </li>
          ))}
        </ul>
      </div>
    )
  }

  render() {
    return (
      <DirectUploadProvider
        onSuccess={this.handleSuccess.bind(this)}
        render={this.renderInput.bind(this)}
      />
    )
  }
}

FileUploadInput.propTypes = {
  id: PropTypes.string.isRequired,
  label: PropTypes.string,
}

export default compose(
  withNamespaces('common')
  // TODO: Add HOC bindings here
)(FileUploadInput)
